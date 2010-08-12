Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab0HLRZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:25:30 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:58130 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab0HLRYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:24:34 -0400
Message-Id: <20100812172621.703227914@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Thu, 12 Aug 2010 19:25:45 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 1/5] [PATCH] sched: merge cpu_to_core_group functions
References: <20100812172544.655648128@de.ibm.com>
Content-Disposition: inline; filename=01-sched-cputocore.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Merge and simplify the two cpu_to_core_group variants so that the
resulting function follows the same pattern like cpu_to_phys_group.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 kernel/sched.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff -urpN linux-2.6/kernel/sched.c linux-2.6-patched/kernel/sched.c
--- linux-2.6/kernel/sched.c	2010-08-11 13:47:16.000000000 +0200
+++ linux-2.6-patched/kernel/sched.c	2010-08-11 13:47:22.000000000 +0200
@@ -6546,31 +6546,23 @@ cpu_to_cpu_group(int cpu, const struct c
 #ifdef CONFIG_SCHED_MC
 static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
-#endif /* CONFIG_SCHED_MC */
 
-#if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
 cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
 		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
-
+#ifdef CONFIG_SCHED_SMT
 	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
 	group = cpumask_first(mask);
+#else
+	group = cpu;
+#endif
 	if (sg)
 		*sg = &per_cpu(sched_group_core, group).sg;
 	return group;
 }
-#elif defined(CONFIG_SCHED_MC)
-static int
-cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *unused)
-{
-	if (sg)
-		*sg = &per_cpu(sched_group_core, cpu).sg;
-	return cpu;
-}
-#endif
+#endif /* CONFIG_SCHED_MC */
 
 static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
 static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);

