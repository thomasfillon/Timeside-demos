FROM andrewosh/binder-base

MAINTAINER Thomas Fillon <thomas@parisson.com>

USER root

# Add dependency
RUN apt-get update
RUN apt-get install -y wget tar

# Get TimeSide configuration files
RUN mkdir -p /srv/src/ && \
    cd /srv/src/ && \
    wget https://github.com/Parisson/TimeSide/archive/dev.tar.gz && \
    tar -xf dev.tar.gz && \
    mv TimeSide-dev/ timeside && \
    cd timeside
    

# Add dependency
RUN DEBIAN_PACKAGES=$(egrep -v "^\s*(#|$)" debian-requirements.txt) && \
    apt-get install -y --force-yes $DEBIAN_PACKAGES && \
    apt-get clean

RUN conda config --add channels piem &&\
    conda env update --name root --file environment-pinned.yml

COPY . /srv/src/timeside/

ENV PYTHON_EGG_CACHE=/srv/.python-eggs
RUN mkdir $PYTHON_EGG_CACHE
RUN chown www-data:www-data $PYTHON_EGG_CACHE

# Install TimeSide
RUN pip install -e .


USER main