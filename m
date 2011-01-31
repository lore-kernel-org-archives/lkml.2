Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab1AaMvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:51:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:33234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab1AaMvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:51:44 -0500
Date: Mon, 31 Jan 2011 12:51:05 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        williams@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        williams@redhat.com, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Initial python binding
Message-ID: <tip-877108e42b1b9ba64857c4030cf356ecc120fd18@git.kernel.org>
Git-Commit-ID: 877108e42b1b9ba64857c4030cf356ecc120fd18
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 12:51:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  877108e42b1b9ba64857c4030cf356ecc120fd18
Gitweb:     http://git.kernel.org/tip/877108e42b1b9ba64857c4030cf356ecc120fd18
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 29 Jan 2011 15:44:29 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 30 Jan 2011 11:37:38 -0200

perf tools: Initial python binding

First clarifying that this kind of binding is not a replacement or an
equivalent to the 'perf script' way of using python with perf.

The 'perf script' way is to process events and look at a given script
for some python function that matches the events to pass each event for
processing.

This is a python module, i.e. everything is driven from the python
script, that merely uses "import perf" or "from perf import".

perf script is focused on tracepoints, this binding is focused on profiling as
an initial target. More work is needed to make available tracepoint specific
variables as event variables accessible via this binding.

There is one example of such usage model, in
tools/perf/python/twatch.py, a tool to watch "cycles" events together
with task (fork, exit) and comm perf events.

For now, due to me not being able to grok how python distutils cope with
building C extensions outside the sources dir the install target just
builds it, I'm using it as:

[root@emilia linux]# export PYTHONPATH=~acme/git/build/perf/lib.linux-x86_64-2.6/
[root@emilia linux]# tools/perf/python/twatch.py
cpu:  4, pid: 30126, tid: 30126 { type: mmap, pid: 30126, tid: 30126, start: 0x4, length: 0x82e9ca03, offset: 0, filename:  }
cpu:  6, pid:   47, tid:   47 { type: mmap, pid: 47, tid: 47, start: 0x6, length: 0xbef87c36, offset: 0, filename:  }
cpu:  1, pid:    0, tid:    0 { type: mmap, pid: 0, tid: 0, start: 0x1, length: 0x775d1904, offset: 0, filename:  }
cpu:  7, pid:    0, tid:    0 { type: mmap, pid: 0, tid: 0, start: 0x7, length: 0xc750aeb6, offset: 0, filename:  }
cpu:  5, pid: 2255, tid: 2255 { type: mmap, pid: 2255, tid: 2255, start: 0x5, length: 0x76669635, offset: 0, filename:  }
cpu:  0, pid:    0, tid:    0 { type: mmap, pid: 0, tid: 0, start: 0, length: 0x6422ef6b, offset: 0, filename:  }
cpu:  2, pid: 2255, tid: 2255 { type: mmap, pid: 2255, tid: 2255, start: 0x2, length: 0xe078757a, offset: 0, filename:  }
cpu:  1, pid: 5769, tid: 5769 { type: fork, pid: 30127, ppid: 5769, tid: 30127, ptid: 5769, time: 103893991270534}
cpu:  6, pid: 30127, tid: 30127 { type: comm, pid: 30127, tid: 30127, comm: ls }
cpu:  6, pid: 30127, tid: 30127 { type: exit, pid: 30127, ppid: 30127, tid: 30127, ptid: 30127, time: 103893993273024}

The first 8 mmap events in this 8 way machine are a mistery that is still being
investigated.

More of the tools/perf/util/ APIs will be exposed via this python binding as
the need arises. For now the focus is on creating events and processing them,
symbol resolution is an obvious next step, with tracepoint variables as a close
second step.

Cc: Clark Williams <williams@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile         |   20 +-
 tools/perf/python/twatch.py |   41 ++
 tools/perf/util/python.c    |  888 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/setup.py    |   18 +
 4 files changed, 966 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index eedcf95..36ff73c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -315,6 +315,7 @@ COMPAT_CFLAGS =
 COMPAT_OBJS =
 LIB_H =
 LIB_OBJS =
+PYRF_OBJS =
 SCRIPT_PERL =
 SCRIPT_SH =
 TEST_PROGRAMS =
@@ -324,6 +325,9 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
+pyrf: $(PYRF_OBJS)
+	python util/setup.py build --build-base='$(OUTPUT)'
+
 #
 # No Perl scripts right now:
 #
@@ -349,7 +353,7 @@ PROGRAMS += $(OUTPUT)perf
 #
 
 # what 'all' will build and 'install' will install, in perfexecdir
-ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
+ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS) pyrf
 
 # what 'all' will build but not install in perfexecdir
 OTHER_PROGRAMS = $(OUTPUT)perf$X
@@ -520,6 +524,20 @@ BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
 PERFLIBS = $(LIB_FILE)
 
+# Files needed for the python binding, perf.so
+# pyrf is just an internal name needed for all those wrappers.
+# This has to be in sync with what is in the 'sources' variable in
+# tools/perf/util/setup.py
+
+PYRF_OBJS += $(OUTPUT)util/cpumap.o
+PYRF_OBJS += $(OUTPUT)util/ctype.o
+PYRF_OBJS += $(OUTPUT)util/evlist.o
+PYRF_OBJS += $(OUTPUT)util/evsel.o
+PYRF_OBJS += $(OUTPUT)util/python.o
+PYRF_OBJS += $(OUTPUT)util/thread_map.o
+PYRF_OBJS += $(OUTPUT)util/util.o
+PYRF_OBJS += $(OUTPUT)util/xyarray.o
+
 #
 # Platform specific tweaks
 #
