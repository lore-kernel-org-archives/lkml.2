Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2DEWWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:22:23 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:65108 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336Ab2DEWWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:22:18 -0400
Date: Fri, 6 Apr 2012 00:22:06 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH 1/1] ARM: Rename CONFIG_ARM_AMBA to CONFIG_ARM_PRIMECELL
Message-ID: <9c8b8d1212528994ea09c9cc57428ce3d1f45da9.1333663714.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1333663714.git.rubini@gnudd.com>
In-Reply-To: <cover.1333663714.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMBA bus (Advanced Microcontroller Bus Architecture) is just an
interconnection bus that needs no software support.  Software support
offered in Linux is some sort of enumeration that only applies to
"PrimeCell" logic blocks (devices).  This renames the config option
to match reality.

Change suggested by Russell King.

Note: CONFIG_ARM_AMBA is retained and is enabled when
CONFIG_ARM_PRIMECELL is selected.  So any #ifdef in out-of-tree
drivers will still work until the symbol will be removed in due time.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Cc: Russell King <linux@arm.linux.org.uk>

---
 arch/arm/Kconfig                  |   36 ++++++++++++++++++++++--------------
 arch/arm/Kconfig.debug            |    2 +-
 arch/arm/mach-exynos/Kconfig      |    4 ++--
 arch/arm/mach-mxs/devices/Kconfig |    2 +-
 arch/arm/mach-netx/Kconfig        |    4 ++--
 arch/arm/mach-omap2/Kconfig       |    2 +-
 arch/arm/plat-samsung/Kconfig     |    2 +-
 drivers/Makefile                  |    2 +-
 drivers/dma/Kconfig               |    4 ++--
 drivers/gpio/Kconfig              |    2 +-
 drivers/input/serio/Kconfig       |    2 +-
 drivers/mmc/host/Kconfig          |    2 +-
 drivers/of/platform.c             |   10 +++++-----
 drivers/rtc/Kconfig               |    4 ++--
 drivers/spi/Kconfig               |    2 +-
 drivers/tty/serial/Kconfig        |    4 ++--
 drivers/video/Kconfig             |    2 +-
 drivers/watchdog/Kconfig          |    2 +-
 sound/arm/Kconfig                 |    2 +-
 19 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4ece1de..717213d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -269,7 +269,7 @@ choice
 
 config ARCH_INTEGRATOR
 	bool "ARM Ltd. Integrator family"
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARCH_HAS_CPUFREQ
 	select CLKDEV_LOOKUP
 	select HAVE_MACH_CLKDEV
@@ -286,7 +286,7 @@ config ARCH_INTEGRATOR
 
 config ARCH_REALVIEW
 	bool "ARM Ltd. RealView family"
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select CLKDEV_LOOKUP
 	select HAVE_MACH_CLKDEV
 	select ICST
@@ -302,7 +302,7 @@ config ARCH_REALVIEW
 
 config ARCH_VERSATILE
 	bool "ARM Ltd. Versatile family"
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARM_VIC
 	select CLKDEV_LOOKUP
 	select HAVE_MACH_CLKDEV
@@ -319,7 +319,7 @@ config ARCH_VERSATILE
 config ARCH_VEXPRESS
 	bool "ARM Ltd. Versatile Express family"
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARM_TIMER_SP804
 	select CLKDEV_LOOKUP
 	select HAVE_MACH_CLKDEV
@@ -347,7 +347,7 @@ config ARCH_BCMRING
 	bool "Broadcom BCMRING"
 	depends on MMU
 	select CPU_V6
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARM_TIMER_SP804
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
@@ -358,7 +358,7 @@ config ARCH_BCMRING
 config ARCH_HIGHBANK
 	bool "Calxeda Highbank-based"
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARM_GIC
 	select ARM_TIMER_SP804
 	select CACHE_L2X0
