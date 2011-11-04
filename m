Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab1KDXyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 19:54:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1KDXyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 19:54:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc cleanups for samsung
Date: Sat, 5 Nov 2011 00:54:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>, Kukjin Kim <kgene.kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201111050054.33975.arnd@arndb.de>
X-Provags-ID: V02:K0:YeJ7i4WxzhOsoxb9IYX+f22Y9IU6Bh7GLeVgCrg4D2R
 MWWyQo3vxaJbgaI14tV5Jxu7C/xjvobIrb2wIHffrgS978DVft
 tixWskf47V0OKKX8HWR7+2E5YBvp8gjm8H56gLd2xaXw512AUZ
 OyDZe00/qybRosHGrKoTocp6vaTeiK0LLRTWmDahpAeHLgE9YK
 oOE/i91xcw6b02IFoMDmNR8Hf6W9vg0kmGk93Y2Cw/0k8DzIF5
 +ErfwX9gBpRSpwdr2g5s0KkAyJKYzgOlv6XXtuRufd6/jr6tgP
 C7Q8DTniUSpbzi5Vm9uEwMpIC6WYdx6Qj6qh/22jmEB+GWvJA1
 4eUc4JHYZxl0WDJ7NUDM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is one of two (possibly three) requests for the remaining patches I
have queued up, almost all of them for the samsung soc platforms.
It's a bit messy because they are based on top of the dmaengine
tree from Vinod Koul at git://git.infradead.org/users/vkoul/slave-dma.git
that you have not pulled yet (Vinod said he sent a pull request for
this on monday).

Vinod and Kukjin agreed that it would be good if you pull the samsung
branches from me anyway, including the 52 patches from Vinod's tree.
There are another 13 patches in his tree now that were not used as
a base for the samsung patches.

The second pull request (will send right after this one) is for
development changes in the samsung platform based on these cleanups.

The third pull request (will send as soon as I get the latest version
from Kukjin) will rename mach-exynos4 to mach-exynos in preparation
for merging exynos5 support in the 3.3 merge window. It is intentionally
late in this window in order to avoid conflicts with other patch touching
the files that get renamed.

	Arnd

