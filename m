Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2H1Ufh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:35:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47613 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab2H1Uff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:35:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clk: Make the generic clock API available by default
Date: Tue, 28 Aug 2012 13:35:04 -0700
Message-Id: <1346186104-4083-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than requiring platforms to select the generic clock API to make
it available make the API available as a user selectable option unless the
user either selects HAVE_CUSTOM_CLK (if they have their own implementation)
or selects COMMON_CLK (if they depend on the generic implementation).

All current architectures that HAVE_CLK but don't use the common clock
framework have selects of HAVE_CUSTOM_CLK added.

This allows drivers to use the generic API on platforms which have no need
for the clock API at platform level.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

This depends on having one of the patches I've sent adding a generic
clkdev.h added merged - Arnd was expecting to merge one of those, there
was just the lack of clarity about the most practical Kbuild hookup.

 arch/arm/Kconfig            |   12 ++++++++++++
 arch/avr32/Kconfig          |    1 +
 arch/mips/Kconfig           |    4 ++++
 arch/mips/loongson/Kconfig  |    1 +
 arch/mips/loongson1/Kconfig |    1 +
 arch/mips/txx9/Kconfig      |    1 +
 arch/powerpc/Kconfig        |    1 +
 arch/unicore32/Kconfig      |    1 +
 drivers/clk/Kconfig         |   13 ++++++++++---
 9 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d4471d4..2a5633b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -330,6 +330,7 @@ config ARCH_VEXPRESS
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_PATA_PLATFORM
 	select ICST
 	select NO_IOPORT
@@ -343,6 +344,7 @@ config ARCH_AT91
 	bool "Atmel AT91"
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select CLKDEV_LOOKUP
 	select IRQ_DOMAIN
 	select NEED_MACH_IO_H if PCCARD
@@ -674,6 +676,7 @@ config ARCH_TEGRA
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	select ARCH_HAS_CPUFREQ
@@ -732,6 +735,7 @@ config ARCH_PXA
 config ARCH_MSM
 	bool "Qualcomm MSM"
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select GENERIC_CLOCKEVENTS
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
@@ -745,6 +749,7 @@ config ARCH_MSM
 config ARCH_SHMOBILE
 	bool "Renesas SH-Mobile / R-Mobile"
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select CLKDEV_LOOKUP
 	select HAVE_MACH_CLKDEV
 	select HAVE_SMP
@@ -798,6 +803,7 @@ config ARCH_S3C24XX
 	select GENERIC_GPIO
 	select ARCH_HAS_CPUFREQ
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select CLKDEV_LOOKUP
 	select ARCH_USES_GETTIMEOFFSET
 	select HAVE_S3C2410_I2C if I2C
@@ -816,6 +822,7 @@ config ARCH_S3C64XX
 	select CPU_V6
 	select ARM_VIC
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_TCM
 	select CLKDEV_LOOKUP
 	select NO_IOPORT
@@ -838,6 +845,7 @@ config ARCH_S5P64X0
 	select CPU_V6
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
@@ -852,6 +860,7 @@ config ARCH_S5PC100
 	bool "Samsung S5PC100"
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select CLKDEV_LOOKUP
 	select CPU_V7
 	select ARCH_USES_GETTIMEOFFSET
@@ -868,6 +877,7 @@ config ARCH_S5PV210
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
 	select ARCH_HAS_CPUFREQ
@@ -886,6 +896,7 @@ config ARCH_EXYNOS
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select CLKDEV_LOOKUP
 	select ARCH_HAS_CPUFREQ
 	select GENERIC_CLOCKEVENTS
@@ -972,6 +983,7 @@ config ARCH_OMAP
 	bool "TI OMAP"
 	depends on MMU
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
 	select CLKSRC_MMIO
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 06e73bf..bfeb9cc 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -4,6 +4,7 @@ config AVR32
 	# that we usually don't need on AVR32.
 	select EXPERT
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 641d067..27dfc99 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -84,6 +84,7 @@ config AR7
 	select ARCH_REQUIRE_GPIOLIB
 	select VLYNQ
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	help
 	  Support for the Texas Instruments AR7 System-on-a-Chip
 	  family: TNETD7100, 7200 and 7300.
@@ -96,6 +97,7 @@ config ATH79
 	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select IRQ_CPU
 	select MIPS_MACHINE
 	select SYS_HAS_CPU_MIPS32_R2
@@ -133,6 +135,7 @@ config BCM63XX
 	select SWAP_IO_SPACE
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	help
 	 Support for BCM63XX based boards
 
@@ -228,6 +231,7 @@ config MACH_JZ4740
 	select SYS_HAS_EARLY_PRINTK
 	select HAVE_PWM
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select GENERIC_IRQ_CHIP
 
 config LANTIQ
diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
index 263beb9..ed42be1 100644
--- a/arch/mips/loongson/Kconfig
+++ b/arch/mips/loongson/Kconfig
@@ -42,6 +42,7 @@ config LEMOTE_MACH2F
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA_SUPPORT_BROKEN
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HW_HAS_PCI
 	select I8259
 	select IRQ_CPU
diff --git a/arch/mips/loongson1/Kconfig b/arch/mips/loongson1/Kconfig
index a9a14d6..ddaa7d0 100644
--- a/arch/mips/loongson1/Kconfig
+++ b/arch/mips/loongson1/Kconfig
@@ -16,6 +16,7 @@ config LOONGSON1_LS1B
 	select SYS_SUPPORTS_HIGHMEM
 	select SYS_HAS_EARLY_PRINTK
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 
 endchoice
 
diff --git a/arch/mips/txx9/Kconfig b/arch/mips/txx9/Kconfig
index 6d40bc7..04e3cdb 100644
--- a/arch/mips/txx9/Kconfig
+++ b/arch/mips/txx9/Kconfig
@@ -21,6 +21,7 @@ config MACH_TXX9
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 
 config TOSHIBA_JMR3927
 	bool "Toshiba JMR-TX3927 board"
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 58088dd..b7a611b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1013,6 +1013,7 @@ config PPC_CLOCK
 	bool
 	default n
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 
 config PPC_LIB_RHEAP
 	bool
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 5d53ffd..fe30bb1 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -89,6 +89,7 @@ config ARCH_PUV3
 	select CPU_UCV2
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
 
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 7f0b5ca..e94fd06 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -9,16 +9,23 @@ config HAVE_CLK_PREPARE
 config HAVE_MACH_CLKDEV
 	bool
 
-config COMMON_CLK
+config HAVE_CUSTOM_CLK
 	bool
+	---help---
+	  Architectures which provide a custom clk API should select
+	  this to disable the common clock API.
+
+config COMMON_CLK
+	bool "Common clock framework"
+	depends on !HAVE_CUSTOM_CLK
 	select HAVE_CLK_PREPARE
 	select CLKDEV_LOOKUP
 	---help---
 	  The common clock framework is a single definition of struct
 	  clk, useful across many platforms, as well as an
 	  implementation of the clock API in include/linux/clk.h.
-	  Architectures utilizing the common struct clk should select
-	  this option.
+	  This provides a generic way for drivers to provide and use
+	  clocks without hard coded relationships in the drivers.
 
 menu "Common Clock Framework"
 	depends on COMMON_CLK
-- 
1.7.10.4

