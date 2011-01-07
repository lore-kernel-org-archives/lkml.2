Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1AGEnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 23:43:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:38938 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1AGEnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 23:43:51 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: remove root_task_group
Date: Fri,  7 Jan 2011 12:43:34 +0800
Message-Id: <1294375414-31028-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 07 Jan 2011 04:43:36.0896 (UTC) FILETIME=[728B8400:01CBAE25]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

root_task_group is the leftover of USER_SCHED, now it's always
same to init_task_group.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c           |    4 +---
 kernel/sched_autogroup.c |    2 +-
 kernel/sched_fair.c      |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 114a0de..2ba7a7e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -278,8 +278,6 @@ struct task_group {
 #endif
 };
 
-#define root_task_group init_task_group
-
 /* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
 
@@ -1447,7 +1445,7 @@ static int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
 	int ret;
 
 	rcu_read_lock();
-	parent = &root_task_group;
+	parent = &init_task_group;
 down:
 	ret = (*down)(parent, data);
 	if (ret)
diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index c80fedc..ff6c88c 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -90,7 +90,7 @@ out_fail:
 static inline bool
 task_wants_autogroup(struct task_struct *p, struct task_group *tg)
 {
-	if (tg != &root_task_group)
+	if (tg != &init_task_group)
 		return false;
 
 	if (p->sched_class != &fair_sched_class)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c62ebae..a994a28 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1348,7 +1348,7 @@ static void task_waking_fair(struct rq *rq, struct task_struct *p)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
- * effective_load() calculates the load change as seen from the root_task_group
+ * effective_load() calculates the load change as seen from the init_task_group
  *
  * Adding load to a group doesn't make a group heavier, but can cause movement
  * of group shares between cpus. Assuming the shares were perfectly aligned one
-- 
1.7.0.4

