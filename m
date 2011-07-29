Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1G2IUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:20:40 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38994 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab1G2IUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:20:39 -0400
Date: Fri, 29 Jul 2011 16:20:33 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        lkml <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [RFC PATCH] sched: Kill WAKEUP_PREEMPT
Message-ID: <20110729082033.GB12106@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
 <20110729062158.GA8971@zhy>
 <1311922180.3938.1573.camel@minggr.sh.intel.com>
 <20110729070356.GA10420@zhy>
 <1311924975.3938.1583.camel@minggr.sh.intel.com>
 <20110729074635.GB10420@zhy>
 <1311926218.5890.215.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1311926218.5890.215.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 09:56:58AM +0200, Peter Zijlstra wrote:
> I've queued Lin's patch as I don't see the point of this thing either,
> normally WAKEUP_PREEMPT is enabled so it says || 0 which is kinda
> useless :-)
> 
> And I'm starting to think we should just kill all of WAKEUP_PREEMPT I
> don't think we ever want to disable it anyway.. 

Someting like this?

---
From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [RFC PATCH] sched: Kill WAKEUP_PREEMPT

Per Peter Zijlstra:
> And I'm starting to think we should just kill all of WAKEUP_PREEMPT I
> don't think we ever want to disable it anyway..

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 kernel/sched_fair.c     |    8 +-------
 kernel/sched_features.h |    5 -----
 2 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 46b7855..3c58042 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1114,9 +1114,6 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	 * narrow margin doesn't have to wait for a full slice.
 	 * This also mitigates buddy induced latencies under load.
 	 */
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
 	if (delta_exec < sysctl_sched_min_granularity)
 		return;
 
@@ -1252,7 +1249,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 		return;
 #endif
 
-	if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
+	if (cfs_rq->nr_running > 1)
 		check_preempt_tick(cfs_rq, curr);
 }
 
@@ -1918,9 +1915,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 
-	if (!sched_feat(WAKEUP_PREEMPT))
-		return;
-
 	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
 	BUG_ON(!pse);
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 1e7066d..878a5f9 100644
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
-- 
1.7.4.1


-- 
Only stand for myself
