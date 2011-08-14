Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1HNP5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:57:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:51179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab1HNP5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:57:51 -0400
Date: Sun, 14 Aug 2011 15:57:36 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-2c2efaed9bc973e3aeab1385c618017b56c8f6d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, yong.zhang0@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <20110729082033.GB12106@zhy>
References: <20110729082033.GB12106@zhy>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Kill WAKEUP_PREEMPT
Git-Commit-ID: 2c2efaed9bc973e3aeab1385c618017b56c8f6d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:57:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c2efaed9bc973e3aeab1385c618017b56c8f6d7
Gitweb:     http://git.kernel.org/tip/2c2efaed9bc973e3aeab1385c618017b56c8f6d7
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Fri, 29 Jul 2011 16:20:33 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:00:41 +0200

sched: Kill WAKEUP_PREEMPT

Remove the WAKEUP_PREEMPT feature, disabling it doesn't make any sense
and its outlived its use by a long long while.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110729082033.GB12106@zhy
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c     |    9 +--------
 kernel/sched_features.h |    5 -----
 2 files changed, 1 insertions(+), 13 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..241fc86 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1095,9 +1095,6 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	 * narrow margin doesn't have to wait for a full slice.
 	 * This also mitigates buddy induced latencies under load.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
 	if (delta_exec < sysctl_sched_min_granularity)
 		return;
 
@@ -1233,7 +1230,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 		return;
 #endif
 
-	if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
+	if (cfs_rq->nr_running > 1)
 		check_preempt_tick(cfs_rq, curr);
 }
 
@@ -1899,10 +1896,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(p->policy != SCHED_NORMAL))
 		return;
 
-
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
 	find_matching_se(&se, &pse);
 	update_curr(cfs_rq_of(se));
 	BUG_ON(!pse);
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 2e74677..efa0a7b 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -12,11 +12,6 @@ SCHED_FEAT(GENTLE_FAIR_SLEEPERS, 1)
 SCHED_FEAT(START_DEBIT, 1)
 
 /*
- * Should wakeups try to preempt running tasks.
- */
-SCHED_FEAT(WAKEUP_PREEMPT, 1)
-
-/*
  * Based on load and program behaviour, see if it makes sense to place
  * a newly woken task on the same cpu as the task that woke it --
  * improve cache locality. Typically used with SYNC wakeups as
