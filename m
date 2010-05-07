Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab0EGSlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:41:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:46417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab0EGSll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:41:41 -0400
Date: Fri, 7 May 2010 18:41:19 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1272997616.1642.207.camel@laptop>
References: <1272997616.1642.207.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove rq argument to the tracepoints
Message-ID: <tip-27a9da6538ee18046d7bff8e36a9f783542c54c3@git.kernel.org>
Git-Commit-ID: 27a9da6538ee18046d7bff8e36a9f783542c54c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:41:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27a9da6538ee18046d7bff8e36a9f783542c54c3
Gitweb:     http://git.kernel.org/tip/27a9da6538ee18046d7bff8e36a9f783542c54c3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 4 May 2010 20:36:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:28:17 +0200

sched: Remove rq argument to the tracepoints

struct rq isn't visible outside of sched.o so its near useless to
expose the pointer, also there are no users of it, so remove it.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1272997616.1642.207.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/trace/events/sched.h      |   32 ++++++++++----------------------
 kernel/sched.c                    |    8 ++++----
 kernel/trace/ftrace.c             |    3 +--
 kernel/trace/trace_sched_switch.c |    5 ++---
 kernel/trace/trace_sched_wakeup.c |    5 ++---
 5 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index cfceb0b..4f733ec 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -51,15 +51,12 @@ TRACE_EVENT(sched_kthread_stop_ret,
 
 /*
  * Tracepoint for waiting on task to unschedule:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 TRACE_EVENT(sched_wait_task,
 
-	TP_PROTO(struct rq *rq, struct task_struct *p),
+	TP_PROTO(struct task_struct *p),
 
-	TP_ARGS(rq, p),
+	TP_ARGS(p),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -79,15 +76,12 @@ TRACE_EVENT(sched_wait_task,
 
 /*
  * Tracepoint for waking up a task:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 DECLARE_EVENT_CLASS(sched_wakeup_template,
 
-	TP_PROTO(struct rq *rq, struct task_struct *p, int success),
+	TP_PROTO(struct task_struct *p, int success),
 
-	TP_ARGS(rq, p, success),
+	TP_ARGS(p, success),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -111,31 +105,25 @@ DECLARE_EVENT_CLASS(sched_wakeup_template,
 );
 
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup,
-	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-	     TP_ARGS(rq, p, success));
+	     TP_PROTO(struct task_struct *p, int success),
+	     TP_ARGS(p, success));
 
 /*
  * Tracepoint for waking up a new task:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 DEFINE_EVENT(sched_wakeup_template, sched_wakeup_new,
-	     TP_PROTO(struct rq *rq, struct task_struct *p, int success),
-	     TP_ARGS(rq, p, success));
+	     TP_PROTO(struct task_struct *p, int success),
+	     TP_ARGS(p, success));
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
- *
- * (NOTE: the 'rq' argument is not used by generic trace events,
- *        but used by the latency tracer plugin. )
  */
 TRACE_EVENT(sched_switch,
 
-	TP_PROTO(struct rq *rq, struct task_struct *prev,
+	TP_PROTO(struct task_struct *prev,
 		 struct task_struct *next),
 
-	TP_ARGS(rq, prev, next),
+	TP_ARGS(prev, next),
 
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
diff --git a/kernel/sched.c b/kernel/sched.c
index 4956ed0..11ac0eb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2168,7 +2168,7 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * just go back and repeat.
 		 */
 		rq = task_rq_lock(p, &flags);
-		trace_sched_wait_task(rq, p);
+		trace_sched_wait_task(p);
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
@@ -2439,7 +2439,7 @@ out_activate:
 	success = 1;
 
 out_running:
-	trace_sched_wakeup(rq, p, success);
+	trace_sched_wakeup(p, success);
 	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
@@ -2613,7 +2613,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 
 	rq = task_rq_lock(p, &flags);
 	activate_task(rq, p, 0);
-	trace_sched_wakeup_new(rq, p, 1);
+	trace_sched_wakeup_new(p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
@@ -2833,7 +2833,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(rq, prev, next);
+	trace_sched_switch(prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2404b59..aa3a92b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3212,8 +3212,7 @@ free:
 }
 
 static void
-ftrace_graph_probe_sched_switch(struct rq *__rq, struct task_struct *prev,
-				struct task_struct *next)
+ftrace_graph_probe_sched_switch(struct task_struct *prev, struct task_struct *next)
 {
 	unsigned long long timestamp;
 	int index;
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 5fca0f5..a55fccf 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -50,8 +50,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_switch(struct rq *__rq, struct task_struct *prev,
-			struct task_struct *next)
+probe_sched_switch(struct task_struct *prev, struct task_struct *next)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
@@ -109,7 +108,7 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
+probe_sched_wakeup(struct task_struct *wakee, int success)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0271742..8052446 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -107,8 +107,7 @@ static void probe_wakeup_migrate_task(struct task_struct *task, int cpu)
 }
 
 static void notrace
-probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
-	struct task_struct *next)
+probe_wakeup_sched_switch(struct task_struct *prev, struct task_struct *next)
 {
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
@@ -200,7 +199,7 @@ static void wakeup_reset(struct trace_array *tr)
 }
 
 static void
-probe_wakeup(struct rq *rq, struct task_struct *p, int success)
+probe_wakeup(struct task_struct *p, int success)
 {
 	struct trace_array_cpu *data;
 	int cpu = smp_processor_id();
