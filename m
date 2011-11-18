Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab1KRXK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:10:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:43923 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493Ab1KRXKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:10:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,535,1315206000"; 
   d="scan'208";a="76848909"
Message-Id: <20111118230554.164910950@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 15:03:29 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 6/6] sched: fix the sched group node allocation for SD_OVERLAP domain
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
Content-Disposition: inline; filename=fix_sched_group_node_allocation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the SD_OVERLAP domain, sched_groups for each CPU's sched_domain are
privately allocated and not shared with any other cpu. So the
sched group allocation should come from the cpu's node for which
SD_OVERLAP sched domain is being setup.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/kernel/sched/core.c
===================================================================
--- tip.orig/kernel/sched/core.c
+++ tip/kernel/sched/core.c
@@ -5879,7 +5879,7 @@ build_overlap_sched_groups(struct sched_
 			continue;
 
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				GFP_KERNEL, cpu_to_node(i));
+				GFP_KERNEL, cpu_to_node(cpu));
 
 		if (!sg)
 			goto fail;