@@ -429,7 +429,7 @@ config ARCH_EBSA110
 config ARCH_EP93XX
 	bool "EP93xx-based"
 	select CPU_ARM920T
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARM_VIC
 	select CLKDEV_LOOKUP
 	select ARCH_REQUIRE_GPIOLIB
@@ -593,7 +593,7 @@ config ARCH_LPC32XX
 	select CPU_ARM926T
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_IDE
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select USB_ARCH_HAS_OHCI
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
@@ -914,7 +914,7 @@ config ARCH_U300
 	select CLKSRC_MMIO
 	select CPU_ARM926T
 	select HAVE_TCM
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARM_PATCH_PHYS_VIRT
 	select ARM_VIC
 	select GENERIC_CLOCKEVENTS
@@ -929,7 +929,7 @@ config ARCH_U8500
 	bool "ST-Ericsson U8500 Series"
 	depends on MMU
 	select CPU_V7
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select GENERIC_CLOCKEVENTS
 	select CLKDEV_LOOKUP
 	select ARCH_REQUIRE_GPIOLIB
@@ -941,7 +941,7 @@ config ARCH_U8500
 
 config ARCH_NOMADIK
 	bool "STMicroelectronics Nomadik"
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARM_VIC
 	select CPU_ARM926T
 	select CLKDEV_LOOKUP
@@ -977,7 +977,7 @@ config ARCH_OMAP
 
 config PLAT_SPEAR
 	bool "ST SPEAr"
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
@@ -1003,7 +1003,7 @@ config ARCH_ZYNQ
 	select GENERIC_CLOCKEVENTS
 	select CLKDEV_LOOKUP
 	select ARM_GIC
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select ICST
 	select MIGHT_HAVE_CACHE_L2X0
 	select USE_OF
@@ -1402,9 +1402,17 @@ source "arch/arm/common/Kconfig"
 
 menu "Bus support"
 
-config ARM_AMBA
+config ARM_PRIMECELL
+	select ARM_AMBA
 	bool
 
+config ARM_AMBA
+	bool "Previous name for CONFIG_ARM_PRIMECELL"
+	help
+	  This name is temporarily preserved for out-of-tree users
+	  that may have dependencies on this config symbol.  The symbol
+	  will be removed in due time.
+
 config ISA
 	bool
 	help
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 85348a0..d2ee7bb 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -320,7 +320,7 @@ config EARLY_PRINTK
 
 config OC_ETM
 	bool "On-chip ETM and ETB"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	help
 	  Enables the on-chip embedded trace macrocell and embedded trace
 	  buffer driver that will allow you to collect traces of the
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 0491cee..e42f91d 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -370,7 +370,7 @@ config MACH_EXYNOS4_DT
 	bool "Samsung Exynos4 Machine using device tree"
 	select CPU_EXYNOS4210
 	select USE_OF
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select HAVE_SAMSUNG_KEYPAD if INPUT_KEYBOARD
 	help
 	  Machine support for Samsung Exynos4 machine with device tree enabled.
@@ -382,7 +382,7 @@ config MACH_EXYNOS5_DT
 	bool "SAMSUNG EXYNOS5 Machine using device tree"
 	select SOC_EXYNOS5250
 	select USE_OF
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	help
 	  Machine support for Samsung Exynos4 machine with device tree enabled.
 	  Select this if a fdt blob is available for the EXYNOS4 SoC based board.
diff --git a/arch/arm/mach-mxs/devices/Kconfig b/arch/arm/mach-mxs/devices/Kconfig
index b8913df..4c8196d 100644
--- a/arch/arm/mach-mxs/devices/Kconfig
+++ b/arch/arm/mach-mxs/devices/Kconfig
@@ -1,6 +1,6 @@
 config MXS_HAVE_AMBA_DUART
 	bool
-	select ARM_AMBA
+	select ARM_PRIMECELL
 
 config MXS_HAVE_PLATFORM_AUART
 	bool
