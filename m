Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2HRVxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:53:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40863 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2HRVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:53:11 -0400
From: valentin.ilie@gmail.com
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, valentin <valentin.ilie@gmail.com>
Subject: [PATCH] kernel: workqueue.c: fixed checkpatch issues
Date: Sun, 19 Aug 2012 00:52:42 +0300
Message-Id: <1345326762-21747-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: valentin <valentin.ilie@gmail.com>

Fixed some checkpatch warnings.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 kernel/workqueue.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 692d976..c4d57c8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -268,16 +268,16 @@ struct workqueue_struct {
 };
 
 struct workqueue_struct *system_wq __read_mostly;
-struct workqueue_struct *system_long_wq __read_mostly;
-struct workqueue_struct *system_nrt_wq __read_mostly;
-struct workqueue_struct *system_unbound_wq __read_mostly;
-struct workqueue_struct *system_freezable_wq __read_mostly;
-struct workqueue_struct *system_nrt_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
+struct workqueue_struct *system_long_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_long_wq);
+struct workqueue_struct *system_nrt_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_nrt_wq);
+struct workqueue_struct *system_unbound_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_unbound_wq);
+struct workqueue_struct *system_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_freezable_wq);
+struct workqueue_struct *system_nrt_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_nrt_freezable_wq);
 
 #define CREATE_TRACE_POINTS
@@ -2011,10 +2011,9 @@ __acquires(&gcwq->lock)
 	lock_map_release(&cwq->wq->lockdep_map);
 
 	if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
-		printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
-		       "%s/0x%08x/%d\n",
+		pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d\n",
 		       current->comm, preempt_count(), task_pid_nr(current));
-		printk(KERN_ERR "    last function: ");
+		pr_err("    last function: ");
 		print_symbol("%s\n", (unsigned long)f);
 		debug_show_held_locks(current);
 		dump_stack();
@@ -2569,8 +2568,8 @@ reflush:
 
 		if (++flush_cnt == 10 ||
 		    (flush_cnt % 100 == 0 && flush_cnt <= 1000))
-			pr_warning("workqueue %s: flush on destruction isn't complete after %u tries\n",
-				   wq->name, flush_cnt);
+			pr_warn("workqueue %s: flush on destruction isn't complete after %u tries\n",
+				wq->name, flush_cnt);
 		goto reflush;
 	}
 
@@ -2781,7 +2780,7 @@ static int try_to_grab_pending(struct work_struct *work)
 }
 
 static bool __cancel_work_timer(struct work_struct *work,
-				struct timer_list* timer)
+				struct timer_list *timer)
 {
 	int ret;
 
@@ -3085,9 +3084,9 @@ static int wq_clamp_max_active(int max_active, unsigned int flags,
 	int lim = flags & WQ_UNBOUND ? WQ_UNBOUND_MAX_ACTIVE : WQ_MAX_ACTIVE;
 
 	if (max_active < 1 || max_active > lim)
-		printk(KERN_WARNING "workqueue: max_active %d requested for %s "
-		       "is out of range, clamping between %d and %d\n",
-		       max_active, name, 1, lim);
+		pr_warn("workqueue: max_active %d requested for %s is out of "
+			"range, clamping between %d and %d\n",
+			max_active, name, 1, lim);
 
 	return clamp_val(max_active, 1, lim);
 }
-- 
1.7.10.4

