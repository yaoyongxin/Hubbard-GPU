# makefile

CPPSRC=ham.cpp\
       ham2D.cpp\
       hamsparse.cpp\
       hamsparse2D_CSR.cpp\
       hamsparse2D.cpp\
       bare-ham.cpp\

CUDASRC=

OBJ=$(CPPSRC:.cpp=.o) $(CUDASRC:.cu=.o)

EXE=main

CC=gcc
CXX=g++

CFLAGS=-g -Wall -O2 -march=native -std=c++11
CPPFLAGS=$(CFLAGS)
LDFLAGS=-g -O2 -Wall -march=native
NVFLAGS=-g -O2 --ptxas-options=-v -arch=sm_13

INCLUDE=
LIBS=-lblas -llapack -larpack

%.o:    %.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $(@:.o=.c) -o $@

%.o:    %.cpp
	$(CXX) -c $(CPPFLAGS) $(INCLUDE) $(@:.o=.cpp) -o $@

%.o:    %.cu
	nvcc -c $(NVFLAGS) $(INCLUDE) $(@:.o=.cu) -o $@
#	nvcc -cuda $(NVFLAGS) $(INCLUDE) $(@:.o=.cu) -o $(@:.o=.cu.ii)
#	$(CXX) -c $(CPPFLAGS) $(INCLUDE) $(@:.o=.cu.ii) -o $@


all: main main2D

main2D: $(OBJ) main2D.o
	$(CXX) $(LDFLAGS) -o main2D $(OBJ) main2D.o $(LIBS)

main: $(OBJ) main.o
	$(CXX) $(LDFLAGS) -o main $(OBJ) main.o $(LIBS)

doc: $(CPPSRC) doc-config
	doxygen doc-config

.PHONY: clean
clean:
	rm -f $(OBJ) main.o main2D.o