diff --git a/arch/arm/mach-netx/Kconfig b/arch/arm/mach-netx/Kconfig
index 3d90ef1..059c921 100644
--- a/arch/arm/mach-netx/Kconfig
+++ b/arch/arm/mach-netx/Kconfig
@@ -10,14 +10,14 @@ config MACH_NXDKN
 config MACH_NXDB500
 	bool "Enable Hilscher nxdb500 Eval Board support"
 	depends on ARCH_NETX
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	help
 	  Board support for the Hilscher nxdb500 Eval Board
 
 config MACH_NXEB500HMI
 	bool "Enable Hilscher nxeb500hmi Eval Board support"
 	depends on ARCH_NETX
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	help
 	  Board support for the Hilscher nxeb500hmi Eval Board
 
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 8141b76..d8012e7 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -346,7 +346,7 @@ config MACH_OMAP4_PANDA
 config OMAP3_EMU
 	bool "OMAP3 debugging peripherals"
 	depends on ARCH_OMAP3
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	select OC_ETM
 	help
 	  Say Y here to enable debugging hardware of omap3
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 71553f4..61a4a02 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -293,7 +293,7 @@ config SAMSUNG_DMADEV
 	select DMADEVICES
 	select PL330_DMA if (CPU_EXYNOS4210 || CPU_S5PV210 || CPU_S5PC100 || \
 					CPU_S5P6450 || CPU_S5P6440)
-	select ARM_AMBA
+	select ARM_PRIMECELL
 	help
 	  Use DMA device engine for PL330 DMAC.
 
diff --git a/drivers/Makefile b/drivers/Makefile
index 4855a1a..a5c189e 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_SFI)		+= sfi/
 # PnP must come after ACPI since it will eventually need to check if acpi
 # was used and do nothing if so
 obj-$(CONFIG_PNP)		+= pnp/
-obj-$(CONFIG_ARM_AMBA)		+= amba/
+obj-$(CONFIG_ARM_PRIMECELL)	+= amba/
 # Many drivers will want to use DMA so this has to be made available
 # really early.
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index ef378b5..cb7ad7a 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -51,7 +51,7 @@ config ASYNC_TX_ENABLE_CHANNEL_SWITCH
 
 config AMBA_PL08X
 	bool "ARM PrimeCell PL080 or PL081 support"
-	depends on ARM_AMBA && EXPERIMENTAL
+	depends on ARM_PRIMECELL && EXPERIMENTAL
 	select DMA_ENGINE
 	help
 	  Platform has a PL08x DMAC device
@@ -199,7 +199,7 @@ config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 config PL330_DMA
 	tristate "DMA API Driver for PL330"
 	select DMA_ENGINE
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	help
 	  Select if your platform has one or more PL330 DMACs.
 	  You need to provide platform specific settings via
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e03653d..abfc4be 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -138,7 +138,7 @@ config GPIO_MXS
 
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	select GENERIC_IRQ_CHIP
 	help
 	  Say yes here to support the PrimeCell PL061 GPIO device
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 55f2c22..8651278 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -101,7 +101,7 @@ config SERIO_AT32PSIF
 
 config SERIO_AMBAKMI
 	tristate "AMBA KMI keyboard controller"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 
 config SERIO_SA1111
 	tristate "Intel SA1111 keyboard controller"
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 4d15dff..298fb55 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -6,7 +6,7 @@ comment "MMC/SD/SDIO Host Controller Drivers"
 
 config MMC_ARMMMCI
 	tristate "ARM AMBA Multimedia Card Interface support"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell Multimedia Card
 	  Interface (PL180 and PL181) support.  If you have an ARM(R)
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 343ad29..a893ae3 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -25,9 +25,9 @@
 
 const struct of_device_id of_default_bus_match_table[] = {
 	{ .compatible = "simple-bus", },
-#ifdef CONFIG_ARM_AMBA
+#ifdef CONFIG_ARM_PRIMECELL
 	{ .compatible = "arm,amba-bus", },
-#endif /* CONFIG_ARM_AMBA */
+#endif /* CONFIG_ARM_PRIMECELL */
 	{} /* Empty terminated list */
 };
 
