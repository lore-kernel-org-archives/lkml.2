Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1DGMnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:43:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1DGMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:54 -0400
Message-Id: <20110407122941.820460566@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:42 +0200
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
Subject: [PATCH 01/23] sched: Remove obsolete arch_ prefixes
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-remove-arch-prefixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non weak static functions clearly are not arch specific, so remove the
arch_ prefix.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -232,7 +232,7 @@ static void destroy_rt_bandwidth(struct
 #endif
 
 /*
- * sched_domains_mutex serializes calls to arch_init_sched_domains,
+ * sched_domains_mutex serializes calls to init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
  */
 static DEFINE_MUTEX(sched_domains_mutex);
@@ -7646,7 +7646,7 @@ void free_sched_domains(cpumask_var_t do
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
  */
-static int arch_init_sched_domains(const struct cpumask *cpu_map)
+static int init_sched_domains(const struct cpumask *cpu_map)
 {
 	int err;
 
@@ -7663,7 +7663,7 @@ static int arch_init_sched_domains(const
 	return err;
 }
 
-static void arch_destroy_sched_domains(const struct cpumask *cpu_map,
+static void destroy_sched_domains(const struct cpumask *cpu_map,
 				       struct cpumask *tmpmask)
 {
 	free_sched_groups(cpu_map, tmpmask);
@@ -7682,7 +7682,7 @@ static void detach_destroy_domains(const
 	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
-	arch_destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
+	destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
 }
 
 /* handle null as "default" */
@@ -7791,7 +7791,7 @@ void partition_sched_domains(int ndoms_n
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-static void arch_reinit_sched_domains(void)
+static void reinit_sched_domains(void)
 {
 	get_online_cpus();
 
@@ -7824,7 +7824,7 @@ static ssize_t sched_power_savings_store
 	else
 		sched_mc_power_savings = level;
 
-	arch_reinit_sched_domains();
+	reinit_sched_domains();
 
 	return count;
 }
@@ -7950,7 +7950,7 @@ void __init sched_init_smp(void)
 #endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
-	arch_init_sched_domains(cpu_active_mask);
+	init_sched_domains(cpu_active_mask);
 	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
 	if (cpumask_empty(non_isolated_cpus))
 		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);


