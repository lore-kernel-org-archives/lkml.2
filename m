Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab1EBWEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:04:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56902 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821Ab1EBWEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:04:42 -0400
Message-Id: <20110502213213.708193594@efficios.com>
User-Agent: quilt/0.48-1
Date: Mon, 02 May 2011 17:11:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC patch 15/32] trace event sched remove trailing semicolon
References: <20110502211123.163877033@efficios.com>
Content-Disposition: inline; filename=trace-event-sched-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Mon,  2 May 2011 21:32:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes. Remove the trailing
semicolons at the end of TRACE_EVENT() and DEFINE_EVENT() in scheduler
instrumentation. Put __trace_sched_switch_state() static inline declaration
within ifdef protection so the preprocessor output is not polluted when creating
an array of events.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
---
 include/trace/events/sched.h |   77 ++++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 36 deletions(-)

Index: linux-2.6-lttng/include/trace/events/sched.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/sched.h
+++ linux-2.6-lttng/include/trace/events/sched.h
@@ -7,6 +7,28 @@
 #include <linux/sched.h>
 #include <linux/tracepoint.h>
 
+#ifndef _TRACE_SCHED_DEF_
+#define _TRACE_SCHED_DEF_
+
+#ifdef CREATE_TRACE_POINTS
+static inline long __trace_sched_switch_state(struct task_struct *p)
+{
+	long state = p->state;
+
+#ifdef CONFIG_PREEMPT
+	/*
+	 * For all intents and purposes a preempted task is a running task.
+	 */
+	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
+		state = TASK_RUNNING;
+#endif
+
+	return state;
+}
+#endif
+
+#endif /* _TRACE_SCHED_DEF_ */
+
 /*
  * Tracepoint for calling kthread_stop, performed to end a kthread:
  */
@@ -27,7 +49,7 @@ TRACE_EVENT(sched_kthread_stop,
 	),
 
 	TP_printk("comm=%s pid=%d", __entry->comm, __entry->pid)
-);
+)
 
 /*
  * Tracepoint for the return value of the kthread stopping:
@@ -47,7 +69,7 @@ TRACE_EVENT(sched_kthread_stop_ret,
 	),
 
 	TP_printk("ret=%d", __entry->ret)
-);
+)
 
 /*
  * Tracepoint for waking up a task:
@@ -77,35 +99,18 @@ DECLARE_EVENT_CLASS(sched_wakeup_templat
 	TP_printk("comm=%s pid=%d prio=%d success=%d target_cpu=%03d",
 		  __entry->comm, __entry->pid, __entry->prio,
 		  __entry->success, __entry->target_cpu)
-);
+)
 
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
 	     TP_PROTO(struct task_struct *p, int success),
-	     TP_ARGS(p, success));
+	     TP_ARGS(p, success))
 
 /*
  * Tracepoint for waking up a new task:
  */
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
 	     TP_PROTO(struct task_struct *p, int success),
