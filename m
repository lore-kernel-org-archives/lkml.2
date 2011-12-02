Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1LBBK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:10:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:3642 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1LBBKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="82332039"
Message-Id: <20111202010832.763100675@sbsiddha-desk.sc.intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 01 Dec 2011 17:07:37 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v3 6/6] sched: fix the sched group node allocation for SD_OVERLAP domain
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
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
@@ -5902,7 +5902,7 @@ build_overlap_sched_groups(struct sched_
 			continue;
 
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				GFP_KERNEL, cpu_to_node(i));
+				GFP_KERNEL, cpu_to_node(cpu));
 
 		if (!sg)
 			goto fail;


