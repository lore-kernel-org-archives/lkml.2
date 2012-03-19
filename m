Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab2CSRG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:06:28 -0400
Received: from mail-wg0-f66.google.com ([74.125.82.66]:38413 "EHLO
	mail-wg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab2CSRGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:06:23 -0400
Date: Mon, 19 Mar 2012 18:06:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v3.4
Message-ID: <20120319170618.GA14166@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   HEAD: fa63030e9c79e37b4d4e63b39ffb09cfb7aa0fe4 x86/platform: Move APIC ID validity check into platform APIC code


out-of-topic modifications in x86-platform-for-linus:
-----------------------------------------------------
drivers/leds/Kconfig               # da4e330: x86/geode/net5501: Add platform d
drivers/leds/Makefile              # da4e330: x86/geode/net5501: Add platform d
drivers/leds/leds-net5501.c        # da4e330: x86/geode/net5501: Add platform d
drivers/platform/x86/Kconfig       # 0f48d34: x86/mid/thermal: Convert to use I
                                   # 33e9970: x86/mid: Kill off Moorestown
drivers/platform/x86/Makefile      # 33e9970: x86/mid: Kill off Moorestown
drivers/platform/x86/intel_mid_powerbtn.c# 8bee7ce: x86/mid/powerbtn: Use MSIC read/w
drivers/platform/x86/intel_mid_thermal.c# 1b7ccab: x86/mid/thermal: Turn off thermis
                                   # 6348307: x86/mid/thermal: Add msic_thermal
                                   # 0f48d34: x86/mid/thermal: Convert to use I
drivers/platform/x86/intel_rar_register.c# 33e9970: x86/mid: Kill off Moorestown
drivers/platform/x86/intel_scu_ipc.c# 4707375: x86/mid/scu_ipc: Remove Moorestow
drivers/platform/x86/intel_scu_ipcutil.c# 4707375: x86/mid/scu_ipc: Remove Moorestow
include/linux/rar_register.h       # 33e9970: x86/mid: Kill off Moorestown

 Thanks,

	Ingo

------------------>
Alan Cox (3):
      x86/mid: Remove Intel Moorestown
      x86/mid: Kill off Moorestown
      x86/mid/scu_ipc: Remove Moorestown support

Daniel Drake (1):
      x86/olpc/xo15/sci: Enable lid close wakeup control

Daniel J Blueman (1):
      x86/platform: Move APIC ID validity check into platform APIC code

Jacob Pan (2):
      x86/ioapic: Use legacy_pic to set correct gsi-irq mapping
      x86/mrst: Set ISA bus type for fake MP IRQs

Michael Demeter (1):
      x86/mid/powerbtn: Use MSIC read/write instead of ipc_scu

Mika Westerberg (5):
      x86/config: Select MSIC MFD driver on Intel Medfield platform
      x86/mrst: Add msic_thermal platform support
      x86/mid/thermal: Convert to use Intel MSIC API
      x86/mid/thermal: Add msic_thermal alias
      x86/mid/thermal: Turn off thermistor

Philip Prindeville (2):
      x86/geode/alix2: Supplement driver to include GPIO button support
      x86/geode/net5501: Add platform driver for Soekris Engineering net5501


 arch/x86/Kconfig                          |   28 +-
 arch/x86/include/asm/apic.h               |    6 +
 arch/x86/include/asm/mrst.h               |    4 +-
 arch/x86/kernel/apic/apic_flat_64.c       |    2 +
 arch/x86/kernel/apic/apic_noop.c          |    1 +
 arch/x86/kernel/apic/apic_numachip.c      |   10 +-
 arch/x86/kernel/apic/bigsmp_32.c          |    1 +
 arch/x86/kernel/apic/es7000_32.c          |    2 +
 arch/x86/kernel/apic/numaq_32.c           |    1 +
 arch/x86/kernel/apic/probe_32.c           |    1 +
 arch/x86/kernel/apic/summit_32.c          |    1 +
 arch/x86/kernel/apic/x2apic_cluster.c     |    1 +
 arch/x86/kernel/apic/x2apic_phys.c        |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c        |    1 +
 arch/x86/kernel/smpboot.c                 |    2 +-
 arch/x86/platform/geode/Makefile          |    1 +
 arch/x86/platform/geode/alix.c            |   76 +++-
 arch/x86/platform/geode/net5501.c         |  154 ++++++
 arch/x86/platform/mrst/Makefile           |    1 -
 arch/x86/platform/mrst/mrst.c             |   70 +--
 arch/x86/platform/mrst/pmu.c              |  817 -----------------------------
 arch/x86/platform/mrst/pmu.h              |  234 --------
 arch/x86/platform/olpc/olpc-xo15-sci.c    |   72 +++-
 drivers/leds/Kconfig                      |   10 -
 drivers/leds/Makefile                     |    1 -
 drivers/leds/leds-net5501.c               |   97 ----
 drivers/platform/x86/Kconfig              |   24 +-
 drivers/platform/x86/Makefile             |    1 -
 drivers/platform/x86/intel_mid_powerbtn.c |   32 +-
 drivers/platform/x86/intel_mid_thermal.c  |   47 +-
 drivers/platform/x86/intel_rar_register.c |  669 -----------------------
 drivers/platform/x86/intel_scu_ipc.c      |  208 +-------
 drivers/platform/x86/intel_scu_ipcutil.c  |   32 +-
 include/linux/rar_register.h              |   60 ---
 34 files changed, 442 insertions(+), 2226 deletions(-)
 create mode 100644 arch/x86/platform/geode/net5501.c
 delete mode 100644 arch/x86/platform/mrst/pmu.c
 delete mode 100644 arch/x86/platform/mrst/pmu.h
 delete mode 100644 drivers/leds/leds-net5501.c
 delete mode 100644 drivers/platform/x86/intel_rar_register.c
 delete mode 100644 include/linux/rar_register.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..7af8a56 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -417,27 +417,6 @@ if X86_WANT_INTEL_MID
 config X86_INTEL_MID
 	bool
 
-config X86_MRST
-       bool "Moorestown MID platform"
-	depends on PCI
-	depends on PCI_GOANY
-	depends on X86_IO_APIC
-	select X86_INTEL_MID
-	select SFI
-	select DW_APB_TIMER
-	select APB_TIMER
-	select I2C
-	select SPI
-	select INTEL_SCU_IPC
-	select X86_PLATFORM_DEVICES
-	---help---
-	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
-	  Internet Device(MID) platform. Moorestown consists of two chips:
-	  Lincroft (CPU core, graphics, and memory controller) and Langwell IOH.
-	  Unlike standard x86 PCs, Moorestown does not have many legacy devices
-	  nor standard legacy replacement devices/features. e.g. Moorestown does
-	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
-
 config X86_MDFLD
        bool "Medfield MID platform"
 	depends on PCI
@@ -451,6 +430,7 @@ config X86_MDFLD
 	select SPI
 	select INTEL_SCU_IPC
 	select X86_PLATFORM_DEVICES
+	select MFD_INTEL_MSIC
 	---help---
 	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. 
@@ -2133,6 +2113,12 @@ config ALIX
 
 	  Note: You have to set alix.force=1 for boards with Award BIOS.
 
+config NET5501
+	bool "Soekris Engineering net5501 System Support (LEDS, GPIO, etc)"
+	select GPIOLIB
+	---help---
+	  This option enables system support for the Soekris Engineering net5501.
+
 endif # X86_32
 
 config AMD_NB
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3ab9bdd..a9371c9 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -288,6 +288,7 @@ struct apic {
 
 	int (*probe)(void);
 	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
+	int (*apic_id_valid)(int apicid);
 	int (*apic_id_registered)(void);
 
 	u32 irq_delivery_mode;
@@ -532,6 +533,11 @@ static inline unsigned int read_apic_id(void)
 	return apic->get_apic_id(reg);
 }
 
+static inline int default_apic_id_valid(int apicid)
+{
+	return x2apic_mode || (apicid < 255);
+}
+
 extern void default_setup_apic_routing(void);
 
 extern struct apic apic_noop;
diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 0a0a954..fc18bf3 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -26,8 +26,8 @@ extern struct sfi_rtc_table_entry sfi_mrtc_array[];
  * identified via MSRs.
  */
 enum mrst_cpu_type {
-	MRST_CPU_CHIP_LINCROFT = 1,
-	MRST_CPU_CHIP_PENWELL,
+	/* 1 was Moorestown */
+	MRST_CPU_CHIP_PENWELL = 2,
 };
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 8c3cdde..359b689 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -180,6 +180,7 @@ static struct apic apic_flat =  {
 	.name				= "flat",
 	.probe				= flat_probe,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= flat_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
@@ -337,6 +338,7 @@ static struct apic apic_physflat =  {
 	.name				= "physical flat",
 	.probe				= physflat_probe,
 	.acpi_madt_oem_check		= physflat_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= flat_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 775b82b..634ae6c 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -124,6 +124,7 @@ struct apic apic_noop = {
 	.probe				= noop_probe,
 	.acpi_madt_oem_check		= NULL,
 
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= noop_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 09d3d8c..d9ea5f3 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -56,6 +56,12 @@ static unsigned int read_xapic_id(void)
 	return get_apic_id(apic_read(APIC_ID));
 }
 
+static int numachip_apic_id_valid(int apicid)
+{
+	/* Trust what bootloader passes in MADT */
+	return 1;
+}
+
 static int numachip_apic_id_registered(void)
 {
 	return physid_isset(read_xapic_id(), phys_cpu_present_map);
@@ -223,10 +229,11 @@ static int __init numachip_system_init(void)
 }
 early_initcall(numachip_system_init);
 
-static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __cpuinit numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strncmp(oem_id, "NUMASC", 6)) {
 		numachip_system = 1;
+		setup_force_cpu_cap(X86_FEATURE_X2APIC);
 		return 1;
 	}
 
@@ -238,6 +245,7 @@ static struct apic apic_numachip __refconst = {
 	.name				= "NumaConnect system",
 	.probe				= numachip_probe,
 	.acpi_madt_oem_check		= numachip_acpi_madt_oem_check,
+	.apic_id_valid			= numachip_apic_id_valid,
 	.apic_id_registered		= numachip_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 521bead..0cdec70 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -198,6 +198,7 @@ static struct apic apic_bigsmp = {
 	.name				= "bigsmp",
 	.probe				= probe_bigsmp,
 	.acpi_madt_oem_check		= NULL,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= bigsmp_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 5d513bc..e42d1d3b9 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -625,6 +625,7 @@ static struct apic __refdata apic_es7000_cluster = {
 	.name				= "es7000",
 	.probe				= probe_es7000,
 	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check_cluster,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= es7000_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
@@ -690,6 +691,7 @@ static struct apic __refdata apic_es7000 = {
 	.name				= "es7000",
 	.probe				= probe_es7000,
 	.acpi_madt_oem_check		= es7000_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= es7000_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index c4a61ca..00d2422 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -478,6 +478,7 @@ static struct apic __refdata apic_numaq = {
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
 	.acpi_madt_oem_check		= NULL,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= numaq_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 0787bb3..ff2c1b9 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -92,6 +92,7 @@ static struct apic apic_default = {
 	.name				= "default",
 	.probe				= probe_default,
 	.acpi_madt_oem_check		= NULL,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= default_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 1911442..fea000b 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -496,6 +496,7 @@ static struct apic apic_summit = {
 	.name				= "summit",
 	.probe				= probe_summit,
 	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= summit_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 5007958..9193713 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -213,6 +213,7 @@ static struct apic apic_x2apic_cluster = {
 	.name				= "cluster x2apic",
 	.probe				= x2apic_cluster_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index f5373df..bcd1db6 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -119,6 +119,7 @@ static struct apic apic_x2apic_phys = {
 	.name				= "physical x2apic",
 	.probe				= x2apic_phys_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 79b05b8..fc47714 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -351,6 +351,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.name				= "UV large system",
 	.probe				= uv_probe,
 	.acpi_madt_oem_check		= uv_acpi_madt_oem_check,
+	.apic_id_valid			= default_apic_id_valid,
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 66d250c..d279e6e 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -847,7 +847,7 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 
 	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
 	    !physid_isset(apicid, phys_cpu_present_map) ||
-	    (!x2apic_mode && apicid >= 255)) {
+	    !apic->apic_id_valid(apicid)) {
 		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
 		return -EINVAL;
 	}
diff --git a/arch/x86/platform/geode/Makefile b/arch/x86/platform/geode/Makefile
index 07c9cd0..246b788 100644
--- a/arch/x86/platform/geode/Makefile
+++ b/arch/x86/platform/geode/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_ALIX)		+= alix.o
+obj-$(CONFIG_NET5501)		+= net5501.o
diff --git a/arch/x86/platform/geode/alix.c b/arch/x86/platform/geode/alix.c
index dc5f1d3..90e23e7 100644
--- a/arch/x86/platform/geode/alix.c
+++ b/arch/x86/platform/geode/alix.c
@@ -6,6 +6,7 @@
  *
  * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
  * Copyright (C) 2011 Ed Wildgoose <kernel@wildgooses.com>
+ *                and Philip Prindeville <philipp@redfish-solutions.com>
  *
  * TODO: There are large similarities with leds-net5501.c
  * by Alessandro Zummo <a.zummo@towertech.it>
@@ -24,14 +25,47 @@
 #include <linux/leds.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+#include <linux/dmi.h>
 
 #include <asm/geode.h>
 
+#define BIOS_SIGNATURE_TINYBIOS		0xf0000
+#define BIOS_SIGNATURE_COREBOOT		0x500
+#define BIOS_REGION_SIZE		0x10000
+
 static bool force = 0;
 module_param(force, bool, 0444);
 /* FIXME: Award bios is not automatically detected as Alix platform */
 MODULE_PARM_DESC(force, "Force detection as ALIX.2/ALIX.3 platform");
 
+static struct gpio_keys_button alix_gpio_buttons[] = {
+	{
+		.code			= KEY_RESTART,
+		.gpio			= 24,
+		.active_low		= 1,
+		.desc			= "Reset button",
+		.type			= EV_KEY,
+		.wakeup			= 0,
+		.debounce_interval	= 100,
+		.can_disable		= 0,
+	}
+};
+static struct gpio_keys_platform_data alix_buttons_data = {
+	.buttons			= alix_gpio_buttons,
+	.nbuttons			= ARRAY_SIZE(alix_gpio_buttons),
+	.poll_interval			= 20,
+};
+
+static struct platform_device alix_buttons_dev = {
+	.name				= "gpio-keys-polled",
+	.id				= 1,
+	.dev = {
+		.platform_data		= &alix_buttons_data,
+	}
+};
+
 static struct gpio_led alix_leds[] = {
 	{
 		.name = "alix:1",
@@ -64,17 +98,22 @@ static struct platform_device alix_leds_dev = {
 	.dev.platform_data = &alix_leds_data,
 };
 
+static struct __initdata platform_device *alix_devs[] = {
+	&alix_buttons_dev,
+	&alix_leds_dev,
+};
+
 static void __init register_alix(void)
 {
 	/* Setup LED control through leds-gpio driver */
-	platform_device_register(&alix_leds_dev);
+	platform_add_devices(alix_devs, ARRAY_SIZE(alix_devs));
 }
 
-static int __init alix_present(unsigned long bios_phys,
+static bool __init alix_present(unsigned long bios_phys,
 				const char *alix_sig,
 				size_t alix_sig_len)
 {
-	const size_t bios_len = 0x00010000;
+	const size_t bios_len = BIOS_REGION_SIZE;
 	const char *bios_virt;
 	const char *scan_end;
 	const char *p;
@@ -84,7 +123,7 @@ static int __init alix_present(unsigned long bios_phys,
 		printk(KERN_NOTICE "%s: forced to skip BIOS test, "
 		       "assume system is ALIX.2/ALIX.3\n",
 		       KBUILD_MODNAME);
-		return 1;
+		return true;
 	}
 
 	bios_virt = phys_to_virt(bios_phys);
@@ -109,15 +148,33 @@ static int __init alix_present(unsigned long bios_phys,
 			*a = '\0';
 
 		tail = p + alix_sig_len;
-		if ((tail[0] == '2' || tail[0] == '3')) {
+		if ((tail[0] == '2' || tail[0] == '3' || tail[0] == '6')) {
 			printk(KERN_INFO
 			       "%s: system is recognized as \"%s\"\n",
 			       KBUILD_MODNAME, name);
-			return 1;
+			return true;
 		}
 	}
 
-	return 0;
+	return false;
+}
+
+static bool __init alix_present_dmi(void)
+{
+	const char *vendor, *product;
+
+	vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	if (!vendor || strcmp(vendor, "PC Engines"))
+		return false;
+
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!product || (strcmp(product, "ALIX.2D") && strcmp(product, "ALIX.6")))
+		return false;
+
+	printk(KERN_INFO "%s: system is recognized as \"%s %s\"\n",
+	       KBUILD_MODNAME, vendor, product);
+
+	return true;
 }
 
 static int __init alix_init(void)
@@ -128,8 +185,9 @@ static int __init alix_init(void)
 	if (!is_geode())
 		return 0;
 
-	if (alix_present(0xf0000, tinybios_sig, sizeof(tinybios_sig) - 1) ||
-	    alix_present(0x500, coreboot_sig, sizeof(coreboot_sig) - 1))
+	if (alix_present(BIOS_SIGNATURE_TINYBIOS, tinybios_sig, sizeof(tinybios_sig) - 1) ||
+	    alix_present(BIOS_SIGNATURE_COREBOOT, coreboot_sig, sizeof(coreboot_sig) - 1) ||
+	    alix_present_dmi())
 		register_alix();
 
 	return 0;
diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
new file mode 100644
index 0000000..66d377e
--- /dev/null
+++ b/arch/x86/platform/geode/net5501.c
@@ -0,0 +1,154 @@
+/*
+ * System Specific setup for Soekris net5501
+ * At the moment this means setup of GPIO control of LEDs and buttons
+ * on net5501 boards.
+ *
+ *
+ * Copyright (C) 2008-2009 Tower Technologies
+ * Written by Alessandro Zummo <a.zummo@towertech.it>
+ *
+ * Copyright (C) 2008 Constantin Baranov <const@mimas.ru>
+ * Copyright (C) 2011 Ed Wildgoose <kernel@wildgooses.com>
+ *                and Philip Prindeville <philipp@redfish-solutions.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+
+#include <asm/geode.h>
+
+#define BIOS_REGION_BASE		0xffff0000
+#define BIOS_REGION_SIZE		0x00010000
+
+static struct gpio_keys_button net5501_gpio_buttons[] = {
+	{
+		.code = KEY_RESTART,
+		.gpio = 24,
+		.active_low = 1,
+		.desc = "Reset button",
+		.type = EV_KEY,
+		.wakeup = 0,
+		.debounce_interval = 100,
+		.can_disable = 0,
+	}
+};
+static struct gpio_keys_platform_data net5501_buttons_data = {
+	.buttons = net5501_gpio_buttons,
+	.nbuttons = ARRAY_SIZE(net5501_gpio_buttons),
+	.poll_interval = 20,
+};
+
+static struct platform_device net5501_buttons_dev = {
+	.name = "gpio-keys-polled",
+	.id = 1,
+	.dev = {
+		.platform_data = &net5501_buttons_data,
+	}
+};
+
+static struct gpio_led net5501_leds[] = {
+	{
+		.name = "net5501:1",
+		.gpio = 6,
+		.default_trigger = "default-on",
+		.active_low = 1,
+	},
+};
+
+static struct gpio_led_platform_data net5501_leds_data = {
+	.num_leds = ARRAY_SIZE(net5501_leds),
+	.leds = net5501_leds,
+};
+
+static struct platform_device net5501_leds_dev = {
+	.name = "leds-gpio",
+	.id = -1,
+	.dev.platform_data = &net5501_leds_data,
+};
+
+static struct __initdata platform_device *net5501_devs[] = {
+	&net5501_buttons_dev,
+	&net5501_leds_dev,
+};
+
+static void __init register_net5501(void)
+{
+	/* Setup LED control through leds-gpio driver */
+	platform_add_devices(net5501_devs, ARRAY_SIZE(net5501_devs));
+}
+
+struct net5501_board {
+	u16	offset;
+	u16	len;
+	char	*sig;
+};
+
+static struct net5501_board __initdata boards[] = {
+	{ 0xb7b, 7, "net5501" },	/* net5501 v1.33/1.33c */
+	{ 0xb1f, 7, "net5501" },	/* net5501 v1.32i */
+};
+
+static bool __init net5501_present(void)
+{
+	int i;
+	unsigned char *rombase, *bios;
+	bool found = false;
+
+	rombase = ioremap(BIOS_REGION_BASE, BIOS_REGION_SIZE - 1);
+	if (!rombase) {
+		printk(KERN_ERR "%s: failed to get rombase\n", KBUILD_MODNAME);
+		return found;
+	}
+
+	bios = rombase + 0x20;	/* null terminated */
+
+	if (memcmp(bios, "comBIOS", 7))
+		goto unmap;
+
+	for (i = 0; i < ARRAY_SIZE(boards); i++) {
+		unsigned char *model = rombase + boards[i].offset;
+
+		if (!memcmp(model, boards[i].sig, boards[i].len)) {
+			printk(KERN_INFO "%s: system is recognized as \"%s\"\n",
+			       KBUILD_MODNAME, model);
+
+			found = true;
+			break;
+		}
+	}
+
+unmap:
+	iounmap(rombase);
+	return found;
+}
+
+static int __init net5501_init(void)
+{
+	if (!is_geode())
+		return 0;
+
+	if (!net5501_present())
+		return 0;
+
+	register_net5501();
+
+	return 0;
+}
+
+module_init(net5501_init);
+
+MODULE_AUTHOR("Philip Prindeville <philipp@redfish-solutions.com>");
+MODULE_DESCRIPTION("Soekris net5501 System Setup");
+MODULE_LICENSE("GPL");
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
index 7baed51..af1da7e 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1,4 +1,3 @@
 obj-$(CONFIG_X86_INTEL_MID)	+= mrst.o
 obj-$(CONFIG_X86_INTEL_MID)	+= vrtc.o
 obj-$(CONFIG_EARLY_PRINTK_INTEL_MID)	+= early_printk_mrst.o
-obj-$(CONFIG_X86_MRST)		+= pmu.o
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 475e2cd..721e652 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -78,16 +78,11 @@ int sfi_mrtc_num;
 
 static void mrst_power_off(void)
 {
-	if (__mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT)
-		intel_scu_ipc_simple_command(IPCMSG_COLD_RESET, 1);
 }
 
 static void mrst_reboot(void)
 {
-	if (__mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT)
-		intel_scu_ipc_simple_command(IPCMSG_COLD_RESET, 0);
-	else
-		intel_scu_ipc_simple_command(IPCMSG_COLD_BOOT, 0);
+	intel_scu_ipc_simple_command(IPCMSG_COLD_BOOT, 0);
 }
 
 /* parse all the mtimer info to a static mtimer array */
@@ -200,34 +195,28 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 
 static unsigned long __init mrst_calibrate_tsc(void)
 {
-	unsigned long flags, fast_calibrate;
-	if (__mrst_cpu_chip == MRST_CPU_CHIP_PENWELL) {
-		u32 lo, hi, ratio, fsb;
-
-		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
-		pr_debug("IA32 perf status is 0x%x, 0x%0x\n", lo, hi);
-		ratio = (hi >> 8) & 0x1f;
-		pr_debug("ratio is %d\n", ratio);
-		if (!ratio) {
-			pr_err("read a zero ratio, should be incorrect!\n");
-			pr_err("force tsc ratio to 16 ...\n");
-			ratio = 16;
-		}
-		rdmsr(MSR_FSB_FREQ, lo, hi);
-		if ((lo & 0x7) == 0x7)
-			fsb = PENWELL_FSB_FREQ_83SKU;
-		else
-			fsb = PENWELL_FSB_FREQ_100SKU;
-		fast_calibrate = ratio * fsb;
-		pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
-		lapic_timer_frequency = fsb * 1000 / HZ;
-		/* mark tsc clocksource as reliable */
-		set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
-	} else {
-		local_irq_save(flags);
-		fast_calibrate = apbt_quick_calibrate();
-		local_irq_restore(flags);
+	unsigned long fast_calibrate;
+	u32 lo, hi, ratio, fsb;
+
+	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
+	pr_debug("IA32 perf status is 0x%x, 0x%0x\n", lo, hi);
+	ratio = (hi >> 8) & 0x1f;
+	pr_debug("ratio is %d\n", ratio);
+	if (!ratio) {
+		pr_err("read a zero ratio, should be incorrect!\n");
+		pr_err("force tsc ratio to 16 ...\n");
+		ratio = 16;
 	}
+	rdmsr(MSR_FSB_FREQ, lo, hi);
+	if ((lo & 0x7) == 0x7)
+		fsb = PENWELL_FSB_FREQ_83SKU;
+	else
+		fsb = PENWELL_FSB_FREQ_100SKU;
+	fast_calibrate = ratio * fsb;
+	pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
+	lapic_timer_frequency = fsb * 1000 / HZ;
+	/* mark tsc clocksource as reliable */
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
 	
 	if (fast_calibrate)
 		return fast_calibrate;
@@ -261,16 +250,11 @@ static void __cpuinit mrst_arch_setup(void)
 {
 	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
 		__mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
-	else if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x26)
-		__mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
 	else {
-		pr_err("Unknown Moorestown CPU (%d:%d), default to Lincroft\n",
+		pr_err("Unknown Intel MID CPU (%d:%d), default to Penwell\n",
 			boot_cpu_data.x86, boot_cpu_data.x86_model);
-		__mrst_cpu_chip = MRST_CPU_CHIP_LINCROFT;
+		__mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
 	}
-	pr_debug("Moorestown CPU %s identified\n",
-		(__mrst_cpu_chip == MRST_CPU_CHIP_LINCROFT) ?
-		"Lincroft" : "Penwell");
 }
 
 /* MID systems don't have i8042 controller */
@@ -686,6 +670,11 @@ static void *msic_ocd_platform_data(void *info)
 	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
 }
 
+static void *msic_thermal_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_THERMAL);
+}
+
 static const struct devs_id __initconst device_ids[] = {
 	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
@@ -705,6 +694,7 @@ static const struct devs_id __initconst device_ids[] = {
 	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data},
 	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data},
 	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data},
+	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data},
 
 	{},
 };
diff --git a/arch/x86/platform/mrst/pmu.c b/arch/x86/platform/mrst/pmu.c
deleted file mode 100644
index c0ac06d..0000000
--- a/arch/x86/platform/mrst/pmu.c
+++ /dev/null
@@ -1,817 +0,0 @@
-/*
- * mrst/pmu.c - driver for MRST Power Management Unit
- *
- * Copyright (c) 2011, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- */
-
-#include <linux/cpuidle.h>
-#include <linux/debugfs.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/seq_file.h>
-#include <linux/sfi.h>
-#include <asm/intel_scu_ipc.h>
-#include "pmu.h"
-
-#define IPCMSG_FW_REVISION	0xF4
-
-struct mrst_device {
-	u16 pci_dev_num;	/* DEBUG only */
-	u16 lss;
-	u16 latest_request;
-	unsigned int pci_state_counts[PCI_D3cold + 1]; /* DEBUG only */
-};
-
-/*
- * comlete list of MRST PCI devices
- */
-static struct mrst_device mrst_devs[] = {
-/*  0 */ { 0x0800, LSS_SPI0 },		/* Moorestown SPI Ctrl 0 */
-/*  1 */ { 0x0801, LSS_SPI1 },		/* Moorestown SPI Ctrl 1 */
-/*  2 */ { 0x0802, LSS_I2C0 },		/* Moorestown I2C 0 */
-/*  3 */ { 0x0803, LSS_I2C1 },		/* Moorestown I2C 1 */
-/*  4 */ { 0x0804, LSS_I2C2 },		/* Moorestown I2C 2 */
-/*  5 */ { 0x0805, LSS_KBD },		/* Moorestown Keyboard Ctrl */
-/*  6 */ { 0x0806, LSS_USB_HC },	/* Moorestown USB Ctrl */
-/*  7 */ { 0x0807, LSS_SD_HC0 },	/* Moorestown SD Host Ctrl 0 */
-/*  8 */ { 0x0808, LSS_SD_HC1 },	/* Moorestown SD Host Ctrl 1 */
-/*  9 */ { 0x0809, LSS_NAND },		/* Moorestown NAND Ctrl */
-/* 10 */ { 0x080a, LSS_AUDIO },		/* Moorestown Audio Ctrl */
-/* 11 */ { 0x080b, LSS_IMAGING },	/* Moorestown ISP */
-/* 12 */ { 0x080c, LSS_SECURITY },	/* Moorestown Security Controller */
-/* 13 */ { 0x080d, LSS_DISPLAY },	/* Moorestown External Displays */
-/* 14 */ { 0x080e, 0 },			/* Moorestown SCU IPC */
-/* 15 */ { 0x080f, LSS_GPIO },		/* Moorestown GPIO Controller */
-/* 16 */ { 0x0810, 0 },			/* Moorestown Power Management Unit */
-/* 17 */ { 0x0811, LSS_USB_OTG },	/* Moorestown OTG Ctrl */
-/* 18 */ { 0x0812, LSS_SPI2 },		/* Moorestown SPI Ctrl 2 */
-/* 19 */ { 0x0813, 0 },			/* Moorestown SC DMA */
-/* 20 */ { 0x0814, LSS_AUDIO_LPE },	/* Moorestown LPE DMA */
-/* 21 */ { 0x0815, LSS_AUDIO_SSP },	/* Moorestown SSP0 */
-
-/* 22 */ { 0x084F, LSS_SD_HC2 },	/* Moorestown SD Host Ctrl 2 */
-
-/* 23 */ { 0x4102, 0 },			/* Lincroft */
-/* 24 */ { 0x4110, 0 },			/* Lincroft */
-};
-
-/* n.b. We ignore PCI-id 0x815 in LSS9 b/c Linux has no driver for it */
-static u16 mrst_lss9_pci_ids[] = {0x080a, 0x0814, 0};
-static u16 mrst_lss10_pci_ids[] = {0x0800, 0x0801, 0x0802, 0x0803,
-					0x0804, 0x0805, 0x080f, 0};
-
-/* handle concurrent SMP invokations of pmu_pci_set_power_state() */
-static spinlock_t mrst_pmu_power_state_lock;
-
-static unsigned int wake_counters[MRST_NUM_LSS];	/* DEBUG only */
-static unsigned int pmu_irq_stats[INT_INVALID + 1];	/* DEBUG only */
-
-static int graphics_is_off;
-static int lss_s0i3_enabled;
-static bool mrst_pmu_s0i3_enable;
-
-/*  debug counters */
-static u32 pmu_wait_ready_calls;
-static u32 pmu_wait_ready_udelays;
-static u32 pmu_wait_ready_udelays_max;
-static u32 pmu_wait_done_calls;
-static u32 pmu_wait_done_udelays;
-static u32 pmu_wait_done_udelays_max;
-static u32 pmu_set_power_state_entry;
-static u32 pmu_set_power_state_send_cmd;
-
-static struct mrst_device *pci_id_2_mrst_dev(u16 pci_dev_num)
-{
-	int index = 0;
-
-	if ((pci_dev_num >= 0x0800) && (pci_dev_num <= 0x815))
-		index = pci_dev_num - 0x800;
-	else if (pci_dev_num == 0x084F)
-		index = 22;
-	else if (pci_dev_num == 0x4102)
-		index = 23;
-	else if (pci_dev_num == 0x4110)
-		index = 24;
-
-	if (pci_dev_num != mrst_devs[index].pci_dev_num) {
-		WARN_ONCE(1, FW_BUG "Unknown PCI device 0x%04X\n", pci_dev_num);
-		return 0;
-	}
-
-	return &mrst_devs[index];
-}
-
-/**
- * mrst_pmu_validate_cstates
- * @dev: cpuidle_device
- *
- * Certain states are not appropriate for governor to pick in some cases.
- * This function will be called as cpuidle_device's prepare callback and
- * thus tells governor to ignore such states when selecting the next state
- * to enter.
- */
-
-#define IDLE_STATE4_IS_C6	4
-#define IDLE_STATE5_IS_S0I3	5
-
-int mrst_pmu_invalid_cstates(void)
-{
-	int cpu = smp_processor_id();
-
-	/*
-	 * Demote to C4 if the PMU is busy.
-	 * Since LSS changes leave the busy bit clear...
-	 * busy means either the PMU is waiting for an ACK-C6 that
-	 * isn't coming due to an MWAIT that returned immediately;
-	 * or we returned from S0i3 successfully, and the PMU
-	 * is not done sending us interrupts.
-	 */
-	if (pmu_read_busy_status())
-		return 1 << IDLE_STATE4_IS_C6 | 1 << IDLE_STATE5_IS_S0I3;
-
-	/*
-	 * Disallow S0i3 if: PMU is not initialized, or CPU1 is active,
-	 * or if device LSS is insufficient, or the GPU is active,
-	 * or if it has been explicitly disabled.
-	 */
-	if (!pmu_reg || !cpumask_equal(cpu_online_mask, cpumask_of(cpu)) ||
-	    !lss_s0i3_enabled || !graphics_is_off || !mrst_pmu_s0i3_enable)
-		return 1 << IDLE_STATE5_IS_S0I3;
-	else
-		return 0;
-}
-
-/*
- * pmu_update_wake_counters(): read PM_WKS, update wake_counters[]
- * DEBUG only.
- */
-static void pmu_update_wake_counters(void)
-{
-	int lss;
-	u32 wake_status;
-
-	wake_status = pmu_read_wks();
-
-	for (lss = 0; lss < MRST_NUM_LSS; ++lss) {
-		if (wake_status & (1 << lss))
-			wake_counters[lss]++;
-	}
-}
-
-int mrst_pmu_s0i3_entry(void)
-{
-	int status;
-
-	/* Clear any possible error conditions */
-	pmu_write_ics(0x300);
-
-	/* set wake control to current D-states */
-	pmu_write_wssc(S0I3_SSS_TARGET);
-
-	status = mrst_s0i3_entry(PM_S0I3_COMMAND, &pmu_reg->pm_cmd);
-	pmu_update_wake_counters();
-	return status;
-}
-
-/* poll for maximum of 5ms for busy bit to clear */
-static int pmu_wait_ready(void)
-{
-	int udelays;
-
-	pmu_wait_ready_calls++;
-
-	for (udelays = 0; udelays < 500; ++udelays) {
-		if (udelays > pmu_wait_ready_udelays_max)
-			pmu_wait_ready_udelays_max = udelays;
-
-		if (pmu_read_busy_status() == 0)
-			return 0;
-
-		udelay(10);
-		pmu_wait_ready_udelays++;
-	}
-
-	/*
-	 * if this fires, observe
-	 * /sys/kernel/debug/mrst_pmu_wait_ready_calls
-	 * /sys/kernel/debug/mrst_pmu_wait_ready_udelays
-	 */
-	WARN_ONCE(1, "SCU not ready for 5ms");
-	return -EBUSY;
-}
-/* poll for maximum of 50ms us for busy bit to clear */
-static int pmu_wait_done(void)
-{
-	int udelays;
-
-	pmu_wait_done_calls++;
-
-	for (udelays = 0; udelays < 500; ++udelays) {
-		if (udelays > pmu_wait_done_udelays_max)
-			pmu_wait_done_udelays_max = udelays;
-
-		if (pmu_read_busy_status() == 0)
-			return 0;
-
-		udelay(100);
-		pmu_wait_done_udelays++;
-	}
-
-	/*
-	 * if this fires, observe
-	 * /sys/kernel/debug/mrst_pmu_wait_done_calls
-	 * /sys/kernel/debug/mrst_pmu_wait_done_udelays
-	 */
-	WARN_ONCE(1, "SCU not done for 50ms");
-	return -EBUSY;
-}
-
-u32 mrst_pmu_msi_is_disabled(void)
-{
-	return pmu_msi_is_disabled();
-}
-
-void mrst_pmu_enable_msi(void)
-{
-	pmu_msi_enable();
-}
-
-/**
- * pmu_irq - pmu driver interrupt handler
- * Context: interrupt context
- */
-static irqreturn_t pmu_irq(int irq, void *dummy)
-{
-	union pmu_pm_ics pmu_ics;
-
-	pmu_ics.value = pmu_read_ics();
-
-	if (!pmu_ics.bits.pending)
-		return IRQ_NONE;
-
-	switch (pmu_ics.bits.cause) {
-	case INT_SPURIOUS:
-	case INT_CMD_DONE:
-	case INT_CMD_ERR:
-	case INT_WAKE_RX:
-	case INT_SS_ERROR:
-	case INT_S0IX_MISS:
-	case INT_NO_ACKC6:
-		pmu_irq_stats[pmu_ics.bits.cause]++;
-		break;
-	default:
-		pmu_irq_stats[INT_INVALID]++;
-	}
-
-	pmu_write_ics(pmu_ics.value); /* Clear pending interrupt */
-
-	return IRQ_HANDLED;
-}
-
-/*
- * Translate PCI power management to MRST LSS D-states
- */
-static int pci_2_mrst_state(int lss, pci_power_t pci_state)
-{
-	switch (pci_state) {
-	case PCI_D0:
-		if (SSMSK(D0i1, lss) & D0I1_ACG_SSS_TARGET)
-			return D0i1;
-		else
-			return D0;
-	case PCI_D1:
-		return D0i1;
-	case PCI_D2:
-		return D0i2;
-	case PCI_D3hot:
-	case PCI_D3cold:
-		return D0i3;
-	default:
-		WARN(1, "pci_state %d\n", pci_state);
-		return 0;
-	}
-}
-
-static int pmu_issue_command(u32 pm_ssc)
-{
-	union pmu_pm_set_cfg_cmd_t command;
-
-	if (pmu_read_busy_status()) {
-		pr_debug("pmu is busy, Operation not permitted\n");
-		return -1;
-	}
-
-	/*
-	 * enable interrupts in PMU so that interrupts are
-	 * propagated when ioc bit for a particular set
-	 * command is set
-	 */
-
-	pmu_irq_enable();
-
-	/* Configure the sub systems for pmu2 */
-
-	pmu_write_ssc(pm_ssc);
-
-	/*
-	 * Send the set config command for pmu its configured
-	 * for mode CM_IMMEDIATE & hence with No Trigger
-	 */
-
-	command.pmu2_params.d_param.cfg_mode = CM_IMMEDIATE;
-	command.pmu2_params.d_param.cfg_delay = 0;
-	command.pmu2_params.d_param.rsvd = 0;
-
-	/* construct the command to send SET_CFG to particular PMU */
-	command.pmu2_params.d_param.cmd = SET_CFG_CMD;
-	command.pmu2_params.d_param.ioc = 0;
-	command.pmu2_params.d_param.mode_id = 0;
-	command.pmu2_params.d_param.sys_state = SYS_STATE_S0I0;
-
-	/* write the value of PM_CMD into particular PMU */
-	pr_debug("pmu command being written %x\n",
-			command.pmu_pm_set_cfg_cmd_value);
-
-	pmu_write_cmd(command.pmu_pm_set_cfg_cmd_value);
-
-	return 0;
-}
-
-static u16 pmu_min_lss_pci_req(u16 *ids, u16 pci_state)
-{
-	u16 existing_request;
-	int i;
-
-	for (i = 0; ids[i]; ++i) {
-		struct mrst_device *mrst_dev;
-
-		mrst_dev = pci_id_2_mrst_dev(ids[i]);
-		if (unlikely(!mrst_dev))
-			continue;
-
-		existing_request = mrst_dev->latest_request;
-		if (existing_request < pci_state)
-			pci_state = existing_request;
-	}
-	return pci_state;
-}
-
-/**
- * pmu_pci_set_power_state - Callback function is used by all the PCI devices
- *			for a platform  specific device power on/shutdown.
- */
-
-int pmu_pci_set_power_state(struct pci_dev *pdev, pci_power_t pci_state)
-{
-	u32 old_sss, new_sss;
-	int status = 0;
-	struct mrst_device *mrst_dev;
-
-	pmu_set_power_state_entry++;
-
-	BUG_ON(pdev->vendor != PCI_VENDOR_ID_INTEL);
-	BUG_ON(pci_state < PCI_D0 || pci_state > PCI_D3cold);
-
-	mrst_dev = pci_id_2_mrst_dev(pdev->device);
-	if (unlikely(!mrst_dev))
-		return -ENODEV;
-
-	mrst_dev->pci_state_counts[pci_state]++;	/* count invocations */
-
-	/* PMU driver calls self as part of PCI initialization, ignore */
-	if (pdev->device == PCI_DEV_ID_MRST_PMU)
-		return 0;
-
-	BUG_ON(!pmu_reg); /* SW bug if called before initialized */
-
-	spin_lock(&mrst_pmu_power_state_lock);
-
-	if (pdev->d3_delay) {
-		dev_dbg(&pdev->dev, "d3_delay %d, should be 0\n",
-			pdev->d3_delay);
-		pdev->d3_delay = 0;
-	}
-	/*
-	 * If Lincroft graphics, simply remember state
-	 */
-	if ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY
-		&& !((pdev->class & PCI_SUB_CLASS_MASK) >> 8)) {
-		if (pci_state == PCI_D0)
-			graphics_is_off = 0;
-		else
-			graphics_is_off = 1;
-		goto ret;
-	}
-
-	if (!mrst_dev->lss)
-		goto ret;	/* device with no LSS */
-
-	if (mrst_dev->latest_request == pci_state)
-		goto ret;	/* no change */
-
-	mrst_dev->latest_request = pci_state;	/* record latest request */
-
-	/*
-	 * LSS9 and LSS10 contain multiple PCI devices.
-	 * Use the lowest numbered (highest power) state in the LSS
-	 */
-	if (mrst_dev->lss == 9)
-		pci_state = pmu_min_lss_pci_req(mrst_lss9_pci_ids, pci_state);
-	else if (mrst_dev->lss == 10)
-		pci_state = pmu_min_lss_pci_req(mrst_lss10_pci_ids, pci_state);
-
-	status = pmu_wait_ready();
-	if (status)
-		goto ret;
-
-	old_sss = pmu_read_sss();
-	new_sss = old_sss & ~SSMSK(3, mrst_dev->lss);
-	new_sss |= SSMSK(pci_2_mrst_state(mrst_dev->lss, pci_state),
-			mrst_dev->lss);
-
-	if (new_sss == old_sss)
-		goto ret;	/* nothing to do */
-
-	pmu_set_power_state_send_cmd++;
-
-	status = pmu_issue_command(new_sss);
-
-	if (unlikely(status != 0)) {
-		dev_err(&pdev->dev, "Failed to Issue a PM command\n");
-		goto ret;
-	}
-
-	if (pmu_wait_done())
-		goto ret;
-
-	lss_s0i3_enabled =
-	((pmu_read_sss() & S0I3_SSS_TARGET) == S0I3_SSS_TARGET);
-ret:
-	spin_unlock(&mrst_pmu_power_state_lock);
-	return status;
-}
-
-#ifdef CONFIG_DEBUG_FS
-static char *d0ix_names[] = {"D0", "D0i1", "D0i2", "D0i3"};
-
-static inline const char *d0ix_name(int state)
-{
-	return d0ix_names[(int) state];
-}
-
-static int debug_mrst_pmu_show(struct seq_file *s, void *unused)
-{
-	struct pci_dev *pdev = NULL;
-	u32 cur_pmsss;
-	int lss;
-
-	seq_printf(s, "0x%08X D0I1_ACG_SSS_TARGET\n", D0I1_ACG_SSS_TARGET);
-
-	cur_pmsss = pmu_read_sss();
-
-	seq_printf(s, "0x%08X S0I3_SSS_TARGET\n", S0I3_SSS_TARGET);
-
-	seq_printf(s, "0x%08X Current SSS ", cur_pmsss);
-	seq_printf(s, lss_s0i3_enabled ? "\n" : "[BLOCKS s0i3]\n");
-
-	if (cpumask_equal(cpu_online_mask, cpumask_of(0)))
-		seq_printf(s, "cpu0 is only cpu online\n");
-	else
-		seq_printf(s, "cpu0 is NOT only cpu online [BLOCKS S0i3]\n");
-
-	seq_printf(s, "GFX: %s\n", graphics_is_off ? "" : "[BLOCKS s0i3]");
-
-
-	for_each_pci_dev(pdev) {
-		int pos;
-		u16 pmcsr;
-		struct mrst_device *mrst_dev;
-		int i;
-
-		mrst_dev = pci_id_2_mrst_dev(pdev->device);
-
-		seq_printf(s, "%s %04x/%04X %-16.16s ",
-			dev_name(&pdev->dev),
-			pdev->vendor, pdev->device,
-			dev_driver_string(&pdev->dev));
-
-		if (unlikely (!mrst_dev)) {
-			seq_printf(s, " UNKNOWN\n");
-			continue;
-		}
-
-		if (mrst_dev->lss)
-			seq_printf(s, "LSS %2d %-4s ", mrst_dev->lss,
-				d0ix_name(((cur_pmsss >>
-					(mrst_dev->lss * 2)) & 0x3)));
-		else
-			seq_printf(s, "            ");
-
-		/* PCI PM config space setting */
-		pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
-		if (pos != 0) {
-			pci_read_config_word(pdev, pos + PCI_PM_CTRL, &pmcsr);
-		seq_printf(s, "PCI-%-4s",
-			pci_power_name(pmcsr & PCI_PM_CTRL_STATE_MASK));
-		} else {
-			seq_printf(s, "        ");
-		}
-
-		seq_printf(s, " %s ", pci_power_name(mrst_dev->latest_request));
-		for (i = 0; i <= PCI_D3cold; ++i)
-			seq_printf(s, "%d ", mrst_dev->pci_state_counts[i]);
-
-		if (mrst_dev->lss) {
-			unsigned int lssmask;
-
-			lssmask = SSMSK(D0i3, mrst_dev->lss);
-
-			if ((lssmask & S0I3_SSS_TARGET) &&
-				((lssmask & cur_pmsss) !=
-					(lssmask & S0I3_SSS_TARGET)))
-						seq_printf(s , "[BLOCKS s0i3]");
-		}
-
-		seq_printf(s, "\n");
-	}
-	seq_printf(s, "Wake Counters:\n");
-	for (lss = 0; lss < MRST_NUM_LSS; ++lss)
-		seq_printf(s, "LSS%d %d\n", lss, wake_counters[lss]);
-
-	seq_printf(s, "Interrupt Counters:\n");
-	seq_printf(s,
-		"INT_SPURIOUS \t%8u\n" "INT_CMD_DONE \t%8u\n"
-		"INT_CMD_ERR  \t%8u\n" "INT_WAKE_RX  \t%8u\n"
-		"INT_SS_ERROR \t%8u\n" "INT_S0IX_MISS\t%8u\n"
-		"INT_NO_ACKC6 \t%8u\n" "INT_INVALID  \t%8u\n",
-		pmu_irq_stats[INT_SPURIOUS], pmu_irq_stats[INT_CMD_DONE],
-		pmu_irq_stats[INT_CMD_ERR], pmu_irq_stats[INT_WAKE_RX],
-		pmu_irq_stats[INT_SS_ERROR], pmu_irq_stats[INT_S0IX_MISS],
-		pmu_irq_stats[INT_NO_ACKC6], pmu_irq_stats[INT_INVALID]);
-
-	seq_printf(s, "mrst_pmu_wait_ready_calls          %8d\n",
-			pmu_wait_ready_calls);
-	seq_printf(s, "mrst_pmu_wait_ready_udelays        %8d\n",
-			pmu_wait_ready_udelays);
-	seq_printf(s, "mrst_pmu_wait_ready_udelays_max    %8d\n",
-			pmu_wait_ready_udelays_max);
-	seq_printf(s, "mrst_pmu_wait_done_calls           %8d\n",
-			pmu_wait_done_calls);
-	seq_printf(s, "mrst_pmu_wait_done_udelays         %8d\n",
-			pmu_wait_done_udelays);
-	seq_printf(s, "mrst_pmu_wait_done_udelays_max     %8d\n",
-			pmu_wait_done_udelays_max);
-	seq_printf(s, "mrst_pmu_set_power_state_entry     %8d\n",
-			pmu_set_power_state_entry);
-	seq_printf(s, "mrst_pmu_set_power_state_send_cmd  %8d\n",
-			pmu_set_power_state_send_cmd);
-	seq_printf(s, "SCU busy: %d\n", pmu_read_busy_status());
-
-	return 0;
-}
-
-static int debug_mrst_pmu_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, debug_mrst_pmu_show, NULL);
-}
-
-static const struct file_operations devices_state_operations = {
-	.open		= debug_mrst_pmu_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-#endif	/* DEBUG_FS */
-
-/*
- * Validate SCU PCI shim PCI vendor capability byte
- * against LSS hard-coded in mrst_devs[] above.
- * DEBUG only.
- */
-static void pmu_scu_firmware_debug(void)
-{
-	struct pci_dev *pdev = NULL;
-
-	for_each_pci_dev(pdev) {
-		struct mrst_device *mrst_dev;
-		u8 pci_config_lss;
-		int pos;
-
-		mrst_dev = pci_id_2_mrst_dev(pdev->device);
-		if (unlikely(!mrst_dev)) {
-			printk(KERN_ERR FW_BUG "pmu: Unknown "
-				"PCI device 0x%04X\n", pdev->device);
-			continue;
-		}
-
-		if (mrst_dev->lss == 0)
-			continue;	 /* no LSS in our table */
-
-		pos = pci_find_capability(pdev, PCI_CAP_ID_VNDR);
-		if (!pos != 0) {
-			printk(KERN_ERR FW_BUG "pmu: 0x%04X "
-				"missing PCI Vendor Capability\n",
-				pdev->device);
-			continue;
-		}
-		pci_read_config_byte(pdev, pos + 4, &pci_config_lss);
-		if (!(pci_config_lss & PCI_VENDOR_CAP_LOG_SS_MASK)) {
-			printk(KERN_ERR FW_BUG "pmu: 0x%04X "
-				"invalid PCI Vendor Capability 0x%x "
-				" expected LSS 0x%X\n",
-				pdev->device, pci_config_lss, mrst_dev->lss);
-			continue;
-		}
-		pci_config_lss &= PCI_VENDOR_CAP_LOG_ID_MASK;
-
-		if (mrst_dev->lss == pci_config_lss)
-			continue;
-
-		printk(KERN_ERR FW_BUG "pmu: 0x%04X LSS = %d, expected %d\n",
-			pdev->device, pci_config_lss, mrst_dev->lss);
-	}
-}
-
-/**
- * pmu_probe
- */
-static int __devinit pmu_probe(struct pci_dev *pdev,
-				   const struct pci_device_id *pci_id)
-{
-	int ret;
-	struct mrst_pmu_reg *pmu;
-
-	/* Init the device */
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to Enable PCI device\n");
-		return ret;
-	}
-
-	ret = pci_request_regions(pdev, MRST_PMU_DRV_NAME);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting\n");
-		goto out_err1;
-	}
-
-	/* Map the memory of PMU reg base */
-	pmu = pci_iomap(pdev, 0, 0);
-	if (!pmu) {
-		dev_err(&pdev->dev, "Unable to map the PMU address space\n");
-		ret = -ENOMEM;
-		goto out_err2;
-	}
-
-#ifdef CONFIG_DEBUG_FS
-	/* /sys/kernel/debug/mrst_pmu */
-	(void) debugfs_create_file("mrst_pmu", S_IFREG | S_IRUGO,
-				NULL, NULL, &devices_state_operations);
-#endif
-	pmu_reg = pmu;	/* success */
-
-	if (request_irq(pdev->irq, pmu_irq, 0, MRST_PMU_DRV_NAME, NULL)) {
-		dev_err(&pdev->dev, "Registering isr has failed\n");
-		ret = -1;
-		goto out_err3;
-	}
-
-	pmu_scu_firmware_debug();
-
-	pmu_write_wkc(S0I3_WAKE_SOURCES);	/* Enable S0i3 wakeup sources */
-
-	pmu_wait_ready();
-
-	pmu_write_ssc(D0I1_ACG_SSS_TARGET);	/* Enable Auto-Clock_Gating */
-	pmu_write_cmd(0x201);
-
-	spin_lock_init(&mrst_pmu_power_state_lock);
-
-	/* Enable the hardware interrupt */
-	pmu_irq_enable();
-	return 0;
-
-out_err3:
-	free_irq(pdev->irq, NULL);
-	pci_iounmap(pdev, pmu_reg);
-	pmu_reg = NULL;
-out_err2:
-	pci_release_region(pdev, 0);
-out_err1:
-	pci_disable_device(pdev);
-	return ret;
-}
-
-static void __devexit pmu_remove(struct pci_dev *pdev)
-{
-	dev_err(&pdev->dev, "Mid PM pmu_remove called\n");
-
-	/* Freeing up the irq */
-	free_irq(pdev->irq, NULL);
-
-	pci_iounmap(pdev, pmu_reg);
-	pmu_reg = NULL;
-
-	/* disable the current PCI device */
-	pci_release_region(pdev, 0);
-	pci_disable_device(pdev);
-}
-
-static DEFINE_PCI_DEVICE_TABLE(pmu_pci_ids) = {
-	{ PCI_VDEVICE(INTEL, PCI_DEV_ID_MRST_PMU), 0 },
-	{ }
-};
-
-MODULE_DEVICE_TABLE(pci, pmu_pci_ids);
-
-static struct pci_driver driver = {
-	.name = MRST_PMU_DRV_NAME,
-	.id_table = pmu_pci_ids,
-	.probe = pmu_probe,
-	.remove = __devexit_p(pmu_remove),
-};
-
-/**
- * pmu_pci_register - register the PMU driver as PCI device
- */
-static int __init pmu_pci_register(void)
-{
-	return pci_register_driver(&driver);
-}
-
-/* Register and probe via fs_initcall() to preceed device_initcall() */
-fs_initcall(pmu_pci_register);
-
-static void __exit mid_pci_cleanup(void)
-{
-	pci_unregister_driver(&driver);
-}
-
-static int ia_major;
-static int ia_minor;
-
-static int pmu_sfi_parse_oem(struct sfi_table_header *table)
-{
-	struct sfi_table_simple *sb;
-
-	sb = (struct sfi_table_simple *)table;
-	ia_major = (sb->pentry[1] >> 0) & 0xFFFF;
-	ia_minor = (sb->pentry[1] >> 16) & 0xFFFF;
-	printk(KERN_INFO "mrst_pmu: IA FW version v%x.%x\n",
-		ia_major, ia_minor);
-
-	return 0;
-}
-
-static int __init scu_fw_check(void)
-{
-	int ret;
-	u32 fw_version;
-
-	if (!pmu_reg)
-		return 0;	/* this driver didn't probe-out */
-
-	sfi_table_parse("OEMB", NULL, NULL, pmu_sfi_parse_oem);
-
-	if (ia_major < 0x6005 || ia_minor < 0x1525) {
-		WARN(1, "mrst_pmu: IA FW version too old\n");
-		return -1;
-	}
-
-	ret = intel_scu_ipc_command(IPCMSG_FW_REVISION, 0, NULL, 0,
-					&fw_version, 1);
-
-	if (ret) {
-		WARN(1, "mrst_pmu: IPC FW version? %d\n", ret);
-	} else {
-		int scu_major = (fw_version >> 8) & 0xFF;
-		int scu_minor = (fw_version >> 0) & 0xFF;
-
-		printk(KERN_INFO "mrst_pmu: firmware v%x\n", fw_version);
-
-		if ((scu_major >= 0xC0) && (scu_minor >= 0x49)) {
-			printk(KERN_INFO "mrst_pmu: enabling S0i3\n");
-			mrst_pmu_s0i3_enable = true;
-		} else {
-			WARN(1, "mrst_pmu: S0i3 disabled, old firmware %X.%X",
-					scu_major, scu_minor);
-		}
-	}
-	return 0;
-}
-late_initcall(scu_fw_check);
-module_exit(mid_pci_cleanup);
diff --git a/arch/x86/platform/mrst/pmu.h b/arch/x86/platform/mrst/pmu.h
deleted file mode 100644
index bfbfe64..0000000
--- a/arch/x86/platform/mrst/pmu.h
+++ /dev/null
@@ -1,234 +0,0 @@
-/*
- * mrst/pmu.h - private definitions for MRST Power Management Unit mrst/pmu.c
- *
- * Copyright (c) 2011, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- */
-
-#ifndef _MRST_PMU_H_
-#define _MRST_PMU_H_
-
-#define PCI_DEV_ID_MRST_PMU		0x0810
-#define MRST_PMU_DRV_NAME		"mrst_pmu"
-#define	PCI_SUB_CLASS_MASK		0xFF00
-
-#define	PCI_VENDOR_CAP_LOG_ID_MASK	0x7F
-#define PCI_VENDOR_CAP_LOG_SS_MASK	0x80
-
-#define SUB_SYS_ALL_D0I1	0x01155555
-#define S0I3_WAKE_SOURCES	0x00001FFF
-
-#define PM_S0I3_COMMAND					\
-	((0 << 31) |	/* Reserved */			\
-	(0 << 30) |	/* Core must be idle */		\
-	(0xc2 << 22) |	/* ACK C6 trigger */		\
-	(3 << 19) |	/* Trigger on DMI message */	\
-	(3 << 16) |	/* Enter S0i3 */		\
-	(0 << 13) |	/* Numeric mode ID (sw) */	\
-	(3 << 9) |	/* Trigger mode */		\
-	(0 << 8) |	/* Do not interrupt */		\
-	(1 << 0))	/* Set configuration */
-
-#define	LSS_DMI		0
-#define	LSS_SD_HC0	1
-#define	LSS_SD_HC1	2
-#define	LSS_NAND	3
-#define	LSS_IMAGING	4
-#define	LSS_SECURITY	5
-#define	LSS_DISPLAY	6
-#define	LSS_USB_HC	7
-#define	LSS_USB_OTG	8
-#define	LSS_AUDIO	9
-#define	LSS_AUDIO_LPE	9
-#define	LSS_AUDIO_SSP	9
-#define	LSS_I2C0	10
-#define	LSS_I2C1	10
-#define	LSS_I2C2	10
-#define	LSS_KBD		10
-#define	LSS_SPI0	10
-#define	LSS_SPI1	10
-#define	LSS_SPI2	10
-#define	LSS_GPIO	10
-#define	LSS_SRAM	11	/* used by SCU, do not touch */
-#define	LSS_SD_HC2	12
-/* LSS hardware bits 15,14,13 are hardwired to 0, thus unusable */
-#define MRST_NUM_LSS	13
-
-#define MIN(a, b) (((a) < (b)) ? (a) : (b))
-
-#define	SSMSK(mask, lss) ((mask) << ((lss) * 2))
-#define	D0	0
-#define	D0i1	1
-#define	D0i2	2
-#define	D0i3	3
-
-#define S0I3_SSS_TARGET	(		\
-	SSMSK(D0i1, LSS_DMI) |		\
-	SSMSK(D0i3, LSS_SD_HC0) |	\
-	SSMSK(D0i3, LSS_SD_HC1) |	\
-	SSMSK(D0i3, LSS_NAND) |		\
-	SSMSK(D0i3, LSS_SD_HC2) |	\
-	SSMSK(D0i3, LSS_IMAGING) |	\
-	SSMSK(D0i3, LSS_SECURITY) |	\
-	SSMSK(D0i3, LSS_DISPLAY) |	\
-	SSMSK(D0i3, LSS_USB_HC) |	\
-	SSMSK(D0i3, LSS_USB_OTG) |	\
-	SSMSK(D0i3, LSS_AUDIO) |	\
-	SSMSK(D0i1, LSS_I2C0))
-
-/*
- * D0i1 on Langwell is Autonomous Clock Gating (ACG).
- * Enable ACG on every LSS except camera and audio
- */
-#define D0I1_ACG_SSS_TARGET	 \
-	(SUB_SYS_ALL_D0I1 & ~SSMSK(D0i1, LSS_IMAGING) & ~SSMSK(D0i1, LSS_AUDIO))
-
-enum cm_mode {
-	CM_NOP,			/* ignore the config mode value */
-	CM_IMMEDIATE,
-	CM_DELAY,
-	CM_TRIGGER,
-	CM_INVALID
-};
-
-enum sys_state {
-	SYS_STATE_S0I0,
-	SYS_STATE_S0I1,
-	SYS_STATE_S0I2,
-	SYS_STATE_S0I3,
-	SYS_STATE_S3,
-	SYS_STATE_S5
-};
-
-#define SET_CFG_CMD	1
-
-enum int_status {
-	INT_SPURIOUS = 0,
-	INT_CMD_DONE = 1,
-	INT_CMD_ERR = 2,
-	INT_WAKE_RX = 3,
-	INT_SS_ERROR = 4,
-	INT_S0IX_MISS = 5,
-	INT_NO_ACKC6 = 6,
-	INT_INVALID = 7,
-};
-
-/* PMU register interface */
-static struct mrst_pmu_reg {
-	u32 pm_sts;		/* 0x00 */
-	u32 pm_cmd;		/* 0x04 */
-	u32 pm_ics;		/* 0x08 */
-	u32 _resv1;		/* 0x0C */
-	u32 pm_wkc[2];		/* 0x10 */
-	u32 pm_wks[2];		/* 0x18 */
-	u32 pm_ssc[4];		/* 0x20 */
-	u32 pm_sss[4];		/* 0x30 */
-	u32 pm_wssc[4];		/* 0x40 */
-	u32 pm_c3c4;		/* 0x50 */
-	u32 pm_c5c6;		/* 0x54 */
-	u32 pm_msi_disable;	/* 0x58 */
-} *pmu_reg;
-
-static inline u32 pmu_read_sts(void) { return readl(&pmu_reg->pm_sts); }
-static inline u32 pmu_read_ics(void) { return readl(&pmu_reg->pm_ics); }
-static inline u32 pmu_read_wks(void) { return readl(&pmu_reg->pm_wks[0]); }
-static inline u32 pmu_read_sss(void) { return readl(&pmu_reg->pm_sss[0]); }
-
-static inline void pmu_write_cmd(u32 arg) { writel(arg, &pmu_reg->pm_cmd); }
-static inline void pmu_write_ics(u32 arg) { writel(arg, &pmu_reg->pm_ics); }
-static inline void pmu_write_wkc(u32 arg) { writel(arg, &pmu_reg->pm_wkc[0]); }
-static inline void pmu_write_ssc(u32 arg) { writel(arg, &pmu_reg->pm_ssc[0]); }
-static inline void pmu_write_wssc(u32 arg)
-					{ writel(arg, &pmu_reg->pm_wssc[0]); }
-
-static inline void pmu_msi_enable(void) { writel(0, &pmu_reg->pm_msi_disable); }
-static inline u32 pmu_msi_is_disabled(void)
-				{ return readl(&pmu_reg->pm_msi_disable); }
-
-union pmu_pm_ics {
-	struct {
-		u32 cause:8;
-		u32 enable:1;
-		u32 pending:1;
-		u32 reserved:22;
-	} bits;
-	u32 value;
-};
-
-static inline void pmu_irq_enable(void)
-{
-	union pmu_pm_ics pmu_ics;
-
-	pmu_ics.value = pmu_read_ics();
-	pmu_ics.bits.enable = 1;
-	pmu_write_ics(pmu_ics.value);
-}
-
-union pmu_pm_status {
-	struct {
-		u32 pmu_rev:8;
-		u32 pmu_busy:1;
-		u32 mode_id:4;
-		u32 Reserved:19;
-	} pmu_status_parts;
-	u32 pmu_status_value;
-};
-
-static inline int pmu_read_busy_status(void)
-{
-	union pmu_pm_status result;
-
-	result.pmu_status_value = pmu_read_sts();
-
-	return result.pmu_status_parts.pmu_busy;
-}
-
-/* pmu set config parameters */
-struct cfg_delay_param_t {
-	u32 cmd:8;
-	u32 ioc:1;
-	u32 cfg_mode:4;
-	u32 mode_id:3;
-	u32 sys_state:3;
-	u32 cfg_delay:8;
-	u32 rsvd:5;
-};
-
-struct cfg_trig_param_t {
-	u32 cmd:8;
-	u32 ioc:1;
-	u32 cfg_mode:4;
-	u32 mode_id:3;
-	u32 sys_state:3;
-	u32 cfg_trig_type:3;
-	u32 cfg_trig_val:8;
-	u32 cmbi:1;
-	u32 rsvd1:1;
-};
-
-union pmu_pm_set_cfg_cmd_t {
-	union {
-		struct cfg_delay_param_t d_param;
-		struct cfg_trig_param_t t_param;
-	} pmu2_params;
-	u32 pmu_pm_set_cfg_cmd_value;
-};
-
-#ifdef FUTURE_PATCH
-extern int mrst_s0i3_entry(u32 regval, u32 *regaddr);
-#else
-static inline int mrst_s0i3_entry(u32 regval, u32 *regaddr) { return -1; }
-#endif
-#endif
diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index 2b235b7..23e5b9d 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -23,7 +23,66 @@
 #define XO15_SCI_CLASS			DRV_NAME
 #define XO15_SCI_DEVICE_NAME		"OLPC XO-1.5 SCI"
 
-static unsigned long xo15_sci_gpe;
+static unsigned long			xo15_sci_gpe;
+static bool				lid_wake_on_close;
+
+/*
+ * The normal ACPI LID wakeup behavior is wake-on-open, but not
+ * wake-on-close. This is implemented as standard by the XO-1.5 DSDT.
+ *
+ * We provide here a sysfs attribute that will additionally enable
+ * wake-on-close behavior. This is useful (e.g.) when we oportunistically
+ * suspend with the display running; if the lid is then closed, we want to
+ * wake up to turn the display off.
+ *
+ * This is controlled through a custom method in the XO-1.5 DSDT.
+ */
+static int set_lid_wake_behavior(bool wake_on_close)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
+
+	arg_list.count		= 1;
+	arg_list.pointer	= &arg;
+	arg.type		= ACPI_TYPE_INTEGER;
+	arg.integer.value	= wake_on_close;
+
+	status = acpi_evaluate_object(NULL, "\\_SB.PCI0.LID.LIDW", &arg_list, NULL);
+	if (ACPI_FAILURE(status)) {
+		pr_warning(PFX "failed to set lid behavior\n");
+		return 1;
+	}
+
+	lid_wake_on_close = wake_on_close;
+
+	return 0;
+}
+
+static ssize_t
+lid_wake_on_close_show(struct kobject *s, struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", lid_wake_on_close);
+}
+
+static ssize_t lid_wake_on_close_store(struct kobject *s,
+				       struct kobj_attribute *attr,
+				       const char *buf, size_t n)
+{
+	unsigned int val;
+
+	if (sscanf(buf, "%u", &val) != 1)
+		return -EINVAL;
+
+	set_lid_wake_behavior(!!val);
+
+	return n;
+}
+
+static struct kobj_attribute lid_wake_on_close_attr =
+	__ATTR(lid_wake_on_close, 0644,
+	       lid_wake_on_close_show,
+	       lid_wake_on_close_store);
 
 static void battery_status_changed(void)
 {
@@ -91,6 +150,7 @@ static int xo15_sci_add(struct acpi_device *device)
 {
 	unsigned long long tmp;
 	acpi_status status;
+	int r;
 
 	if (!device)
 		return -EINVAL;
@@ -112,6 +172,10 @@ static int xo15_sci_add(struct acpi_device *device)
 
 	dev_info(&device->dev, "Initialized, GPE = 0x%lx\n", xo15_sci_gpe);
 
+	r = sysfs_create_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
+	if (r)
+		goto err_sysfs;
+
 	/* Flush queue, and enable all SCI events */
 	process_sci_queue();
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
@@ -123,6 +187,11 @@ static int xo15_sci_add(struct acpi_device *device)
 		device_init_wakeup(&device->dev, true);
 
 	return 0;
+
+err_sysfs:
+	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
+	cancel_work_sync(&sci_work);
+	return r;
 }
 
 static int xo15_sci_remove(struct acpi_device *device, int type)
@@ -130,6 +199,7 @@ static int xo15_sci_remove(struct acpi_device *device, int type)
 	acpi_disable_gpe(NULL, xo15_sci_gpe);
 	acpi_remove_gpe_handler(NULL, xo15_sci_gpe, xo15_sci_gpe_handler);
 	cancel_work_sync(&sci_work);
+	sysfs_remove_file(&device->dev.kobj, &lid_wake_on_close_attr.attr);
 	return 0;
 }
 
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 9ca28fc..8c7a75d 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -89,16 +89,6 @@ config LEDS_NET48XX
 	  This option enables support for the Soekris net4801 and net4826 error
 	  LED.
 
-config LEDS_NET5501
-	tristate "LED Support for Soekris net5501 series Error LED"
-	depends on LEDS_TRIGGERS
-	depends on X86 && GPIO_CS5535
-	select LEDS_TRIGGER_DEFAULT_ON
-	default n
-	help
-	  Add support for the Soekris net5501 board (detection, error led
-	  and GPIO).
-
 config LEDS_FSG
 	tristate "LED Support for the Freecom FSG-3"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 1fc6875..6bcf4f6 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
-obj-$(CONFIG_LEDS_NET5501)		+= leds-net5501.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
diff --git a/drivers/leds/leds-net5501.c b/drivers/leds/leds-net5501.c
deleted file mode 100644
index 0555d47..0000000
--- a/drivers/leds/leds-net5501.c
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Soekris board support code
- *
- * Copyright (C) 2008-2009 Tower Technologies
- * Written by Alessandro Zummo <a.zummo@towertech.it>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-#include <linux/string.h>
-#include <linux/leds.h>
-#include <linux/platform_device.h>
-#include <linux/gpio.h>
-#include <linux/module.h>
-
-#include <asm/geode.h>
-
-static const struct gpio_led net5501_leds[] = {
-	{
-		.name = "error",
-		.gpio = 6,
-		.default_trigger = "default-on",
-	},
-};
-
-static struct gpio_led_platform_data net5501_leds_data = {
-	.num_leds = ARRAY_SIZE(net5501_leds),
-	.leds = net5501_leds,
-};
-
-static struct platform_device net5501_leds_dev = {
-	.name = "leds-gpio",
-	.id = -1,
-	.dev.platform_data = &net5501_leds_data,
-};
-
-static void __init init_net5501(void)
-{
-	platform_device_register(&net5501_leds_dev);
-}
-
-struct soekris_board {
-	u16	offset;
-	char	*sig;
-	u8	len;
-	void	(*init)(void);
-};
-
-static struct soekris_board __initdata boards[] = {
-	{ 0xb7b, "net5501", 7, init_net5501 },	/* net5501 v1.33/1.33c */
-	{ 0xb1f, "net5501", 7, init_net5501 },	/* net5501 v1.32i */
-};
-
-static int __init soekris_init(void)
-{
-	int i;
-	unsigned char *rombase, *bios;
-
-	if (!is_geode())
-		return 0;
-
-	rombase = ioremap(0xffff0000, 0xffff);
-	if (!rombase) {
-		printk(KERN_INFO "Soekris net5501 LED driver failed to get rombase");
-		return 0;
-	}
-
-	bios = rombase + 0x20;	/* null terminated */
-
-	if (strncmp(bios, "comBIOS", 7))
-		goto unmap;
-
-	for (i = 0; i < ARRAY_SIZE(boards); i++) {
-		unsigned char *model = rombase + boards[i].offset;
-
-		if (strncmp(model, boards[i].sig, boards[i].len) == 0) {
-			printk(KERN_INFO "Soekris %s: %s\n", model, bios);
-
-			if (boards[i].init)
-				boards[i].init();
-			break;
-		}
-	}
-
-unmap:
-	iounmap(rombase);
-	return 0;
-}
-
-arch_initcall(soekris_init);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index f995e6e..86720bc 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -672,33 +672,11 @@ config INTEL_MID_POWER_BUTTON
 
 config INTEL_MFLD_THERMAL
        tristate "Thermal driver for Intel Medfield platform"
-       depends on INTEL_SCU_IPC && THERMAL
+       depends on MFD_INTEL_MSIC && THERMAL
        help
          Say Y here to enable thermal driver support for the  Intel Medfield
          platform.
 
-config RAR_REGISTER
-	bool "Restricted Access Region Register Driver"
-	depends on PCI && X86_MRST
-	default n
-	---help---
-	  This driver allows other kernel drivers access to the
-	  contents of the restricted access region control registers.
-
-	  The restricted access region control registers
-	  (rar_registers) are used to pass address and
-	  locking information on restricted access regions
-	  to other drivers that use restricted access regions.
-
-	  The restricted access regions are regions of memory
-	  on the Intel MID Platform that are not accessible to
-	  the x86 processor, but are accessible to dedicated
-	  processors on board peripheral devices.
-
-	  The purpose of the restricted access regions is to
-	  protect sensitive data from compromise by unauthorized
-	  programs running on the x86 processor.
-
 config INTEL_IPS
 	tristate "Intel Intelligent Power Sharing"
 	depends on ACPI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 293a320..1b6665e 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -34,7 +34,6 @@ obj-$(CONFIG_TOSHIBA_BT_RFKILL)	+= toshiba_bluetooth.o
 obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
 obj-$(CONFIG_INTEL_SCU_IPC_UTIL) += intel_scu_ipcutil.o
 obj-$(CONFIG_INTEL_MFLD_THERMAL) += intel_mid_thermal.o
-obj-$(CONFIG_RAR_REGISTER)	+= intel_rar_register.o
 obj-$(CONFIG_INTEL_IPS)		+= intel_ips.o
 obj-$(CONFIG_GPIO_INTEL_PMIC)	+= intel_pmic_gpio.o
 obj-$(CONFIG_XO1_RFKILL)	+= xo1-rfkill.o
diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index f1ae507..0903a88 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -23,21 +23,27 @@
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
-
-#include <asm/intel_scu_ipc.h>
+#include <linux/mfd/intel_msic.h>
 
 #define DRIVER_NAME "msic_power_btn"
 
-#define MSIC_PB_STATUS	0x3f
 #define MSIC_PB_LEVEL	(1 << 3) /* 1 - release, 0 - press */
 
+/*
+ * MSIC document ti_datasheet defines the 1st bit reg 0x21 is used to mask
+ * power button interrupt
+ */
+#define MSIC_PWRBTNM    (1 << 0)
+
 static irqreturn_t mfld_pb_isr(int irq, void *dev_id)
 {
 	struct input_dev *input = dev_id;
 	int ret;
 	u8 pbstat;
 
-	ret = intel_scu_ipc_ioread8(MSIC_PB_STATUS, &pbstat);
+	ret = intel_msic_reg_read(INTEL_MSIC_PBSTATUS, &pbstat);
+	dev_dbg(input->dev.parent, "PB_INT status= %d\n", pbstat);
+
 	if (ret < 0) {
 		dev_err(input->dev.parent, "Read error %d while reading"
 			       " MSIC_PB_STATUS\n", ret);
@@ -88,6 +94,24 @@ static int __devinit mfld_pb_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, input);
+
+	/*
+	 * SCU firmware might send power button interrupts to IA core before
+	 * kernel boots and doesn't get EOI from IA core. The first bit of
+	 * MSIC reg 0x21 is kept masked, and SCU firmware doesn't send new
+	 * power interrupt to Android kernel. Unmask the bit when probing
+	 * power button in kernel.
+	 * There is a very narrow race between irq handler and power button
+	 * initialization. The race happens rarely. So we needn't worry
+	 * about it.
+	 */
+	error = intel_msic_reg_update(INTEL_MSIC_IRQLVL1MSK, 0, MSIC_PWRBTNM);
+	if (error) {
+		dev_err(&pdev->dev, "Unable to clear power button interrupt, "
+				"error: %d\n", error);
+		goto err_free_irq;
+	}
+
 	return 0;
 
 err_free_irq:
diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index ccd7b1f..2ee9766 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -33,18 +33,15 @@
 #include <linux/slab.h>
 #include <linux/pm.h>
 #include <linux/thermal.h>
-
-#include <asm/intel_scu_ipc.h>
+#include <linux/mfd/intel_msic.h>
 
 /* Number of thermal sensors */
 #define MSIC_THERMAL_SENSORS	4
 
 /* ADC1 - thermal registers */
-#define MSIC_THERM_ADC1CNTL1	0x1C0
 #define MSIC_ADC_ENBL		0x10
 #define MSIC_ADC_START		0x08
 
-#define MSIC_THERM_ADC1CNTL3	0x1C2
 #define MSIC_ADCTHERM_ENBL	0x04
 #define MSIC_ADCRRDATA_ENBL	0x05
 #define MSIC_CHANL_MASK_VAL	0x0F
@@ -75,8 +72,8 @@
 #define ADC_VAL60C		315
 
 /* ADC base addresses */
-#define ADC_CHNL_START_ADDR	0x1C5	/* increments by 1 */
-#define ADC_DATA_START_ADDR	0x1D4	/* increments by 2 */
+#define ADC_CHNL_START_ADDR	INTEL_MSIC_ADC1ADDR0	/* increments by 1 */
+#define ADC_DATA_START_ADDR	INTEL_MSIC_ADC1SNS0H	/* increments by 2 */
 
 /* MSIC die attributes */
 #define MSIC_DIE_ADC_MIN	488
@@ -189,17 +186,17 @@ static int mid_read_temp(struct thermal_zone_device *tzd, unsigned long *temp)
 	addr = td_info->chnl_addr;
 
 	/* Enable the msic for conversion before reading */
-	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
 	if (ret)
 		return ret;
 
 	/* Re-toggle the RRDATARD bit (temporary workaround) */
-	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
 	if (ret)
 		return ret;
 
 	/* Read the higher bits of data */
-	ret = intel_scu_ipc_ioread8(addr, &data);
+	ret = intel_msic_reg_read(addr, &data);
 	if (ret)
 		return ret;
 
@@ -207,7 +204,7 @@ static int mid_read_temp(struct thermal_zone_device *tzd, unsigned long *temp)
 	adc_val = (data << 2);
 	addr++;
 
-	ret = intel_scu_ipc_ioread8(addr, &data);/* Read lower bits */
+	ret = intel_msic_reg_read(addr, &data);/* Read lower bits */
 	if (ret)
 		return ret;
 
@@ -235,7 +232,7 @@ static int configure_adc(int val)
 	int ret;
 	uint8_t data;
 
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL1, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL1, &data);
 	if (ret)
 		return ret;
 
@@ -246,7 +243,7 @@ static int configure_adc(int val)
 		/* Just stop the ADC */
 		data &= (~MSIC_ADC_START);
 	}