diff --git a/tools/perf/python/twatch.py b/tools/perf/python/twatch.py
new file mode 100755
index 0000000..5e9f3b7
--- /dev/null
+++ b/tools/perf/python/twatch.py
@@ -0,0 +1,41 @@
+#! /usr/bin/python
+# -*- python -*-
+# -*- coding: utf-8 -*-
+#   twatch - Experimental use of the perf python interface
+#   Copyright (C) 2011 Arnaldo Carvalho de Melo <acme@redhat.com>
+#
+#   This application is free software; you can redistribute it and/or
+#   modify it under the terms of the GNU General Public License
+#   as published by the Free Software Foundation; version 2.
+#
+#   This application is distributed in the hope that it will be useful,
+#   but WITHOUT ANY WARRANTY; without even the implied warranty of
+#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+#   General Public License for more details.
+
+import perf
+
+def main():
+	cpus = perf.cpu_map()
+	threads = perf.thread_map()
+	evsel = perf.evsel(task = 1, comm = 1, mmap = 0,
+			   wakeup_events = 1, sample_period = 1,
+			   sample_id_all = 1,
+			   sample_type = perf.SAMPLE_PERIOD | perf.SAMPLE_TID | perf.SAMPLE_CPU | perf.SAMPLE_TID)
+	evsel.open(cpus = cpus, threads = threads);
+	evlist = perf.evlist()
+	evlist.add(evsel)
+	evlist.mmap(cpus = cpus, threads = threads)
+	while True:
+		evlist.poll(timeout = -1)
+		for cpu in cpus:
+			event = evlist.read_on_cpu(cpu)
+			if not event:
+				continue
+			print "cpu: %2d, pid: %4d, tid: %4d" % (event.sample_cpu,
+								event.sample_pid,
+								event.sample_tid),
+			print event
+
+if __name__ == '__main__':
+    main()
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
new file mode 100644
index 0000000..88d4789
--- /dev/null
+++ b/tools/perf/util/python.c
@@ -0,0 +1,888 @@
+#include <Python.h>
+#include <structmember.h>
+#include <inttypes.h>
+#include <poll.h>
+#include "evlist.h"
+#include "evsel.h"
+#include "event.h"
+#include "cpumap.h"
+#include "thread_map.h"
+
+struct throttle_event {
+	struct perf_event_header header;
+	u64			 time;
+	u64			 id;
+	u64			 stream_id;
+};
+
+#define member_def(type, member, ptype, help) \
+	{ #member, ptype, \
+	  offsetof(struct pyrf_event, event) + offsetof(struct type, member), \
+	  0, help }
+
+#define sample_member_def(name, member, ptype, help) \
+	{ #name, ptype, \
+	  offsetof(struct pyrf_event, sample) + offsetof(struct perf_sample, member), \
+	  0, help }
+
+struct pyrf_event {
+	PyObject_HEAD
+	struct perf_sample sample;
+	union perf_event   event;
+};
+
+#define T_ULONG_LONG T_ULONG
+
+#define sample_members \
+	sample_member_def(sample_ip, ip, T_ULONG_LONG, "event type"),			 \
+	sample_member_def(sample_pid, pid, T_INT, "event pid"),			 \
+	sample_member_def(sample_tid, tid, T_INT, "event tid"),			 \
+	sample_member_def(sample_time, time, T_ULONG_LONG, "event timestamp"),		 \
+	sample_member_def(sample_addr, addr, T_ULONG_LONG, "event addr"),		 \
+	sample_member_def(sample_id, id, T_ULONG_LONG, "event id"),			 \
+	sample_member_def(sample_stream_id, stream_id, T_ULONG_LONG, "event stream id"), \
+	sample_member_def(sample_period, period, T_ULONG_LONG, "event period"),		 \
+	sample_member_def(sample_cpu, cpu, T_UINT, "event cpu"),
+
+static char pyrf_mmap_event__doc[] = PyDoc_STR("perf mmap event object.");
+
+static PyMemberDef pyrf_mmap_event__members[] = {
+	sample_members
+	member_def(perf_event_header, type, T_UINT, "event type"),
+	member_def(mmap_event, pid, T_UINT, "event pid"),
+	member_def(mmap_event, tid, T_UINT, "event tid"),
+	member_def(mmap_event, start, T_ULONG_LONG, "start of the map"),
+	member_def(mmap_event, len, T_ULONG_LONG, "map length"),
+	member_def(mmap_event, pgoff, T_ULONG_LONG, "page offset"),
+	member_def(mmap_event, filename, T_STRING_INPLACE, "backing store"),
+	{ NULL, },
+};
+
+static PyObject *pyrf_mmap_event__repr(struct pyrf_event *pevent)
+{
+	PyObject *ret;
+	char *s;
+
+	if (asprintf(&s, "{ type: mmap, pid: %u, tid: %u, start: %#" PRIx64 ", "
+			 "length: %#" PRIx64 ", offset: %#" PRIx64 ", "
+			 "filename: %s }",
+		     pevent->event.mmap.pid, pevent->event.mmap.tid,
+		     pevent->event.mmap.start, pevent->event.mmap.len,
+		     pevent->event.mmap.pgoff, pevent->event.mmap.filename) < 0) {
+		ret = PyErr_NoMemory();
+	} else {
+		ret = PyString_FromString(s);
+		free(s);
+	}
+	return ret;
+}
+
+static PyTypeObject pyrf_mmap_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.mmap_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_mmap_event__doc,
+	.tp_members	= pyrf_mmap_event__members,
+	.tp_repr	= (reprfunc)pyrf_mmap_event__repr,
+};
+
+static char pyrf_task_event__doc[] = PyDoc_STR("perf task (fork/exit) event object.");
+
+static PyMemberDef pyrf_task_event__members[] = {
+	sample_members
+	member_def(perf_event_header, type, T_UINT, "event type"),
+	member_def(fork_event, pid, T_UINT, "event pid"),
+	member_def(fork_event, ppid, T_UINT, "event ppid"),
+	member_def(fork_event, tid, T_UINT, "event tid"),
+	member_def(fork_event, ptid, T_UINT, "event ptid"),
+	member_def(fork_event, time, T_ULONG_LONG, "timestamp"),
+	{ NULL, },
+};
+
+static PyObject *pyrf_task_event__repr(struct pyrf_event *pevent)
+{
+	return PyString_FromFormat("{ type: %s, pid: %u, ppid: %u, tid: %u, "
+				   "ptid: %u, time: %" PRIu64 "}",
+				   pevent->event.header.type == PERF_RECORD_FORK ? "fork" : "exit",
+				   pevent->event.fork.pid,
+				   pevent->event.fork.ppid,
+				   pevent->event.fork.tid,
+				   pevent->event.fork.ptid,
+				   pevent->event.fork.time);
+}
+
+static PyTypeObject pyrf_task_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.task_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_task_event__doc,
+	.tp_members	= pyrf_task_event__members,
+	.tp_repr	= (reprfunc)pyrf_task_event__repr,
+};
+
+static char pyrf_comm_event__doc[] = PyDoc_STR("perf comm event object.");
+
+static PyMemberDef pyrf_comm_event__members[] = {
+	sample_members
+	member_def(perf_event_header, type, T_UINT, "event type"),
+	member_def(comm_event, pid, T_UINT, "event pid"),
+	member_def(comm_event, tid, T_UINT, "event tid"),
+	member_def(comm_event, comm, T_STRING_INPLACE, "process name"),
+	{ NULL, },
+};
+
+static PyObject *pyrf_comm_event__repr(struct pyrf_event *pevent)
+{
+	return PyString_FromFormat("{ type: comm, pid: %u, tid: %u, comm: %s }",
+				   pevent->event.comm.pid,
+				   pevent->event.comm.tid,
+				   pevent->event.comm.comm);
+}
+
+static PyTypeObject pyrf_comm_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.comm_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_comm_event__doc,
+	.tp_members	= pyrf_comm_event__members,
+	.tp_repr	= (reprfunc)pyrf_comm_event__repr,
+};
+
+static char pyrf_throttle_event__doc[] = PyDoc_STR("perf throttle event object.");
+
+static PyMemberDef pyrf_throttle_event__members[] = {
+	sample_members
+	member_def(perf_event_header, type, T_UINT, "event type"),
+	member_def(throttle_event, time, T_ULONG_LONG, "timestamp"),
+	member_def(throttle_event, id, T_ULONG_LONG, "event id"),
+	member_def(throttle_event, stream_id, T_ULONG_LONG, "event stream id"),
+	{ NULL, },
+};
+
+static PyObject *pyrf_throttle_event__repr(struct pyrf_event *pevent)
+{
+	struct throttle_event *te = (struct throttle_event *)(&pevent->event.header + 1);
+
+	return PyString_FromFormat("{ type: %sthrottle, time: %" PRIu64 ", id: %" PRIu64
+				   ", stream_id: %" PRIu64 " }",
+				   pevent->event.header.type == PERF_RECORD_THROTTLE ? "" : "un",
+				   te->time, te->id, te->stream_id);
+}
+
+static PyTypeObject pyrf_throttle_event__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.throttle_event",
+	.tp_basicsize	= sizeof(struct pyrf_event),
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_throttle_event__doc,
+	.tp_members	= pyrf_throttle_event__members,
+	.tp_repr	= (reprfunc)pyrf_throttle_event__repr,
+};
+
+static int pyrf_event__setup_types(void)
+{
+	int err;
+	pyrf_mmap_event__type.tp_new =
+	pyrf_task_event__type.tp_new =
+	pyrf_comm_event__type.tp_new =
+	pyrf_throttle_event__type.tp_new = PyType_GenericNew;
+	err = PyType_Ready(&pyrf_mmap_event__type);
+	if (err < 0)
+		goto out;
+	err = PyType_Ready(&pyrf_task_event__type);
+	if (err < 0)
+		goto out;
+	err = PyType_Ready(&pyrf_comm_event__type);
+	if (err < 0)
+		goto out;
+	err = PyType_Ready(&pyrf_throttle_event__type);
+	if (err < 0)
+		goto out;
+out:
+	return err;
+}
+
+static PyTypeObject *pyrf_event__type[] = {
+	[PERF_RECORD_MMAP]	 = &pyrf_mmap_event__type,
+	[PERF_RECORD_LOST]	 = &pyrf_mmap_event__type,
+	[PERF_RECORD_COMM]	 = &pyrf_comm_event__type,
+	[PERF_RECORD_EXIT]	 = &pyrf_task_event__type,
+	[PERF_RECORD_THROTTLE]	 = &pyrf_throttle_event__type,
+	[PERF_RECORD_UNTHROTTLE] = &pyrf_throttle_event__type,
+	[PERF_RECORD_FORK]	 = &pyrf_task_event__type,
+	[PERF_RECORD_READ]	 = &pyrf_mmap_event__type,
+	[PERF_RECORD_SAMPLE]	 = &pyrf_mmap_event__type,
+};
+
+static PyObject *pyrf_event__new(union perf_event *event)
+{
+	struct pyrf_event *pevent;
+	PyTypeObject *ptype;
+
+	if (event->header.type < PERF_RECORD_MMAP ||
+	    event->header.type > PERF_RECORD_SAMPLE)
+		return NULL;
+
+	ptype = pyrf_event__type[event->header.type];
+	pevent = PyObject_New(struct pyrf_event, ptype);
+	if (pevent != NULL)
+		memcpy(&pevent->event, event, event->header.size);
+	return (PyObject *)pevent;
+}
+
+struct pyrf_cpu_map {
+	PyObject_HEAD
+
+	struct cpu_map *cpus;
+};
+
+static int pyrf_cpu_map__init(struct pyrf_cpu_map *pcpus,
+			      PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = { "cpustr", NULL, NULL, };
+	char *cpustr = NULL;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|s",
+					 kwlist, &cpustr))
+		return -1;
+
+	pcpus->cpus = cpu_map__new(cpustr);
+	if (pcpus->cpus == NULL)
+		return -1;
+	return 0;
+}
+
+static void pyrf_cpu_map__delete(struct pyrf_cpu_map *pcpus)
+{
+	cpu_map__delete(pcpus->cpus);
+	pcpus->ob_type->tp_free((PyObject*)pcpus);
+}
+
+static Py_ssize_t pyrf_cpu_map__length(PyObject *obj)
+{
+	struct pyrf_cpu_map *pcpus = (void *)obj;
+
+	return pcpus->cpus->nr;
+}
+
+static PyObject *pyrf_cpu_map__item(PyObject *obj, Py_ssize_t i)
+{
+	struct pyrf_cpu_map *pcpus = (void *)obj;
+
+	if (i >= pcpus->cpus->nr)
+		return NULL;
+
+	return Py_BuildValue("i", pcpus->cpus->map[i]);
+}
+
+static PySequenceMethods pyrf_cpu_map__sequence_methods = {
+	.sq_length = pyrf_cpu_map__length,
+	.sq_item   = pyrf_cpu_map__item,
+};
+
+static char pyrf_cpu_map__doc[] = PyDoc_STR("cpu map object.");
+
+static PyTypeObject pyrf_cpu_map__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.cpu_map",
+	.tp_basicsize	= sizeof(struct pyrf_cpu_map),
+	.tp_dealloc	= (destructor)pyrf_cpu_map__delete,
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_cpu_map__doc,
+	.tp_as_sequence	= &pyrf_cpu_map__sequence_methods,
+	.tp_init	= (initproc)pyrf_cpu_map__init,
+};
+
+static int pyrf_cpu_map__setup_types(void)
+{
+	pyrf_cpu_map__type.tp_new = PyType_GenericNew;
+	return PyType_Ready(&pyrf_cpu_map__type);
+}
+
+struct pyrf_thread_map {
+	PyObject_HEAD
+
+	struct thread_map *threads;
+};
+
+static int pyrf_thread_map__init(struct pyrf_thread_map *pthreads,
+				 PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = { "pid", "tid", NULL, NULL, };
+	int pid = -1, tid = -1;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii",
+					 kwlist, &pid, &tid))
+		return -1;
+
+	pthreads->threads = thread_map__new(pid, tid);
+	if (pthreads->threads == NULL)
+		return -1;
+	return 0;
+}
+
+static void pyrf_thread_map__delete(struct pyrf_thread_map *pthreads)
+{
+	thread_map__delete(pthreads->threads);
+	pthreads->ob_type->tp_free((PyObject*)pthreads);
+}
+
+static Py_ssize_t pyrf_thread_map__length(PyObject *obj)
+{
+	struct pyrf_thread_map *pthreads = (void *)obj;
+
+	return pthreads->threads->nr;
+}
+
+static PyObject *pyrf_thread_map__item(PyObject *obj, Py_ssize_t i)
+{
+	struct pyrf_thread_map *pthreads = (void *)obj;
+
+	if (i >= pthreads->threads->nr)
+		return NULL;
+
+	return Py_BuildValue("i", pthreads->threads->map[i]);
+}
+
+static PySequenceMethods pyrf_thread_map__sequence_methods = {
+	.sq_length = pyrf_thread_map__length,
+	.sq_item   = pyrf_thread_map__item,
+};
+
+static char pyrf_thread_map__doc[] = PyDoc_STR("thread map object.");
+
+static PyTypeObject pyrf_thread_map__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.thread_map",
+	.tp_basicsize	= sizeof(struct pyrf_thread_map),
+	.tp_dealloc	= (destructor)pyrf_thread_map__delete,
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_thread_map__doc,
+	.tp_as_sequence	= &pyrf_thread_map__sequence_methods,
+	.tp_init	= (initproc)pyrf_thread_map__init,
+};
+
+static int pyrf_thread_map__setup_types(void)
+{
+	pyrf_thread_map__type.tp_new = PyType_GenericNew;
+	return PyType_Ready(&pyrf_thread_map__type);
+}
+
+struct pyrf_evsel {
+	PyObject_HEAD
+
+	struct perf_evsel evsel;
+};
+
+static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
+			    PyObject *args, PyObject *kwargs)
+{
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_HARDWARE,
+		.config = PERF_COUNT_HW_CPU_CYCLES,
+		.sample_type = PERF_SAMPLE_PERIOD | PERF_SAMPLE_TID,
+	};
+	static char *kwlist[] = {
+		"type",
+		"config",
+		"sample_freq",
+		"sample_period",
+		"sample_type",
+		"read_format",
+		"disabled",
+		"inherit",
+		"pinned",
+		"exclusive",
+		"exclude_user",
+		"exclude_kernel",
+		"exclude_hv",
+		"exclude_idle",
+		"mmap",
+		"comm",
+		"freq",
+		"inherit_stat",
+		"enable_on_exec",
+		"task",
+		"watermark",
+		"precise_ip",
+		"mmap_data",
+		"sample_id_all",
+		"wakeup_events",
+		"bp_type",
+		"bp_addr",
+		"bp_len", NULL, NULL, };
+	u64 sample_period = 0;
+	u32 disabled = 0,
+	    inherit = 0,
+	    pinned = 0,
+	    exclusive = 0,
+	    exclude_user = 0,
+	    exclude_kernel = 0,
+	    exclude_hv = 0,
+	    exclude_idle = 0,
+	    mmap = 0,
+	    comm = 0,
+	    freq = 1,
+	    inherit_stat = 0,
+	    enable_on_exec = 0,
+	    task = 0,
+	    watermark = 0,
+	    precise_ip = 0,
+	    mmap_data = 0,
+	    sample_id_all = 1;
+	int idx = 0;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs,
+					 "|iKiKKiiiiiiiiiiiiiiiiiiiiiKK", kwlist,
+					 &attr.type, &attr.config, &attr.sample_freq,
+					 &sample_period, &attr.sample_type,
+					 &attr.read_format, &disabled, &inherit,
+					 &pinned, &exclusive, &exclude_user,
+					 &exclude_kernel, &exclude_hv, &exclude_idle,
+					 &mmap, &comm, &freq, &inherit_stat,
+					 &enable_on_exec, &task, &watermark,
+					 &precise_ip, &mmap_data, &sample_id_all,
+					 &attr.wakeup_events, &attr.bp_type,
+					 &attr.bp_addr, &attr.bp_len, &idx))
+		return -1;
+
+	/* union... */
+	if (sample_period != 0) {
+		if (attr.sample_freq != 0)
+			return -1; /* FIXME: throw right exception */
+		attr.sample_period = sample_period;
+	}
+
+	/* Bitfields */
+	attr.disabled	    = disabled;
+	attr.inherit	    = inherit;
+	attr.pinned	    = pinned;
+	attr.exclusive	    = exclusive;
+	attr.exclude_user   = exclude_user;
+	attr.exclude_kernel = exclude_kernel;
+	attr.exclude_hv	    = exclude_hv;
+	attr.exclude_idle   = exclude_idle;
+	attr.mmap	    = mmap;
+	attr.comm	    = comm;
+	attr.freq	    = freq;
+	attr.inherit_stat   = inherit_stat;
+	attr.enable_on_exec = enable_on_exec;
+	attr.task	    = task;
+	attr.watermark	    = watermark;
+	attr.precise_ip	    = precise_ip;
+	attr.mmap_data	    = mmap_data;
+	attr.sample_id_all  = sample_id_all;
+
+	perf_evsel__init(&pevsel->evsel, &attr, idx);
+	return 0;
+}
+
+static void pyrf_evsel__delete(struct pyrf_evsel *pevsel)
+{
+	perf_evsel__exit(&pevsel->evsel);
+	pevsel->ob_type->tp_free((PyObject*)pevsel);
+}
+
+static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
+				  PyObject *args, PyObject *kwargs)
+{
+	struct perf_evsel *evsel = &pevsel->evsel;
+	struct cpu_map *cpus = NULL;
+	struct thread_map *threads = NULL;
+	PyObject *pcpus = NULL, *pthreads = NULL;
+	int group = 0, overwrite = 0;
+	static char *kwlist[] = {"cpus", "threads", "group", "overwrite", NULL, NULL};
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist,
+					 &pcpus, &pthreads, &group, &overwrite))
+		return NULL;
+
+	if (pthreads != NULL)
+		threads = ((struct pyrf_thread_map *)pthreads)->threads;
+
+	if (pcpus != NULL)
+		cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
+
+	if (perf_evsel__open(evsel, cpus, threads, group, overwrite) < 0) {
+		PyErr_SetFromErrno(PyExc_OSError);
+		return NULL;
+	}
+
+	Py_INCREF(Py_None);
+	return Py_None;
+}
+
+static PyMethodDef pyrf_evsel__methods[] = {
+	{
+		.ml_name  = "open",
+		.ml_meth  = (PyCFunction)pyrf_evsel__open,
+		.ml_flags = METH_VARARGS | METH_KEYWORDS,
+		.ml_doc	  = PyDoc_STR("open the event selector file descriptor table.")
+	},
+	{ NULL, }
+};
+
+static char pyrf_evsel__doc[] = PyDoc_STR("perf event selector list object.");
+
+static PyTypeObject pyrf_evsel__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.evsel",
+	.tp_basicsize	= sizeof(struct pyrf_evsel),
+	.tp_dealloc	= (destructor)pyrf_evsel__delete,
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_doc		= pyrf_evsel__doc,
+	.tp_methods	= pyrf_evsel__methods,
+	.tp_init	= (initproc)pyrf_evsel__init,
+};
+
+static int pyrf_evsel__setup_types(void)
+{
+	pyrf_evsel__type.tp_new = PyType_GenericNew;
+	return PyType_Ready(&pyrf_evsel__type);
+}
+
+struct pyrf_evlist {
+	PyObject_HEAD
+
+	struct perf_evlist evlist;
+};
+
+static int pyrf_evlist__init(struct pyrf_evlist *pevlist,
+			     PyObject *args, PyObject *kwargs)
+{
+	perf_evlist__init(&pevlist->evlist);
+	return 0;
+}
+
+static void pyrf_evlist__delete(struct pyrf_evlist *pevlist)
+{
+	perf_evlist__exit(&pevlist->evlist);
+	pevlist->ob_type->tp_free((PyObject*)pevlist);
+}
+
+static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
+				   PyObject *args, PyObject *kwargs)
+{
+	struct perf_evlist *evlist = &pevlist->evlist;
+	PyObject *pcpus = NULL, *pthreads = NULL;
+	struct cpu_map *cpus = NULL;
+	struct thread_map *threads = NULL;
+	static char *kwlist[] = {"cpus", "threads", "pages", "overwrite",
+				  NULL, NULL};
+	int pages = 128, overwrite = false;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "OO|ii", kwlist,
+					 &pcpus, &pthreads, &pages, &overwrite))
+		return NULL;
+
+	threads = ((struct pyrf_thread_map *)pthreads)->threads;
+	cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
+
+	if (perf_evlist__mmap(evlist, cpus, threads, pages, overwrite) < 0) {
+		PyErr_SetFromErrno(PyExc_OSError);
+		return NULL;
+	}
+
+	Py_INCREF(Py_None);
+	return Py_None;
+}
+
+static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
+				   PyObject *args, PyObject *kwargs)
+{
+	struct perf_evlist *evlist = &pevlist->evlist;
+	static char *kwlist[] = {"timeout", NULL, NULL};
+	int timeout = -1, n;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|i", kwlist, &timeout))
+		return NULL;
+
+	n = poll(evlist->pollfd, evlist->nr_fds, timeout);
+	if (n < 0) {
+		PyErr_SetFromErrno(PyExc_OSError);
+		return NULL;
+	}
+
+	return Py_BuildValue("i", n);
+}
+
+static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
+					 PyObject *args, PyObject *kwargs)
+{
+	struct perf_evlist *evlist = &pevlist->evlist;
+        PyObject *list = PyList_New(0);
+	int i;
+
+	for (i = 0; i < evlist->nr_fds; ++i) {
+		PyObject *file;
+		FILE *fp = fdopen(evlist->pollfd[i].fd, "r");
+
+		if (fp == NULL)
+			goto free_list;
+
+		file = PyFile_FromFile(fp, "perf", "r", NULL);
+		if (file == NULL)
+			goto free_list;
+
+		if (PyList_Append(list, file) != 0) {
+			Py_DECREF(file);
+			goto free_list;
+		}
+			
+		Py_DECREF(file);
+	}
+
+	return list;
+free_list:
+	return PyErr_NoMemory();
+}
+
+
+static PyObject *pyrf_evlist__add(struct pyrf_evlist *pevlist,
+				  PyObject *args, PyObject *kwargs)
+{
+	struct perf_evlist *evlist = &pevlist->evlist;
+	PyObject *pevsel;
+	struct perf_evsel *evsel;
+
+	if (!PyArg_ParseTuple(args, "O", &pevsel))
+		return NULL;
+
+	Py_INCREF(pevsel);
+	evsel = &((struct pyrf_evsel *)pevsel)->evsel;
+	evsel->idx = evlist->nr_entries;
+	perf_evlist__add(evlist, evsel);
+
+	return Py_BuildValue("i", evlist->nr_entries);
+}
+
+static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
+					  PyObject *args, PyObject *kwargs)
+{
+	struct perf_evlist *evlist = &pevlist->evlist;
+	union perf_event *event;
+	int sample_id_all = 1, cpu;
+	static char *kwlist[] = {"sample_id_all", NULL, NULL};
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
+					 &cpu, &sample_id_all))
+		return NULL;
+
+	event = perf_evlist__read_on_cpu(evlist, cpu);
+	if (event != NULL) {
+		struct perf_evsel *first;
+		PyObject *pyevent = pyrf_event__new(event);
+		struct pyrf_event *pevent = (struct pyrf_event *)pyevent;
+
+		if (pyevent == NULL)
+			return PyErr_NoMemory();
+
+		first = list_entry(evlist->entries.next, struct perf_evsel, node);
+		perf_event__parse_sample(event, first->attr.sample_type, sample_id_all,
+					 &pevent->sample);
+		return pyevent;
+	}
+
+	Py_INCREF(Py_None);
+	return Py_None;
+}
+
+static PyMethodDef pyrf_evlist__methods[] = {
+	{
+		.ml_name  = "mmap",
+		.ml_meth  = (PyCFunction)pyrf_evlist__mmap,
+		.ml_flags = METH_VARARGS | METH_KEYWORDS,
+		.ml_doc	  = PyDoc_STR("mmap the file descriptor table.")
+	},
+	{
+		.ml_name  = "poll",
+		.ml_meth  = (PyCFunction)pyrf_evlist__poll,
+		.ml_flags = METH_VARARGS | METH_KEYWORDS,
+		.ml_doc	  = PyDoc_STR("poll the file descriptor table.")
+	},
+	{
+		.ml_name  = "get_pollfd",
+		.ml_meth  = (PyCFunction)pyrf_evlist__get_pollfd,
+		.ml_flags = METH_VARARGS | METH_KEYWORDS,
+		.ml_doc	  = PyDoc_STR("get the poll file descriptor table.")
+	},
+	{
+		.ml_name  = "add",
+		.ml_meth  = (PyCFunction)pyrf_evlist__add,
+		.ml_flags = METH_VARARGS | METH_KEYWORDS,
+		.ml_doc	  = PyDoc_STR("adds an event selector to the list.")
+	},
+	{
+		.ml_name  = "read_on_cpu",
+		.ml_meth  = (PyCFunction)pyrf_evlist__read_on_cpu,
+		.ml_flags = METH_VARARGS | METH_KEYWORDS,
+		.ml_doc	  = PyDoc_STR("reads an event.")
+	},
+	{ NULL, }
+};
+
+static Py_ssize_t pyrf_evlist__length(PyObject *obj)
+{
+	struct pyrf_evlist *pevlist = (void *)obj;
+
+	return pevlist->evlist.nr_entries;
+}
+
+static PyObject *pyrf_evlist__item(PyObject *obj, Py_ssize_t i)
+{
+	struct pyrf_evlist *pevlist = (void *)obj;
+	struct perf_evsel *pos;
+
+	if (i >= pevlist->evlist.nr_entries)
+		return NULL;
+
+	list_for_each_entry(pos, &pevlist->evlist.entries, node)
+		if (i-- == 0)
+			break;
+
+	return Py_BuildValue("O", container_of(pos, struct pyrf_evsel, evsel));
+}
+
+static PySequenceMethods pyrf_evlist__sequence_methods = {
+	.sq_length = pyrf_evlist__length,
+	.sq_item   = pyrf_evlist__item,
+};
+
+static char pyrf_evlist__doc[] = PyDoc_STR("perf event selector list object.");
+
+static PyTypeObject pyrf_evlist__type = {
+	PyVarObject_HEAD_INIT(NULL, 0)
+	.tp_name	= "perf.evlist",
+	.tp_basicsize	= sizeof(struct pyrf_evlist),
+	.tp_dealloc	= (destructor)pyrf_evlist__delete,
+	.tp_flags	= Py_TPFLAGS_DEFAULT|Py_TPFLAGS_BASETYPE,
+	.tp_as_sequence	= &pyrf_evlist__sequence_methods,
+	.tp_doc		= pyrf_evlist__doc,
+	.tp_methods	= pyrf_evlist__methods,
+	.tp_init	= (initproc)pyrf_evlist__init,
+};
+
+static int pyrf_evlist__setup_types(void)
+{
+	pyrf_evlist__type.tp_new = PyType_GenericNew;
+	return PyType_Ready(&pyrf_evlist__type);
+}
+
+static struct {
+	const char *name;
+	int	    value;
+} perf__constants[] = {
+	{ "TYPE_HARDWARE",   PERF_TYPE_HARDWARE },
+	{ "TYPE_SOFTWARE",   PERF_TYPE_SOFTWARE },
+	{ "TYPE_TRACEPOINT", PERF_TYPE_TRACEPOINT },
+	{ "TYPE_HW_CACHE",   PERF_TYPE_HW_CACHE },
+	{ "TYPE_RAW",	     PERF_TYPE_RAW },
+	{ "TYPE_BREAKPOINT", PERF_TYPE_BREAKPOINT },
+
+	{ "COUNT_HW_CPU_CYCLES",	  PERF_COUNT_HW_CPU_CYCLES },
+	{ "COUNT_HW_INSTRUCTIONS",	  PERF_COUNT_HW_INSTRUCTIONS },
+	{ "COUNT_HW_CACHE_REFERENCES",	  PERF_COUNT_HW_CACHE_REFERENCES },
+	{ "COUNT_HW_CACHE_MISSES",	  PERF_COUNT_HW_CACHE_MISSES },
+	{ "COUNT_HW_BRANCH_INSTRUCTIONS", PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
+	{ "COUNT_HW_BRANCH_MISSES",	  PERF_COUNT_HW_BRANCH_MISSES },
+	{ "COUNT_HW_BUS_CYCLES",	  PERF_COUNT_HW_BUS_CYCLES },
+	{ "COUNT_HW_CACHE_L1D",		  PERF_COUNT_HW_CACHE_L1D },
+	{ "COUNT_HW_CACHE_L1I",		  PERF_COUNT_HW_CACHE_L1I },
+	{ "COUNT_HW_CACHE_LL",	  	  PERF_COUNT_HW_CACHE_LL },
+	{ "COUNT_HW_CACHE_DTLB",	  PERF_COUNT_HW_CACHE_DTLB },
+	{ "COUNT_HW_CACHE_ITLB",	  PERF_COUNT_HW_CACHE_ITLB },
+	{ "COUNT_HW_CACHE_BPU",		  PERF_COUNT_HW_CACHE_BPU },
+	{ "COUNT_HW_CACHE_OP_READ",	  PERF_COUNT_HW_CACHE_OP_READ },
+	{ "COUNT_HW_CACHE_OP_WRITE",	  PERF_COUNT_HW_CACHE_OP_WRITE },
+	{ "COUNT_HW_CACHE_OP_PREFETCH",	  PERF_COUNT_HW_CACHE_OP_PREFETCH },
+	{ "COUNT_HW_CACHE_RESULT_ACCESS", PERF_COUNT_HW_CACHE_RESULT_ACCESS },
+	{ "COUNT_HW_CACHE_RESULT_MISS",   PERF_COUNT_HW_CACHE_RESULT_MISS },
+
+	{ "COUNT_SW_CPU_CLOCK",	       PERF_COUNT_SW_CPU_CLOCK },
+	{ "COUNT_SW_TASK_CLOCK",       PERF_COUNT_SW_TASK_CLOCK },
+	{ "COUNT_SW_PAGE_FAULTS",      PERF_COUNT_SW_PAGE_FAULTS },
+	{ "COUNT_SW_CONTEXT_SWITCHES", PERF_COUNT_SW_CONTEXT_SWITCHES },
+	{ "COUNT_SW_CPU_MIGRATIONS",   PERF_COUNT_SW_CPU_MIGRATIONS },
+	{ "COUNT_SW_PAGE_FAULTS_MIN",  PERF_COUNT_SW_PAGE_FAULTS_MIN },
+	{ "COUNT_SW_PAGE_FAULTS_MAJ",  PERF_COUNT_SW_PAGE_FAULTS_MAJ },
+	{ "COUNT_SW_ALIGNMENT_FAULTS", PERF_COUNT_SW_ALIGNMENT_FAULTS },
+	{ "COUNT_SW_EMULATION_FAULTS", PERF_COUNT_SW_EMULATION_FAULTS },
+
+	{ "SAMPLE_IP",	      PERF_SAMPLE_IP },
+	{ "SAMPLE_TID",	      PERF_SAMPLE_TID },
+	{ "SAMPLE_TIME",      PERF_SAMPLE_TIME },
+	{ "SAMPLE_ADDR",      PERF_SAMPLE_ADDR },
+	{ "SAMPLE_READ",      PERF_SAMPLE_READ },
+	{ "SAMPLE_CALLCHAIN", PERF_SAMPLE_CALLCHAIN },
+	{ "SAMPLE_ID",	      PERF_SAMPLE_ID },
+	{ "SAMPLE_CPU",	      PERF_SAMPLE_CPU },
+	{ "SAMPLE_PERIOD",    PERF_SAMPLE_PERIOD },
+	{ "SAMPLE_STREAM_ID", PERF_SAMPLE_STREAM_ID },
+	{ "SAMPLE_RAW",	      PERF_SAMPLE_RAW },
+
+	{ "FORMAT_TOTAL_TIME_ENABLED", PERF_FORMAT_TOTAL_TIME_ENABLED },
+	{ "FORMAT_TOTAL_TIME_RUNNING", PERF_FORMAT_TOTAL_TIME_RUNNING },
+	{ "FORMAT_ID",		       PERF_FORMAT_ID },
+	{ "FORMAT_GROUP",	       PERF_FORMAT_GROUP },
+
+	{ "RECORD_MMAP",       PERF_RECORD_MMAP },
+	{ "RECORD_LOST",       PERF_RECORD_LOST },
+	{ "RECORD_COMM",       PERF_RECORD_COMM },
+	{ "RECORD_EXIT",       PERF_RECORD_EXIT },
+	{ "RECORD_THROTTLE",   PERF_RECORD_THROTTLE },
+	{ "RECORD_UNTHROTTLE", PERF_RECORD_UNTHROTTLE },
+	{ "RECORD_FORK",       PERF_RECORD_FORK },
+	{ "RECORD_READ",       PERF_RECORD_READ },
+	{ "RECORD_SAMPLE",     PERF_RECORD_SAMPLE },
+	{ NULL, },
+};
+
+static PyMethodDef perf__methods[] = {
+	{ NULL, NULL }
+};
+
+PyMODINIT_FUNC initperf(void)
+{
+	PyObject *obj;
+	int i;
+	PyObject *dict, *module = Py_InitModule("perf", perf__methods);
+
+	if (module == NULL ||
+	    pyrf_event__setup_types() < 0 ||
+	    pyrf_evlist__setup_types() < 0 ||
+	    pyrf_evsel__setup_types() < 0 ||
+	    pyrf_thread_map__setup_types() < 0 ||
+	    pyrf_cpu_map__setup_types() < 0)
+		return;
+
+	Py_INCREF(&pyrf_evlist__type);
+	PyModule_AddObject(module, "evlist", (PyObject*)&pyrf_evlist__type);
+
+	Py_INCREF(&pyrf_evsel__type);
+	PyModule_AddObject(module, "evsel", (PyObject*)&pyrf_evsel__type);
+
+	Py_INCREF(&pyrf_thread_map__type);
+	PyModule_AddObject(module, "thread_map", (PyObject*)&pyrf_thread_map__type);
+
+	Py_INCREF(&pyrf_cpu_map__type);
+	PyModule_AddObject(module, "cpu_map", (PyObject*)&pyrf_cpu_map__type);
+
+	dict = PyModule_GetDict(module);
+	if (dict == NULL)
+		goto error;
+
+	for (i = 0; perf__constants[i].name != NULL; i++) {
+		obj = PyInt_FromLong(perf__constants[i].value);
+		if (obj == NULL)
+			goto error;
+		PyDict_SetItemString(dict, perf__constants[i].name, obj);
+		Py_DECREF(obj);
+	}
+
+error:
+	if (PyErr_Occurred())
+		PyErr_SetString(PyExc_ImportError, "perf: Init failed!");
+}
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
new file mode 100644
index 0000000..496d7f4
--- /dev/null
+++ b/tools/perf/util/setup.py
@@ -0,0 +1,18 @@
+#!/usr/bin/python2
+
+from distutils.core import setup, Extension
+
+perf = Extension('perf',
+		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
+			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
+			     'util/util.c', 'util/xyarray.c'],
+		  include_dirs = ['util/include'])
+
+setup(name='perf',
+      version='0.1',
+      description='Interface with the Linux profiling infrastructure',
+      author='Arnaldo Carvalho de Melo',
+      author_email='acme@redhat.com',
+      license='GPLv2',
+      url='http://perf.wiki.kernel.org',
+      ext_modules=[perf])
