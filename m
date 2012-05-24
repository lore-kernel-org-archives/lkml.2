Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab2EXUEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:04:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47538 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab2EXUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:04:03 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 24 May 2012 14:03:42 -0600
X-Google-Sender-Auth: ZgmncqHbEnixUKPITpDMhrdH5ns
Message-ID: <CACxGe6s2DiqRhNH81NUw6KykFcVbtwFgrUr0XQwj5y8CVFhuOg@mail.gmail.com>
Subject: [GIT PULL] gpio changes for v3.5 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Description below, please pull.
g.

The following changes since commit 6edd94db250038c8fdf176f23ca4017d2f312509:

  gpio/omap: fix incorrect initialization of omap_gpio_mod_init
(2012-05-10 07:16:15 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus

for you to fetch changes up to 3e11f7b840b4671213c66817294ad7dd0b572756:

  gpio/generic: initialize basic_mmio_gpio shadow variables properly
(2012-05-19 12:17:35 -0600)

----------------------------------------------------------------
GPIO driver changes for v3.5 merge window

Lots of gpio changes, both to core code and drivers.  Changes do touch
architecture code to remove the need for separate arm/gpio.h includes
in most architectures.  Some new drivers are added, and a number of
gpio drivers are converted to use irq_domains for gpio inputs used as
interrupts.  Device tree support has been amended to allow multiple
gpio_chips to use the same device tree node.  Remaining changes are
primarily bug fixes.

----------------------------------------------------------------
Andreas Schallenberg (1):
      Add support for TCA6424A

Axel Lin (2):
      gpio/pca953x: Update GPIO_PCA953X Kconfig entry to include more
supported devices
      gpio: Convert drivers to use module_pci_driver()

Grant Likely (6):
      gpio: Move DT support code into drivers/gpio
      Merge tag 'v3.4-rc6' into gpio/next
      Merge branch 'for_3.5/gpio/cleanup' of
git://git.kernel.org/.../khilman/linux-omap-pm into gpio/next
      gpio: Adjust of_xlate API to support multiple GPIO chips
      Merge branch 'for_3.5/fixes/gpio-2' of
git://git.kernel.org/.../khilman/linux-omap-pm into gpio/next
      gpiolib: Remove 'const' from data argument of gpiochip_find()

H Hartley Sweeten (1):
      gpiolib: quiet gpiochip_add boot message noise

Kevin Hilman (2):
      gpio/omap: fix broken context restore for non-OFF mode transitions
      gpio/omap: (re)fix wakeups on level-triggered GPIOs

Laxman Dewangan (1):
      gpio/rc5t583: add gpio driver for RICOH PMIC RC5T583

Mark Brown (3):
      gpiolib: Add !CONFIG_GPIOLIB definitions of devm_ functions
      gpiolib/arches: Centralise bolierplate asm/gpio.h
      gpiolib: Implement devm_gpio_request_one()

Mathias Nyman (1):
      gpio: add MSIC gpio driver

Mika Westerberg (5):
      gpio/langwell: use devm_* helpers to simplify probe
      gpio/langwell: allocate IRQ descriptors dynamically for SPARSE_IRQ
      gpio/langwell: clear IRQ edge detect registers at init
      gpio/langwell: convert to use irq_domain
      gpio/langwell: re-read the IRQ status register after each iteration

Olof Johansson (1):
      gpio: samsung: refactor gpiolib init for exynos4/5

Peter Korsgaard (1):
      gpio-mcp23s08: dbg_show: fix pullup configuration display

Roland Stigge (1):
      gpio/lpc32xx: Add device tree support

Shawn Guo (1):
      gpio/generic: initialize basic_mmio_gpio shadow variables properly

Tarun Kanti DebBarma (8):
      gpio/omap: remove virtual_irq_start variable
      gpio/omap: remove saved_fallingdetect, saved_risingdetect
      gpio/omap: remove suspend_wakeup field from struct gpio_bank
      gpio/omap: remove saved_wakeup field from struct gpio_bank
      gpio/omap: remove retrigger variable in gpio_irq_handler
      gpio/omap: remove suspend/resume callbacks
      gpio/omap: remove cpu_is_omapxxxx() checks from *_runtime_resume()
      gpio/omap: fix missing check in *_runtime_suspend()

Thomas Gleixner (1):
      gpio: mpc8xxx: Prevent NULL pointer deref in demux handler

Wolfram Sang (1):
      gpio: add flags to export GPIOs when requesting

 .../devicetree/bindings/gpio/gpio_lpc32xx.txt      |   43 +++
 Documentation/gpio.txt                             |    3 +
 arch/alpha/include/asm/gpio.h                      |   59 +--
 arch/arm/Kconfig                                   |    1 +
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    3 +-
 arch/arm/mach-lpc32xx/include/mach/gpio.h          |    9 +-
 arch/arm/mach-omap1/gpio15xx.c                     |    2 -
 arch/arm/mach-omap1/gpio16xx.c                     |    5 -
 arch/arm/mach-omap1/gpio7xx.c                      |    7 -
 arch/arm/mach-omap2/gpio.c                         |    3 +-
 arch/arm/plat-omap/include/plat/gpio.h             |    3 +-
 arch/avr32/Kconfig                                 |    1 +
 arch/blackfin/Kconfig                              |    1 +
 arch/ia64/include/asm/gpio.h                       |   59 +--
 arch/m68k/Kconfig.cpu                              |    1 +
 arch/microblaze/include/asm/gpio.h                 |   57 +--
 arch/mips/Kconfig                                  |    1 +
 arch/openrisc/include/asm/gpio.h                   |   69 +---
 arch/powerpc/include/asm/gpio.h                    |   57 +--
 arch/sh/Kconfig                                    |    1 +
 arch/sparc/include/asm/gpio.h                      |   40 +-
 arch/unicore32/Kconfig                             |    1 +
 arch/x86/include/asm/gpio.h                        |   57 +--
 arch/xtensa/include/asm/gpio.h                     |   60 +--
 drivers/gpio/Kconfig                               |   39 +-
 drivers/gpio/Makefile                              |    3 +
 drivers/gpio/devres.c                              |   29 ++
 drivers/gpio/gpio-bt8xx.c                          |   12 +-
 drivers/gpio/gpio-ep93xx.c                         |    2 +-
 drivers/gpio/gpio-generic.c                        |   16 +-
 drivers/gpio/gpio-langwell.c                       |   91 +++--
 drivers/gpio/gpio-lpc32xx.c                        |   52 ++-
 drivers/gpio/gpio-mcp23s08.c                       |    2 +-
 drivers/gpio/gpio-ml-ioh.c                         |   12 +-
 drivers/gpio/gpio-mpc8xxx.c                        |    3 +-
 drivers/gpio/gpio-msic.c                           |  339 ++++++++++++++++
 drivers/gpio/gpio-mxc.c                            |    2 +-
 drivers/gpio/gpio-mxs.c                            |    2 +-
 drivers/gpio/gpio-omap.c                           |  106 ++---
 drivers/gpio/gpio-pca953x.c                        |   43 ++-
 drivers/gpio/gpio-pch.c                            |   12 +-
 drivers/gpio/gpio-rc5t583.c                        |  180 +++++++++
 drivers/gpio/gpio-samsung.c                        |  403 +++++++++++---------
 drivers/gpio/gpio-sodaville.c                      |   14 +-
 drivers/{of/gpio.c => gpio/gpiolib-of.c}           |   80 ++--
 drivers/gpio/gpiolib.c                             |   18 +-
 drivers/of/Kconfig                                 |    6 -
 drivers/of/Makefile                                |    1 -
 include/asm-generic/gpio.h                         |    6 +-
 include/linux/basic_mmio_gpio.h                    |    6 +-
 include/linux/gpio.h                               |   59 +++
 include/linux/mfd/rc5t583.h                        |    2 +
 include/linux/of_gpio.h                            |    1 -
 53 files changed, 1210 insertions(+), 874 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
 create mode 100644 drivers/gpio/gpio-msic.c
 create mode 100644 drivers/gpio/gpio-rc5t583.c
 rename drivers/{of/gpio.c => gpio/gpiolib-of.c} (86%)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