-	return intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL1, data);
+	return intel_msic_reg_write(INTEL_MSIC_ADC1CNTL1, data);
 }
 
 /**
@@ -262,21 +259,21 @@ static int set_up_therm_channel(u16 base_addr)
 	int ret;
 
 	/* Enable all the sensor channels */
-	ret = intel_scu_ipc_iowrite8(base_addr, SKIN_SENSOR0_CODE);
+	ret = intel_msic_reg_write(base_addr, SKIN_SENSOR0_CODE);
 	if (ret)
 		return ret;
 
-	ret = intel_scu_ipc_iowrite8(base_addr + 1, SKIN_SENSOR1_CODE);
+	ret = intel_msic_reg_write(base_addr + 1, SKIN_SENSOR1_CODE);
 	if (ret)
 		return ret;
 
-	ret = intel_scu_ipc_iowrite8(base_addr + 2, SYS_SENSOR_CODE);
+	ret = intel_msic_reg_write(base_addr + 2, SYS_SENSOR_CODE);
 	if (ret)
 		return ret;
 
 	/* Since this is the last channel, set the stop bit
 	 * to 1 by ORing the DIE_SENSOR_CODE with 0x10 */
-	ret = intel_scu_ipc_iowrite8(base_addr + 3,
+	ret = intel_msic_reg_write(base_addr + 3,
 			(MSIC_DIE_SENSOR_CODE | 0x10));
 	if (ret)
 		return ret;
@@ -295,11 +292,11 @@ static int reset_stopbit(uint16_t addr)
 {
 	int ret;
 	uint8_t data;
-	ret = intel_scu_ipc_ioread8(addr, &data);
+	ret = intel_msic_reg_read(addr, &data);
 	if (ret)
 		return ret;
 	/* Set the stop bit to zero */
-	return intel_scu_ipc_iowrite8(addr, (data & 0xEF));
+	return intel_msic_reg_write(addr, (data & 0xEF));
 }
 
 /**
@@ -322,7 +319,7 @@ static int find_free_channel(void)
 	uint8_t data;
 
 	/* check whether ADC is enabled */
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL1, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL1, &data);
 	if (ret)
 		return ret;
 
