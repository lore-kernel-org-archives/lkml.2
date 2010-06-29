Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0F2JXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:23:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:39160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab0F2JXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:23:03 -0400
Date: Tue, 29 Jun 2010 09:22:39 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4BFA3787.2040800@cn.fujitsu.com>
References: <4BFA3787.2040800@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Convert more sched events to DEFINE_EVENT
Message-ID: <tip-210f766915207636acccba7bec42248bfe882998@git.kernel.org>
Git-Commit-ID: 210f766915207636acccba7bec42248bfe882998
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:22:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  210f766915207636acccba7bec42248bfe882998
Gitweb:     http://git.kernel.org/tip/210f766915207636acccba7bec42248bfe882998
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 24 May 2010 16:23:35 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 28 Jun 2010 17:12:50 -0400

tracing: Convert more sched events to DEFINE_EVENT

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