-	     TP_ARGS(p, success));
-
-#ifdef CREATE_TRACE_POINTS
-static inline long __trace_sched_switch_state(struct task_struct *p)
-{
-	long state = p->state;
-
-#ifdef CONFIG_PREEMPT
-	/*
-	 * For all intents and purposes a preempted task is a running task.
-	 */
-	if (task_thread_info(p)->preempt_count & PREEMPT_ACTIVE)
-		state = TASK_RUNNING;
-#endif
-
-	return state;
-}
-#endif
+	     TP_ARGS(p, success))
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
@@ -145,7 +150,7 @@ TRACE_EVENT(sched_switch,
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
 				{ 128, "W" }) : "R",
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
-);
+)
 
 /*
  * Tracepoint for a task being migrated:
@@ -175,7 +180,7 @@ TRACE_EVENT(sched_migrate_task,
 	TP_printk("comm=%s pid=%d prio=%d orig_cpu=%d dest_cpu=%d",
 		  __entry->comm, __entry->pid, __entry->prio,
 		  __entry->orig_cpu, __entry->dest_cpu)
-);
+)
 
 DECLARE_EVENT_CLASS(sched_process_template,
 
@@ -197,14 +202,14 @@ DECLARE_EVENT_CLASS(sched_process_templa
 
 	TP_printk("comm=%s pid=%d prio=%d",
 		  __entry->comm, __entry->pid, __entry->prio)
-);
+)
 
 /*
  * Tracepoint for freeing a task:
  */
 DEFINE_EVENT(sched_process_template, sched_process_free,
 	     TP_PROTO(struct task_struct *p),
-	     TP_ARGS(p));
+	     TP_ARGS(p))
 	     
 
 /*
@@ -212,14 +217,14 @@ DEFINE_EVENT(sched_process_template, sch
  */
 DEFINE_EVENT(sched_process_template, sched_process_exit,
 	     TP_PROTO(struct task_struct *p),
-	     TP_ARGS(p));
+	     TP_ARGS(p))
 
 /*
  * Tracepoint for waiting on task to unschedule:
  */
 DEFINE_EVENT(sched_process_template, sched_wait_task,
 	TP_PROTO(struct task_struct *p),
-	TP_ARGS(p));
+	TP_ARGS(p))
 
 /*
  * Tracepoint for a waiting task:
@@ -244,7 +249,7 @@ TRACE_EVENT(sched_process_wait,
 
 	TP_printk("comm=%s pid=%d prio=%d",
 		  __entry->comm, __entry->pid, __entry->prio)
-);
+)
 
 /*
  * Tracepoint for do_fork:
@@ -272,7 +277,7 @@ TRACE_EVENT(sched_process_fork,
 	TP_printk("comm=%s pid=%d child_comm=%s child_pid=%d",
 		__entry->parent_comm, __entry->parent_pid,
 		__entry->child_comm, __entry->child_pid)
-);
+)
 
 /*
  * XXX the below sched_stat tracepoints only apply to SCHED_OTHER/BATCH/IDLE
@@ -302,7 +307,7 @@ DECLARE_EVENT_CLASS(sched_stat_template,
 	TP_printk("comm=%s pid=%d delay=%Lu [ns]",
 			__entry->comm, __entry->pid,
 			(unsigned long long)__entry->delay)
-);
+)
 
 
 /*
@@ -311,7 +316,7 @@ DECLARE_EVENT_CLASS(sched_stat_template,
  */
 DEFINE_EVENT(sched_stat_template, sched_stat_wait,
 	     TP_PROTO(struct task_struct *tsk, u64 delay),
-	     TP_ARGS(tsk, delay));
+	     TP_ARGS(tsk, delay))
 
 /*
  * Tracepoint for accounting sleep time (time the task is not runnable,
@@ -319,7 +324,7 @@ DEFINE_EVENT(sched_stat_template, sched_
  */
 DEFINE_EVENT(sched_stat_template, sched_stat_sleep,
 	     TP_PROTO(struct task_struct *tsk, u64 delay),
-	     TP_ARGS(tsk, delay));
+	     TP_ARGS(tsk, delay))
 
 /*
  * Tracepoint for accounting iowait time (time the task is not runnable
@@ -327,7 +332,7 @@ DEFINE_EVENT(sched_stat_template, sched_
  */
 DEFINE_EVENT(sched_stat_template, sched_stat_iowait,
 	     TP_PROTO(struct task_struct *tsk, u64 delay),
-	     TP_ARGS(tsk, delay));
+	     TP_ARGS(tsk, delay))
 
 /*
  * Tracepoint for accounting runtime (time the task is executing
@@ -360,7 +365,7 @@ TRACE_EVENT(sched_stat_runtime,
 			__entry->comm, __entry->pid,
 			(unsigned long long)__entry->runtime,
 			(unsigned long long)__entry->vruntime)
-);
+)
 
 /*
  * Tracepoint for showing priority inheritance modifying a tasks
@@ -389,7 +394,7 @@ TRACE_EVENT(sched_pi_setprio,
 	TP_printk("comm=%s pid=%d oldprio=%d newprio=%d",
 			__entry->comm, __entry->pid,
 			__entry->oldprio, __entry->newprio)
-);
+)
 
 #endif /* _TRACE_SCHED_H */
 

