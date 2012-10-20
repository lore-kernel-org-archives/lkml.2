Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2JTQac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:30:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46218 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2JTQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:30:29 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 3/3] workqueue: remove unused argument of wq_worker_waking_up()
Date: Sun, 21 Oct 2012 01:30:07 +0900
Message-Id: <1350750607-2051-4-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350750607-2051-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1350750607-2051-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 63d95a91 ('workqueue: use @pool instead of @gcwq or @cpu where
applicable') changes an approach to access nr_running.
Thus, wq_worker_waking_up() doesn't use @cpu anymore.
Remove it and remove comment related to it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..30a23d0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1243,7 +1243,7 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 
 	/* if a worker is waking up, notify workqueue */
 	if (p->flags & PF_WQ_WORKER)
-		wq_worker_waking_up(p, cpu_of(rq));
+		wq_worker_waking_up(p);
 }
 
 /*
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 27a6dee..daf101c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -727,7 +727,6 @@ static void wake_up_worker(struct worker_pool *pool)
 /**
  * wq_worker_waking_up - a worker is waking up
  * @task: task waking up
- * @cpu: CPU @task is waking up to
  *
  * This function is called during try_to_wake_up() when a worker is
  * being awoken.
@@ -735,7 +734,7 @@ static void wake_up_worker(struct worker_pool *pool)
  * CONTEXT:
  * spin_lock_irq(rq->lock)
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
+void wq_worker_waking_up(struct task_struct *task)
 {
 	struct worker *worker = kthread_data(task);
 
diff --git a/kernel/workqueue_sched.h b/kernel/workqueue_sched.h
index 2d10fc9..c1b45a5 100644
--- a/kernel/workqueue_sched.h
+++ b/kernel/workqueue_sched.h
@@ -4,6 +4,6 @@
  * Scheduler hooks for concurrency managed workqueue.  Only to be
  * included from sched.c and workqueue.c.
  */
-void wq_worker_waking_up(struct task_struct *task, unsigned int cpu);
+void wq_worker_waking_up(struct task_struct *task);
 struct task_struct *wq_worker_sleeping(struct task_struct *task,
 				       unsigned int cpu);
-- 
1.7.9.5

