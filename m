Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1CNP1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:27:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab1CNP1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:27:50 -0400
Message-Id: <20110314152226.830131130@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 14 Mar 2011 16:06:18 +0100
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
Subject: [RFC][PATCH 05/14] sched: Clean up some ALLNODES code
References: <20110314150613.749843433@chello.nl>
Content-Disposition: inline; filename=sched-foo4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
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


