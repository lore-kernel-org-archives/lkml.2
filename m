Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab1ADXvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:51:16 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33048 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1ADXvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:51:13 -0500
Message-Id: <20110104232419.782205410@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 18:16:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [RFC patch 5/5] trace event sched: remove TP_perf_assign
References: <20110104231629.996422888@efficios.com>
Content-Disposition: inline; filename=trace-event-sched-remove-perf-count.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  4 Jan 2011 23:24:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TP_perf_assign part of 2 scheduler TRACE_EVENT are not used and don't act as
TRACE_EVENT fields per se.

CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Mike Galbraith <efault@gmx.de>
CC: Paul Mackerras <paulus@samba.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/trace/events/sched.h |    6 ------
 include/trace/ftrace.h       |    6 ------
 2 files changed, 12 deletions(-)

Index: linux-2.6-lttng/include/trace/events/sched.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/sched.h
+++ linux-2.6-lttng/include/trace/events/sched.h
@@ -294,9 +294,6 @@ DECLARE_EVENT_CLASS(sched_stat_template,
 		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
 		__entry->pid	= tsk->pid;
 		__entry->delay	= delay;
-	)
-	TP_perf_assign(
-		__perf_count(delay);
 	),
 
 	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
@@ -351,9 +348,6 @@ TRACE_EVENT(sched_stat_runtime,
 		__entry->pid		= tsk->pid;
 		__entry->runtime	= runtime;
 		__entry->vruntime	= vruntime;
-	)
-	TP_perf_assign(
-		__perf_count(runtime);
 	),
 
 	TP_printk("comm=%s pid=%d runtime=%Lu [ns] vruntime=%Lu [ns]",
Index: linux-2.6-lttng/include/trace/ftrace.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/ftrace.h
+++ linux-2.6-lttng/include/trace/ftrace.h
@@ -481,9 +481,6 @@ static inline notrace int ftrace_get_off
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
 
-#undef TP_perf_assign
-#define TP_perf_assign(args...)
-
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 									\
@@ -680,9 +677,6 @@ __attribute__((section("_ftrace_events")
 #undef __perf_addr
 #define __perf_addr(a) __addr = (a)
 
-#undef __perf_count
-#define __perf_count(c) __count = (c)
-
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\

