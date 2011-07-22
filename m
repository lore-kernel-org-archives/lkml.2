Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1GVPye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:54:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36542 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab1GVPyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:54:33 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 22 Jul 2011 09:54:10 -0600
X-Google-Sender-Auth: juYmUNG-UHDr1B57eGB-dXtMH3o
Message-ID: <CACxGe6t=KvJ3P+5D_SapWr8JT3McxEdN0VuRXdq=G-oH-E4F8w@mail.gmail.com>
Subject: [GIT PULL] gpio changes for v3.1
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Lots of changes here which crosses maintainer boundaries and looks a
lot bigger than it actually is due to file renames.  Biggest change is
due to gpio drivers moving from arch/arm/* into drivers/gpio, and
reorganizing the filenames in the drivers/gpio directory.  A lot of
bug fixes and consolidation changes here too.  The commits that touch
arch/arm code have been acked by their respective maintainers and this
branch has been in linux-next for quite some time so there shouldn't
be any worrysome merge conflicts.

g.

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 gpio/next

Axel Lin (2):
      gpio/ml-ioh: fix off-by-one for displaying variable i in dev_err
      gpio/da9052: remove a redundant assignment for gpio->da9052

Charulatha V (1):
      gpio/omap: remove get_gpio_bank()

David Jander (7):
      gpio/pca953x.c: Interrupt pin is active-low
      gpio/pca953x: Fix IRQ support.
      gpio/pca953x: Interrupt pin is active-low
      gpio/pca953x: Fix warning of enabled interrupts in handler
      gpio/pca953x: Fix IRQ support.
      gpio/pca953x: Remove dynamic platform data pointer
      gpio/pca953x: Deprecate meaningless device-tree bindings

Grant Likely (10):
      gpio/mxs: Move Freescale mxs gpio driver to drivers/gpio
      Merge branch 'gpio/next-mx' into gpio/next
      gpio: reorganize drivers
      gpio/ep93xx: Remove superfluous debug pr_info statement
      gpio/tegra: Move Tegra gpio driver to drivers/gpio
      gpio/tegra: add devicetree support
      Merge branch 'gpio/next-tegra' into gpio/next
      Merge branch 'for_3.1/gpio-cleanup' of
git://git.kernel.org/.../khilman/linux-omap-pm into gpio/next
      gpio/dt: Refine GPIO device tree binding
      gpio: Move mpc5200 gpio driver to drivers/gpio

H Hartley Sweeten (6):
      gpio/74x164: remove unnecessary defines and prototype
      gpio/samsung: make Kconfig options def_bool
      gpio/ep93xx: move driver to drivers/gpio
      gpio/ep93xx: fix pr_fmt output
      gpio/ep93xx: convert to platform_driver and use basic_mmio_gpio library
      gpio/ep93xx: Add missing EP93XX_GPIO_PHYS_BASE define

Joe Perches (1):
      gpio/vr41xx: Convert use of struct resource to resource_size(ptr)

John Bonesio (1):
      of/gpio: Add new method for getting gpios under different property names

Kevin Hilman (13):
      gpio/omap: _clear_gpio_irqbank: fix flushing of posted write
      gpio/omap: remove MPUIO handling from _clear_gpio_irqbank()
      gpio/omap: move bank width into struct gpio_bank
      gpio/omap: _get_gpio_irqbank_mask: replace hard-coded mask with
bank->width
      gpio/omap: replace get_gpio_index() by using bank width
      gpio/omap: consolidate direction, input, output, remove #ifdefs
      gpio/omap: consolidate IRQ status handling, remove #ifdefs
      gpio/omap: conslidate enable/disable of GPIO IRQs, remove ifdefs
      gpio/omap: convert MPUIO IRQ over to generic irq_chip
      gpio/omap: remove useless gpio_valid() & check_gpio() checks
      gpio/omap: cleanup _set_gpio_wakeup(), remove ifdefs
      gpio/omap: debounce remove SoC specific registers, use pdata
      gpio/omap: cleanup show revision, remove cpu_is checks, display only once

Linus Walleij (1):
      gpio/74x164: fix clash with gpiolib namespace

Lothar Waßmann (1):
      gpio/mxc: add missing initialization of basic_mmio_gpio shadow variables

Olof Johansson (1):
      gpio/tegra: dt: add binding for gpio polarity

Peter Korsgaard (4):
      mcp23s08: remove unused work queue
      mcp23s08: get rid of setup/teardown callbacks
      mcp23s08: isolate spi specific parts
      mcp23s08: add i2c support

Shawn Guo (14):
      leds: remove config option LEDS_GPIO_PLATFORM from Kconfig
      gpio/mxs: Change gpio-mxs into an upstanding gpio driver
      gpio/mxc: Move Freescale MXC gpio driver to drivers/gpio
      gpio/mxc: Change gpio-mxc into an upstanding gpio driver
      gpio/mxc: convert gpio-mxc to use basic_mmio_gpio library
      gpio/mxc: convert gpio-mxc to use generic irq chip
      gpio/mxs: convert gpio-mxs to use basic_mmio_gpio library
      gpio/mxs: remove irq_high related implementation
      gpio/mxs: convert gpio-mxs to use generic irq chip
      gpio/mxc: fix a bug with gpio_get_value calling
      gpio/mxc: get rid of the uses of cpu_is_mx()
      ARM: mxc: use ARCH_NR_GPIOS to define gpio number
      gpio/mxc: add device tree probe support
      gpio/mxc/mxs: fix build error introduced by the irq_gc_ack() renaming

Stephen Warren (1):
      gpio/tegra: Use engineering names in DT compatible property

ashishj3 (1):
      GPIO: DA9052 GPIO module v3

 .../devicetree/bindings/gpio/fsl-imx-gpio.txt      |   22 +
 Documentation/devicetree/bindings/gpio/gpio.txt    |   46 +-
 .../devicetree/bindings/gpio/gpio_nvidia.txt       |    8 +
 arch/arm/mach-ep93xx/Makefile                      |    2 +-
 arch/arm/mach-ep93xx/core.c                        |   27 +-
 arch/arm/mach-ep93xx/include/mach/ep93xx-regs.h    |    1 +
 arch/arm/mach-imx/mach-apf9328.c                   |    2 +
 arch/arm/mach-imx/mach-armadillo5x0.c              |    2 +
 arch/arm/mach-imx/mach-bug.c                       |    2 +
 arch/arm/mach-imx/mach-cpuimx27.c                  |    2 +
 arch/arm/mach-imx/mach-cpuimx35.c                  |    2 +
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |    2 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    2 +
 arch/arm/mach-imx/mach-imx27ipcam.c                |    2 +
 arch/arm/mach-imx/mach-imx27lite.c                 |    2 +
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    2 +
 arch/arm/mach-imx/mach-mx1ads.c                    |    2 +
 arch/arm/mach-imx/mach-mx21ads.c                   |    2 +
 arch/arm/mach-imx/mach-mx25_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-mx27_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-mx27ads.c                   |    2 +
 arch/arm/mach-imx/mach-mx31_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-mx31ads.c                   |    2 +
 arch/arm/mach-imx/mach-mx31lilly.c                 |    2 +
 arch/arm/mach-imx/mach-mx31lite.c                  |    2 +
 arch/arm/mach-imx/mach-mx31moboard.c               |    2 +
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-mxt_td60.c                  |    2 +
 arch/arm/mach-imx/mach-pca100.c                    |    2 +
 arch/arm/mach-imx/mach-pcm037.c                    |    2 +
 arch/arm/mach-imx/mach-pcm038.c                    |    2 +
 arch/arm/mach-imx/mach-pcm043.c                    |    2 +
 arch/arm/mach-imx/mach-qong.c                      |    2 +
 arch/arm/mach-imx/mach-scb9328.c                   |    2 +
 arch/arm/mach-imx/mach-vpr200.c                    |    2 +
 arch/arm/mach-imx/mm-imx1.c                        |   21 +-
 arch/arm/mach-imx/mm-imx21.c                       |   21 +-
 arch/arm/mach-imx/mm-imx25.c                       |   17 +-
 arch/arm/mach-imx/mm-imx27.c                       |   22 +-
 arch/arm/mach-imx/mm-imx31.c                       |   15 +-
 arch/arm/mach-imx/mm-imx35.c                       |   16 +-
 arch/arm/mach-mx5/board-cpuimx51.c                 |    2 +
 arch/arm/mach-mx5/board-cpuimx51sd.c               |    2 +
 arch/arm/mach-mx5/board-mx50_rdp.c                 |    2 +
 arch/arm/mach-mx5/board-mx51_3ds.c                 |    2 +
 arch/arm/mach-mx5/board-mx51_babbage.c             |    2 +
 arch/arm/mach-mx5/board-mx51_efikamx.c             |    2 +
 arch/arm/mach-mx5/board-mx51_efikasb.c             |    2 +
 arch/arm/mach-mx5/board-mx53_evk.c                 |    2 +
 arch/arm/mach-mx5/board-mx53_loco.c                |    2 +
 arch/arm/mach-mx5/board-mx53_smd.c                 |    2 +
 arch/arm/mach-mx5/devices.c                        |   64 --
 arch/arm/mach-mx5/mm-mx50.c                        |   22 +-
 arch/arm/mach-mx5/mm.c                             |   27 +-
 arch/arm/mach-mxs/Makefile                         |    2 +-
 arch/arm/mach-mxs/devices.c                        |   11 +
 arch/arm/mach-mxs/devices/Makefile                 |    1 +
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c      |   53 ++
 arch/arm/mach-mxs/gpio.c                           |  331 ---------
 arch/arm/mach-mxs/gpio.h                           |   34 -
 arch/arm/mach-mxs/include/mach/devices-common.h    |    2 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |    1 -
 arch/arm/mach-mxs/mm-mx23.c                        |    1 -
 arch/arm/mach-mxs/mm-mx28.c                        |    1 -
 arch/arm/mach-omap1/gpio15xx.c                     |   22 +
 arch/arm/mach-omap1/gpio16xx.c                     |   28 +
 arch/arm/mach-omap1/gpio7xx.c                      |   27 +
 arch/arm/mach-omap2/gpio.c                         |   32 +
 arch/arm/mach-tegra/Makefile                       |    1 -
 arch/arm/plat-mxc/Makefile                         |    2 +-
 arch/arm/plat-mxc/devices.c                        |   11 +
 arch/arm/plat-mxc/devices/Makefile                 |    1 +
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |   32 +
 arch/arm/plat-mxc/gpio.c                           |  361 ----------
 arch/arm/plat-mxc/include/mach/common.h            |   12 +-
 arch/arm/plat-mxc/include/mach/devices-common.h    |    2 +
 arch/arm/plat-mxc/include/mach/gpio.h              |   27 -
 arch/arm/plat-mxc/include/mach/irqs.h              |   21 +-
 arch/arm/plat-omap/include/plat/gpio.h             |   20 +
 arch/powerpc/platforms/52xx/Kconfig                |    8 -
 arch/powerpc/platforms/52xx/Makefile               |    1 -
 drivers/gpio/Kconfig                               |   66 ++-
 drivers/gpio/Makefile                              |   87 ++--
 drivers/gpio/{74x164.c => gpio-74x164.c}           |   33 +-
 drivers/gpio/{ab8500-gpio.c => gpio-ab8500.c}      |    0
 drivers/gpio/{adp5520-gpio.c => gpio-adp5520.c}    |    0
 drivers/gpio/{adp5588-gpio.c => gpio-adp5588.c}    |    0
 drivers/gpio/{bt8xxgpio.c => gpio-bt8xx.c}         |    0
 drivers/gpio/{cs5535-gpio.c => gpio-cs5535.c}      |    0
 drivers/gpio/gpio-da9052.c                         |  277 ++++++++
 .../gpio.c => drivers/gpio/gpio-ep93xx.c           |  243 ++++----
 drivers/gpio/gpio-exynos4.c                        |    5 +-
 drivers/gpio/{basic_mmio_gpio.c => gpio-generic.c} |    6 +-
 drivers/gpio/{it8761e_gpio.c => gpio-it8761e.c}    |    2 +-
 drivers/gpio/{janz-ttl.c => gpio-janz-ttl.c}       |    0
 drivers/gpio/{langwell_gpio.c => gpio-langwell.c}  |    4 +-
 drivers/gpio/{max7300.c => gpio-max7300.c}         |    2 -
 drivers/gpio/{max7301.c => gpio-max7301.c}         |    2 -
 drivers/gpio/{max730x.c => gpio-max730x.c}         |    2 -
 drivers/gpio/{max732x.c => gpio-max732x.c}         |    2 +-
 drivers/gpio/{mc33880.c => gpio-mc33880.c}         |    2 +-
 drivers/gpio/{mcp23s08.c => gpio-mcp23s08.c}       |  291 +++++++--
 drivers/gpio/{ml_ioh_gpio.c => gpio-ml-ioh.c}      |    2 +-
 .../mpc52xx_gpio.c => drivers/gpio/gpio-mpc5200.c  |   12 +-
 drivers/gpio/gpio-mxc.c                            |  460 +++++++++++++
 drivers/gpio/gpio-mxs.c                            |  289 ++++++++
 drivers/gpio/gpio-omap.c                           |  723 +++++---------------
 drivers/gpio/{pca953x.c => gpio-pca953x.c}         |  105 ++--
 drivers/gpio/{pcf857x.c => gpio-pcf857x.c}         |    2 +-
 drivers/gpio/{pch_gpio.c => gpio-pch.c}            |    0
 drivers/gpio/{pl061.c => gpio-pl061.c}             |    4 +-
 drivers/gpio/gpio-plat-samsung.c                   |    3 +-
 drivers/gpio/{rdc321x-gpio.c => gpio-rdc321x.c}    |    0
 drivers/gpio/gpio-s5pc100.c                        |    5 +-
 drivers/gpio/gpio-s5pv210.c                        |    5 +-
 drivers/gpio/{sch_gpio.c => gpio-sch.c}            |    2 +-
 drivers/gpio/{stmpe-gpio.c => gpio-stmpe.c}        |    0
 drivers/gpio/{sx150x.c => gpio-sx150x.c}           |    0
 drivers/gpio/{tc3589x-gpio.c => gpio-tc3589x.c}    |    0
 .../mach-tegra/gpio.c => drivers/gpio/gpio-tegra.c |   10 +
 drivers/gpio/{timbgpio.c => gpio-timberdale.c}     |    2 +-
 drivers/gpio/{tps65910-gpio.c => gpio-tps65910.c}  |    2 +-
 drivers/gpio/{twl4030-gpio.c => gpio-twl4030.c}    |    2 +-
 drivers/gpio/gpio-u300.c                           |    5 +-
 drivers/gpio/{ucb1400_gpio.c => gpio-ucb1400.c}    |    0
 drivers/gpio/{vr41xx_giu.c => gpio-vr41xx.c}       |    2 +-
 drivers/gpio/{vx855_gpio.c => gpio-vx855.c}        |    0
 drivers/gpio/{wm831x-gpio.c => gpio-wm831x.c}      |    2 +-
 drivers/gpio/{wm8350-gpiolib.c => gpio-wm8350.c}   |    2 +-
 drivers/gpio/{wm8994-gpio.c => gpio-wm8994.c}      |    2 +-
 drivers/gpio/{xilinx_gpio.c => gpio-xilinx.c}      |    0
 drivers/leds/Kconfig                               |   19 +-
 drivers/leds/leds-gpio.c                           |    6 +-
 drivers/of/gpio.c                                  |   11 +-
 include/linux/of_gpio.h                            |   42 +-
 include/linux/spi/74x164.h                         |    2 -
 include/linux/spi/mcp23s08.h                       |    9 -
 137 files changed, 2291 insertions(+), 1917 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/fsl-imx-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_nvidia.txt
 create mode 100644 arch/arm/mach-mxs/devices/platform-gpio-mxs.c
 delete mode 100644 arch/arm/mach-mxs/gpio.c
 delete mode 100644 arch/arm/mach-mxs/gpio.h
 create mode 100644 arch/arm/plat-mxc/devices/platform-gpio-mxc.c
 delete mode 100644 arch/arm/plat-mxc/gpio.c
 rename drivers/gpio/{74x164.c => gpio-74x164.c} (88%)
 rename drivers/gpio/{ab8500-gpio.c => gpio-ab8500.c} (100%)
 rename drivers/gpio/{adp5520-gpio.c => gpio-adp5520.c} (100%)
 rename drivers/gpio/{adp5588-gpio.c => gpio-adp5588.c} (100%)
 rename drivers/gpio/{bt8xxgpio.c => gpio-bt8xx.c} (100%)
 rename drivers/gpio/{cs5535-gpio.c => gpio-cs5535.c} (100%)
 create mode 100644 drivers/gpio/gpio-da9052.c
 rename arch/arm/mach-ep93xx/gpio.c => drivers/gpio/gpio-ep93xx.c (69%)
 rename drivers/gpio/{basic_mmio_gpio.c => gpio-generic.c} (99%)
 rename drivers/gpio/{it8761e_gpio.c => gpio-it8761e.c} (98%)
 rename drivers/gpio/{janz-ttl.c => gpio-janz-ttl.c} (100%)
 rename drivers/gpio/{langwell_gpio.c => gpio-langwell.c} (99%)
 rename drivers/gpio/{max7300.c => gpio-max7300.c} (98%)
 rename drivers/gpio/{max7301.c => gpio-max7301.c} (98%)
 rename drivers/gpio/{max730x.c => gpio-max730x.c} (99%)
 rename drivers/gpio/{max732x.c => gpio-max732x.c} (99%)
 rename drivers/gpio/{mc33880.c => gpio-mc33880.c} (98%)
 rename drivers/gpio/{mcp23s08.c => gpio-mcp23s08.c} (68%)
 rename drivers/gpio/{ml_ioh_gpio.c => gpio-ml-ioh.c} (99%)
 rename arch/powerpc/platforms/52xx/mpc52xx_gpio.c =>
drivers/gpio/gpio-mpc5200.c (98%)
 create mode 100644 drivers/gpio/gpio-mxc.c
 create mode 100644 drivers/gpio/gpio-mxs.c
 rename drivers/gpio/{pca953x.c => gpio-pca953x.c} (89%)
 rename drivers/gpio/{pcf857x.c => gpio-pcf857x.c} (99%)
 rename drivers/gpio/{pch_gpio.c => gpio-pch.c} (100%)
 rename drivers/gpio/{pl061.c => gpio-pl061.c} (99%)
 rename drivers/gpio/{rdc321x-gpio.c => gpio-rdc321x.c} (100%)
 rename drivers/gpio/{sch_gpio.c => gpio-sch.c} (99%)
 rename drivers/gpio/{stmpe-gpio.c => gpio-stmpe.c} (100%)
 rename drivers/gpio/{sx150x.c => gpio-sx150x.c} (100%)
 rename drivers/gpio/{tc3589x-gpio.c => gpio-tc3589x.c} (100%)
 rename arch/arm/mach-tegra/gpio.c => drivers/gpio/gpio-tegra.c (97%)
 rename drivers/gpio/{timbgpio.c => gpio-timberdale.c} (99%)
 rename drivers/gpio/{tps65910-gpio.c => gpio-tps65910.c} (98%)
 rename drivers/gpio/{twl4030-gpio.c => gpio-twl4030.c} (99%)
 rename drivers/gpio/{ucb1400_gpio.c => gpio-ucb1400.c} (100%)
 rename drivers/gpio/{vr41xx_giu.c => gpio-vr41xx.c} (99%)
 rename drivers/gpio/{vx855_gpio.c => gpio-vx855.c} (100%)
 rename drivers/gpio/{wm831x-gpio.c => gpio-wm831x.c} (99%)
 rename drivers/gpio/{wm8350-gpiolib.c => gpio-wm8350.c} (98%)
 rename drivers/gpio/{wm8994-gpio.c => gpio-wm8994.c} (99%)
 rename drivers/gpio/{xilinx_gpio.c => gpio-xilinx.c} (100%)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
