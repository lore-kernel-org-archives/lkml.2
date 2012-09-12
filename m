Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab2ILPAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:00:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2ILO6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 03/13] ARM: SoC: convert OMAP4 to SoC descriptor
Date: Wed, 12 Sep 2012 16:58:16 +0200
Message-Id: <1347461906-13527-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:pVuvNDWSD99gD1SnWDsxhFYrKoBeVAxdT/8NwE3nbDw
 ItFhOH1Jd5EMzb7isJvH3FhXRdwx9NYP4ppAgErR5joXhVpf+u
 jsO9/2xhTWy+fNZRxFKchwriRRumiBgX98+kdSZMiOPrCS/Hnc
 NNENatuvUf1pZuo9bgFr6Jx0nBwh80luhmUGNp/SG1Ct/RK71f
 DSYw/nESo75hUVOKBf3LZ+kFdl5pl6KlkDPboIom7b5ZfkCaIc
 hRLqiVcypc+OMHH/DqxGDtY4mUzZKMWCJ8H0Jo/W+0MLIlTS11
 1/iaIR4FQdRYuXANH/xrf4r1j3ZIMBSI6+8QOOmCmz0C+V/iLU
 Zy/lluzIfW/Mvl0uK8Q5CVrf1UaV1+W0ymuSwuxHsfHGUZDHmZ
 AiLHsINY79MZb7Aj5OXOZ8nVqRYlEUC3/8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Convert OMAP4 to use the SoC descriptor to provide its SMP
and CPU hotplug operations.

Tested on both Panda and IGEPv2 (MULTI_OMAP kernel)

Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-omap2/board-4430sdp.c    |    1 +
 arch/arm/mach-omap2/board-generic.c    |    2 ++
 arch/arm/mach-omap2/board-omap4panda.c |    1 +
 arch/arm/mach-omap2/common.h           |    5 +++++
 arch/arm/mach-omap2/omap-hotplug.c     |   16 +---------------
 arch/arm/mach-omap2/omap-smp.c         |   18 ++++++++++++++----
 6 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index ad8a7d9..0e63d80 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -909,6 +909,7 @@ static void __init omap_4430sdp_init(void)
 MACHINE_START(OMAP_4430SDP, "OMAP4430 4430SDP board")
 	/* Maintainer: Santosh Shilimkar - Texas Instruments Inc */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(omap4_smp_ops),
 	.reserve	= omap_reserve,
 	.map_io		= omap4_map_io,
 	.init_early	= omap4430_init_early,
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 6f93a20..82dcf00 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -127,6 +127,7 @@ static const char *omap4_boards_compat[] __initdata = {
 
 DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
 	.reserve	= omap_reserve,
+	.smp		= smp_ops(omap4_smp_ops),
 	.map_io		= omap4_map_io,
 	.init_early	= omap4430_init_early,
 	.init_irq	= omap_gic_of_init,
@@ -147,6 +148,7 @@ static const char *omap5_boards_compat[] __initdata = {
 
 DT_MACHINE_START(OMAP5_DT, "Generic OMAP5 (Flattened Device Tree)")
 	.reserve	= omap_reserve,
+	.smp		= smp_ops(omap4_smp_ops),
 	.map_io		= omap5_map_io,
 	.init_early	= omap5_init_early,
 	.init_irq	= omap_gic_of_init,
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 70f6d1d..abbf239 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -518,6 +518,7 @@ static void __init omap4_panda_init(void)
 MACHINE_START(OMAP4_PANDA, "OMAP4 Panda board")
 	/* Maintainer: David Anders - Texas Instruments Inc */
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(omap4_smp_ops),
 	.reserve	= omap_reserve,
 	.map_io		= omap4_map_io,
 	.init_early	= omap4430_init_early,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 1f65b18..2296106 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -278,6 +278,11 @@ extern void omap_secondary_startup(void);
 extern u32 omap_modify_auxcoreboot0(u32 set_mask, u32 clear_mask);
 extern void omap_auxcoreboot_addr(u32 cpu_addr);
 extern u32 omap_read_auxcoreboot0(void);
+
+extern void omap4_cpu_die(unsigned int cpu);
+
+extern struct smp_operations omap4_smp_ops;
+
 extern void omap5_secondary_startup(void);
 #endif
 
diff --git a/arch/arm/mach-omap2/omap-hotplug.c b/arch/arm/mach-omap2/omap-hotplug.c
index 414083b..2de71a3 100644
--- a/arch/arm/mach-omap2/omap-hotplug.c
+++ b/arch/arm/mach-omap2/omap-hotplug.c
@@ -26,16 +26,11 @@
 
 #include "powerdomain.h"
 
-int platform_cpu_kill(unsigned int cpu)
-{
-	return 1;
-}
-
 /*
  * platform-specific code to shutdown a CPU
  * Called with IRQs disabled
  */
-void __ref platform_cpu_die(unsigned int cpu)
+void __ref omap4_cpu_die(unsigned int cpu)
 {
 	unsigned int boot_cpu = 0;
 	void __iomem *base = omap_get_wakeupgen_base();
@@ -75,12 +70,3 @@ void __ref platform_cpu_die(unsigned int cpu)
 		pr_debug("CPU%u: spurious wakeup call\n", cpu);
 	}
 }
-
-int platform_cpu_disable(unsigned int cpu)
-{
-	/*
-	 * we don't allow CPU 0 to be shutdown (it is still too special
-	 * e.g. clock tick interrupts)
-	 */
-	return cpu == 0 ? -EPERM : 0;
-}
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 9a35adf..046fa0d 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -49,7 +49,7 @@ void __iomem *omap4_get_scu_base(void)
 	return scu_base;
 }
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit omap4_secondary_init(unsigned int cpu)
 {
 	/*
 	 * Configure ACTRL and enable NS SMP bit access on CPU1 on HS device.
@@ -77,7 +77,7 @@ void __cpuinit platform_secondary_init(unsigned int cpu)
 	spin_unlock(&boot_lock);
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int __cpuinit omap4_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	static struct clockdomain *cpu1_clkdm;
 	static bool booted;
@@ -165,7 +165,7 @@ static void __init wakeup_secondary(void)
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-void __init smp_init_cpus(void)
+static void __init omap4_smp_init_cpus(void)
 {
 	unsigned int i = 0, ncores = 1, cpu_id;
 
@@ -196,7 +196,7 @@ void __init smp_init_cpus(void)
 	set_smp_cross_call(gic_raise_softirq);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init omap4_smp_prepare_cpus(unsigned int max_cpus)
 {
 
 	/*
@@ -207,3 +207,13 @@ void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 		scu_enable(scu_base);
 	wakeup_secondary();
 }
+
+struct smp_operations omap4_smp_ops __initdata = {
+	.smp_init_cpus		= omap4_smp_init_cpus,
+	.smp_prepare_cpus	= omap4_smp_prepare_cpus,
+	.smp_secondary_init	= omap4_secondary_init,
+	.smp_boot_secondary	= omap4_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= omap4_cpu_die,
+#endif
+};
-- 
1.7.10