The following changes since commit 276fb249d228aebb86aa9662ce10b6d2ff408790:

  Merge branch 'depends/dma-slave' into tmp (2011-11-05 00:29:50 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/cleanup3

Abhilash Kesavan (3):
      ARM: S5P: Make the common S5P PM code conditionally compile
      ARM: S5P: Make the sleep code common for S5P series SoCs
      ARM: S5P64X0: Add Power Management support

Ajay Kumar (5):
      ARM: S5P64X0: Add register base and IRQ for Framebuffer
      ARM: S5P64X0: Set s3c_device_fb name
      ARM: S5P64X0: Add GPIO setup for LCD
      ARM: S5P6440: Add LCD-LTE480 and enable Framebuffer support
      ARM: S5P6450: Add LCD-LTE480 and enable Framebuffer support

Alim Akhtar (3):
      ARM: EXYNOS4: register the second instance of pl330 DMAC
      ARM: S5PV210: register the second instance of pl330 DMAC
      ARM: S5PC100: register the second instance of pl330 DMAC

Arnd Bergmann (2):
      Merge branch 'omap/cleanup' into next/cleanup2
      Merge branch 'depends/rmk/memory_h' into next/cleanup2

Boojin Kim (1):
      ARM: S5P64X0: Add the devname for DMA clock

Chanwoo Choi (1):
      ARM: EXYNOS4: Update config file of NURI to enable RTC

Giridhar Maruthy (1):
      ARM: EXYNOS4: Add PWM backlight support on ORIGEN

Hatim Ali (1):
      ARM: EXYNOS4: Add TVOUT support for SMDKV310

Heiko Stuebner (4):
      ARM: S3C2443: Move i2s clock definitions to common code
      ARM: S3C2443: Define constant for HSSPI pclk
      ARM: S3C2416: Add HSSPI clock sourced from EPLL
      ARM: S3C2443: Add hsspi-clock from pclk and rename S3C2443 hsspi sclk

Inderpal Singh (1):
      ARM: EXYNOS4: Configure MAX8997 PMIC for ORIGEN


8<-------
This is my conflict resolution:

diff --cc arch/arm/mach-exynos4/Kconfig
index dd660eb,a652735..0000000
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@@ -11,9 -11,8 +11,10 @@@ if ARCH_EXYNOS
  
  config CPU_EXYNOS4210
        bool
 -      select S3C_PL330_DMA
 +      select SAMSUNG_DMADEV
 +      select S5P_PM if PM
 +      select S5P_SLEEP if PM
+       select ARM_CPU_SUSPEND if PM
        help
          Enable EXYNOS4210 CPU support
  
diff --cc drivers/gpio/Makefile
index 62db458,19c5d27..0000000
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@@ -14,10 -14,14 +14,13 @@@ obj-$(CONFIG_GPIO_ADP5588) += gpio-adp5
  obj-$(CONFIG_GPIO_BT8XX)      += gpio-bt8xx.o
  obj-$(CONFIG_GPIO_CS5535)     += gpio-cs5535.o
  obj-$(CONFIG_GPIO_DA9052)     += gpio-da9052.o
+ obj-$(CONFIG_ARCH_DAVINCI)    += gpio-davinci.o
  obj-$(CONFIG_GPIO_EP93XX)     += gpio-ep93xx.o
 -obj-$(CONFIG_GPIO_EXYNOS4)    += gpio-exynos4.o
  obj-$(CONFIG_GPIO_IT8761E)    += gpio-it8761e.o
  obj-$(CONFIG_GPIO_JANZ_TTL)   += gpio-janz-ttl.o
+ obj-$(CONFIG_MACH_KS8695)     += gpio-ks8695.o
  obj-$(CONFIG_GPIO_LANGWELL)   += gpio-langwell.o
+ obj-$(CONFIG_ARCH_LPC32XX)    += gpio-lpc32xx.o
  obj-$(CONFIG_GPIO_MAX730X)    += gpio-max730x.o
  obj-$(CONFIG_GPIO_MAX7300)    += gpio-max7300.o
  obj-$(CONFIG_GPIO_MAX7301)    += gpio-max7301.o
@@@ -36,8 -40,13 +39,10 @@@ obj-$(CONFIG_GPIO_PCA953X)  += gpio-pca9
  obj-$(CONFIG_GPIO_PCF857X)    += gpio-pcf857x.o
  obj-$(CONFIG_GPIO_PCH)                += gpio-pch.o
  obj-$(CONFIG_GPIO_PL061)      += gpio-pl061.o
+ obj-$(CONFIG_PLAT_PXA)                += gpio-pxa.o
  obj-$(CONFIG_GPIO_RDC321X)    += gpio-rdc321x.o
 -
 -obj-$(CONFIG_GPIO_PLAT_SAMSUNG)       += gpio-plat-samsung.o
 -obj-$(CONFIG_GPIO_S5PC100)    += gpio-s5pc100.o
 -obj-$(CONFIG_GPIO_S5PV210)    += gpio-s5pv210.o
 +obj-$(CONFIG_PLAT_SAMSUNG)    += gpio-samsung.o
+ obj-$(CONFIG_ARCH_SA1100)     += gpio-sa1100.o
  obj-$(CONFIG_GPIO_SCH)                += gpio-sch.o
  obj-$(CONFIG_GPIO_STMPE)      += gpio-stmpe.o
  obj-$(CONFIG_GPIO_SX150X)     += gpio-sx150x.o

 arch/arm/Kconfig                                   |    5 +-
 arch/arm/mach-exynos4/Kconfig                      |   37 +
 arch/arm/mach-exynos4/Makefile                     |    2 +-
 arch/arm/mach-exynos4/clock.c                      |  204 ++-
 arch/arm/mach-exynos4/cpu.c                        |    2 +
 arch/arm/mach-exynos4/dma.c                        |    1 +
 arch/arm/mach-exynos4/include/mach/clkdev.h        |    7 -
 arch/arm/mach-exynos4/include/mach/irqs.h          |    4 +
 arch/arm/mach-exynos4/include/mach/map.h           |   12 +
 arch/arm/mach-exynos4/include/mach/pm-core.h       |    8 +-
 arch/arm/mach-exynos4/include/mach/pmu.h           |    7 +
 arch/arm/mach-exynos4/include/mach/pwm-clock.h     |   70 -
 arch/arm/mach-exynos4/include/mach/regs-pmu.h      |   74 +-
 arch/arm/mach-exynos4/mach-nuri.c                  |   34 +
 arch/arm/mach-exynos4/mach-origen.c                |  577 +++++-
 arch/arm/mach-exynos4/mach-smdkv310.c              |   49 +
 arch/arm/mach-exynos4/mach-universal_c210.c        |  307 +++-
 arch/arm/mach-exynos4/pm.c                         |    7 +
 arch/arm/mach-exynos4/pmu.c                        |  353 ++--
 arch/arm/mach-exynos4/setup-sdhci.c                |   47 -
 arch/arm/mach-exynos4/sleep.S                      |   54 -
 arch/arm/mach-s3c2410/Kconfig                      |    1 -
 arch/arm/mach-s3c2410/include/mach/fb.h            |   75 +-
 arch/arm/mach-s3c2410/include/mach/gpio-fns.h      |   99 +-
 arch/arm/mach-s3c2410/include/mach/gpio-track.h    |    6 +-
 arch/arm/mach-s3c2410/include/mach/irqs.h          |    4 +-
 arch/arm/mach-s3c2410/include/mach/map.h           |    1 +
 arch/arm/mach-s3c2410/include/mach/pm-core.h       |    2 +-
 .../mach-s3c2410/include/mach/regs-s3c2443-clock.h |    1 +
 arch/arm/mach-s3c2410/mach-h1940.c                 |    6 +-
 arch/arm/mach-s3c2410/mach-qt2410.c                |    1 +
 arch/arm/mach-s3c2410/s3c2410.c                    |    4 +-
 arch/arm/mach-s3c2412/gpio.c                       |   62 +
 arch/arm/mach-s3c2416/Kconfig                      |    1 -
 arch/arm/mach-s3c2416/clock.c                      |   29 +-
 arch/arm/mach-s3c2416/s3c2416.c                    |    4 +-
 arch/arm/mach-s3c2416/setup-sdhci.c                |   37 -
 arch/arm/mach-s3c2440/Kconfig                      |    2 -
 arch/arm/mach-s3c2440/mach-rx1950.c                |    1 +
 arch/arm/mach-s3c2440/s3c2440.c                    |    4 +-
 arch/arm/mach-s3c2440/s3c2442.c                    |    4 +-
 arch/arm/mach-s3c2443/Kconfig                      |    1 -
 arch/arm/mach-s3c2443/clock.c                      |   55 +-
 arch/arm/mach-s3c2443/s3c2443.c                    |    4 +-
 arch/arm/mach-s3c64xx/Kconfig                      |    1 +
 arch/arm/mach-s3c64xx/Makefile                     |    5 +-
 arch/arm/mach-s3c64xx/clock.c                      |   13 +-
 arch/arm/mach-s3c64xx/cpu.c                        |    4 +-
 arch/arm/mach-s3c64xx/dev-onenand1.c               |   53 -
 arch/arm/mach-s3c64xx/dma.c                        |    2 +-
 arch/arm/mach-s3c64xx/gpiolib.c                    |  290 ---
 arch/arm/mach-s3c64xx/include/mach/clkdev.h        |    7 -
 arch/arm/mach-s3c64xx/include/mach/crag6410.h      |   23 +
 arch/arm/mach-s3c64xx/include/mach/pll.h           |   45 -
 arch/arm/mach-s3c64xx/include/mach/pm-core.h       |    2 +-
 arch/arm/mach-s3c64xx/include/mach/pwm-clock.h     |   56 -
 arch/arm/mach-s3c64xx/include/mach/regs-sys.h      |    3 +
 arch/arm/mach-s3c64xx/include/mach/s3c6400.h       |   36 -
 arch/arm/mach-s3c64xx/include/mach/s3c6410.h       |   29 -
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |  182 ++
 arch/arm/mach-s3c64xx/mach-crag6410.c              |  108 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq5.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    2 +-
 arch/arm/mach-s3c64xx/pm.c                         |    4 +
 arch/arm/mach-s3c64xx/s3c6400.c                    |    2 +-
 arch/arm/mach-s3c64xx/s3c6410.c                    |    4 +-
 arch/arm/mach-s3c64xx/setup-sdhci.c                |   48 -
 arch/arm/mach-s5p64x0/Kconfig                      |   14 +
 arch/arm/mach-s5p64x0/Makefile                     |    4 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |    1 +
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |    1 +
 arch/arm/mach-s5p64x0/cpu.c                        |    3 +
 arch/arm/mach-s5p64x0/include/mach/clkdev.h        |    7 -
 arch/arm/mach-s5p64x0/include/mach/irqs.h          |    4 +
 arch/arm/mach-s5p64x0/include/mach/map.h           |    4 +
 arch/arm/mach-s5p64x0/include/mach/pm-core.h       |  117 +
 arch/arm/mach-s5p64x0/include/mach/pwm-clock.h     |   68 -
 arch/arm/mach-s5p64x0/include/mach/regs-clock.h    |   33 +
 arch/arm/mach-s5p64x0/include/mach/regs-gpio.h     |   21 +
 arch/arm/mach-s5p64x0/irq-eint.c                   |    2 +
 arch/arm/mach-s5p64x0/irq-pm.c                     |   92 +
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   74 +
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   75 +
 arch/arm/mach-s5p64x0/pm.c                         |  204 ++
 arch/arm/mach-s5p64x0/setup-fb-24bpp.c             |   29 +
 arch/arm/mach-s5pc100/clock.c                      |    4 +-
 arch/arm/mach-s5pc100/dma.c                        |    1 +
 arch/arm/mach-s5pc100/include/mach/clkdev.h        |    7 -
 arch/arm/mach-s5pc100/include/mach/pwm-clock.h     |   56 -
 arch/arm/mach-s5pc100/setup-sdhci.c                |   42 -
 arch/arm/mach-s5pv210/Kconfig                      |    4 +
 arch/arm/mach-s5pv210/Makefile                     |    2 +-
 arch/arm/mach-s5pv210/clock.c                      |  141 +-
 arch/arm/mach-s5pv210/cpu.c                        |    4 +
 arch/arm/mach-s5pv210/dma.c                        |    1 +
 arch/arm/mach-s5pv210/include/mach/clkdev.h        |    7 -
 arch/arm/mach-s5pv210/include/mach/irqs.h          |    4 +-
 arch/arm/mach-s5pv210/include/mach/map.h           |   13 +
 arch/arm/mach-s5pv210/include/mach/pm-core.h       |    2 +-
 arch/arm/mach-s5pv210/include/mach/pwm-clock.h     |   70 -
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |    3 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |   57 +
 arch/arm/mach-s5pv210/setup-sdhci.c                |   41 -
 arch/arm/mach-s5pv210/sleep.S                      |   52 -
 arch/arm/plat-s3c24xx/Kconfig                      |    1 -
 arch/arm/plat-s3c24xx/Makefile                     |    4 +-
 arch/arm/plat-s3c24xx/dev-uart.c                   |  100 +
 arch/arm/plat-s3c24xx/devs.c                       |  528 ----
 arch/arm/plat-s3c24xx/gpio.c                       |   96 -
 arch/arm/plat-s3c24xx/gpiolib.c                    |  229 --
 arch/arm/plat-s3c24xx/include/mach/clkdev.h        |    7 -
 arch/arm/plat-s3c24xx/include/mach/pwm-clock.h     |   55 -
 arch/arm/plat-s3c24xx/include/plat/audio-simtec.h  |   37 -
 arch/arm/plat-s3c24xx/include/plat/common-smdk.h   |   15 -
 arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h |  287 ---
 arch/arm/plat-s3c24xx/include/plat/fiq.h           |   13 -
 arch/arm/plat-s3c24xx/include/plat/irq.h           |  115 -
 arch/arm/plat-s3c24xx/include/plat/mci.h           |   52 -
 arch/arm/plat-s3c24xx/include/plat/pll.h           |   62 -
 arch/arm/plat-s3c24xx/include/plat/regs-dma.h      |  145 --
 arch/arm/plat-s3c24xx/include/plat/regs-iis.h      |   68 -
 arch/arm/plat-s3c24xx/include/plat/regs-spi.h      |   81 -
 arch/arm/plat-s3c24xx/include/plat/regs-udc.h      |  153 --
 arch/arm/plat-s3c24xx/include/plat/s3c2410.h       |   33 -
 arch/arm/plat-s3c24xx/include/plat/s3c2412.h       |   29 -
 arch/arm/plat-s3c24xx/include/plat/s3c2416.h       |   31 -
 arch/arm/plat-s3c24xx/include/plat/s3c2443.h       |   51 -
 arch/arm/plat-s3c24xx/include/plat/s3c244x.h       |   42 -
 arch/arm/plat-s3c24xx/include/plat/udc.h           |   57 -
 arch/arm/plat-s3c24xx/s3c2443-clock.c              |   57 +
 arch/arm/plat-s5p/Kconfig                          |   25 +-
 arch/arm/plat-s5p/Makefile                         |   14 +-
 arch/arm/plat-s5p/dev-csis0.c                      |   34 -
 arch/arm/plat-s5p/dev-csis1.c                      |   34 -
 arch/arm/plat-s5p/dev-ehci.c                       |   57 -
 arch/arm/plat-s5p/dev-fimc0.c                      |   43 -
 arch/arm/plat-s5p/dev-fimc1.c                      |   43 -
 arch/arm/plat-s5p/dev-fimc2.c                      |   43 -
 arch/arm/plat-s5p/dev-fimc3.c                      |   43 -
 arch/arm/plat-s5p/dev-fimd0.c                      |   67 -
 arch/arm/plat-s5p/dev-mfc.c                        |   50 -
 arch/arm/plat-s5p/dev-onenand.c                    |   45 -
 arch/arm/plat-s5p/dev-pmu.c                        |   36 -
 arch/arm/plat-s5p/include/plat/camport.h           |   28 -
 arch/arm/plat-s5p/include/plat/ehci.h              |   21 -
 arch/arm/plat-s5p/include/plat/exynos4.h           |   35 -
 arch/arm/plat-s5p/include/plat/irqs.h              |   80 -
 arch/arm/plat-s5p/include/plat/mfc.h               |   27 -
 arch/arm/plat-s5p/include/plat/mipi_csis.h         |   43 -
 arch/arm/plat-s5p/include/plat/pll.h               |  203 --
 arch/arm/plat-s5p/include/plat/regs-srom.h         |   54 -
 arch/arm/plat-s5p/include/plat/reset.h             |   16 -
 arch/arm/plat-s5p/include/plat/s5p-clock.h         |   55 -
 arch/arm/plat-s5p/include/plat/s5p-time.h          |   40 -
 arch/arm/plat-s5p/include/plat/s5p6440.h           |   36 -
 arch/arm/plat-s5p/include/plat/s5p6450.h           |   36 -
 arch/arm/plat-s5p/include/plat/s5pc100.h           |   33 -
 arch/arm/plat-s5p/include/plat/s5pv210.h           |   33 -
 arch/arm/plat-s5p/include/plat/sysmmu.h            |   95 -
 arch/arm/plat-s5p/include/plat/system-reset.h      |   31 -
 arch/arm/plat-s5p/include/plat/usb-phy.h           |   22 -
 arch/arm/plat-s5p/irq-gpioint.c                    |   10 +-
 arch/arm/plat-s5p/sleep.S                          |   49 +
 arch/arm/plat-samsung/Kconfig                      |   27 -
 arch/arm/plat-samsung/Makefile                     |   33 +-
 arch/arm/plat-samsung/dev-adc.c                    |   46 -
 arch/arm/plat-samsung/dev-asocdma.c                |   35 -
 arch/arm/plat-samsung/dev-fb.c                     |   63 -
 arch/arm/plat-samsung/dev-hsmmc.c                  |   62 -
 arch/arm/plat-samsung/dev-hsmmc1.c                 |   62 -
 arch/arm/plat-samsung/dev-hsmmc2.c                 |   63 -
 arch/arm/plat-samsung/dev-hsmmc3.c                 |   66 -
 arch/arm/plat-samsung/dev-hwmon.c                  |   32 -
 arch/arm/plat-samsung/dev-i2c0.c                   |   70 -
 arch/arm/plat-samsung/dev-i2c1.c                   |   61 -
 arch/arm/plat-samsung/dev-i2c2.c                   |   62 -
 arch/arm/plat-samsung/dev-i2c3.c                   |   60 -
 arch/arm/plat-samsung/dev-i2c4.c                   |   60 -
 arch/arm/plat-samsung/dev-i2c5.c                   |   60 -
 arch/arm/plat-samsung/dev-i2c6.c                   |   60 -
 arch/arm/plat-samsung/dev-i2c7.c                   |   60 -
 arch/arm/plat-samsung/dev-ide.c                    |   44 -
 arch/arm/plat-samsung/dev-keypad.c                 |   50 -
 arch/arm/plat-samsung/dev-nand.c                   |  125 -
 arch/arm/plat-samsung/dev-onenand.c                |   43 -
 arch/arm/plat-samsung/dev-pwm.c                    |   53 -
 arch/arm/plat-samsung/dev-rtc.c                    |   43 -
 arch/arm/plat-samsung/dev-ts.c                     |   59 -
 arch/arm/plat-samsung/dev-usb-hsotg.c              |   48 -
 arch/arm/plat-samsung/dev-usb.c                    |   65 -
 arch/arm/plat-samsung/dev-wdt.c                    |   40 -
 arch/arm/plat-samsung/devs.c                       | 1463 +++++++++++
 arch/arm/plat-samsung/gpio-config.c                |  431 ----
 arch/arm/plat-samsung/gpio.c                       |  167 --
 arch/arm/plat-samsung/include/plat/audio-simtec.h  |   37 +
 arch/arm/plat-samsung/include/plat/camport.h       |   28 +
 arch/arm/plat-samsung/include/plat/common-smdk.h   |   15 +
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |  288 +++
 arch/arm/plat-samsung/include/plat/devs.h          |  151 +-
 arch/arm/plat-samsung/include/plat/ehci.h          |   21 +
 arch/arm/plat-samsung/include/plat/exynos4.h       |   35 +
 arch/arm/plat-samsung/include/plat/fb-s3c2410.h    |   72 +
 arch/arm/plat-samsung/include/plat/fb.h            |    7 +
 arch/arm/plat-samsung/include/plat/fiq.h           |   13 +
 .../plat-samsung/include/plat/gpio-cfg-helpers.h   |  172 +-
 arch/arm/plat-samsung/include/plat/gpio-cfg.h      |   34 +-
 arch/arm/plat-samsung/include/plat/gpio-core.h     |   97 +-
 arch/arm/plat-samsung/include/plat/gpio-fns.h      |   98 +
 arch/arm/plat-samsung/include/plat/iic.h           |    1 +
 arch/arm/plat-samsung/include/plat/irq.h           |  116 +
 arch/arm/plat-samsung/include/plat/irqs.h          |   80 +
 arch/arm/plat-samsung/include/plat/mci.h           |   52 +
 arch/arm/plat-samsung/include/plat/mfc.h           |   27 +
 arch/arm/plat-samsung/include/plat/mipi_csis.h     |   43 +
 arch/arm/plat-samsung/include/plat/pll.h           |  323 +++
 arch/arm/plat-samsung/include/plat/pll6553x.h      |   51 -
 arch/arm/plat-samsung/include/plat/pm.h            |   10 +-
 arch/arm/plat-samsung/include/plat/pwm-clock.h     |   81 +
 arch/arm/plat-samsung/include/plat/regs-dma.h      |  151 ++
 arch/arm/plat-samsung/include/plat/regs-iis.h      |   70 +
 arch/arm/plat-samsung/include/plat/regs-spi.h      |   48 +
 arch/arm/plat-samsung/include/plat/regs-srom.h     |   54 +
 arch/arm/plat-samsung/include/plat/regs-udc.h      |  151 ++
 arch/arm/plat-samsung/include/plat/reset.h         |   16 +
 arch/arm/plat-samsung/include/plat/s3c2410.h       |   33 +
 arch/arm/plat-samsung/include/plat/s3c2412.h       |   29 +
 arch/arm/plat-samsung/include/plat/s3c2416.h       |   31 +
 arch/arm/plat-samsung/include/plat/s3c2443.h       |   51 +
 arch/arm/plat-samsung/include/plat/s3c244x.h       |   42 +
 arch/arm/plat-samsung/include/plat/s3c6400.h       |   36 +
 arch/arm/plat-samsung/include/plat/s3c6410.h       |   29 +
 arch/arm/plat-samsung/include/plat/s5p-clock.h     |   55 +
 arch/arm/plat-samsung/include/plat/s5p-time.h      |   40 +
 arch/arm/plat-samsung/include/plat/s5p6440.h       |   36 +
 arch/arm/plat-samsung/include/plat/s5p6450.h       |   36 +
 arch/arm/plat-samsung/include/plat/s5pc100.h       |   33 +
 arch/arm/plat-samsung/include/plat/s5pv210.h       |   33 +
 arch/arm/plat-samsung/include/plat/sdhci.h         |   57 -
 arch/arm/plat-samsung/include/plat/sysmmu.h        |   95 +
 arch/arm/plat-samsung/include/plat/system-reset.h  |   31 +
 arch/arm/plat-samsung/include/plat/tv-core.h       |   44 +
 arch/arm/plat-samsung/include/plat/udc.h           |   57 +
 arch/arm/plat-samsung/include/plat/usb-phy.h       |   22 +
 arch/arm/plat-samsung/platformdata.c               |    2 -
 arch/arm/plat-samsung/pm-gpio.c                    |   72 +-
 arch/arm/plat-samsung/pm.c                         |    6 +-
 arch/arm/plat-samsung/pwm-clock.c                  |   13 +-
 drivers/gpio/Kconfig                               |   16 -
 drivers/gpio/Makefile                              |    6 +-
 drivers/gpio/gpio-exynos4.c                        |  385 ---
 drivers/gpio/gpio-plat-samsung.c                   |  205 --
 drivers/gpio/gpio-s5pc100.c                        |  354 ---
 drivers/gpio/gpio-s5pv210.c                        |  287 ---
 drivers/gpio/gpio-samsung.c                        | 2688 ++++++++++++++++++++
 sound/soc/samsung/dma.c                            |    2 +-
 262 files changed, 9942 insertions(+), 9132 deletions(-)

8<---------

These are the changes from the dma-slave tree that are also included:

The following changes since commit 1a67a573b8d9f02211f36fbab50f6265dc49384a:

  Merge git://git.samba.org/sfrench/cifs-2.6 (2011-11-03 21:07:58 -0700)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git depends/dma-slave/do/not/pull

Boojin Kim (16):
      DMA: PL330: Add support runtime PM for PL330 DMAC
      DMA: PL330: Update PL330 DMA API driver
      DMA: PL330: Support DMA_SLAVE_CONFIG command
      DMA: PL330: Remove the start operation for handling DMA_TERMINATE_ALL command
      DMA: PL330: Add DMA_CYCLIC capability
      ARM: SAMSUNG: Update to use PL330-DMA driver
      ARM: SAMSUNG: Add common DMA operations
      ARM: EXYNOS4: Use generic DMA PL330 driver
      ARM: S5PV210: Use generic DMA PL330 driver
      ARM: S5PC100: Use generic DMA PL330 driver
      ARM: S5P64X0: Use generic DMA PL330 driver
      ARM: SAMSUNG: Remove S3C-PL330-DMA driver
      spi/s3c64xx: Add support DMA engine API
      spi/s3c64xx: Merge dma control code
      ASoC: Samsung: Update DMA interface
      ARM: SAMSUNG: Remove Samsung specific enum type for dma direction

Guennadi Liakhovetski (1):
      dmatest: make dmatest threads freezable

Lothar Waßmann (1):
      mxs-dma: enable CLKGATE before accessing registers

Nicolas Ferre (4):
      dmaengine: at_hdmac: replace spin_lock* with irqsave variants
      dmaengine: at_hdmac: improve power management routines
      dmaengine: at_hdmac: add wrappers for testing channel state
      dmaengine: at_hdmac: fix way to specify cyclic capability

Per Forlin (4):
      dmaengine/ste_dma40: add missing kernel doc for pending_queue
      dmaengine/ste_dma40: remove duplicate call to d40_pool_lli_free().
      dmaengine/ste_dma40: fix Oops due to double free of client descriptor
      dmaengine/ste_dma40: fix memory leak due to prepared descriptors

Russell King - ARM Linux (1):
      dmaengine: amba-pl08x: make filter check that the channel is owned by pl08x

Sascha Hauer (3):
      dmaengine i.MX SDMA: lock channel 0
      dmaengine i.MX SDMA: set firmware scripts addresses to negative value initially
      dmaengine i.MX SDMA: use request_firmware_nowait

Vinod Koul (3):
      dmaengine: add helper function for slave_single
      dmaengine: remove struct scatterlist for header
      Merge branch 'next' into v3.1-rc4

Viresh Kumar (19):
      dmaengine/dmatest: Terminate transfers on all channels in case of error or exit
      ARM: asm/pl080.h: Protect against multiple inclusion of header file
      dmaengine/amba-pl08x: Resolve formatting issues
      dmaengine/amba-pl08x: Rearrange inclusion of header files in ascending order
      dmaengine/amba-pl08x: pass (*ptr) to sizeof() instead of (struct xyz)
      dmaengine/amba-pl08x: Complete doc comment for struct pl08x_txd
      dmaengine/amba-pl08x: Remove redundant comment and rewrite original
      dmaengine/amba-pl08x: Changing few prints to dev_dbg from dev_info
      dmaengine/amba-pl08x: support runtime PM
      dmaengine/amba-pl08x: Simplify pl08x_ensure_on()
      dmaengine/amba-pl08x: No need to check "ch->signal < 0"
      dmaengine/amba-pl08x: Schedule tasklet in case of error interrupt
      dmaengine/amba-pl08x: Get rid of pl08x_pre_boundary()
      dmaengine/amba-pl08x: max_bytes_per_lli is TRANSFER_SIZE * src_width (not MIN(width))
      dmaengine/amba-pl08x: Add prep_single_byte_llis() routine
      dmaengine/amba-pl08x: Align lli_len to max(src.width, dst.width)
      dmaengine/amba-pl08x: Choose peripheral bus as master bus
      dmaengine/amba-pl08x: Pass flow controller information with slave channel data
      dmaengine/amba-pl08x: Call pl08x_free_txd() instead of calling kfree() directly

 arch/arm/include/asm/hardware/pl080.h              |    4 +
 arch/arm/mach-exynos4/Kconfig                      |    2 +-
 arch/arm/mach-exynos4/clock.c                      |   11 +-
 arch/arm/mach-exynos4/dma.c                        |  299 +++--
 arch/arm/mach-exynos4/include/mach/dma.h           |    4 +-
 arch/arm/mach-s3c2410/include/mach/dma.h           |   20 +-
 arch/arm/mach-s3c2412/dma.c                        |    4 +-
 arch/arm/mach-s3c64xx/dma.c                        |   10 +-
 arch/arm/mach-s3c64xx/include/mach/dma.h           |    8 +-
 arch/arm/mach-s5p64x0/Kconfig                      |    4 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |    9 +-
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |    9 +-
 arch/arm/mach-s5p64x0/dma.c                        |  273 +++--
 arch/arm/mach-s5p64x0/include/mach/dma.h           |    4 +-
 arch/arm/mach-s5pc100/Kconfig                      |    2 +-
 arch/arm/mach-s5pc100/clock.c                      |   11 +-
 arch/arm/mach-s5pc100/dma.c                        |  323 ++++--
 arch/arm/mach-s5pc100/include/mach/dma.h           |    4 +-
 arch/arm/mach-s5pv210/Kconfig                      |    2 +-
 arch/arm/mach-s5pv210/clock.c                      |   10 +-
 arch/arm/mach-s5pv210/dma.c                        |  316 ++++--
 arch/arm/mach-s5pv210/include/mach/dma.h           |    4 +-
 arch/arm/plat-s3c24xx/dma.c                        |   10 +-
 arch/arm/plat-samsung/Kconfig                      |    9 +-
 arch/arm/plat-samsung/Makefile                     |    4 +-
 arch/arm/plat-samsung/dma-ops.c                    |  131 ++
 arch/arm/plat-samsung/include/plat/dma-ops.h       |   63 +
 .../include/plat/{s3c-dma-pl330.h => dma-pl330.h}  |   24 +-
 arch/arm/plat-samsung/include/plat/dma-s3c24xx.h   |    2 +-
 arch/arm/plat-samsung/include/plat/dma.h           |   10 +-
 .../plat-samsung/include/plat/s3c-pl330-pdata.h    |   32 -
 arch/arm/plat-samsung/s3c-dma-ops.c                |  130 ++
 arch/arm/plat-samsung/s3c-pl330.c                  | 1244 --------------------
 drivers/dma/Kconfig                                |    3 +-
 drivers/dma/amba-pl08x.c                           |  455 +++----
 drivers/dma/at_hdmac.c                             |  159 ++-
 drivers/dma/at_hdmac_regs.h                        |   24 +
 drivers/dma/dmatest.c                              |   23 +-
 drivers/dma/imx-sdma.c                             |   47 +-
 drivers/dma/mxs-dma.c                              |   45 +-
 drivers/dma/pl330.c                                |  229 ++++-
 drivers/dma/ste_dma40.c                            |   42 +-
 drivers/mmc/host/s3cmci.c                          |    6 +-
 drivers/spi/spi-s3c64xx.c                          |  175 ++--
 include/linux/amba/pl08x.h                         |   14 +-
 include/linux/amba/pl330.h                         |    6 +-
 include/linux/dmaengine.h                          |   13 +-
 sound/soc/samsung/ac97.c                           |   10 +-
 sound/soc/samsung/dma.c                            |  146 +--
 sound/soc/samsung/dma.h                            |    4 +-
 50 files changed, 2084 insertions(+), 2309 deletions(-)
 create mode 100644 arch/arm/plat-samsung/dma-ops.c
 create mode 100644 arch/arm/plat-samsung/include/plat/dma-ops.h
 rename arch/arm/plat-samsung/include/plat/{s3c-dma-pl330.h => dma-pl330.h} (84%)
 delete mode 100644 arch/arm/plat-samsung/include/plat/s3c-pl330-pdata.h
 create mode 100644 arch/arm/plat-samsung/s3c-dma-ops.c
 delete mode 100644 arch/arm/plat-samsung/s3c-pl330.c

