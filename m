Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2EVFin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:38:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43213 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab2EVFhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:43 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 6/8] arm-soc: soc-specific pinctrl changes
Date: Mon, 21 May 2012 22:35:06 -0700
Message-Id: <1337664908-17478-7-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1337664908-17478-1-git-send-email-olof@lixom.net>
References: <1337664908-17478-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this, five platforms are moving to the relatively new pinctrl
subsystem for their pin management, replacing the older soc specific
in-kernel interfaces with common code.

There is quite a bit of net addition of code for each platform being
added to the pinctrl subsystem. but the payback comes later when adding
new boards can be done by only providing new device trees instead.


Merge conflicts from this branch:
* add/remove context conflict in ux500 Makefile. Delete u5500 files,
  keep mop500-msp.
* remove/remove context conflict in board-mop500.c dealing with i2c and
  pinmux setup. Both sides of the conflict should be removed.

----------------------------------------------------------------

The following changes since commit 6e7e7311a85042150257384de1cc5b69ebaa56a9:

  Merge tag 'soc' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/pinctrl

for you to fetch changes up to f3f08dcb9965f42378851ce888fb7539607712e6:

  Merge branch 'imx/pinctrl' into next/pinctrl

----------------------------------------------------------------

Arnd Bergmann (6):
      Merge branch 'spear/pinctrl' into next/pinctrl
      Merge branch 'ux500-gpio-pins-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/gpio
      pinctrl/nomadik: !CONFIG_OF build error
      Merge branches 'depends/pinctrl/devel' and 'depends/rmk/clkdev' into spear/pinctrl
      Merge branch 'spear/pinctrl' into next/pinctrl
      ARM: nomadik: enable PINCTRL_NOMADIK where needed

Barry Song (1):
      ARM: PRIMA2: select PINCTRL and PINCTRL_SIRF in Kconfig

Dong Aisheng (3):
      ARM: imx: enable pinctrl dummy states
      ARM: imx6q: switch to use pinctrl subsystem
      mmc: sdhci-imx-esdhc: adopt pinctrl support

Lee Jones (2):
      drivers/gpio: gpio-nomadik: Apply Device Tree bindings
      drivers/gpio: gpio-nomadik: Add support for irqdomains

Linus Walleij (17):
      gpio/nomadik: use ioremap() instead of static mappings
      plat-nomadik: new sleep mode pincfg macros
      ARM: ux500: remove a bunch of internal pull-ups
      ARM: ux500: update pin handling
      Merge tag 'pinctrl-mergebase-20120418' into HEAD
      gpio: move the Nomadik GPIO driver to pinctrl
      pinctrl/nomadik: basic Nomadik pinctrl interface
      pinctrl/nomadik: break out single GPIO debug function
      pinctrl/nomadik: reuse GPIO debug function for pins
      pinctrl/nomadik: implement pin multiplexing
      pinctrl/nomadik: implement pin configuration
      pinctrl: add sleep state definition
      ARM: ux500: switch over to Nomadik pinctrl driver
      ARM: ux500: delete custom pin control system
      ARM: ux500: switch to using pinctrl for uart0
      ARM: ux500: alter MSP registration to return a device pointer
      ARM: ux500: switch MSP to using pinctrl for pins

Ola Lilja (1):
      ARM: ux500: Add support for MSP I2S-devices

Olof Johansson (5):
      Merge tag 'pinctrl-mergebase-20120418' of git://git.kernel.org/.../linusw/linux-pinctrl into next/pinctrl
      Merge branch 'for-3.5/gpio-pinmux' of git://git.kernel.org/.../swarren/linux-tegra into next/pinctrl
      Merge branch 'imx/pinctrl/for-3.5' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/pinctrl
      Merge tag 'ux500-gpio-pins-for-3.5' of git://git.kernel.org/.../linusw/linux-stericsson into next/pinctrl
      Merge branch 'imx/pinctrl' into next/pinctrl

