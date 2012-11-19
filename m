Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2KSKow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:44:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:40645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab2KSKov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:44:51 -0500
X-IronPort-AV: E=Sophos;i="4.83,279,1352044800"; 
   d="scan'208";a="6231070"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, serge@hallyn.com, akpm@linux-foundation.org,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] pidns: remove the useless function is_container_init
Date: Mon, 19 Nov 2012 18:44:42 +0800
Message-Id: <1353321882-30491-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 18:44:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/19 18:44:37,
	Serialize complete at 2012/11/19 18:44:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since commit 1cdcbec1a3372c0c49c59d292e708fd07b509f18,
is_container_init has no used for a long time.

just remove it.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/sched.h |    6 ------
 kernel/pid.c          |   15 ---------------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0dd42a0..3fadd26 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1710,12 +1710,6 @@ static inline int is_global_init(struct task_struct *tsk)
 	return tsk->pid == 1;
 }
 
-/*
- * is_container_init:
- * check whether in the task is init in its own pid namespace.
- */
-extern int is_container_init(struct task_struct *tsk);
-
 extern struct pid *cad_pid;
 
 extern void free_task(struct task_struct *tsk);
diff --git a/kernel/pid.c b/kernel/pid.c
index aebd4f5..8ccdf0e 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -81,21 +81,6 @@ struct pid_namespace init_pid_ns = {
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
-int is_container_init(struct task_struct *tsk)
-{
-	int ret = 0;
-	struct pid *pid;
-
-	rcu_read_lock();
-	pid = task_pid(tsk);
-	if (pid != NULL && pid->numbers[pid->level].nr == 1)
-		ret = 1;
-	rcu_read_unlock();
-
-	return ret;
-}
-EXPORT_SYMBOL(is_container_init);
-
 /*
  * Note: disable interrupts while the pidmap_lock is held as an
  * interrupt might come in and do read_lock(&tasklist_lock).
-- 
1.7.7.6

