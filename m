Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2HTUny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:43:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2HTUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:43:51 -0400
Date: Mon, 20 Aug 2012 13:38:43 -0700
From: Tejun Heo <tj@kernel.org>
To: valentin.ilie@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: fix checkpatch issues
Message-ID: <20120820203843.GU24861@google.com>
References: <1345326762-21747-1-git-send-email-valentin.ilie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345326762-21747-1-git-send-email-valentin.ilie@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 044c782ce3a901fbd17cbe701c592f582381174d Mon Sep 17 00:00:00 2001
From: Valentin Ilie <valentin.ilie@gmail.com>
Date: Sun, 19 Aug 2012 00:52:42 +0300

Fixed some checkpatch warnings.

tj: adapted to wq/for-3.7 and massaged pr_xxx() format strings a bit.

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <1345326762-21747-1-git-send-email-valentin.ilie@gmail.com>
---
Applied to wq/for-3.7 with some updates.

Thanks.

 kernel/workqueue.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7da2471..de429ba 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -269,18 +269,18 @@ struct workqueue_struct {
 };
 
 struct workqueue_struct *system_wq __read_mostly;
-struct workqueue_struct *system_highpri_wq __read_mostly;
-struct workqueue_struct *system_long_wq __read_mostly;
-struct workqueue_struct *system_nrt_wq __read_mostly;
-struct workqueue_struct *system_unbound_wq __read_mostly;
-struct workqueue_struct *system_freezable_wq __read_mostly;
-struct workqueue_struct *system_nrt_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
+struct workqueue_struct *system_highpri_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_highpri_wq);
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
@@ -2232,11 +2232,9 @@ __acquires(&gcwq->lock)
 	lock_map_release(&cwq->wq->lockdep_map);
 
 	if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
-		printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
-		       "%s/0x%08x/%d\n",
-		       current->comm, preempt_count(), task_pid_nr(current));
-		printk(KERN_ERR "    last function: ");
-		print_symbol("%s\n", (unsigned long)f);
+		pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d\n"
+		       "     last function: %pf\n",
+		       current->comm, preempt_count(), task_pid_nr(current), f);
 		debug_show_held_locks(current);
 		dump_stack();
 	}
@@ -2790,8 +2788,8 @@ reflush:
 
 		if (++flush_cnt == 10 ||
 		    (flush_cnt % 100 == 0 && flush_cnt <= 1000))
-			pr_warning("workqueue %s: flush on destruction isn't complete after %u tries\n",
-				   wq->name, flush_cnt);
+			pr_warn("workqueue %s: flush on destruction isn't complete after %u tries\n",
+				wq->name, flush_cnt);
 		goto reflush;
 	}
 
@@ -3275,9 +3273,8 @@ static int wq_clamp_max_active(int max_active, unsigned int flags,
 	int lim = flags & WQ_UNBOUND ? WQ_UNBOUND_MAX_ACTIVE : WQ_MAX_ACTIVE;
 
 	if (max_active < 1 || max_active > lim)
-		printk(KERN_WARNING "workqueue: max_active %d requested for %s "
-		       "is out of range, clamping between %d and %d\n",
-		       max_active, name, 1, lim);
+		pr_warn("workqueue: max_active %d requested for %s is out of range, clamping between %d and %d\n",
+			max_active, name, 1, lim);
 
 	return clamp_val(max_active, 1, lim);
 }
-- 
1.7.7.3