Rabin Vincent (5):
      gpio/nomadik: don't set SLPM to 1 for non-wakeup pins
      gpio/nomadik: cache [rf]w?imsc
      gpio/nomadik: fix spurious interrupts with SKE
      gpio/nomadik: support low EMI mode
      ARM: ux500: implement pin API

Shawn Guo (15):
      ARM: mxs: enable pinctrl dummy states
      tty: serial: imx: adopt pinctrl support
      net: fec: adopt pinctrl support
      can: flexcan: adopt pinctrl support
      i2c: imx: adopt pinctrl support
      spi/imx: adopt pinctrl support
      serial: amba-pl011: adopt pinctrl support
      serial: mxs-auart: adopt pinctrl support
      mmc: mxs-mmc: adopt pinctrl support
      mtd: nand: gpmi: adopt pinctrl support
      i2c: mxs: adopt pinctrl support
      ASoC: mxs-saif: adopt pinctrl support
      video: mxsfb: adopt pinctrl support
      ARM: mxs: enable pinctrl support
      mtd: nand: gpmi: fix compile error caused by pinctrl call

Stephen Warren (12):
      usb: ehci-tegra: Add vbus_gpio to platform data
      ARM: tegra: Remove VBUS_GPIO handling from board files
      gpio: tegra: configure pins during irq_set_type
      ARM: tegra: seaboard: Don't gpio_request() ISL29018_IRQ
      gpio: tegra: Hide tegra_gpio_enable/disable()
      ARM: tegra: Switch to new pinctrl driver
      ARM: tegra: Remove pre-pinctrl pinmux driver
      ARM: dt: tegra cardhu: add pinmux to device tree
      ARM: dt: tegra20: add pinmux to device tree
      pinctrl: tegra: refactor probe handling
      pinctrl: tegra: debugfs enhancements
      pinctrl: tegra: error reporting cleanup