@@ -331,7 +328,7 @@ static int find_free_channel(void)
 
 	/* ADC is already enabled; Looking for an empty channel */
 	for (i = 0; i < ADC_CHANLS_MAX; i++) {
-		ret = intel_scu_ipc_ioread8(ADC_CHNL_START_ADDR + i, &data);
+		ret = intel_msic_reg_read(ADC_CHNL_START_ADDR + i, &data);
 		if (ret)
 			return ret;
 
@@ -359,12 +356,14 @@ static int mid_initialize_adc(struct device *dev)
 	 * Ensure that adctherm is disabled before we
 	 * initialize the ADC
 	 */
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL3, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL3, &data);
 	if (ret)
 		return ret;
 
-	if (data & MSIC_ADCTHERM_MASK)
-		dev_warn(dev, "ADCTHERM already set");
+	data &= ~MSIC_ADCTHERM_MASK;
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, data);
+	if (ret)
+		return ret;
 
 	/* Index of the first channel in which the stop bit is set */
 	channel_index = find_free_channel();
@@ -546,7 +545,7 @@ static int mid_thermal_remove(struct platform_device *pdev)
 	return configure_adc(0);
 }
 
-#define DRIVER_NAME "msic_sensor"
+#define DRIVER_NAME "msic_thermal"
 
 static const struct platform_device_id therm_id_table[] = {
 	{ DRIVER_NAME, 1 },
diff --git a/drivers/platform/x86/intel_rar_register.c b/drivers/platform/x86/intel_rar_register.c
deleted file mode 100644
index c8a6aed..0000000
--- a/drivers/platform/x86/intel_rar_register.c
+++ /dev/null
@@ -1,669 +0,0 @@
-/*
- *  rar_register.c - An Intel Restricted Access Region register driver
- *
- *  Copyright(c) 2009 Intel Corporation. All rights reserved.
- *
- *  This program is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU General Public License as
- *  published by the Free Software Foundation; either version 2 of the
- *  License, or (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- *  General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
- *  02111-1307, USA.
- *
- * -------------------------------------------------------------------
- *  20091204 Mark Allyn <mark.a.allyn@intel.com>
- *	     Ossama Othman <ossama.othman@intel.com>
- *	Cleanup per feedback from Alan Cox and Arjan Van De Ven
- *
- *  20090806 Ossama Othman <ossama.othman@intel.com>
- *      Return zero high address if upper 22 bits is zero.
- *      Cleaned up checkpatch errors.
- *      Clarified that driver is dealing with bus addresses.
- *
- *  20090702 Ossama Othman <ossama.othman@intel.com>
- *      Removed unnecessary include directives
- *      Cleaned up spinlocks.
- *      Cleaned up logging.
- *      Improved invalid parameter checks.
- *      Fixed and simplified RAR address retrieval and RAR locking
- *      code.
- *
- *  20090626 Mark Allyn <mark.a.allyn@intel.com>
- *      Initial publish
- */
-
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/spinlock.h>
-#include <linux/device.h>
-#include <linux/kernel.h>
-#include <linux/rar_register.h>
-
-/* === Lincroft Message Bus Interface === */
-#define LNC_MCR_OFFSET		0xD0	/* Message Control Register */
-#define LNC_MDR_OFFSET		0xD4	/* Message Data Register */
-
-/* Message Opcodes */
-#define LNC_MESSAGE_READ_OPCODE	0xD0
-#define LNC_MESSAGE_WRITE_OPCODE 0xE0
-
-/* Message Write Byte Enables */
-#define LNC_MESSAGE_BYTE_WRITE_ENABLES	0xF
-
-/* B-unit Port */
-#define LNC_BUNIT_PORT	0x3
-
-/* === Lincroft B-Unit Registers - Programmed by IA32 firmware === */
-#define LNC_BRAR0L	0x10
-#define LNC_BRAR0H	0x11
-#define LNC_BRAR1L	0x12
-#define LNC_BRAR1H	0x13
-/* Reserved for SeP */
-#define LNC_BRAR2L	0x14
-#define LNC_BRAR2H	0x15
-
-/* Moorestown supports three restricted access regions. */
-#define MRST_NUM_RAR 3
-
-/* RAR Bus Address Range */
-struct rar_addr {
-	dma_addr_t low;
-	dma_addr_t high;
-};
-
-/*
- *	We create one of these for each RAR
- */
-struct client {
-	int (*callback)(unsigned long data);
-	unsigned long driver_priv;
-	bool busy;
-};
-
-static DEFINE_MUTEX(rar_mutex);
-static DEFINE_MUTEX(lnc_reg_mutex);
-
-/*
- *	One per RAR device (currently only one device)
- */
-struct rar_device {
-	struct rar_addr rar_addr[MRST_NUM_RAR];
-	struct pci_dev *rar_dev;
-	bool registered;
-	bool allocated;
-	struct client client[MRST_NUM_RAR];
-};
-
-/* Current platforms have only one rar_device for 3 rar regions */
-static struct rar_device my_rar_device;
-
-/*
- *	Abstract out multiple device support. Current platforms only
- *	have a single RAR device.
- */
-
-/**
- *	alloc_rar_device	-	return a new RAR structure
- *
- *	Return a new (but not yet ready) RAR device object
- */
-static struct rar_device *alloc_rar_device(void)
-{
-	if (my_rar_device.allocated)
-		return NULL;
-	my_rar_device.allocated = 1;
-	return &my_rar_device;
-}
-
-/**
- *	free_rar_device		-	free a RAR object
- *	@rar: the RAR device being freed
- *
- *	Release a RAR object and any attached resources
- */
-static void free_rar_device(struct rar_device *rar)
-{
-	pci_dev_put(rar->rar_dev);
-	rar->allocated = 0;
-}
-
-/**
- *	_rar_to_device		-	return the device handling this RAR
- *	@rar: RAR number
- *	@off: returned offset
- *
- *	Internal helper for looking up RAR devices. This and alloc are the
- *	two functions that need touching to go to multiple RAR devices.
- */
-static struct rar_device *_rar_to_device(int rar, int *off)
-{
-	if (rar >= 0 && rar < MRST_NUM_RAR) {
-		*off = rar;
-		return &my_rar_device;
-	}
-	return NULL;
-}
-
-/**
- *	rar_to_device		-	return the device handling this RAR
- *	@rar: RAR number
- *	@off: returned offset
- *
- *	Return the device this RAR maps to if one is present, otherwise
- *	returns NULL. Reports the offset relative to the base of this
- *	RAR device in off.
- */
-static struct rar_device *rar_to_device(int rar, int *off)
-{
-	struct rar_device *rar_dev = _rar_to_device(rar, off);
-	if (rar_dev == NULL || !rar_dev->registered)
-		return NULL;
-	return rar_dev;
-}
-
-/**
- *	rar_to_client		-	return the client handling this RAR
- *	@rar: RAR number
- *
- *	Return the client this RAR maps to if a mapping is known, otherwise
- *	returns NULL.
- */
-static struct client *rar_to_client(int rar)
-{
-	int idx;
-	struct rar_device *r = _rar_to_device(rar, &idx);
-	if (r != NULL)
-		return &r->client[idx];
-	return NULL;
-}
-
-/**
- *	rar_read_addr		-	retrieve a RAR mapping
- *	@pdev: PCI device for the RAR
- *	@offset: offset for message
- *	@addr: returned address
- *
- *	Reads the address of a given RAR register. Returns 0 on success
- *	or an error code on failure.
- */
-static int rar_read_addr(struct pci_dev *pdev, int offset, dma_addr_t *addr)
-{
-	/*
-	 * ======== The Lincroft Message Bus Interface ========
-	 * Lincroft registers may be obtained via PCI from
-	 * the host bridge using the Lincroft Message Bus
-	 * Interface.  That message bus interface is generally
-	 * comprised of two registers: a control register (MCR, 0xDO)
-	 * and a data register (MDR, 0xD4).
-	 *
-	 * The MCR (message control register) format is the following:
-	 *   1.  [31:24]: Opcode
-	 *   2.  [23:16]: Port
-	 *   3.  [15:8]: Register Offset
-	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
-	 *              to 1)
-	 *   5.  [3:0]: reserved
-	 *
-	 *  Read (0xD0) and write (0xE0) opcodes are written to the
-	 *  control register when reading and writing to Lincroft
-	 *  registers, respectively.
-	 *
-	 *  We're interested in registers found in the Lincroft
-	 *  B-unit.  The B-unit port is 0x3.
-	 *
-	 *  The six B-unit RAR register offsets we use are listed
-	 *  earlier in this file.
-	 *
-	 *  Lastly writing to the MCR register requires the "Byte
-	 *  enables" bits to be set to 1.  This may be achieved by
-	 *  writing 0xF at bit 4.
-	 *
-	 * The MDR (message data register) format is the following:
-	 *   1. [31:0]: Read/Write Data
-	 *
-	 *  Data being read from this register is only available after
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	 *
-	 *  Data being written to this register must be written before
-	 *  writing the appropriate control message to the MCR
-	 *  register.
-	*/
-
-	int result;
-	u32 addr32;
-
-	/* Construct control message */
-	u32 const message =
-		 (LNC_MESSAGE_READ_OPCODE << 24)
-		 | (LNC_BUNIT_PORT << 16)
-		 | (offset << 8)
-		 | (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
-
-	dev_dbg(&pdev->dev, "Offset for 'get' LNC MSG is %x\n", offset);
-
-	/*
-	* We synchronize access to the Lincroft MCR and MDR registers
-	* until BOTH the command is issued through the MCR register
-	* and the corresponding data is read from the MDR register.
-	* Otherwise a race condition would exist between accesses to
-	* both registers.
-	*/
-
-	mutex_lock(&lnc_reg_mutex);
-
-	/* Send the control message */
-	result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
-	if (!result) {
-		/* Read back the address as a 32bit value */
-		result = pci_read_config_dword(pdev, LNC_MDR_OFFSET, &addr32);
-		*addr = (dma_addr_t)addr32;
-	}
-	mutex_unlock(&lnc_reg_mutex);
-	return result;
-}
-
-/**
- *	rar_set_addr		-	Set a RAR mapping
- *	@pdev: PCI device for the RAR
- *	@offset: offset for message
- *	@addr: address to set
- *
- *	Sets the address of a given RAR register. Returns 0 on success
- *	or an error code on failure.
- */
-static int rar_set_addr(struct pci_dev *pdev,
-	int offset,
-	dma_addr_t addr)
-{
-	/*
-	* Data being written to this register must be written before
-	* writing the appropriate control message to the MCR
-	* register.
-	* See rar_get_addrs() for a description of the
-	* message bus interface being used here.
-	*/
-
-	int result;
-
-	/* Construct control message */
-	u32 const message = (LNC_MESSAGE_WRITE_OPCODE << 24)
-		| (LNC_BUNIT_PORT << 16)
-		| (offset << 8)
-		| (LNC_MESSAGE_BYTE_WRITE_ENABLES << 4);
-
-	/*
-	* We synchronize access to the Lincroft MCR and MDR registers
-	* until BOTH the command is issued through the MCR register
-	* and the corresponding data is read from the MDR register.
-	* Otherwise a race condition would exist between accesses to
-	* both registers.
-	*/
-
-	mutex_lock(&lnc_reg_mutex);
-
-	/* Send the control message */
-	result = pci_write_config_dword(pdev, LNC_MDR_OFFSET, addr);
-	if (!result)
-		/* And address */
-		result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
-
-	mutex_unlock(&lnc_reg_mutex);
-	return result;
-}
-
-/*
- *	rar_init_params		-	Initialize RAR parameters
- *	@rar: RAR device to initialise
- *
- *	Initialize RAR parameters, such as bus addresses, etc. Returns 0
- *	on success, or an error code on failure.
- */
-static int init_rar_params(struct rar_device *rar)
-{
-	struct pci_dev *pdev = rar->rar_dev;
-	unsigned int i;
-	int result = 0;
-	int offset = 0x10;	/* RAR 0 to 2 in order low/high/low/high/... */
-
-	/* Retrieve RAR start and end bus addresses.
-	* Access the RAR registers through the Lincroft Message Bus
-	* Interface on PCI device: 00:00.0 Host bridge.
-	*/
-
-	for (i = 0; i < MRST_NUM_RAR; ++i) {
-		struct rar_addr *addr = &rar->rar_addr[i];
-
-		result = rar_read_addr(pdev, offset++, &addr->low);
-		if (result != 0)
-			return result;
-
-		result = rar_read_addr(pdev, offset++, &addr->high);
-		if (result != 0)
-			return result;
-
-
-		/*
-		* Only the upper 22 bits of the RAR addresses are
-		* stored in their corresponding RAR registers so we
-		* must set the lower 10 bits accordingly.
-
-		* The low address has its lower 10 bits cleared, and
-		* the high address has all its lower 10 bits set,
-		* e.g.:
-		* low = 0x2ffffc00
-		*/
-
-		addr->low &= (dma_addr_t)0xfffffc00u;
-
-		/*
-		* Set bits 9:0 on uppser address if bits 31:10 are non
-		* zero; otherwize clear all bits
-		*/
-
-		if ((addr->high & 0xfffffc00u) == 0)
-			addr->high = 0;
-		else
-			addr->high |= 0x3ffu;
-	}
-	/* Done accessing the device. */
-
-	if (result == 0) {
-		for (i = 0; i != MRST_NUM_RAR; ++i) {
-			/*
-			* "BRAR" refers to the RAR registers in the
-			* Lincroft B-unit.
-			*/
-			dev_info(&pdev->dev, "BRAR[%u] bus address range = "
-			  "[%lx, %lx]\n", i,
-			  (unsigned long)rar->rar_addr[i].low,
-			  (unsigned long)rar->rar_addr[i].high);
-		}
-	}
-	return result;
-}
-
-/**
- *	rar_get_address		-	get the bus address in a RAR
- *	@start: return value of start address of block
- *	@end: return value of end address of block
- *
- *	The rar_get_address function is used by other device drivers
- *	to obtain RAR address information on a RAR. It takes three
- *	parameters:
- *
- *	The function returns a 0 upon success or an error if there is no RAR
- *	facility on this system.
- */
-int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end)
-{
-	int idx;
-	struct rar_device *rar = rar_to_device(rar_index, &idx);
-
-	if (rar == NULL) {
-		WARN_ON(1);
-		return -ENODEV;
-	}
-
-	*start = rar->rar_addr[idx].low;
-	*end = rar->rar_addr[idx].high;
-	return 0;
-}
-EXPORT_SYMBOL(rar_get_address);
-
-/**
- *	rar_lock	-	lock a RAR register
- *	@rar_index: RAR to lock (0-2)
- *
- *	The rar_lock function is ued by other device drivers to lock an RAR.
- *	once a RAR is locked, it stays locked until the next system reboot.
- *
- *	The function returns a 0 upon success or an error if there is no RAR
- *	facility on this system, or the locking fails
- */
-int rar_lock(int rar_index)
-{
-	struct rar_device *rar;
-	int result;
-	int idx;
-	dma_addr_t low, high;
-
-	rar = rar_to_device(rar_index, &idx);
-
-	if (rar == NULL) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	low = rar->rar_addr[idx].low & 0xfffffc00u;
-	high = rar->rar_addr[idx].high & 0xfffffc00u;
-
-	/*
-	* Only allow I/O from the graphics and Langwell;
-	* not from the x86 processor
-	*/
-
-	if (rar_index == RAR_TYPE_VIDEO) {
-		low |= 0x00000009;
-		high |= 0x00000015;
-	} else if (rar_index == RAR_TYPE_AUDIO) {
-		/* Only allow I/O from Langwell; nothing from x86 */
-		low |= 0x00000008;
-		high |= 0x00000018;
-	} else
-		/* Read-only from all agents */
-		high |= 0x00000018;
-
-	/*
-	* Now program the register using the Lincroft message
-	* bus interface.
-	*/
-	result = rar_set_addr(rar->rar_dev,
-				2 * idx, low);
-
-	if (result == 0)
-		result = rar_set_addr(rar->rar_dev,
-				2 * idx + 1, high);
-
-	return result;
-}
-EXPORT_SYMBOL(rar_lock);
-
-/**
- *	register_rar		-	register a RAR handler
- *	@num: RAR we wish to register for
- *	@callback: function to call when RAR support is available
- *	@data: data to pass to this function
- *
- *	The register_rar function is to used by other device drivers
- *	to ensure that this driver is ready. As we cannot be sure of
- *	the compile/execute order of drivers in the kernel, it is
- *	best to give this driver a callback function to call when
- *	it is ready to give out addresses. The callback function
- *	would have those steps that continue the initialization of
- *	a driver that do require a valid RAR address. One of those
- *	steps would be to call rar_get_address()
- *
- *	This function return 0 on success or an error code on failure.
- */
-int register_rar(int num, int (*callback)(unsigned long data),
-							unsigned long data)
-{
-	/* For now we hardcode a single RAR device */
-	struct rar_device *rar;
-	struct client *c;
-	int idx;
-	int retval = 0;
-
-	mutex_lock(&rar_mutex);
-
-	/* Do we have a client mapping for this RAR number ? */
-	c = rar_to_client(num);
-	if (c == NULL) {
-		retval = -ERANGE;
-		goto done;
-	}
-	/* Is it claimed ? */
-	if (c->busy) {
-		retval = -EBUSY;
-		goto done;
-	}
-	c->busy = 1;
-
-	/* See if we have a handler for this RAR yet, if we do then fire it */
-	rar = rar_to_device(num, &idx);
-
-	if (rar) {
-		/*
-		* if the driver already registered, then we can simply
-		* call the callback right now
-		*/
-		(*callback)(data);
-		goto done;
-	}
-
-	/* Arrange to be called back when the hardware is found */
-	c->callback = callback;
-	c->driver_priv = data;
-done:
-	mutex_unlock(&rar_mutex);
-	return retval;
-}
-EXPORT_SYMBOL(register_rar);
-
-/**
- *	unregister_rar	-	release a RAR allocation
- *	@num: RAR number
- *
- *	Releases a RAR allocation, or pending allocation. If a callback is
- *	pending then this function will either complete before the unregister
- *	returns or not at all.
- */
-
-void unregister_rar(int num)
-{
-	struct client *c;
-
-	mutex_lock(&rar_mutex);
-	c = rar_to_client(num);
-	if (c == NULL || !c->busy)
-		WARN_ON(1);
-	else
-		c->busy = 0;
-	mutex_unlock(&rar_mutex);
-}
-EXPORT_SYMBOL(unregister_rar);
-
-/**
- *	rar_callback		-	Process callbacks
- *	@rar: new RAR device
- *
- *	Process the callbacks for a newly found RAR device.
- */
-
-static void rar_callback(struct rar_device *rar)
-{
-	struct client *c = &rar->client[0];
-	int i;
-
-	mutex_lock(&rar_mutex);
-
-	rar->registered = 1;	/* Ensure no more callbacks queue */
-
-	for (i = 0; i < MRST_NUM_RAR; i++) {
-		if (c->callback && c->busy) {
-			c->callback(c->driver_priv);
-			c->callback = NULL;
-		}
-		c++;
-	}
-	mutex_unlock(&rar_mutex);
-}
-
-/**
- *	rar_probe		-	PCI probe callback
- *	@dev: PCI device
- *	@id: matching entry in the match table
- *
- *	A RAR device has been discovered. Initialise it and if successful
- *	process any pending callbacks that can now be completed.
- */
-static int rar_probe(struct pci_dev *dev, const struct pci_device_id *id)
-{
-	int error;
-	struct rar_device *rar;
-
-	dev_dbg(&dev->dev, "PCI probe starting\n");
-
-	rar = alloc_rar_device();
-	if (rar == NULL)
-		return -EBUSY;
-
-	/* Enable the device */
-	error = pci_enable_device(dev);
-	if (error) {
-		dev_err(&dev->dev,
-			"Error enabling RAR register PCI device\n");
-		goto end_function;
-	}
-
-	/* Fill in the rar_device structure */
-	rar->rar_dev = pci_dev_get(dev);
-	pci_set_drvdata(dev, rar);
-
-	/*
-	 * Initialize the RAR parameters, which have to be retrieved
-	 * via the message bus interface.
-	 */
-	error = init_rar_params(rar);
-	if (error) {
-		pci_disable_device(dev);
-		dev_err(&dev->dev, "Error retrieving RAR addresses\n");
-		goto end_function;
-	}
-	/* now call anyone who has registered (using callbacks) */
-	rar_callback(rar);
-	return 0;
-end_function:
-	free_rar_device(rar);
-	return error;
-}
-
-static DEFINE_PCI_DEVICE_TABLE(rar_pci_id_tbl) = {
-	{ PCI_VDEVICE(INTEL, 0x4110) },
-	{ 0 }
-};
-
-MODULE_DEVICE_TABLE(pci, rar_pci_id_tbl);
-
-/* field for registering driver to PCI device */
-static struct pci_driver rar_pci_driver = {
-	.name = "rar_register_driver",
-	.id_table = rar_pci_id_tbl,
-	.probe = rar_probe,
-	/* Cannot be unplugged - no remove */
-};
-
-static int __init rar_init_handler(void)
-{
-	return pci_register_driver(&rar_pci_driver);
-}
-
-static void __exit rar_exit_handler(void)
-{
-	pci_unregister_driver(&rar_pci_driver);
-}
-
-module_init(rar_init_handler);
-module_exit(rar_exit_handler);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Intel Restricted Access Region Register Driver");
diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index f00d0d1..9215ed7 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -159,7 +159,7 @@ static inline int busy_loop(void) /* Wait till scu status is busy */
 /* Read/Write power control(PMIC in Langwell, MSIC in PenWell) registers */
 static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
 {
-	int i, nc, bytes, d;
+	int nc;
 	u32 offset = 0;
 	int err;
 	u8 cbuf[IPC_WWBUF_SIZE] = { };
@@ -174,55 +174,34 @@ static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
 		return -ENODEV;
 	}
 
-	if (platform != MRST_CPU_CHIP_PENWELL) {
-		bytes = 0;
-		d = 0;
-		for (i = 0; i < count; i++) {
-			cbuf[bytes++] = addr[i];
-			cbuf[bytes++] = addr[i] >> 8;
-			if (id != IPC_CMD_PCNTRL_R)
-				cbuf[bytes++] = data[d++];
-			if (id == IPC_CMD_PCNTRL_M)
-				cbuf[bytes++] = data[d++];
-		}
-		for (i = 0; i < bytes; i += 4)
-			ipc_data_writel(wbuf[i/4], i);
-		ipc_command(bytes << 16 |  id << 12 | 0 << 8 | op);
-	} else {
-		for (nc = 0; nc < count; nc++, offset += 2) {
-			cbuf[offset] = addr[nc];
-			cbuf[offset + 1] = addr[nc] >> 8;
-		}
+	for (nc = 0; nc < count; nc++, offset += 2) {
+		cbuf[offset] = addr[nc];
+		cbuf[offset + 1] = addr[nc] >> 8;
+	}
 
-		if (id == IPC_CMD_PCNTRL_R) {
-			for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
-				ipc_data_writel(wbuf[nc], offset);
-			ipc_command((count*2) << 16 |  id << 12 | 0 << 8 | op);
-		} else if (id == IPC_CMD_PCNTRL_W) {
-			for (nc = 0; nc < count; nc++, offset += 1)
-				cbuf[offset] = data[nc];
-			for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
-				ipc_data_writel(wbuf[nc], offset);
-			ipc_command((count*3) << 16 |  id << 12 | 0 << 8 | op);
-		} else if (id == IPC_CMD_PCNTRL_M) {
-			cbuf[offset] = data[0];
-			cbuf[offset + 1] = data[1];
-			ipc_data_writel(wbuf[0], 0); /* Write wbuff */
-			ipc_command(4 << 16 |  id << 12 | 0 << 8 | op);
-		}
+	if (id == IPC_CMD_PCNTRL_R) {
+		for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
+			ipc_data_writel(wbuf[nc], offset);
+		ipc_command((count*2) << 16 |  id << 12 | 0 << 8 | op);
+	} else if (id == IPC_CMD_PCNTRL_W) {
+		for (nc = 0; nc < count; nc++, offset += 1)
+			cbuf[offset] = data[nc];
+		for (nc = 0, offset = 0; nc < count; nc++, offset += 4)
+			ipc_data_writel(wbuf[nc], offset);
+		ipc_command((count*3) << 16 |  id << 12 | 0 << 8 | op);
+	} else if (id == IPC_CMD_PCNTRL_M) {
+		cbuf[offset] = data[0];
+		cbuf[offset + 1] = data[1];
+		ipc_data_writel(wbuf[0], 0); /* Write wbuff */
+		ipc_command(4 << 16 |  id << 12 | 0 << 8 | op);
 	}
 
 	err = busy_loop();
 	if (id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
 		/* Workaround: values are read as 0 without memcpy_fromio */
 		memcpy_fromio(cbuf, ipcdev.ipc_base + 0x90, 16);
-		if (platform != MRST_CPU_CHIP_PENWELL) {
-			for (nc = 0, offset = 2; nc < count; nc++, offset += 3)
-				data[nc] = ipc_data_readb(offset);
-		} else {
-			for (nc = 0; nc < count; nc++)
-				data[nc] = ipc_data_readb(nc);
-		}
+		for (nc = 0; nc < count; nc++)
+			data[nc] = ipc_data_readb(nc);
 	}
 	mutex_unlock(&ipclock);
 	return err;
@@ -503,148 +482,6 @@ int intel_scu_ipc_i2c_cntrl(u32 addr, u32 *data)
 }
 EXPORT_SYMBOL(intel_scu_ipc_i2c_cntrl);
 
-#define IPC_FW_LOAD_ADDR 0xFFFC0000 /* Storage location for FW image */
-#define IPC_FW_UPDATE_MBOX_ADDR 0xFFFFDFF4 /* Mailbox between ipc and scu */
-#define IPC_MAX_FW_SIZE 262144 /* 256K storage size for loading the FW image */
-#define IPC_FW_MIP_HEADER_SIZE 2048 /* Firmware MIP header size */
-/* IPC inform SCU to get ready for update process */
-#define IPC_CMD_FW_UPDATE_READY  0x10FE
-/* IPC inform SCU to go for update process */
-#define IPC_CMD_FW_UPDATE_GO     0x20FE
-/* Status code for fw update */
-#define IPC_FW_UPDATE_SUCCESS	0x444f4e45 /* Status code 'DONE' */
-#define IPC_FW_UPDATE_BADN	0x4241444E /* Status code 'BADN' */
-#define IPC_FW_TXHIGH		0x54784849 /* Status code 'IPC_FW_TXHIGH' */
-#define IPC_FW_TXLOW		0x54784c4f /* Status code 'IPC_FW_TXLOW' */
-
-struct fw_update_mailbox {
-	u32    status;
-	u32    scu_flag;
-	u32    driver_flag;
-};
-
-
-/**
- *	intel_scu_ipc_fw_update	-	 Firmware update utility
- *	@buffer: firmware buffer
- *	@length: size of firmware buffer
- *
- *	This function provides an interface to load the firmware into
- *	the SCU. Returns 0 on success or -1 on failure
- */
-int intel_scu_ipc_fw_update(u8 *buffer, u32 length)
-{
-	void __iomem *fw_update_base;
-	struct fw_update_mailbox __iomem *mailbox = NULL;
-	int retry_cnt = 0;
-	u32 status;
-
-	mutex_lock(&ipclock);
-	fw_update_base = ioremap_nocache(IPC_FW_LOAD_ADDR, (128*1024));
-	if (fw_update_base == NULL) {
-		mutex_unlock(&ipclock);
-		return -ENOMEM;
-	}
-	mailbox = ioremap_nocache(IPC_FW_UPDATE_MBOX_ADDR,
-					sizeof(struct fw_update_mailbox));
-	if (mailbox == NULL) {
-		iounmap(fw_update_base);
-		mutex_unlock(&ipclock);
-		return -ENOMEM;
-	}
-
-	ipc_command(IPC_CMD_FW_UPDATE_READY);
-
-	/* Intitialize mailbox */
-	writel(0, &mailbox->status);
-	writel(0, &mailbox->scu_flag);
-	writel(0, &mailbox->driver_flag);
-
-	/* Driver copies the 2KB MIP header to SRAM at 0xFFFC0000*/
-	memcpy_toio(fw_update_base, buffer, 0x800);
-
-	/* Driver sends "FW Update" IPC command (CMD_ID 0xFE; MSG_ID 0x02).
-	* Upon receiving this command, SCU will write the 2K MIP header
-	* from 0xFFFC0000 into NAND.
-	* SCU will write a status code into the Mailbox, and then set scu_flag.
-	*/
-
-	ipc_command(IPC_CMD_FW_UPDATE_GO);
-
-	/*Driver stalls until scu_flag is set */
-	while (readl(&mailbox->scu_flag) != 1) {
-		rmb();
-		mdelay(1);
-	}
-
-	/* Driver checks Mailbox status.
-	 * If the status is 'BADN', then abort (bad NAND).
-	 * If the status is 'IPC_FW_TXLOW', then continue.
-	 */
-	while (readl(&mailbox->status) != IPC_FW_TXLOW) {
-		rmb();
-		mdelay(10);
-	}
-	mdelay(10);
-
-update_retry:
-	if (retry_cnt > 5)
-		goto update_end;
-
-	if (readl(&mailbox->status) != IPC_FW_TXLOW)
-		goto update_end;
-	buffer = buffer + 0x800;
-	memcpy_toio(fw_update_base, buffer, 0x20000);
-	writel(1, &mailbox->driver_flag);
-	while (readl(&mailbox->scu_flag) == 1) {
-		rmb();
-		mdelay(1);
-	}
-
-	/* check for 'BADN' */
-	if (readl(&mailbox->status) == IPC_FW_UPDATE_BADN)
-		goto update_end;
-
-	while (readl(&mailbox->status) != IPC_FW_TXHIGH) {
-		rmb();
-		mdelay(10);
-	}
-	mdelay(10);
-
-	if (readl(&mailbox->status) != IPC_FW_TXHIGH)
-		goto update_end;
-
-	buffer = buffer + 0x20000;
-	memcpy_toio(fw_update_base, buffer, 0x20000);
-	writel(0, &mailbox->driver_flag);
-
-	while (mailbox->scu_flag == 0) {
-		rmb();
-		mdelay(1);
-	}
-
-	/* check for 'BADN' */
-	if (readl(&mailbox->status) == IPC_FW_UPDATE_BADN)
-		goto update_end;
-
-	if (readl(&mailbox->status) == IPC_FW_TXLOW) {
-		++retry_cnt;
-		goto update_retry;
-	}
-
-update_end:
-	status = readl(&mailbox->status);
-
-	iounmap(fw_update_base);
-	iounmap(mailbox);
-	mutex_unlock(&ipclock);
-
-	if (status == IPC_FW_UPDATE_SUCCESS)
-		return 0;
-	return -EIO;
-}
-EXPORT_SYMBOL(intel_scu_ipc_fw_update);
-
 /*
  * Interrupt handler gets called when ioc bit of IPC_COMMAND_REG set to 1
  * When ioc bit is set to 1, caller api must wait for interrupt handler called
@@ -727,7 +564,6 @@ static void ipc_remove(struct pci_dev *pdev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080e)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x082a)},
 	{ 0,}
 };
diff --git a/drivers/platform/x86/intel_scu_ipcutil.c b/drivers/platform/x86/intel_scu_ipcutil.c
index 2d0f913..02bc5a6 100644
--- a/drivers/platform/x86/intel_scu_ipcutil.c
+++ b/drivers/platform/x86/intel_scu_ipcutil.c
@@ -26,13 +26,10 @@
 
 static int major;
 
-#define MAX_FW_SIZE 264192
-
 /* ioctl commnds */
 #define	INTE_SCU_IPC_REGISTER_READ	0
 #define INTE_SCU_IPC_REGISTER_WRITE	1
 #define INTE_SCU_IPC_REGISTER_UPDATE	2
-#define INTE_SCU_IPC_FW_UPDATE		0xA2
 
 struct scu_ipc_data {
 	u32     count;  /* No. of registers */
@@ -88,27 +85,14 @@ static long scu_ipc_ioctl(struct file *fp, unsigned int cmd,
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
-	if (cmd == INTE_SCU_IPC_FW_UPDATE) {
-			u8 *fwbuf = kmalloc(MAX_FW_SIZE, GFP_KERNEL);
-			if (fwbuf == NULL)
-				return -ENOMEM;
-			if (copy_from_user(fwbuf, (u8 *)arg, MAX_FW_SIZE)) {
-				kfree(fwbuf);
-				return -EFAULT;
-			}
-			ret = intel_scu_ipc_fw_update(fwbuf, MAX_FW_SIZE);
-			kfree(fwbuf);
-			return ret;
-	} else {
-		if (copy_from_user(&data, argp, sizeof(struct scu_ipc_data)))
-			return -EFAULT;
-		ret = scu_reg_access(cmd, &data);
-		if (ret < 0)
-			return ret;
-		if (copy_to_user(argp, &data, sizeof(struct scu_ipc_data)))
-			return -EFAULT;
-		return 0;
-	}
+	if (copy_from_user(&data, argp, sizeof(struct scu_ipc_data)))
+		return -EFAULT;
+	ret = scu_reg_access(cmd, &data);
+	if (ret < 0)
+		return ret;
+	if (copy_to_user(argp, &data, sizeof(struct scu_ipc_data)))
+		return -EFAULT;
+	return 0;
 }
 
 static const struct file_operations scu_ipc_fops = {
diff --git a/include/linux/rar_register.h b/include/linux/rar_register.h
deleted file mode 100644
index 5c61181..0000000
--- a/include/linux/rar_register.h
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (C) 2010 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General
- * Public License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be
- * useful, but WITHOUT ANY WARRANTY; without even the implied
- * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
- * PURPOSE.  See the GNU General Public License for more details.
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the Free
- * Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA  02111-1307, USA.
- * The full GNU General Public License is included in this
- * distribution in the file called COPYING.
- */
-
-
-#ifndef _RAR_REGISTER_H
-#define _RAR_REGISTER_H
-
-#include <linux/types.h>
-
-/* following are used both in drivers as well as user space apps */
-
-#define	RAR_TYPE_VIDEO	0
-#define	RAR_TYPE_AUDIO	1
-#define	RAR_TYPE_IMAGE	2
-#define	RAR_TYPE_DATA	3
-
-#ifdef __KERNEL__
-
-struct rar_device;
-
-#if defined(CONFIG_RAR_REGISTER)
-int register_rar(int num,
-		int (*callback)(unsigned long data), unsigned long data);
-void unregister_rar(int num);
-int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end);
-int rar_lock(int rar_index);
-#else
-extern void unregister_rar(int num)  { }
-extern int rar_lock(int rar_index) { return -EIO; }
-
-extern inline int register_rar(int num,
-		int (*callback)(unsigned long data), unsigned long data)
-{
-	return -ENODEV;
-}
-
-extern int rar_get_address(int rar_index, dma_addr_t *start, dma_addr_t *end)
-{
-	return -ENODEV;
-}
-#endif	/* RAR_REGISTER */
-
-#endif  /* __KERNEL__ */
-#endif  /* _RAR_REGISTER_H */
