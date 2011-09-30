Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab1I3SiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:38:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab1I3SiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:38:21 -0400
Date: Fri, 30 Sep 2011 20:36:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20110930183651.GA22879@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-urgent-for-linus

 Thanks,

	Ingo

------------------>
Shawn Bohrer (1):
      sched/rt: Migrate equal priority tasks to available CPUs

Simon Kirby (1):
      sched: Fix up wchan borkage


 kernel/sched.c    |    2 +-
 kernel/sched_rt.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ec5f472..d249ea8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4372,7 +4372,7 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
 
-asmlinkage void schedule(void)
+asmlinkage void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97540f0..af11778 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1050,7 +1050,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->rt.nr_cpus_allowed < 2 ||
-	     curr->prio < p->prio) &&
+	     curr->prio <= p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int target = find_lowest_rq(p);
 
@@ -1581,7 +1581,7 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
 	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio))
+	     rq->curr->prio <= p->prio))
 		push_rt_tasks(rq);
 }
 
