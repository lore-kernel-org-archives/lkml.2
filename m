Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab1EKQS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:18:26 -0400
Received: from 236.121.91-79.rev.gaoland.net ([79.91.121.236]:60544 "EHLO
	mx.synack.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab1EKQSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:18:22 -0400
From: Samir Bellabes <sam@synack.fr>
To: linux-kernel@vger.kernel.org
Cc: Samir Bellabes <sam@synack.fr>
Subject: [PATCH] [PATCH] remove unused parameters from sched_fork() and wake_up_new_task()
Date: Wed, 11 May 2011 18:18:05 +0200
Message-Id: <1305130685-1047-1-git-send-email-sam@synack.fr>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_fork() and wake_up_new_task() are defined with a parameter
'unsigned long clone_flags', which is unused.
This patch removes the parameters.

Signed-off-by: Samir Bellabes <sam@synack.fr>
---
 include/linux/sched.h |    5 ++---
 kernel/fork.c         |    4 ++--
 kernel/sched.c        |    4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ec2c02..fef4a76 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2057,14 +2057,13 @@ extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
-extern void wake_up_new_task(struct task_struct *tsk,
-				unsigned long clone_flags);
+extern void wake_up_new_task(struct task_struct *tsk);
 #ifdef CONFIG_SMP
  extern void kick_process(struct task_struct *tsk);
 #else
  static inline void kick_process(struct task_struct *tsk) { }
 #endif
-extern void sched_fork(struct task_struct *p, int clone_flags);
+extern void sched_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 extern void proc_caches_init(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..7c440fa 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1153,7 +1153,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p, clone_flags);
+	sched_fork(p);
 
 	retval = perf_event_init_task(p);
 	if (retval)
@@ -1464,7 +1464,7 @@ long do_fork(unsigned long clone_flags,
 		 */
 		p->flags &= ~PF_STARTING;
 
-		wake_up_new_task(p, clone_flags);
+		wake_up_new_task(p);
 
 		tracehook_report_clone_complete(trace, regs,
 						clone_flags, nr, p);
diff --git a/kernel/sched.c b/kernel/sched.c
index 4801363..3105b01 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2626,7 +2626,7 @@ static void __sched_fork(struct task_struct *p)
 /*
  * fork()/clone()-time setup:
  */
-void sched_fork(struct task_struct *p, int clone_flags)
+void sched_fork(struct task_struct *p)
 {
 	int cpu = get_cpu();
 
@@ -2707,7 +2707,7 @@ void sched_fork(struct task_struct *p, int clone_flags)
  * that must be done for every newly created context, then puts the task
  * on the runqueue and wakes it.
  */
-void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
+void wake_up_new_task(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
-- 
1.7.4.1

