Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2BPDwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:52:51 -0500
Received: from ozlabs.org ([203.10.76.45]:55118 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab2BPDv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:51:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
CC: Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
CC: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
CC: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
CC: Chris Metcalf <cmetcalf@tilera.com>
CC: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Message-ID: <1329364286.9720.rusty@rustcorp.com.au>
Date: Thu, 16 Feb 2012 14:21:26 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] remove references to cpu_*_map in arch/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

In adjacent context, replaced old cpus_* with cpumask_*.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: David S. Miller <davem@davemloft.net> (arch/sparc)
Acked-by: Chris Metcalf <cmetcalf@tilera.com> (arch/tile)
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: linux-parisc@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
---
 arch/arm/kernel/kprobes.c           |    4 ++--
 arch/arm/kernel/smp.c               |    7 ++++---
 arch/hexagon/kernel/smp.c           |    8 ++++----
 arch/mips/cavium-octeon/smp.c       |    2 +-
 arch/mips/kernel/mips-mt-fpaff.c    |    2 +-
 arch/mips/kernel/proc.c             |    2 +-
 arch/mips/kernel/smp-bmips.c        |    2 +-
 arch/mips/kernel/smp.c              |   27 ++++++++++++---------------
 arch/mips/kernel/smtc.c             |    2 +-
 arch/mips/mm/c-octeon.c             |    6 +++---
 arch/mips/netlogic/common/smp.c     |    6 +++---
 arch/mips/pmc-sierra/yosemite/smp.c |    6 +++---
 arch/mips/sgi-ip27/ip27-smp.c       |    2 +-
 arch/mips/sibyte/bcm1480/smp.c      |    5 ++---
 arch/mips/sibyte/sb1250/smp.c       |    7 +++----
 arch/parisc/kernel/smp.c            |    3 +--
 arch/powerpc/platforms/wsp/smp.c    |    2 +-
 arch/sh/kernel/smp.c                |    2 +-
 arch/sh/kernel/topology.c           |    2 +-
 arch/sparc/kernel/leon_kernel.c     |    6 +++---
 arch/tile/kernel/setup.c            |    6 +++---
 arch/um/kernel/skas/process.c       |    2 +-
 arch/um/kernel/smp.c                |    9 ++++-----
 23 files changed, 57 insertions(+), 63 deletions(-)

diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -127,7 +127,7 @@ void __kprobes arch_arm_kprobe(struct kp
 		flush_insns(addr, sizeof(u16));
 	} else if (addr & 2) {
 		/* A 32-bit instruction spanning two words needs special care */
-		stop_machine(set_t32_breakpoint, (void *)addr, &cpu_online_map);
+		stop_machine(set_t32_breakpoint, (void *)addr, cpu_online_mask);
 	} else {
 		/* Word aligned 32-bit instruction can be written atomically */
 		u32 bkp = KPROBE_THUMB32_BREAKPOINT_INSTRUCTION;
@@ -190,7 +190,7 @@ int __kprobes __arch_disarm_kprobe(void 
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	stop_machine(__arch_disarm_kprobe, p, &cpu_online_map);
+	stop_machine(__arch_disarm_kprobe, p, cpu_online_mask);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -359,7 +359,7 @@ void __init smp_prepare_cpus(unsigned in
 		 * re-initialize the map in platform_smp_prepare_cpus() if
 		 * present != possible (e.g. physical hotplug).
 		 */
-		init_cpu_present(&cpu_possible_map);
+		init_cpu_present(cpu_possible_mask);
 
 		/*
 		 * Initialise the SCU if there are more than one CPU
@@ -577,8 +577,9 @@ void smp_send_stop(void)
 	unsigned long timeout;
 
 	if (num_online_cpus() > 1) {
-		cpumask_t mask = cpu_online_map;
-		cpu_clear(smp_processor_id(), mask);
+		struct cpumask mask;
+		cpumask_copy(&mask, cpu_online_mask);
+		cpumask_clear_cpu(smp_processor_id(), &mask);
 
 		smp_cross_call(&mask, IPI_CPU_STOP);
 	}
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -36,7 +36,7 @@
 #define BASE_IPI_IRQ 26
 
 /*
- * cpu_possible_map needs to be filled out prior to setup_per_cpu_areas
+ * cpu_possible_mask needs to be filled out prior to setup_per_cpu_areas
  * (which is prior to any of our smp_prepare_cpu crap), in order to set
  * up the...  per_cpu areas.
  */
@@ -211,7 +211,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	stack_start =  ((void *) thread) + THREAD_SIZE;
 	__vmstart(start_secondary, stack_start);
 
-	while (!cpu_isset(cpu, cpu_online_map))
+	while (!cpu_online(cpu))
 		barrier();
 
 	return 0;
@@ -232,7 +232,7 @@ void __init smp_prepare_cpus(unsigned in
 
 	/*  Right now, let's just fake it. */
 	for (i = 0; i < max_cpus; i++)
-		cpu_set(i, cpu_present_map);
+		set_cpu_present(i, true);
 
 	/*  Also need to register the interrupts for IPI  */
 	if (max_cpus > 1)
@@ -272,5 +272,5 @@ void smp_start_cpus(void)
 	int i;
 
 	for (i = 0; i < NR_CPUS; i++)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 }
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -268,7 +268,7 @@ static int octeon_cpu_disable(void)
 
 	spin_lock(&smp_reserve_lock);
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 	cpu_clear(cpu, cpu_callin_map);
 	local_irq_disable();
 	fixup_irqs();
diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -173,7 +173,7 @@ asmlinkage long mipsmt_sys_sched_getaffi
 	if (retval)
 		goto out_unlock;
 
-	cpus_and(mask, p->thread.user_cpus_allowed, cpu_possible_map);
+	cpumask_and(&mask, &p->thread.user_cpus_allowed, cpu_possible_mask);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -25,7 +25,7 @@ static int show_cpuinfo(struct seq_file 
 	int i;
 
 #ifdef CONFIG_SMP
-	if (!cpu_isset(n, cpu_online_map))
+	if (!cpu_online(n))
 		return 0;
 #endif
 
diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -319,7 +319,7 @@ static int bmips_cpu_disable(void)
 
 	pr_info("SMP: CPU%d is offline\n", cpu);
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 	cpu_clear(cpu, cpu_callin_map);
 
 	local_flush_tlb_all();
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -148,7 +148,7 @@ static void stop_this_cpu(void *dummy)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	for (;;) {
 		if (cpu_wait)
 			(*cpu_wait)();		/* Wait if available. */
@@ -174,7 +174,7 @@ void __init smp_prepare_cpus(unsigned in
 	mp_ops->prepare_cpus(max_cpus);
 	set_cpu_sibling_map(0);
 #ifndef CONFIG_HOTPLUG_CPU
-	init_cpu_present(&cpu_possible_map);
+	init_cpu_present(cpu_possible_mask);
 #endif
 }
 
@@ -248,7 +248,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	while (!cpu_isset(cpu, cpu_callin_map))
 		udelay(100);
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 
 	return 0;
 }
@@ -320,13 +320,12 @@ void flush_tlb_mm(struct mm_struct *mm)
 	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
 		smp_on_other_tlbs(flush_tlb_mm_ipi, mm);
 	} else {
-		cpumask_t mask = cpu_online_map;
 		unsigned int cpu;
 
-		cpu_clear(smp_processor_id(), mask);
-		for_each_cpu_mask(cpu, mask)
-			if (cpu_context(cpu, mm))
+		for_each_online_cpu(cpu) {
+			if (cpu != smp_processor_id() && cpu_context(cpu, mm))
 				cpu_context(cpu, mm) = 0;
+		}
 	}
 	local_flush_tlb_mm(mm);
 
@@ -360,13 +359,12 @@ void flush_tlb_range(struct vm_area_stru
 
 		smp_on_other_tlbs(flush_tlb_range_ipi, &fd);
 	} else {
-		cpumask_t mask = cpu_online_map;
 		unsigned int cpu;
 
-		cpu_clear(smp_processor_id(), mask);
-		for_each_cpu_mask(cpu, mask)
-			if (cpu_context(cpu, mm))
+		for_each_online_cpu(cpu) {
+			if (cpu != smp_processor_id() && cpu_context(cpu, mm))
 				cpu_context(cpu, mm) = 0;
+		}
 	}
 	local_flush_tlb_range(vma, start, end);
 	preempt_enable();
@@ -407,13 +405,12 @@ void flush_tlb_page(struct vm_area_struc
 
 		smp_on_other_tlbs(flush_tlb_page_ipi, &fd);
 	} else {
-		cpumask_t mask = cpu_online_map;
 		unsigned int cpu;
 
-		cpu_clear(smp_processor_id(), mask);
-		for_each_cpu_mask(cpu, mask)
-			if (cpu_context(cpu, vma->vm_mm))
+		for_each_online_cpu(cpu) {
+			if (cpu != smp_processor_id() && cpu_context(cpu, vma->vm_mm))
 				cpu_context(cpu, vma->vm_mm) = 0;
+		}
 	}
 	local_flush_tlb_page(vma, page);
 	preempt_enable();
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -292,7 +292,7 @@ static void smtc_configure_tlb(void)
  * possibly leave some TCs/VPEs as "slave" processors.
  *
  * Use c0_MVPConf0 to find out how many TCs are available, setting up
- * cpu_possible_map and the logical/physical mappings.
+ * cpu_possible_mask and the logical/physical mappings.
  */
 
 int __init smtc_build_cpu_map(int start_cpu_slot)
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -81,9 +81,9 @@ static void octeon_flush_icache_all_core
 	if (vma)
 		mask = *mm_cpumask(vma->vm_mm);
 	else
-		mask = cpu_online_map;
-	cpu_clear(cpu, mask);
-	for_each_cpu_mask(cpu, mask)
+		mask = *cpu_online_mask;
+	cpumask_clear_cpu(cpu, &mask);
+	for_each_cpu(cpu, &mask)
 		octeon_send_ipi_single(cpu, SMP_ICACHE_FLUSH);
 
 	preempt_enable();
diff --git a/arch/mips/netlogic/common/smp.c b/arch/mips/netlogic/common/smp.c
--- a/arch/mips/netlogic/common/smp.c
+++ b/arch/mips/netlogic/common/smp.c
@@ -165,7 +165,7 @@ void __init nlm_smp_setup(void)
 	cpu_set(boot_cpu, phys_cpu_present_map);
 	__cpu_number_map[boot_cpu] = 0;
 	__cpu_logical_map[0] = boot_cpu;
-	cpu_set(0, cpu_possible_map);
+	set_cpu_possible(0, true);
 
 	num_cpus = 1;
 	for (i = 0; i < NR_CPUS; i++) {
@@ -177,14 +177,14 @@ void __init nlm_smp_setup(void)
 			cpu_set(i, phys_cpu_present_map);
 			__cpu_number_map[i] = num_cpus;
 			__cpu_logical_map[num_cpus] = i;
-			cpu_set(num_cpus, cpu_possible_map);
+			set_cpu_possible(num_cpus, true);
 			++num_cpus;
 		}
 	}
 
 	pr_info("Phys CPU present map: %lx, possible map %lx\n",
 		(unsigned long)phys_cpu_present_map.bits[0],
-		(unsigned long)cpu_possible_map.bits[0]);
+		(unsigned long)cpumask_bits(cpu_possible_mask)[0]);
 
 	pr_info("Detected %i Slave CPU(s)\n", num_cpus);
 	nlm_set_nmi_handler(nlm_boot_secondary_cpus);
diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -155,10 +155,10 @@ static void __init yos_smp_setup(void)
 {
 	int i;
 
-	cpus_clear(cpu_possible_map);
+	init_cpu_possible(cpu_none_mask);
 
 	for (i = 0; i < 2; i++) {
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 		__cpu_number_map[i]	= i;
 		__cpu_logical_map[i]	= i;
 	}
@@ -169,7 +169,7 @@ static void __init yos_prepare_cpus(unsi
 	/*
 	 * Be paranoid.  Enable the IPI only if we're really about to go SMP.
 	 */
-	if (cpus_weight(cpu_possible_map))
+	if (num_possible_cpus())
 		set_c0_status(STATUSF_IP5);
 }
 
diff --git a/arch/mips/sgi-ip27/ip27-smp.c b/arch/mips/sgi-ip27/ip27-smp.c
--- a/arch/mips/sgi-ip27/ip27-smp.c
+++ b/arch/mips/sgi-ip27/ip27-smp.c
@@ -76,7 +76,7 @@ static int do_cpumask(cnodeid_t cnode, n
 			/* Only let it join in if it's marked enabled */
 			if ((acpu->cpu_info.flags & KLINFO_ENABLE) &&
 			    (tot_cpus_found != NR_CPUS)) {
-				cpu_set(cpuid, cpu_possible_map);
+				set_cpu_possible(cpuid, true);
 				alloc_cpupda(cpuid, tot_cpus_found);
 				cpus_found++;
 				tot_cpus_found++;
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -147,14 +147,13 @@ static void __init bcm1480_smp_setup(voi
 {
 	int i, num;
 
-	cpus_clear(cpu_possible_map);
-	cpu_set(0, cpu_possible_map);
+	init_cpu_possible(cpumask_of(0));
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -126,7 +126,7 @@ static void __cpuinit sb1250_boot_second
 
 /*
  * Use CFE to find out how many CPUs are available, setting up
- * cpu_possible_map and the logical/physical mappings.
+ * cpu_possible_mask and the logical/physical mappings.
  * XXXKW will the boot CPU ever not be physical 0?
  *
  * Common setup before any secondaries are started
@@ -135,14 +135,13 @@ static void __init sb1250_smp_setup(void
 {
 	int i, num;
 
-	cpus_clear(cpu_possible_map);
-	cpu_set(0, cpu_possible_map);
+	init_cpu_possible(cpumask_of(0));
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -291,8 +291,7 @@ smp_cpu_init(int cpunum)
 	mb();
 
 	/* Well, support 2.4 linux scheme as well. */
-	if (cpu_isset(cpunum, cpu_online_map))
-	{
+	if (cpu_online(cpunum))	{
 		extern void machine_halt(void); /* arch/parisc.../process.c */
 
 		printk(KERN_CRIT "CPU#%d already initialized!\n", cpunum);
diff --git a/arch/powerpc/platforms/wsp/smp.c b/arch/powerpc/platforms/wsp/smp.c
--- a/arch/powerpc/platforms/wsp/smp.c
+++ b/arch/powerpc/platforms/wsp/smp.c
@@ -71,7 +71,7 @@ int __devinit smp_a2_kick_cpu(int nr)
 
 static int __init smp_a2_probe(void)
 {
-	return cpus_weight(cpu_possible_map);
+	return num_possible_cpus();
 }
 
 static struct smp_ops_t a2_smp_ops = {
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -63,7 +63,7 @@ void __init smp_prepare_cpus(unsigned in
 	mp_ops->prepare_cpus(max_cpus);
 
 #ifndef CONFIG_HOTPLUG_CPU
-	init_cpu_present(&cpu_possible_map);
+	init_cpu_present(cpu_possible_mask);
 #endif
 }
 
diff --git a/arch/sh/kernel/topology.c b/arch/sh/kernel/topology.c
--- a/arch/sh/kernel/topology.c
+++ b/arch/sh/kernel/topology.c
@@ -27,7 +27,7 @@ static cpumask_t cpu_coregroup_map(unsig
 	 * Presently all SH-X3 SMP cores are multi-cores, so just keep it
 	 * simple until we have a method for determining topology..
 	 */
-	return cpu_possible_map;
+	return *cpu_possible_mask;
 }
 
 const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
diff --git a/arch/sparc/kernel/leon_kernel.c b/arch/sparc/kernel/leon_kernel.c
--- a/arch/sparc/kernel/leon_kernel.c
+++ b/arch/sparc/kernel/leon_kernel.c
@@ -104,11 +104,11 @@ static int irq_choose_cpu(const struct c
 {
 	cpumask_t mask;
 
-	cpus_and(mask, cpu_online_map, *affinity);
-	if (cpus_equal(mask, cpu_online_map) || cpus_empty(mask))
+	cpumask_and(&mask, cpu_online_mask, affinity);
+	if (cpumask_equal(&mask, cpu_online_mask) || cpumask_empty(&mask))
 		return boot_cpu_id;
 	else
-		return first_cpu(mask);
+		return cpumask_first(&mask);
 }
 #else
 #define irq_choose_cpu(affinity) boot_cpu_id
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1186,7 +1186,7 @@ static void __init setup_cpu_maps(void)
 			      sizeof(cpu_lotar_map));
 	if (rc < 0) {
 		pr_err("warning: no HV_INQ_TILES_LOTAR; using AVAIL\n");
-		cpu_lotar_map = cpu_possible_map;
+		cpu_lotar_map = *cpu_possible_mask;
 	}
 
 #if CHIP_HAS_CBOX_HOME_MAP()
@@ -1196,9 +1196,9 @@ static void __init setup_cpu_maps(void)
 			      sizeof(hash_for_home_map));
 	if (rc < 0)
 		early_panic("hv_inquire_tiles(HFH_CACHE) failed: rc %d\n", rc);
-	cpumask_or(&cpu_cacheable_map, &cpu_possible_map, &hash_for_home_map);
+	cpumask_or(&cpu_cacheable_map, cpu_possible_mask, &hash_for_home_map);
 #else
-	cpu_cacheable_map = cpu_possible_map;
+	cpu_cacheable_map = *cpu_possible_mask;
 #endif
 }
 
diff --git a/arch/um/kernel/skas/process.c b/arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c
+++ b/arch/um/kernel/skas/process.c
@@ -41,7 +41,7 @@ static int __init start_kernel_proc(void
 	cpu_tasks[0].pid = pid;
 	cpu_tasks[0].task = current;
 #ifdef CONFIG_SMP
-	cpu_online_map = cpumask_of_cpu(0);
+	init_cpu_online(get_cpu_mask(0));
 #endif
 	start_kernel();
 	return 0;
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -76,7 +76,7 @@ static int idle_proc(void *cpup)
 		cpu_relax();
 
 	notify_cpu_starting(cpu);
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	default_idle();
 	return 0;
 }
@@ -110,8 +110,7 @@ void smp_prepare_cpus(unsigned int maxcp
 	for (i = 0; i < ncpus; ++i)
 		set_cpu_possible(i, true);
 
-	cpu_clear(me, cpu_online_map);
-	cpu_set(me, cpu_online_map);
+	set_cpu_online(me, true);
 	cpu_set(me, cpu_callin_map);
 
 	err = os_pipe(cpu_data[me].ipi_pipe, 1, 1);
@@ -138,13 +137,13 @@ void smp_prepare_cpus(unsigned int maxcp
 
 void smp_prepare_boot_cpu(void)
 {
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 }
 
 int __cpu_up(unsigned int cpu)
 {
 	cpu_set(cpu, smp_commenced_mask);
-	while (!cpu_isset(cpu, cpu_online_map))
+	while (!cpu_online(cpu))
 		mb();
 	return 0;
 }

