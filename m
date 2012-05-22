Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2EVFjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:39:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46552 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2EVFhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:41 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/8] arm-soc: device tree conversions, part 1
Date: Mon, 21 May 2012 22:35:04 -0700
Message-Id: <1337664908-17478-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1337664908-17478-1-git-send-email-olof@lixom.net>
References: <1337664908-17478-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spear3xx, lpc32xx, shmobile and mmp platforms are joining the game of
booting using device trees, which is a great step forward for them. at91
and spear have pretty much completed this process with a huge amount of
work being put into at91. The other platforms are continuing the process.

We finally start to see the payback on this investment, as new machines
are getting supported purely by adding a .dts source file that can be
completely independent of the kernel source.


Heads up:

It was discovered in -next that automated resolutions done
by git ends up in a mismerge of this branch vs the staging
tree. When the latter of the two is pulled in, please see
http://marc.info/?l=linux-kernel&m=133764253705519&w=2 for the required
fixup.

The other conflict seen here is an add-vs-remove context conflict in
arch/arm/Kconfig: remove TICK_ONESHOT, add IRQ_DOMAIN.

----------------------------------------------------------------

The following changes since commit 8d1aea09a3c7e0ff111b7cad29cb5538d98d43c3:

  Merge tag 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt

for you to fetch changes up to 396d81cd0fe12ce5d1f6d159f093f9315d2837bc:

  Merge branch 'at91/dt' into next/dt

----------------------------------------------------------------

