Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805Ab2ILPBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:01:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2ILO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:58:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v9 04/13] ARM: SoC: convert Tegra to SoC descriptor
Date: Wed, 12 Sep 2012 16:58:17 +0200
Message-Id: <1347461906-13527-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347461906-13527-1-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:aUdsJoKTZ1mcB5X82vRWtxxJ9i5ZGNbkVOa/4VVf1Dv
 ckczEfSX2uqRfC5pmJrPG7uoYSBl9QlNiucZKc1o2rHyraro7U
 0DyKa5w/NuBh+nDljBYOlW65CNWIj9WEFt9fhGyMSvO8fI/gYy
 9kMlcAF5iezltGptd8073AvYm3QPflPOdbpiaaxnj+D2RrGi2+
 XWL8BYE/ubnItsVR+qNUbiO9nERtVCaFBGL2/87pc6ao8Dvuvf
 HwsFvyNEaUUA4Zf6/wuaoGGB/bSYkcAsc1bwvOiCqiz//wZXUT
 rgv3mFfG0emaPPEx8ki+eivIT/N+n/6T4GSgSeTR0FCwJspoo5
 e5towieGDsXyK/XIEiNSW8jkVwybRN4O8Idc/eGgEH2UTLtSS4
 fjQQwfVkEZuP9vMpCFoQ/BEXoYMHPKMIMs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

Convert Tegra to use the SoC descriptor to provide its SMP
and CPU hotplug operations.

Tested on Harmony.

Cc: Colin Cross <ccross@android.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    2 ++
 arch/arm/mach-tegra/board-dt-tegra30.c |    2 ++
 arch/arm/mach-tegra/board-harmony.c    |    2 ++
 arch/arm/mach-tegra/board-paz00.c      |    2 ++
 arch/arm/mach-tegra/board-trimslice.c  |    2 ++
 arch/arm/mach-tegra/common.c           |    1 +
 arch/arm/mach-tegra/common.h           |    3 +++
 arch/arm/mach-tegra/hotplug.c          |   16 +---------------
 arch/arm/mach-tegra/platsmp.c          |   20 ++++++++++++++++----
 9 files changed, 31 insertions(+), 19 deletions(-)
 create mode 100644 arch/arm/mach-tegra/common.h

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index c099963..a30537c 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -45,6 +45,7 @@
 #include "board-harmony.h"
 #include "clock.h"
 #include "devices.h"
+#include "common.h"
 
 struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
