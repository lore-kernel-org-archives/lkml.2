Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab2ILPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:01:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54187 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2ILO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 06/13] ARM: SoC: convert MSM SMP to SoC descriptor
Date: Wed, 12 Sep 2012 16:58:19 +0200
Message-Id: <1347461906-13527-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1wgZKARiXtf12+d7Msr+P3Icy6dHGkT20CoeyGlCk59
 PLImdv1c9GpAb1fp9IvfblBU9y0sRN0MroWTgXxt+ziKmA6I//
 kkvzXbwPMMwjmFo2rvV34mo8FO+Ufey6njsHPD9MclFt7AYM0t
 r7pQbeLG7Em8wee47tmHz1OGdo5oh3fP3fTSAdYE/cQEMdyfV9
 0kmenIDKkDCwF0UMg0a6W75xwZeDLHPjmgVZRyRuhqxl7NTi5l
 Zi8JziBEJQHotAXQeMVlrd9fmP4oRWaDg0tui0H2o8jaBivff1
 AGag54Kq1RmRPapQfmezVI2dWwTWGfr/AYIGpA3WnqZs4Hlr+d
 DteGfxwI0oFmDksWkg+PgSXsAhENGnGxXOIyJ9bNmmCA9616Wn
 0aSNWoNKqF0cq5hCB3EH3w9WOQsXqnvKZ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Convert MSM SMP platforms to use the SoC descriptor to provide
their SMP and CPU hotplug operations.

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-msm/board-msm8960.c |    3 +++
 arch/arm/mach-msm/board-msm8x60.c |    7 +++++++
 arch/arm/mach-msm/core.h          |    2 ++
 arch/arm/mach-msm/hotplug.c       |   18 +++---------------
 arch/arm/mach-msm/platsmp.c       |   19 +++++++++++++++----
 5 files changed, 30 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm/mach-msm/core.h

diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 65f4a1d..a156968 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -30,6 +30,7 @@
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
 
+#include "core.h"
 #include "devices.h"
 
 static void __init msm8960_fixup(struct tag *tag, char **cmdline,
@@ -99,6 +100,7 @@ static void __init msm8960_init_late(void)
 }
 
 MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
+	.smp = smp_ops(msm_smp_ops),
 	.fixup = msm8960_fixup,
 	.reserve = msm8960_reserve,
 	.map_io = msm8960_map_io,
@@ -110,6 +112,7 @@ MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
 MACHINE_END
 
 MACHINE_START(MSM8960_RUMI3, "QCT MSM8960 RUMI3")
+	.smp = smp_ops(msm_smp_ops),
 	.fixup = msm8960_fixup,
 	.reserve = msm8960_reserve,
 	.map_io = msm8960_map_io,
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index e37a724..dc2abd3 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -29,6 +29,8 @@
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
 
+#include "core.h"
+
 static void __init msm8x60_fixup(struct tag *tag, char **cmdline,
 		struct meminfo *mi)
 {
@@ -110,6 +112,7 @@ static const char *msm8x60_fluid_match[] __initdata = {
 #endif /* CONFIG_OF */
 
 MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
+	.smp = smp_ops(msm_smp_ops),
 	.fixup = msm8x60_fixup,
 	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
@@ -121,6 +124,7 @@ MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
 MACHINE_END
 
 MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
+	.smp = smp_ops(msm_smp_ops),
 	.fixup = msm8x60_fixup,
 	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
@@ -132,6 +136,7 @@ MACHINE_START(MSM8X60_SURF, "QCT MSM8X60 SURF")
 MACHINE_END
 
 MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
+	.smp = smp_ops(msm_smp_ops),
 	.fixup = msm8x60_fixup,
 	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
@@ -143,6 +148,7 @@ MACHINE_START(MSM8X60_SIM, "QCT MSM8X60 SIMULATOR")
 MACHINE_END
 
 MACHINE_START(MSM8X60_FFA, "QCT MSM8X60 FFA")
+	.smp = smp_ops(msm_smp_ops),
 	.fixup = msm8x60_fixup,
 	.reserve = msm8x60_reserve,
 	.map_io = msm8x60_map_io,
@@ -156,6 +162,7 @@ MACHINE_END
 #ifdef CONFIG_OF
 /* TODO: General device tree support for all MSM. */
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
+	.smp = smp_ops(msm_smp_ops),
 	.map_io = msm8x60_map_io,
 	.init_irq = msm8x60_init_irq,
 	.init_machine = msm8x60_dt_init,
diff --git a/arch/arm/mach-msm/core.h b/arch/arm/mach-msm/core.h
new file mode 100644
index 0000000..a9bab53
--- /dev/null
+++ b/arch/arm/mach-msm/core.h
@@ -0,0 +1,2 @@
+extern struct smp_operations msm_smp_ops;
+extern void msm_cpu_die(unsigned int cpu);
diff --git a/arch/arm/mach-msm/hotplug.c b/arch/arm/mach-msm/hotplug.c
index a446fc1..d0f79e8 100644
--- a/arch/arm/mach-msm/hotplug.c
+++ b/arch/arm/mach-msm/hotplug.c
@@ -13,6 +13,8 @@
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 
+#include "core.h"
+
 extern volatile int pen_release;
 
 static inline void cpu_enter_lowpower(void)
@@ -57,17 +59,12 @@ static inline void platform_do_lowpower(unsigned int cpu)
 	}
 }
 
-int platform_cpu_kill(unsigned int cpu)
-{
-	return 1;
-}
-
 /*
  * platform-specific code to shutdown a CPU
  *
  * Called with IRQs disabled
  */
-void platform_cpu_die(unsigned int cpu)
+void msm_cpu_die(unsigned int cpu)
 {
 	/*
 	 * we're ready for shutdown now, so do it
@@ -81,12 +78,3 @@ void platform_cpu_die(unsigned int cpu)
 	 */
 	cpu_leave_lowpower();
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
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index e012dc8..ba3c4b0 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -25,6 +25,7 @@
 #include <mach/msm_iomap.h>
 
 #include "scm-boot.h"
+#include "core.h"
 
 #define VDD_SC1_ARRAY_CLAMP_GFS_CTL 0x15A0
 #define SCSS_CPU1CORE_RESET 0xD80
@@ -48,7 +49,7 @@ static inline int get_core_count(void)
 	return ((read_cpuid_id() >> 4) & 3) + 1;
 }
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit msm_secondary_init(unsigned int cpu)
 {
 	/* Configure edge-triggered PPIs */
 	writel(GIC_PPI_EDGE_MASK, MSM_QGIC_DIST_BASE + GIC_DIST_CONFIG + 4);
@@ -93,7 +94,7 @@ static __cpuinit void prepare_cold_cpu(unsigned int cpu)
 				  "address\n");
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int __cpuinit msm_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	unsigned long timeout;
 	static int cold_boot_done;
@@ -153,7 +154,7 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  * does not support the ARM SCU, so just set the possible cpu mask to
  * NR_CPUS.
  */
-void __init smp_init_cpus(void)
+static void __init msm_smp_init_cpus(void)
 {
 	unsigned int i, ncores = get_core_count();
 
@@ -169,6 +170,16 @@ void __init smp_init_cpus(void)
         set_smp_cross_call(gic_raise_softirq);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
 {
 }
+
+struct smp_operations msm_smp_ops __initdata = {
+	.smp_init_cpus		= msm_smp_init_cpus,
+	.smp_prepare_cpus	= msm_smp_prepare_cpus,
+	.smp_secondary_init	= msm_secondary_init,
+	.smp_boot_secondary	= msm_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= msm_cpu_die,
+#endif
+};
-- 
1.7.10

