Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0DDKMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 06:12:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab0DDKLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 06:11:54 -0400
Date: Sun, 4 Apr 2010 12:11:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20100404101148.GA4178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Mike Galbraith (1):
      sched: Fix proc_sched_set_task()

Oleg Nesterov (1):
      sched: set_cpus_allowed_ptr(): Don't use rq->migration_thread after unlock


 kernel/sched.c       |    2 +-
 kernel/sched_debug.c |    4 ----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 49d2fa7..528a105 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5387,7 +5387,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 
 		get_task_struct(mt);
 		task_rq_unlock(rq, &flags);
-		wake_up_process(rq->migration_thread);
+		wake_up_process(mt);
 		put_task_struct(mt);
 		wait_for_completion(&req.done);
 		tlb_migrate_finish(p->mm);
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 67f95aa..9b49db1 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -518,8 +518,4 @@ void proc_sched_set_task(struct task_struct *p)
 	p->se.nr_wakeups_idle			= 0;
 	p->sched_info.bkl_count			= 0;
 #endif
-	p->se.sum_exec_runtime			= 0;
-	p->se.prev_sum_exec_runtime		= 0;
-	p->nvcsw				= 0;
-	p->nivcsw				= 0;
 }
