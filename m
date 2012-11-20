Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2KTOGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:06:43 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:57488 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752314Ab2KTOGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:06:42 -0500
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cgroup: remove obsolete guarantee from cgroup_task_migrate.
Date: Tue, 20 Nov 2012 22:06:18 +0800
Message-Id: <1353420379-3131-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 123.121.144.191 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

'guarantee' is already removed from cgroup_task_migrate, so remove
the corresponding comments. Some other typos in cgroup are also
changed.

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 include/linux/cgroup.h |    4 ++--
 kernel/cgroup.c        |    8 +++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f8a030c..7508ac0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -66,7 +66,7 @@ struct cgroup_subsys_state {
 	/*
 	 * State maintained by the cgroup system to allow subsystems
 	 * to be "busy". Should be accessed via css_get(),
-	 * css_tryget() and and css_put().
+	 * css_tryget() and css_put().
 	 */
 
 	atomic_t refcnt;
@@ -282,7 +282,7 @@ struct cgroup_map_cb {
 
 /* cftype->flags */
 #define CFTYPE_ONLY_ON_ROOT	(1U << 0)	/* only create on root cg */
-#define CFTYPE_NOT_ON_ROOT	(1U << 1)	/* don't create onp root cg */
+#define CFTYPE_NOT_ON_ROOT	(1U << 1)	/* don't create on root cg */
 
 #define MAX_CFTYPE_NAME		64
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a9f8388..46b8f7d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -782,12 +782,12 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  *	The task_lock() exception
  *
  * The need for this exception arises from the action of
- * cgroup_attach_task(), which overwrites one tasks cgroup pointer with
+ * cgroup_attach_task(), which overwrites one task's cgroup pointer with
  * another.  It does so using cgroup_mutex, however there are
  * several performance critical places that need to reference
  * task->cgroup without the expense of grabbing a system global
  * mutex.  Therefore except as noted below, when dereferencing or, as
- * in cgroup_attach_task(), modifying a task'ss cgroup pointer we use
+ * in cgroup_attach_task(), modifying a task's cgroup pointer we use
  * task_lock(), which acts on a spinlock (task->alloc_lock) already in
  * the task_struct routinely used for such matters.
  *
@@ -1930,9 +1930,7 @@ EXPORT_SYMBOL_GPL(cgroup_taskset_size);
 /*
  * cgroup_task_migrate - move a task from one cgroup to another.
  *
- * 'guarantee' is set if the caller promises that a new css_set for the task
- * will already exist. If not set, this function might sleep, and can fail with
- * -ENOMEM. Must be called with cgroup_mutex and threadgroup locked.
+ * Must be called with cgroup_mutex and threadgroup locked.
  */
 static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 				struct task_struct *tsk, struct css_set *newcg)
-- 
1.7.1

