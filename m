Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab1CBRqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:46:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:45894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab1CBRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:46:38 -0500
Message-Id: <20110302174121.564867855@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 02 Mar 2011 18:38:49 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 18/22] sched: Rename ttwu_post_activation
References: <20110302173831.295031866@chello.nl>
Content-Disposition: inline; filename=sched-ttwu_do_wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ttwu_post_activation() does the core wakeup, it sets TASK_RUNNING
and performs wakeup-preemption, so give is a more descriptive name.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2399,8 +2399,11 @@ ttwu_stat(struct task_struct *p, int cpu
 #endif /* CONFIG_SCHEDSTATS */
 }
 
+/*
+ * Mark the task runnable and perform wakeup-preemption.
+ */
 static void
-ttwu_post_activation(struct task_struct *p, struct rq *rq, int wake_flags)
+ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
 	trace_sched_wakeup(p, true);
 	check_preempt_curr(rq, p, wake_flags);
@@ -2492,7 +2495,7 @@ try_to_wake_up(struct task_struct *p, un
 
 	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
 out_running:
-	ttwu_post_activation(p, rq, wake_flags);
+	ttwu_do_wakeup(rq, p, wake_flags);
 	success = 1;
 	__task_rq_unlock(rq);
 
@@ -2529,7 +2532,7 @@ static void try_to_wake_up_local(struct 
 	if (!p->on_rq)
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
-	ttwu_post_activation(p, rq, 0);
+	ttwu_do_wakeup(rq, p, 0);
 	ttwu_stat(p, smp_processor_id(), 0);
 out:
 	raw_spin_unlock(&p->pi_lock);


