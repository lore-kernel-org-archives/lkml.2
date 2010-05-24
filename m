Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab0EXIVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:21:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56408 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755987Ab0EXIVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:21:16 -0400
Message-ID: <4BFA3787.2040800@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:23:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/8] tracing: Conver more sched events to DEFINE_EVENT
References: <4BFA3728.3000701@cn.fujitsu.com>
In-Reply-To: <4BFA3728.3000701@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert sched_wait_task to DEFINE_EVENT, and save ~1K:

   text    data     bss     dec     hex filename
 104595    9424    4992  119011   1d0e3 kernel/sched.o.orig
 103619    9344    4992  117955   1ccc3 kernel/sched.o

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/sched.h |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 4f733ec..7338c05 100644
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
@@ -223,6 +198,13 @@ DEFINE_EVENT(sched_process_template, sched_process_exit,
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
1.6.3