Arnd Bergmann (11):
      ARM: spear: remove most mach/*.h header contents
      Merge branch 'renesas/dt' into next/dt
      Merge branch 'spear/dt' into next/dt
      Merge branch 'depends/i2c/lpc32xx' into next/dt
      Merge branch 'lpc32xx/dt' of git://git.antcom.de/linux-2.6 into next/dt
      Merge branch 'spear/dt' into next/dt
      Merge branch 'ux500-devicetree-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'at91-for-next-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge branch 'ux500-devicetree-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge branch 'dt' of git://github.com/hzhuang1/linux into next/dt
      Merge branch 'at91/dt' into next/dt

Benoit Cousson (14):
      arm/dts: twl6030: Add DTS file for twl6030 PMIC
      arm/dts: twl4030: Add DTS file for twl4030 PM + Audio IC
      arm/dts: omap4-panda: Add twl6030 and i2c EEPROM
      arm/dts: omap4-sdp: Add twl6030, i2c3 and i2c4 devices
      arm/dts: omap3-beagle: Add twl4030 and i2c EEPROM
      ARM: OMAP2+: board-generic: Remove i2c static init
      arm/dts: OMAP4: Add gpio nodes
      arm/dts: OMAP3: Add gpio nodes
      arm/dts: OMAP4: Add SPI controller nodes
      arm/dts: OMAP3: Add SPI controller nodes
      arm/dts: omap4-sdp: Add ks8851 ethernet SPI device
      arm/dts: twl4030: Add twl4030-gpio node
      arm/dts: omap4-sdp: Add LEDs support
      arm/dts: omap4-panda: Add LEDs support

Boris BREZILLON (1):
      ARM: at91: add kizbox board dt support.

Haojian Zhuang (9):
      ARM: mmp: fix build issue on mmp with device tree
      ARM: mmp: append CONFIG_MACH_MMP2_DT
      ARM: mmp: support DT in irq
      ARM: mmp: support DT in timer
      gpio: pxa: parse gpio from DTS file
      ARM: mmp: support mmp2 with device tree
      ARM: mmp: support pxa910 with device tree
      ARM: dts: refresh dts file for arch mmp
      Documentation: update docs for mmp dt

Jean-Christophe PLAGNIOL-VILLARD (11):
      ARM: at91: add at91sam9260 DT support
      arm: at91: add Calao TNY-A9260 and TNY-A9G20 board support
      ARM: at91: add at91sam9g20ek boards dt support
      ARM: at91: USB A926x update nand partition
      ARM: at91: Calao USB A926x factorize common binding in usb_a9260_common
      ARM: at91: DT: add Calao USB A9260 DT support
      ARM: at91: standard device init only if DT is not populated.
      ARM: at91: add at91sam9263 DT support
      ARM: at91: add at91sam9263ek DT support
      ARM: at91: DT: add Calao USB A9263 board support
      ARM: at91: DT: add Calao TNY A9263 board support

Lee Jones (13):
      ARM: ux500: Rename the DT compatible entry for i2c devices on Snowball
      ARM: ux500: Shorten Snowball's DT compatible gpio entry
      ARM: ux500: Enable the external bus with Device Tree
      drivers/gpio: gpio-nomadik: Device Tree bindings
      drivers/gpio: gpio-nomadik: Provide documentation for Device Tree bindings
      ARM: ux500: Rename gpio_keys in the Device Tree file
      drivers/gpio: represent gpio-nomadik as an IRQ controller in DT documentation
      ARM: ux500: Enable the SMSC9115 on Snowball via Device Tree
      ARM: ux500: Configure the PRCMU Timer for db8500 based devices in DT
      ARM: ux500: Do not attempt to register non-existent i2c devices on Snowball
      ARM: ux500: Fork cpu-db8500 platform_devs for sequential DT enablement
      ARM: ux500: Disable SMSC911x platform code registration when DT is enabled
      ARM: ux500: Enable PRCMU Timer 4 (clocksource) for Device Tree

Magnus Damm (6):
      ARM: mach-shmobile: Introduce shmobile_setup_delay()
      ARM: mach-shmobile: Introduce INTC_IRQ_PINS_16H
      ARM: mach-shmobile: Use 0x3400 as INTCS vector offset
      ARM: mach-shmobile: Use INTC_IRQ_PINS_16H on sh7372
      ARM: mach-shmobile: Rework sh7372 INTCS demuxer V2
      ARM: mach-shmobile: sh7372 generic board support via DT V2

Nicolas Ferre (1):
      ARM: at91: Add ADC driver to at91sam9260/at91sam9g20 dtsi files

Olof Johansson (2):
      Merge branch 'omap/dt-missed-3.4' into next/dt
      Merge tag 'omap-dt-for-v3.5' of git://git.kernel.org/.../tmlind/linux-omap into next/dt

Peter Ujfalusi (2):
      OMAP4: devices: Do not create dmic device if the dtb has been provided
      OMAP4: devices: Do not create mcpdm device if the dtb has been provided

Rajendra Nayak (3):
      arm/dts: twl: Pass regulator data from dt
      arm/dts: OMAP4: Add mmc controller nodes and board data
      arm/dts: OMAP3: Add mmc controller nodes and board data

Roland Stigge (12):
      i2c: pnx: Disable clk in suspend
      i2c-pnx.c: Use resources in platforms
      i2c-pnx.c: Remove duplicated i2c.h
      i2c: Add device tree support to i2c-pnx.c
      net: Add device tree support to LPC32xx
      ARM: LPC32xx: clock.c cleanup
      ARM: LPC32xx: clock.c registration adjustment
      ARM: LPC32xx: Remove obsolete platform Kconfig
      ARM: LPC32xx: DTS files for device tree conversion
      ARM: LPC32xx: Device tree support
      ARM: LPC32xx: Move common code to common.c
      ARM: LPC32xx: Defconfig update

Stefan Roese (1):
      ARM: SPEAr600: Change FSMC and SMI clock names

Tim Schendekehl (1):
      Ethernut 5 board support

Viresh Kumar (8):
      SPEAr: Use CLKDEV_INIT for defining clk_lookups
      SPEAr3xx: Add clock instance of usb hosts - ehci and ohci 0 and 1
      SPEAr6xx: Add compilation support for dtbs using 'make dtbs'
      SPEAr3xx: Replace printk() with pr_*()
      ARM: SPEAr3xx: Add device-tree support to SPEAr3xx architecture
      SPEAr: Add PL080 DMA support for 3xx and 6xx
      SPEAr: Update defconfigs
      ARM: SPEAr3xx: Correct keyboard data passed from DT


 Documentation/arm/SPEAr/overview.txt            |  13 +-
 .../devicetree/bindings/arm/lpc32xx-mic.txt     |  38 ++
 .../devicetree/bindings/arm/lpc32xx.txt         |   8 +
 .../devicetree/bindings/arm/mrvl/intc.txt       |  40 ++
 .../devicetree/bindings/arm/{ => mrvl}/mrvl.txt |   8 +
 .../devicetree/bindings/arm/mrvl/timer.txt      |  13 +
 Documentation/devicetree/bindings/arm/spear.txt |  18 +
 .../devicetree/bindings/gpio/gpio-nmk.txt       |  31 ++
 .../devicetree/bindings/gpio/mrvl-gpio.txt      |  18 +-
 .../devicetree/bindings/i2c/mrvl-i2c.txt        |  15 +-
 Documentation/devicetree/bindings/i2c/pnx.txt   |  36 ++
 .../devicetree/bindings/net/lpc-eth.txt         |  24 +
 arch/arm/Kconfig                                |   2 +
 arch/arm/boot/dts/at91sam9260.dtsi              | 273 ++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi              | 220 +++++++++
 arch/arm/boot/dts/at91sam9263ek.dts             | 156 +++++++
 arch/arm/boot/dts/at91sam9g20.dtsi              | 222 +--------
 arch/arm/boot/dts/at91sam9g20ek.dts             |  29 ++
 arch/arm/boot/dts/at91sam9g20ek_2mmc.dts        |  29 ++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi     | 142 ++++++
 arch/arm/boot/dts/db8500.dtsi                   |  63 ++-
 arch/arm/boot/dts/ethernut5.dts                 |  84 ++++
 arch/arm/boot/dts/kizbox.dts                    | 138 ++++++
 arch/arm/boot/dts/lpc32xx.dtsi                  | 292 ++++++++++++
 arch/arm/boot/dts/mmp2-brownstone.dts           |  38 ++
 arch/arm/boot/dts/mmp2.dtsi                     | 220 +++++++++
 arch/arm/boot/dts/omap3-beagle.dts              |  49 ++
 arch/arm/boot/dts/omap3.dtsi                    | 102 +++++
 arch/arm/boot/dts/omap4-panda.dts               |  71 +++
 arch/arm/boot/dts/omap4-sdp.dts                 | 140 ++++++
 arch/arm/boot/dts/omap4.dtsi                    | 117 +++++
 arch/arm/boot/dts/phy3250.dts                   | 145 ++++++
 arch/arm/boot/dts/pxa168.dtsi                   |  67 ++-
 arch/arm/boot/dts/pxa910-dkb.dts                |  38 ++
 arch/arm/boot/dts/pxa910.dtsi                   | 140 ++++++
 arch/arm/boot/dts/sh7372.dtsi                   |  21 +
 arch/arm/boot/dts/snowball.dts                  |  40 +-
 arch/arm/boot/dts/spear300-evb.dts              | 183 ++++++++
 arch/arm/boot/dts/spear300.dtsi                 |  72 +++
 arch/arm/boot/dts/spear310-evb.dts              | 111 +++++
 arch/arm/boot/dts/spear310.dtsi                 |  75 ++++
 arch/arm/boot/dts/spear320-evb.dts              | 112 +++++
 arch/arm/boot/dts/spear320.dtsi                 |  90 ++++
 arch/arm/boot/dts/spear3xx.dtsi                 | 144 ++++++
 arch/arm/boot/dts/spear600-evb.dts              |   4 +
 arch/arm/boot/dts/spear600.dtsi                 |   8 +
 arch/arm/boot/dts/tny_a9260.dts                 |  15 +
 arch/arm/boot/dts/tny_a9260_common.dtsi         |  83 ++++
 arch/arm/boot/dts/tny_a9263.dts                 |  97 ++++
 arch/arm/boot/dts/tny_a9g20.dts                 |  15 +
 arch/arm/boot/dts/twl4030.dtsi                  |  47 ++
 arch/arm/boot/dts/twl6030.dtsi                  |  86 ++++
 arch/arm/boot/dts/usb_a9260.dts                 |  23 +
 arch/arm/boot/dts/usb_a9260_common.dtsi         | 117 +++++
 arch/arm/boot/dts/usb_a9263.dts                 | 131 ++++++
 arch/arm/boot/dts/usb_a9g20.dts                 | 102 +----
 arch/arm/configs/lpc32xx_defconfig              |  44 +-
 arch/arm/configs/spear3xx_defconfig             |  52 ++-
 arch/arm/configs/spear6xx_defconfig             |  41 +-
 arch/arm/mach-at91/Makefile.boot                |  12 +
 arch/arm/mach-at91/at91sam9260_devices.c        |  20 +-
 arch/arm/mach-at91/at91sam9263.c                |  10 +
 arch/arm/mach-at91/at91sam9263_devices.c        |  20 +
 arch/arm/mach-at91/at91sam9g45_devices.c        |  30 +-
 arch/arm/mach-at91/board-usb-a926x.c            |   4 +
 arch/arm/mach-lpc32xx/Kconfig                   |  26 --
 arch/arm/mach-lpc32xx/clock.c                   |  77 ++--
 arch/arm/mach-lpc32xx/common.c                  | 188 +-------
 arch/arm/mach-lpc32xx/common.h                  |  14 -
 arch/arm/mach-lpc32xx/include/mach/i2c.h        |  63 ---
 arch/arm/mach-lpc32xx/irq.c                     |  78 +++-
 arch/arm/mach-lpc32xx/phy3250.c                 | 149 +++----
 arch/arm/mach-mmp/Kconfig                       |  29 +-
 arch/arm/mach-mmp/Makefile                      |   9 +-
 arch/arm/mach-mmp/include/mach/entry-macro.S    |   4 +-
 arch/arm/mach-mmp/include/mach/irqs.h           |  27 +-
 arch/arm/mach-mmp/irq-mmp2.c                    | 158 -------
 arch/arm/mach-mmp/irq-pxa168.c                  |  54 ---
 arch/arm/mach-mmp/irq.c                         | 445 +++++++++++++++++++
 arch/arm/mach-mmp/mmp-dt.c                      |  66 +--
 arch/arm/mach-mmp/mmp2-dt.c                     |  60 +++
 arch/arm/mach-mmp/time.c                        |  81 +++-
 arch/arm/mach-omap2/board-generic.c             |  37 +-
 arch/arm/mach-omap2/devices.c                   |   9 +-
 arch/arm/mach-omap2/gpio.c                      |   8 +-
 arch/arm/mach-pnx4008/i2c.c                     |  64 +--
 arch/arm/mach-pnx4008/include/mach/i2c.h        |  64 ---
 arch/arm/mach-shmobile/include/mach/common.h    |   2 +
 arch/arm/mach-shmobile/include/mach/intc.h      |  44 ++
 arch/arm/mach-shmobile/include/mach/irqs.h      |   2 +-
 arch/arm/mach-shmobile/intc-sh7372.c            |  34 +-
 arch/arm/mach-shmobile/setup-sh7372.c           |  48 ++
 arch/arm/mach-shmobile/timer.c                  |  17 +
 arch/arm/mach-spear3xx/Kconfig                  |  34 +-
 arch/arm/mach-spear3xx/Makefile                 |  13 +-
 arch/arm/mach-spear3xx/Makefile.boot            |   4 +
 arch/arm/mach-spear3xx/clock.c                  | 280 +++++++++---
 arch/arm/mach-spear3xx/include/mach/generic.h   |  42 +-
 arch/arm/mach-spear3xx/include/mach/hardware.h  |  24 +-
 arch/arm/mach-spear3xx/include/mach/irqs.h      | 130 +-----
 arch/arm/mach-spear3xx/include/mach/misc_regs.h | 144 ------
 arch/arm/mach-spear3xx/include/mach/spear.h     |  47 +-
 arch/arm/mach-spear3xx/include/mach/spear300.h  |  54 ---
 arch/arm/mach-spear3xx/include/mach/spear310.h  |  58 ---
 arch/arm/mach-spear3xx/include/mach/spear320.h  |  67 ---
 arch/arm/mach-spear3xx/spear300.c               | 335 ++++++++++++--
 arch/arm/mach-spear3xx/spear300_evb.c           |  75 ----
 arch/arm/mach-spear3xx/spear310.c               | 391 +++++++++++++++-
 arch/arm/mach-spear3xx/spear310_evb.c           |  81 ----
 arch/arm/mach-spear3xx/spear320.c               | 390 +++++++++++++++-
 arch/arm/mach-spear3xx/spear320_evb.c           |  79 ----
 arch/arm/mach-spear3xx/spear3xx.c               | 152 ++++---
 arch/arm/mach-spear6xx/Makefile.boot            |   2 +
 arch/arm/mach-spear6xx/clock.c                  | 186 ++++++--
 arch/arm/mach-spear6xx/include/mach/generic.h   |  29 +-
 arch/arm/mach-spear6xx/include/mach/hardware.h  |  24 +-
 arch/arm/mach-spear6xx/include/mach/irqs.h      |  75 +---
 arch/arm/mach-spear6xx/include/mach/misc_regs.h | 154 -------
 arch/arm/mach-spear6xx/include/mach/spear.h     |  55 +--
 arch/arm/mach-spear6xx/include/mach/spear600.h  |  21 -
 arch/arm/mach-spear6xx/spear6xx.c               | 417 ++++++++++++++++-
 arch/arm/mach-ux500/board-mop500.c              |  31 +-
 arch/arm/mach-ux500/cpu-db8500.c                |  18 +-
 arch/arm/mach-ux500/timer.c                     |  24 +
 arch/arm/plat-spear/Kconfig                     |   3 +-
 arch/arm/plat-spear/Makefile                    |   2 +-
 arch/arm/plat-spear/include/plat/debug-macro.S  |   2 +-
 arch/arm/plat-spear/include/plat/hardware.h     |  17 -
 arch/arm/plat-spear/include/plat/pl080.h        |  21 +
 arch/arm/plat-spear/include/plat/uncompress.h   |   2 +-
 arch/arm/plat-spear/pl080.c                     |  80 ++++
 arch/arm/plat-spear/restart.c                   |   2 +-
 arch/arm/plat-spear/time.c                      |  17 +-
 drivers/gpio/gpio-pxa.c                         | 116 ++++-
 drivers/i2c/busses/i2c-pnx.c                    | 157 +++++--
 drivers/net/ethernet/nxp/lpc_eth.c              |  71 ++-
 drivers/of/address.c                            |   1 +
 include/linux/i2c-pnx.h                         |  10 +-
 138 files changed, 7736 insertions(+), 2906 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/lpc32xx-mic.txt
 create mode 100644 Documentation/devicetree/bindings/arm/lpc32xx.txt
 create mode 100644 Documentation/devicetree/bindings/arm/mrvl/intc.txt
 rename Documentation/devicetree/bindings/arm/{ => mrvl}/mrvl.txt (53%)
 create mode 100644 Documentation/devicetree/bindings/arm/mrvl/timer.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-nmk.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/pnx.txt
 create mode 100644 Documentation/devicetree/bindings/net/lpc-eth.txt
 create mode 100644 arch/arm/boot/dts/at91sam9260.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9263.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9263ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9g20ek.dts
 create mode 100644 arch/arm/boot/dts/at91sam9g20ek_2mmc.dts
 create mode 100644 arch/arm/boot/dts/at91sam9g20ek_common.dtsi
 create mode 100644 arch/arm/boot/dts/ethernut5.dts
 create mode 100644 arch/arm/boot/dts/kizbox.dts
 create mode 100644 arch/arm/boot/dts/lpc32xx.dtsi
 create mode 100644 arch/arm/boot/dts/mmp2-brownstone.dts
 create mode 100644 arch/arm/boot/dts/mmp2.dtsi
 create mode 100644 arch/arm/boot/dts/phy3250.dts
 create mode 100644 arch/arm/boot/dts/pxa910-dkb.dts
 create mode 100644 arch/arm/boot/dts/pxa910.dtsi
 create mode 100644 arch/arm/boot/dts/sh7372.dtsi
 create mode 100644 arch/arm/boot/dts/spear300-evb.dts
 create mode 100644 arch/arm/boot/dts/spear300.dtsi
 create mode 100644 arch/arm/boot/dts/spear310-evb.dts
 create mode 100644 arch/arm/boot/dts/spear310.dtsi
 create mode 100644 arch/arm/boot/dts/spear320-evb.dts
 create mode 100644 arch/arm/boot/dts/spear320.dtsi
 create mode 100644 arch/arm/boot/dts/spear3xx.dtsi
 create mode 100644 arch/arm/boot/dts/tny_a9260.dts
 create mode 100644 arch/arm/boot/dts/tny_a9260_common.dtsi
 create mode 100644 arch/arm/boot/dts/tny_a9263.dts
 create mode 100644 arch/arm/boot/dts/tny_a9g20.dts
 create mode 100644 arch/arm/boot/dts/twl4030.dtsi
 create mode 100644 arch/arm/boot/dts/twl6030.dtsi
 create mode 100644 arch/arm/boot/dts/usb_a9260.dts
 create mode 100644 arch/arm/boot/dts/usb_a9260_common.dtsi
 create mode 100644 arch/arm/boot/dts/usb_a9263.dts
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/i2c.h
 delete mode 100644 arch/arm/mach-mmp/irq-mmp2.c
 delete mode 100644 arch/arm/mach-mmp/irq-pxa168.c
 create mode 100644 arch/arm/mach-mmp/irq.c
 create mode 100644 arch/arm/mach-mmp/mmp2-dt.c
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/i2c.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/spear300.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/spear310.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/spear320.h
 delete mode 100644 arch/arm/mach-spear3xx/spear300_evb.c
 delete mode 100644 arch/arm/mach-spear3xx/spear310_evb.c
 delete mode 100644 arch/arm/mach-spear3xx/spear320_evb.c
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/spear600.h
 delete mode 100644 arch/arm/plat-spear/include/plat/hardware.h
 create mode 100644 arch/arm/plat-spear/include/plat/pl080.h
 create mode 100644 arch/arm/plat-spear/pl080.c