@@ -166,6 +167,7 @@ static const char *tegra20_dt_board_compat[] = {
 
 DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.map_io		= tegra_map_common_io,
+	.smp		= smp_ops(tegra_smp_ops),
 	.init_early	= tegra20_init_early,
 	.init_irq	= tegra_dt_init_irq,
 	.handle_irq	= gic_handle_irq,
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 53bf60f..e4a676d 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -37,6 +37,7 @@
 
 #include "board.h"
 #include "clock.h"
+#include "common.h"
 
 struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", 0x78000000, "sdhci-tegra.0", NULL),
@@ -83,6 +84,7 @@ static const char *tegra30_dt_board_compat[] = {
 };
 
 DT_MACHINE_START(TEGRA30_DT, "NVIDIA Tegra30 (Flattened Device Tree)")
+	.smp		= smp_ops(tegra_smp_ops),
 	.map_io		= tegra_map_common_io,
 	.init_early	= tegra30_init_early,
 	.init_irq	= tegra_dt_init_irq,
diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index e65e837..c1a0c8d 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -45,6 +45,7 @@
 #include "clock.h"
 #include "devices.h"
 #include "gpio-names.h"
+#include "common.h"
 
 static struct plat_serial8250_port debug_uart_platform_data[] = {
 	{
@@ -185,6 +186,7 @@ static void __init tegra_harmony_init(void)
 
 MACHINE_START(HARMONY, "harmony")
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(tegra_smp_ops),
 	.fixup		= tegra_harmony_fixup,
 	.map_io         = tegra_map_common_io,
 	.init_early	= tegra20_init_early,
diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index 4b64af5..2b25cc7 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -47,6 +47,7 @@
 #include "clock.h"
 #include "devices.h"
 #include "gpio-names.h"
+#include "common.h"
 
 static struct plat_serial8250_port debug_uart_platform_data[] = {
 	{
@@ -223,6 +224,7 @@ static void __init tegra_paz00_init(void)
 
 MACHINE_START(PAZ00, "Toshiba AC100 / Dynabook AZ")
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(tegra_smp_ops),
 	.fixup		= tegra_paz00_fixup,
 	.map_io         = tegra_map_common_io,
 	.init_early	= tegra20_init_early,
diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
index 776aa95..6a1e0b2 100644
--- a/arch/arm/mach-tegra/board-trimslice.c
+++ b/arch/arm/mach-tegra/board-trimslice.c
@@ -40,6 +40,7 @@
 #include "clock.h"
 #include "devices.h"
 #include "gpio-names.h"
+#include "common.h"
 
 #include "board-trimslice.h"
 
@@ -171,6 +172,7 @@ static void __init tegra_trimslice_init(void)
 
 MACHINE_START(TRIMSLICE, "trimslice")
 	.atag_offset	= 0x100,
+	.smp		= smp_ops(tegra_smp_ops),
 	.fixup		= tegra_trimslice_fixup,
 	.map_io         = tegra_map_common_io,
 	.init_early	= tegra20_init_early,
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 96fef6b..990f275 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -31,6 +31,7 @@
 
 #include "board.h"
 #include "clock.h"
+#include "common.h"
 #include "fuse.h"
 #include "pmc.h"
 #include "apbio.h"
diff --git a/arch/arm/mach-tegra/common.h b/arch/arm/mach-tegra/common.h
new file mode 100644
index 0000000..301b35e
--- /dev/null
+++ b/arch/arm/mach-tegra/common.h
@@ -0,0 +1,3 @@
+extern struct smp_operations tegra_smp_ops;
+
+extern void tegra_cpu_die(unsigned int cpu);
diff --git a/arch/arm/mach-tegra/hotplug.c b/arch/arm/mach-tegra/hotplug.c
index d8dc9dd..73402db 100644
--- a/arch/arm/mach-tegra/hotplug.c
+++ b/arch/arm/mach-tegra/hotplug.c
@@ -87,17 +87,12 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
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
+void tegra_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
 
@@ -116,12 +111,3 @@ void platform_cpu_die(unsigned int cpu)
 	if (spurious)
 		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
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
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 1a208db..24bfb653 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -32,6 +32,8 @@
 #include "flowctrl.h"
 #include "reset.h"
 
+#include "common.h"
+
 extern void tegra_secondary_startup(void);
 
 static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
@@ -50,7 +52,7 @@ static void __iomem *scu_base = IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
 #define CPU_CLOCK(cpu)	(0x1<<(8+cpu))
 #define CPU_RESET(cpu)	(0x1111ul<<(cpu))
 
-void __cpuinit platform_secondary_init(unsigned int cpu)
+static void __cpuinit tegra_secondary_init(unsigned int cpu)
 {
 	/*
 	 * if any interrupts are already enabled for the primary
@@ -117,7 +119,7 @@ static int tegra30_power_up_cpu(unsigned int cpu)
 	return 0;
 }
 
-int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
+static int __cpuinit tegra_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	int status;
 
@@ -165,7 +167,7 @@ done:
  * Initialise the CPU possible map early - this describes the CPUs
  * which may be present or become present in the system.
  */
-void __init smp_init_cpus(void)
+static void __init tegra_smp_init_cpus(void)
 {
 	unsigned int i, ncores = scu_get_core_count(scu_base);
 
@@ -181,8 +183,18 @@ void __init smp_init_cpus(void)
 	set_smp_cross_call(gic_raise_softirq);
 }
 
-void __init platform_smp_prepare_cpus(unsigned int max_cpus)
+static void __init tegra_smp_prepare_cpus(unsigned int max_cpus)
 {
 	tegra_cpu_reset_handler_init();
 	scu_enable(scu_base);
 }
+
+struct smp_operations tegra_smp_ops __initdata = {
+	.smp_init_cpus		= tegra_smp_init_cpus,
+	.smp_prepare_cpus	= tegra_smp_prepare_cpus,
+	.smp_secondary_init	= tegra_secondary_init,
+	.smp_boot_secondary	= tegra_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_die		= tegra_cpu_die,
+#endif
+};
-- 
1.7.10