@@ -238,7 +238,7 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 }
 EXPORT_SYMBOL(of_platform_device_create);
 
-#ifdef CONFIG_ARM_AMBA
+#ifdef CONFIG_ARM_PRIMECELL
 static struct amba_device *of_amba_device_create(struct device_node *node,
 						 const char *bus_id,
 						 void *platform_data,
@@ -293,7 +293,7 @@ err_free:
 	amba_device_put(dev);
 	return NULL;
 }
-#else /* CONFIG_ARM_AMBA */
+#else /* CONFIG_ARM_PRIMECELL */
 static struct amba_device *of_amba_device_create(struct device_node *node,
 						 const char *bus_id,
 						 void *platform_data,
@@ -301,7 +301,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 {
 	return NULL;
 }
-#endif /* CONFIG_ARM_AMBA */
+#endif /* CONFIG_ARM_PRIMECELL */
 
 /**
  * of_devname_lookup() - Given a device node, lookup the preferred Linux name
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4161bfe..83bbca1 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -811,7 +811,7 @@ config RTC_DRV_VR41XX
 
 config RTC_DRV_PL030
 	tristate "ARM AMBA PL030 RTC"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	help
 	  If you say Y here you will get access to ARM AMBA
 	  PrimeCell PL030 RTC found on certain ARM SOCs.
@@ -821,7 +821,7 @@ config RTC_DRV_PL030
 
 config RTC_DRV_PL031
 	tristate "ARM AMBA PL031 RTC"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	help
 	  If you say Y here you will get access to ARM AMBA
 	  PrimeCell PL031 RTC found on certain ARM SOCs.
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 3ed7483..e0d92c9 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -256,7 +256,7 @@ config SPI_ORION
 
 config SPI_PL022
 	tristate "ARM AMBA PL022 SSP controller"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	default y if MACH_U300
 	default y if ARCH_REALVIEW
 	default y if INTEGRATOR_IMPD1
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 665beb6..c26336d 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -11,7 +11,7 @@ comment "Non-8250 serial port support"
 
 config SERIAL_AMBA_PL010
 	tristate "ARM AMBA PL010 serial port support"
-	depends on ARM_AMBA && (BROKEN || !ARCH_VERSATILE)
+	depends on ARM_PRIMECELL && (BROKEN || !ARCH_VERSATILE)
 	select SERIAL_CORE
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell PL010 UART.  If you have
@@ -38,7 +38,7 @@ config SERIAL_AMBA_PL010_CONSOLE
 
 config SERIAL_AMBA_PL011
 	tristate "ARM AMBA PL011 serial port support"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	select SERIAL_CORE
 	help
 	  This selects the ARM(R) AMBA(R) PrimeCell PL011 UART.  If you have
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index a290be5..b320462 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -314,7 +314,7 @@ config FB_PM2_FIFO_DISCONNECT
 
 config FB_ARMCLCD
 	tristate "ARM PrimeCell PL110 support"
-	depends on FB && ARM && ARM_AMBA
+	depends on FB && ARM && ARM_PRIMECELL
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 3709624..105030a 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -86,7 +86,7 @@ config WM8350_WATCHDOG
 
 config ARM_SP805_WATCHDOG
 	tristate "ARM SP805 Watchdog"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	help
 	  ARM Primecell SP805 Watchdog timer. This will reboot your system when
 	  the timeout is reached.
diff --git a/sound/arm/Kconfig b/sound/arm/Kconfig
index 885683a..ab7ada9 100644
--- a/sound/arm/Kconfig
+++ b/sound/arm/Kconfig
@@ -13,7 +13,7 @@ if SND_ARM
 
 config SND_ARMAACI
 	tristate "ARM PrimeCell PL041 AC Link support"
-	depends on ARM_AMBA
+	depends on ARM_PRIMECELL
 	select SND_PCM
 	select SND_AC97_CODEC
 
-- 
1.7.7.2