Viresh Kumar (4):
      pinctrl: Add SPEAr pinctrl drivers
      pinctrl: Add SPEAr3xx pinctrl drivers
      SPEAr: Remove existing padmux support for SPEAr
      SPEAr3xx: Add pinctrl support for boards


 .../bindings/pinctrl/pinctrl_spear.txt          |  108 +
 MAINTAINERS                                     |   23 +-
 arch/arm/Kconfig                                |    4 +
 arch/arm/boot/dts/spear300-evb.dts              |   38 +
 arch/arm/boot/dts/spear300.dtsi                 |    5 +
 arch/arm/boot/dts/spear310-evb.dts              |   61 +
 arch/arm/boot/dts/spear310.dtsi                 |    5 +
 arch/arm/boot/dts/spear320-evb.dts              |   61 +
 arch/arm/boot/dts/spear320.dtsi                 |    7 +-
 arch/arm/boot/dts/tegra-cardhu.dts              |   44 +
 arch/arm/boot/dts/tegra-harmony.dts             |  224 ++
 arch/arm/boot/dts/tegra-paz00.dts               |  220 ++
 arch/arm/boot/dts/tegra-seaboard.dts            |  243 ++
 arch/arm/boot/dts/tegra-trimslice.dts           |  230 ++
 arch/arm/boot/dts/tegra-ventana.dts             |  230 ++
 arch/arm/configs/nhk8815_defconfig              |    1 +
 arch/arm/mach-imx/Kconfig                       |    2 +
 arch/arm/mach-imx/imx51-dt.c                    |    3 +
 arch/arm/mach-imx/imx53-dt.c                    |    3 +
 arch/arm/mach-imx/mach-imx6q.c                  |    7 +
 arch/arm/mach-imx/mm-imx1.c                     |    2 +
 arch/arm/mach-imx/mm-imx21.c                    |    2 +
 arch/arm/mach-imx/mm-imx25.c                    |    2 +
 arch/arm/mach-imx/mm-imx27.c                    |    2 +
 arch/arm/mach-imx/mm-imx3.c                     |    2 +
 arch/arm/mach-imx/mm-imx5.c                     |    2 +
 arch/arm/mach-mxs/Kconfig                       |    2 +
 arch/arm/mach-mxs/include/mach/common.h         |    2 +
 arch/arm/mach-mxs/mach-apx4devkit.c             |    2 +
 arch/arm/mach-mxs/mach-m28evk.c                 |    2 +
 arch/arm/mach-mxs/mach-mx23evk.c                |    2 +
 arch/arm/mach-mxs/mach-mx28evk.c                |    2 +
 arch/arm/mach-mxs/mach-stmp378x_devb.c          |    2 +
 arch/arm/mach-mxs/mach-tx28.c                   |    2 +
 arch/arm/mach-mxs/mm.c                          |   11 +
 arch/arm/mach-nomadik/Kconfig                   |    1 +
 arch/arm/mach-spear3xx/Kconfig                  |    3 +
 arch/arm/mach-spear3xx/include/mach/generic.h   |  128 -
 arch/arm/mach-spear3xx/spear300.c               |  389 +-
 arch/arm/mach-spear3xx/spear310.c               |  161 +-
 arch/arm/mach-spear3xx/spear320.c               |  403 +-
 arch/arm/mach-spear3xx/spear3xx.c               |  425 ---
 arch/arm/mach-tegra/Makefile                    |    3 -
 arch/arm/mach-tegra/board-dt-tegra20.c          |   31 -
 arch/arm/mach-tegra/board-harmony-pinmux.c      |  266 +-
 arch/arm/mach-tegra/board-paz00-pinmux.c        |  263 +-
 arch/arm/mach-tegra/board-pinmux.c              |  105 +-
 arch/arm/mach-tegra/board-pinmux.h              |   40 +-
 arch/arm/mach-tegra/board-seaboard-pinmux.c     |  346 +-
 arch/arm/mach-tegra/board-seaboard.c            |   21 +-
 arch/arm/mach-tegra/board-trimslice-pinmux.c    |  264 +-
 arch/arm/mach-tegra/board-trimslice.c           |   15 +-
 arch/arm/mach-tegra/devices.c                   |    5 +-
 arch/arm/mach-tegra/include/mach/gpio-tegra.h   |    9 -
 .../mach-tegra/include/mach/pinmux-tegra20.h    |  184 -
 .../mach-tegra/include/mach/pinmux-tegra30.h    |  320 --
 arch/arm/mach-tegra/include/mach/pinmux.h       |  302 --
 arch/arm/mach-tegra/pinmux-tegra20-tables.c     |  244 --
 arch/arm/mach-tegra/pinmux-tegra30-tables.c     |  376 --
 arch/arm/mach-tegra/pinmux.c                    |  987 -----
 arch/arm/mach-tegra/usb_phy.c                   |    1 -
 arch/arm/mach-ux500/Kconfig                     |    3 +
 arch/arm/mach-ux500/Makefile                    |    3 +-
 arch/arm/mach-ux500/board-mop500-msp.c          |  267 ++
 arch/arm/mach-ux500/board-mop500-msp.h          |   14 +
 arch/arm/mach-ux500/board-mop500-pins.c         |  733 ++--
 arch/arm/mach-ux500/board-mop500.c              |   99 +-
 arch/arm/mach-ux500/board-mop500.h              |   10 +-
 arch/arm/mach-ux500/clock.c                     |    8 +-
 arch/arm/mach-ux500/cpu-db8500.c                |    1 +
 arch/arm/mach-ux500/cpu.c                       |   12 +
 arch/arm/mach-ux500/devices-common.h            |   12 +
 arch/arm/mach-ux500/devices-db8500.h            |   10 -
 arch/arm/mach-ux500/include/mach/msp.h          |   29 +
 arch/arm/mach-ux500/pins-db8500.h               |   72 +-
 .../plat-nomadik/include/plat/gpio-nomadik.h    |    8 +
 arch/arm/plat-nomadik/include/plat/pincfg.h     |   32 +
 arch/arm/plat-spear/Kconfig                     |    1 +
 arch/arm/plat-spear/Makefile                    |    2 +-
 arch/arm/plat-spear/include/plat/padmux.h       |   92 -
 arch/arm/plat-spear/padmux.c                    |  164 -
 drivers/gpio/Makefile                           |    1 -
 drivers/gpio/gpio-tegra.c                       |   39 +-
 drivers/i2c/busses/i2c-imx.c                    |    8 +
 drivers/i2c/busses/i2c-mxs.c                    |    6 +
 drivers/mmc/host/mxs-mmc.c                      |    8 +
 drivers/mmc/host/sdhci-esdhc-imx.c              |    9 +
 drivers/mmc/host/sdhci-tegra.c                  |   24 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c          |    9 +
 drivers/net/can/flexcan.c                       |    6 +
 drivers/net/ethernet/freescale/fec.c            |    9 +
 drivers/pinctrl/Kconfig                         |   12 +
 drivers/pinctrl/Makefile                        |    4 +
 drivers/pinctrl/pinctrl-nomadik-db8500.c        |  857 +++++
 .../pinctrl-nomadik.c}                          |  857 ++++-
 drivers/pinctrl/pinctrl-nomadik.h               |   77 +
 drivers/pinctrl/pinctrl-tegra.c                 |  236 +-
 drivers/pinctrl/pinctrl-tegra.h                 |   23 +-
 drivers/pinctrl/pinctrl-tegra20.c               |   40 +-
 drivers/pinctrl/pinctrl-tegra30.c               |   40 +-
 drivers/pinctrl/spear/Kconfig                   |   34 +
 drivers/pinctrl/spear/Makefile                  |    7 +
 drivers/pinctrl/spear/pinctrl-spear.c           |  354 ++
 drivers/pinctrl/spear/pinctrl-spear.h           |  142 +
 drivers/pinctrl/spear/pinctrl-spear300.c        |  708 ++++
 drivers/pinctrl/spear/pinctrl-spear310.c        |  431 +++
 drivers/pinctrl/spear/pinctrl-spear320.c        | 3468 ++++++++++++++++++
 drivers/pinctrl/spear/pinctrl-spear3xx.c        |  588 +++
 drivers/pinctrl/spear/pinctrl-spear3xx.h        |   92 +
 drivers/spi/spi-imx.c                           |    8 +
 drivers/tty/serial/amba-pl011.c                 |    8 +
 drivers/tty/serial/imx.c                        |    8 +
 drivers/tty/serial/mxs-auart.c                  |    8 +
 drivers/usb/host/ehci-tegra.c                   |   13 +-
 drivers/video/mxsfb.c                           |    9 +
 include/linux/pinctrl/pinctrl-state.h           |   13 +
 include/linux/platform_data/tegra_usb.h         |    1 +
 sound/soc/mxs/mxs-saif.c                        |    8 +
 118 files changed, 10999 insertions(+), 5588 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl_spear.txt
 delete mode 100644 arch/arm/mach-tegra/include/mach/pinmux-tegra20.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/pinmux-tegra30.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/pinmux.h
 delete mode 100644 arch/arm/mach-tegra/pinmux-tegra20-tables.c
 delete mode 100644 arch/arm/mach-tegra/pinmux-tegra30-tables.c
 delete mode 100644 arch/arm/mach-tegra/pinmux.c
 create mode 100644 arch/arm/mach-ux500/board-mop500-msp.c
 create mode 100644 arch/arm/mach-ux500/board-mop500-msp.h
 create mode 100644 arch/arm/mach-ux500/include/mach/msp.h
 delete mode 100644 arch/arm/plat-spear/include/plat/padmux.h
 delete mode 100644 arch/arm/plat-spear/padmux.c
 create mode 100644 drivers/pinctrl/pinctrl-nomadik-db8500.c
 rename drivers/{gpio/gpio-nomadik.c => pinctrl/pinctrl-nomadik.c} (56%)
 create mode 100644 drivers/pinctrl/pinctrl-nomadik.h
 create mode 100644 drivers/pinctrl/spear/Kconfig
 create mode 100644 drivers/pinctrl/spear/Makefile
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear.c
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear.h
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear300.c
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear310.c
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear320.c
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear3xx.c
 create mode 100644 drivers/pinctrl/spear/pinctrl-spear3xx.h
