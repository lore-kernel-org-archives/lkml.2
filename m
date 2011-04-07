Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1DGMlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:41:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:48202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1DGMlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:41:12 -0400
Message-Id: <20110407122942.025636011@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/23] sched: Clean up some ALLNODES code
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7256,7 +7256,9 @@ static void build_sched_groups(struct s_
 						d->send_covered, d->tmpmask);
 
 	case SD_LV_ALLNODES:
-		init_sched_build_groups(cpu_map, cpu_map, &cpu_to_allnodes_group,
+		if (cpu == cpumask_first(cpu_map))
+			init_sched_build_groups(cpu_map, cpu_map,
+					&cpu_to_allnodes_group,
 					d->send_covered, d->tmpmask);
 		break;
 #endif
@@ -7307,14 +7309,9 @@ static int __build_sched_domains(const s
 		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
 		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
 		build_sched_groups(&d, SD_LV_NODE, cpu_map, i);
+		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, i);
 	}
 
-#ifdef CONFIG_NUMA
-	/* Set up node groups */
-	if (d.sd_allnodes)
-		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, 0);
-#endif
-
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
 	for_each_cpu(i, cpu_map) {


