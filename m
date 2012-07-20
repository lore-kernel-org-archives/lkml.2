Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2GTGTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:19:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:25852 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab2GTGTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124666982"
From: Alex Shi <alex.shi@intel.com>
To: a.p.zijlstra@chello.nl
Cc: tj@kernel.org, alex.shi@intel.com, mingo@kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sched/numa: recovered SD_PERFER_SIBLING on CPU domain
Date: Fri, 20 Jul 2012 14:19:50 +0800
Message-Id: <1342765190-21540-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8e7fbcbc22c(sched: Remove stale power aware scheduling remnants
and dysfunctional knobs) removed SD_PERFER_SIBLING on CPU domain
On numa machine, that causes load_balance didn't perfer LCPU in same
physical CPU package.

It causes some regression on our numa machines from core2 to NHM and SNB.
Recover this domain flag can recover the performance drop.

This recovery doesn't has any bad impact on my all benchmarks specjbb,
kbuild, fio, hackbench .. etc, on all my machines.
Since it is a recovery, I assume it also has no bad impact for other
platforms.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/topology.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index e91cd43..fec12d6 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -164,6 +164,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| 1*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
-- 
1.7.5.4

