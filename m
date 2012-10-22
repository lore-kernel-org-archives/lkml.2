Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2JVNDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:03:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55229 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab2JVNDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:03:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clk: Make the generic clock API available by default
Date: Mon, 22 Oct 2012 14:02:50 +0100
Message-Id: <1350910970-9095-1-git-send-email-broonie@opensource.wolfsonmicro.com>
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
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Mike, the patch to provide a defualt clkdev.h went in during the merge
window so it should now be safe to merge this.

 arch/arm/Kconfig            |   13 +++++++++++++
 arch/avr32/Kconfig          |    1 +
 arch/mips/Kconfig           |    4 ++++
 arch/mips/loongson/Kconfig  |    1 +
 arch/mips/loongson1/Kconfig |    1 +
 arch/mips/txx9/Kconfig      |    1 +
 arch/powerpc/Kconfig        |    1 +
 arch/unicore32/Kconfig      |    1 +
 drivers/clk/Kconfig         |   13 ++++++++++---
 9 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fe90e60..2248940 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -314,6 +314,7 @@ config ARCH_VERSATILE
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
 	select HAVE_MACH_CLKDEV
+	select HAVE_CUSTOM_CLK
 	select ICST
 	select PLAT_VERSATILE
 	select PLAT_VERSATILE_CLCD
@@ -327,6 +328,7 @@ config ARCH_AT91
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select IRQ_DOMAIN
 	select NEED_MACH_GPIO_H
 	select NEED_MACH_IO_H if PCCARD
@@ -632,6 +634,7 @@ config ARCH_TEGRA
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	select SPARSE_IRQ
@@ -666,6 +669,7 @@ config ARCH_MSM
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	help
 	  Support for Qualcomm MSM/QSD based systems.  This runs on the
 	  apps processor of the MSM/QSD and depends on a shared memory
@@ -678,6 +682,7 @@ config ARCH_SHMOBILE
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_MACH_CLKDEV
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
@@ -728,10 +733,12 @@ config ARCH_SA1100
 config ARCH_S3C24XX
 	bool "Samsung S3C24XX SoCs"
 	select ARCH_HAS_CPUFREQ
+	select CLKDEV_LOOKUP
 	select ARCH_USES_GETTIMEOFFSET
 	select CLKDEV_LOOKUP
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
 	select HAVE_S3C_RTC if RTC_CLASS
@@ -752,6 +759,7 @@ config ARCH_S3C64XX
 	select CLKDEV_LOOKUP
 	select CPU_V6
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
 	select HAVE_TCM
@@ -775,6 +783,7 @@ config ARCH_S5P64X0
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
 	select HAVE_S3C_RTC if RTC_CLASS
@@ -790,6 +799,7 @@ config ARCH_S5PC100
 	select CPU_V7
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
 	select HAVE_S3C_RTC if RTC_CLASS
@@ -808,6 +818,7 @@ config ARCH_S5PV210
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
 	select HAVE_S3C_RTC if RTC_CLASS
@@ -826,6 +837,7 @@ config ARCH_EXYNOS
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select HAVE_S3C2410_I2C if I2C
 	select HAVE_S3C2410_WATCHDOG if WATCHDOG
 	select HAVE_S3C_RTC if RTC_CLASS
@@ -928,6 +940,7 @@ config ARCH_OMAP
 	select CLKSRC_MMIO
 	select GENERIC_CLOCKEVENTS
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select NEED_MACH_GPIO_H
 	help
 	  Support for TI's OMAP platform (OMAP1/2/3/4).
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
index ce6c9a6..e0be02f 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -85,6 +85,7 @@ config AR7
 	select ARCH_REQUIRE_GPIOLIB
 	select VLYNQ
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	help
 	  Support for the Texas Instruments AR7 System-on-a-Chip
 	  family: TNETD7100, 7200 and 7300.
@@ -97,6 +98,7 @@ config ATH79
 	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	select IRQ_CPU
 	select MIPS_MACHINE
 	select SYS_HAS_CPU_MIPS32_R2
@@ -134,6 +136,7 @@ config BCM63XX
 	select SWAP_IO_SPACE
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 	help
 	 Support for BCM63XX based boards
 
@@ -229,6 +232,7 @@ config MACH_JZ4740
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
index 5af5aa7..da4ea6c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -1028,6 +1028,7 @@ config PPC_CLOCK
 	bool
 	default n
 	select HAVE_CLK
+	select HAVE_CUSTOM_CLK
 
 config PPC_LIB_RHEAP
 	bool
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index fda37c9..8247d69 100644
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
index bace9e9..8dc8391 100644
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

