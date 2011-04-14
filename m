Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab1DNIjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:39:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:49824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612Ab1DNIj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:39:29 -0400
Date: Thu, 14 Apr 2011 08:39:05 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-23f41eeb42ce7f6f1210904e49e84718f02cb61c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.434609705@chello.nl>
References: <20110405152729.434609705@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Rename ttwu_post_activation() to ttwu_do_wakeup()
Git-Commit-ID: 23f41eeb42ce7f6f1210904e49e84718f02cb61c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:39:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23f41eeb42ce7f6f1210904e49e84718f02cb61c
Gitweb:     http://git.kernel.org/tip/23f41eeb42ce7f6f1210904e49e84718f02cb61c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:56 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:40 +0200

sched: Rename ttwu_post_activation() to ttwu_do_wakeup()

The ttwu_post_activation() code does the core wakeup, it sets TASK_RUNNING
and performs wakeup-preemption, so give is a more descriptive name.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152729.434609705@chello.nl
---
 kernel/sched.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5ec2e8b..e309dba 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2456,8 +2456,11 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
 		wq_worker_waking_up(p, cpu_of(rq));
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
@@ -2562,7 +2565,7 @@ out_activate:
 
 	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
 out_running:
-	ttwu_post_activation(p, rq, wake_flags);
+	ttwu_do_wakeup(rq, p, wake_flags);
 	success = 1;
 	__task_rq_unlock(rq);
 
@@ -2602,7 +2605,7 @@ static void try_to_wake_up_local(struct task_struct *p)
 	if (!p->on_rq)
 		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
 
-	ttwu_post_activation(p, rq, 0);
+	ttwu_do_wakeup(rq, p, 0);
 	ttwu_stat(p, smp_processor_id(), 0);
 out:
 	raw_spin_unlock(&p->pi_lock);
