Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0F2DKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:10:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0F2DKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:10:45 -0400
X-Authority-Analysis: v=1.1 cv=fhltGCNqn7I0vuW4QMEj3LCOhQQl14bnXIhcDW1W0Bg= c=1 sm=0 a=I8fKHGn6QH8A:10 a=yQWWgrYGNuUA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=bsh6GnydtJJ8K8m1yDsA:9 a=JzuoIlrIf2yuzguqVUYA:7 a=S7gKavcUMv3qGao6Bz5MbUa3L7wA:4 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100629031043.610262509@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 28 Jun 2010 23:08:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/9] tracing: Convert more sched events to DEFINE_EVENT
References: <20100629030836.222433712@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Convert-more-sched-events-to-DEFINE_EVENT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Convert sched_wait_task to DEFINE_EVENT, and save ~1K:

   text    data     bss     dec     hex filename
 104595    9424    4992  119011   1d0e3 kernel/sched.o.orig
 103619    9344    4992  117955   1ccc3 kernel/sched.o

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4BFA3787.2040800@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b9e1dd6..9208c92 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -50,31 +50,6 @@ TRACE_EVENT(sched_kthread_stop_ret,
 );
 
 /*
- * Tracepoint for waiting on task to unschedule:
- */
-TRACE_EVENT(sched_wait_task,
-
-	TP_PROTO(struct task_struct *p),
-
-	TP_ARGS(p),
-
-	TP_STRUCT__entry(
-		__array(	char,	comm,	TASK_COMM_LEN	)
-		__field(	pid_t,	pid			)
-		__field(	int,	prio			)
-	),
-
-	TP_fast_assign(
-		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
-		__entry->pid	= p->pid;
-		__entry->prio	= p->prio;
-	),
-
-	TP_printk("comm=%s pid=%d prio=%d",
-		  __entry->comm, __entry->pid, __entry->prio)
-);
-
-/*
  * Tracepoint for waking up a task:
  */
 DECLARE_EVENT_CLASS(sched_wakeup_template,
@@ -240,6 +215,13 @@ DEFINE_EVENT(sched_process_template, sched_process_exit,
 	     TP_ARGS(p));
 
 /*
+ * Tracepoint for waiting on task to unschedule:
+ */
+DEFINE_EVENT(sched_process_template, sched_wait_task,
+	TP_PROTO(struct task_struct *p),
+	TP_ARGS(p));
+
+/*
  * Tracepoint for a waiting task:
  */
 TRACE_EVENT(sched_process_wait,
-- 
1.7.1


