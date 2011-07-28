Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1G1Jn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:43:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:5787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab1G1JnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:43:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,281,1309762800"; 
   d="scan'208";a="35442653"
Subject: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in entity_tick
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 17:43:23 +0800
Message-ID: <1311846203.3938.1555.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, entity_tick calls check_preempt_tick if WAKEUP_PREEMPT feature is
disabled. That's wrong. It should do that if the feature is enabled.

And actually the check is duplicate because check_preempt_tick will do
that. So just remove it from entity_tick.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..af2fe9d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1233,7 +1233,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 		return;
 #endif
 
-	if (cfs_rq->nr_running > 1 || !sched_feat(WAKEUP_PREEMPT))
+	if (cfs_rq->nr_running > 1)
 		check_preempt_tick(cfs_rq, curr);
 }
 
-- 
1.7.2.3



