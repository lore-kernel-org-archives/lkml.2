Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1DEPbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:31:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1DEPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:36 -0400
Message-Id: <20110405152729.434609705@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:56 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 18/21] sched: Rename ttwu_post_activation
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-ttwu_do_wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ttwu_post_activation() does the core wakeup, it sets TASK_RUNNING
and performs wakeup-preemption, so give is a more descriptive name.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/sched.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2447,8 +2447,11 @@ ttwu_stat(struct task_struct *p, int cpu
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
@@ -2555,7 +2558,7 @@ try_to_wake_up(struct task_struct *p, un
 	activate_task(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
 	p->on_rq = 1;
 out_running:
-	ttwu_post_activation(p, rq, wake_flags);
+	ttwu_do_wakeup(rq, p, wake_flags);
 	success = 1;
 	__task_rq_unlock(rq);
 
@@ -2592,7 +2595,7 @@ static void try_to_wake_up_local(struct 
 	if (!p->on_rq)
 		activate_task(rq, p, ENQUEUE_WAKEUP);
 
-	ttwu_post_activation(p, rq, 0);
+	ttwu_do_wakeup(rq, p, 0);
 	ttwu_stat(p, smp_processor_id(), 0);
 out:
 	raw_spin_unlock(&p->pi_lock);


