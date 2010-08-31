Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0HaI1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:27:09 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:38404 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0HaI0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:26:49 -0400
Message-Id: <20100831082843.953617555@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 31 Aug 2010 10:28:15 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH V2 1/4] sched: merge cpu_to_core_group functions
References: <20100831082814.501484459@de.ibm.com>
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
--- linux-2.6/kernel/sched.c	2010-08-30 11:21:32.000000000 +0200
+++ linux-2.6-patched/kernel/sched.c	2010-08-30 11:21:41.000000000 +0200
@@ -6554,31 +6554,23 @@ cpu_to_cpu_group(int cpu, const struct c
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

