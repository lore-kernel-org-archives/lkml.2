Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab1KRXLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:11:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:43394 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283Ab1KRXKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:10:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,536,1315206000"; 
   d="scan'208";a="92706441"
Message-Id: <20111118230554.105376150@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 15:03:28 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/6] sched: disable sched feature TTWU_QUEUE by default
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=disable_sched_ttwu_queue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Context-switch intensive microbenchmark on a 8-socket system had
~600K times more resched IPI's on each logical CPU with this feature enabled
by default. Disabling this features makes that microbenchmark perform 5 times
better.

Also disabling this feature showed 2% performance improvement on a 8-socket
OLTP workload.

More heurestics are needed when and how to use this feature by default.
For now, disable it by default.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/features.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/kernel/sched/features.h
===================================================================
--- tip.orig/kernel/sched/features.h
+++ tip/kernel/sched/features.h
@@ -64,7 +64,7 @@ SCHED_FEAT(NONTASK_POWER, 1)
  * Queue remote wakeups on the target CPU and process them
  * using the scheduler IPI. Reduces rq->lock contention/bounces.
  */
-SCHED_FEAT(TTWU_QUEUE, 1)
+SCHED_FEAT(TTWU_QUEUE, 0)
 
 SCHED_FEAT(FORCE_SD_OVERLAP, 0)
 SCHED_FEAT(RT_RUNTIME_SHARE, 1)


