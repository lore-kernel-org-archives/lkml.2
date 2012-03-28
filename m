Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2C1HPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:15:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2C1HOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:14:44 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/5] ARM: More device tree support updates
Date: Wed, 28 Mar 2012 00:14:01 -0700
Message-Id: <1332918842-13521-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
In-Reply-To: <1332918842-13521-1-git-send-email-olof@lixom.net>
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch contains a number of updates for device tree support on
several ARM platforms, in particular:

* AT91 continues the device tree conversion adding support for a number of
on-chip drivers and other functionality
* ux500 adds probing of some of the core SoC blocks through device tree
* Initial device tree support for ST SPEAr600 platforms
* kirkwood continues the conversion to device-tree probing


Merge conflicts and proposed solutions:

arch/arm/mach-ux500/Kconfig: Two new config options. Keep both.

drivers/usb/gadget/at91_udc.c: Context changes, linux/prefetch.h has
already been added in a previous commit.


-Olof

----------------------------------------------------------------

The following changes since commit 43b9c8b099be92115b4103271881426d5cef50ff:

  Merge tag 'soc2' into for-next

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt2

for you to fetch changes up to 7d1206bc2859c6e9f46e35ae697c138e7d7858a7:

  Merge branch 'kirkwood/dt' into next/dt2

----------------------------------------------------------------

Andrew Lunn (2):
      ARM: orion: spi: remove enable_clock_fix which is not used
      ARM: Kirkwood: Remove tclk from kirkwood_asoc_platform_data.

Arnd Bergmann (12):
      Merge branch 'at91-3.4-cleanup2-DT2' of git://github.com/at91linux/linux-at91 into next/dt
      Merge branch 'at91-3.4-cleanup2-DT2+USB' of git://github.com/at91linux/linux-at91 into next/dt
      Merge branch 'ux500/soc' into ux500/dt
      Merge branch 'depends/driver-core' into ux500/dt
      ARM: ux500: Initial Device Tree support for Snowball
      ARM: ux500: combine the board init functions for DT boot
      ARM: ux500: split dts file for snowball into generic part
      Merge branch 'ux500/dt' into next/dt2
      Merge branch 'kirkwood_dt_for_3.4_v3' of git://git.infradead.org/users/jcooper/linux-kirkwood into kirkwood/dt
      Merge branch 'spear/dt' into next/dt2
      Merge branch 'for-3.4/dt' of git://git.kernel.org/.../olof/tegra into next/dt2
      Merge branch 'kirkwood/dt' into next/dt2

Jason Cooper (7):
      ARM: orion: wdt: use resource vice direct access
      ARM: kirkwood: fdt: use mrvl ticker symbol
      ARM: kirkwood: fdt: absorb kirkwood_init()
      ARM: kirkwood: fdt: facilitate new boards during fdt migration
      ARM: kirkwood: fdt: define uart[01] as disabled, enable uart0
      ARM: kirkwood: rtc-mv devicetree bindings
      ARM: kirkwood: use devicetree for rtc-mv

Jean-Christophe PLAGNIOL-VILLARD (25):
      ATMEL: fix nand ecc support
      mtd/atmel_nand: add on_flash_bbt to enable the use of On Flash BBT
      ARM: at91: enable on flash bbt for Atmel Reference and DT boards
      of: introduce helper to manage boolean
      of/mtd/nand: add generic bindings and helpers
      atmel/nand: add DT support
      ARM: at91: sam9x5 add nand support
      i2c/gpio: add DT support
      ARM: at91: sam9g20 add i2c DT support
      ARM: at91: usb_a9g20 add DT i2c support
      ARM: at91: sam9g45 add i2c DT support
      ARM: at91: sam9x5 add i2c DT support
      ARM: at91/dt: add Calao DAB-MMX daugther board support for USB-A9G20
      ARM: at91/dt: add specific DT soc init
      ARM: at91: add pmc DT support
      ARM: at91: always enable sam9 restart
      ARM: at91: add RSTC (Reset Controller) dt support
      ARM: at91: add ram controller DT support
      ARM: at91: add Shutdown Controller (SHDWC) DT support
      ARM: at91: usb ohci add dt support
      ARM: at91: dt: enable usb ohci for sam9g20, sam9g45 amd sam9x5
      ARM: at91: usb ehci add dt support
      ARM: at91: dt: enable usb ehci for sam9g45 and sam9x5
      USB: at91: Device udc add dt support
      ARM: at91: sam9g20 udc add dt support

Lee Jones (7):
      ARM: ux500: CONFIG: Enable Device Tree support for future endeavours
      ARM: ux500: db8500: list most devices in the snowball device tree
      ARM: ux500: Enable Cortex-A9 GIC (Generic Interrupt Controller) in Device Tree
      ARM: ux500: Enable PL011 AMBA UART Controller for Device Tree
      ARM: ux500: Enable PL310 Level 2 Cache Controller in Device Tree
      ARM: ux500: Enable PL022 SSP Controller in Device Tree
      ARM: ux500: Provide local timer support for Device Tree

Simon Glass (3):
      arm: tegra: dts: Support host/device selection and legacy mode
      arm: tegra: dts: Add legacy mode support to Tegra2x USB1 port
      arm: tegra: dts: Mark USB1 as an OTG port on Seaboard

Stefan Roese (1):
      ARM: SPEAr600: Add device-tree support to SPEAr600 boards


 .../devicetree/bindings/arm/atmel-at91.txt         |   60 ++++
 .../devicetree/bindings/arm/atmel-pmc.txt          |   11 +
 Documentation/devicetree/bindings/arm/spear.txt    |    8 +
 .../devicetree/bindings/gpio/gpio_i2c.txt          |   32 ++
 .../devicetree/bindings/mtd/atmel-nand.txt         |   41 +++
 Documentation/devicetree/bindings/mtd/nand.txt     |    7 +
 .../devicetree/bindings/usb/atmel-usb.txt          |   49 +++
 .../devicetree/bindings/usb/tegra-usb.txt          |   13 +
 arch/arm/boot/dts/at91sam9g20.dtsi                 |   63 ++++
 arch/arm/boot/dts/at91sam9g25ek.dts                |   14 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   64 ++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   46 ++-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |   88 +++++
 arch/arm/boot/dts/at91sam9x5cm.dtsi                |   45 +++
 arch/arm/boot/dts/db8500.dtsi                      |  275 +++++++++++++++
 arch/arm/boot/dts/kirkwood-dreamplug.dts           |   13 +-
 arch/arm/boot/dts/kirkwood.dtsi                    |   34 +-
 arch/arm/boot/dts/snowball.dts                     |  139 ++++++++
 arch/arm/boot/dts/spear600-evb.dts                 |   47 +++
 arch/arm/boot/dts/spear600.dtsi                    |  174 +++++++++
 arch/arm/boot/dts/tegra-seaboard.dts               |    1 +
 arch/arm/boot/dts/tegra20.dtsi                     |    1 +
 arch/arm/boot/dts/usb_a9g20-dab-mmx.dtsi           |   96 +++++
 arch/arm/boot/dts/usb_a9g20.dts                    |   74 +++-
 arch/arm/configs/at91sam9g20_defconfig             |    3 +
 arch/arm/configs/u8500_defconfig                   |    1 +
 arch/arm/mach-at91/Kconfig                         |   10 +-
 arch/arm/mach-at91/at91sam9260.c                   |    1 +
 arch/arm/mach-at91/at91sam9g45.c                   |    2 +
 arch/arm/mach-at91/at91sam9x5.c                    |   17 +-
 arch/arm/mach-at91/board-afeb-9260v1.c             |    1 +
 arch/arm/mach-at91/board-cam60.c                   |    1 +
 arch/arm/mach-at91/board-cpu9krea.c                |    1 +
 arch/arm/mach-at91/board-dt.c                      |   57 +--
 arch/arm/mach-at91/board-kb9202.c                  |    1 +
 arch/arm/mach-at91/board-neocore926.c              |    1 +
 arch/arm/mach-at91/board-qil-a9260.c               |    2 +
 arch/arm/mach-at91/board-rm9200dk.c                |    2 +
 arch/arm/mach-at91/board-sam9-l9260.c              |    1 +
 arch/arm/mach-at91/board-sam9260ek.c               |    2 +
 arch/arm/mach-at91/board-sam9261ek.c               |    2 +
 arch/arm/mach-at91/board-sam9263ek.c               |    2 +
 arch/arm/mach-at91/board-sam9g20ek.c               |    2 +
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    2 +
 arch/arm/mach-at91/board-sam9rlek.c                |    2 +
 arch/arm/mach-at91/board-snapper9260.c             |    1 +
 arch/arm/mach-at91/board-stamp9g20.c               |    1 +
 arch/arm/mach-at91/board-usb-a926x.c               |    2 +
 arch/arm/mach-at91/board-yl-9200.c                 |    1 +
 arch/arm/mach-at91/clock.c                         |   56 ++-
 arch/arm/mach-at91/generic.h                       |    2 +
 arch/arm/mach-at91/include/mach/at91_shdwc.h       |    4 +-
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |    5 -
 arch/arm/mach-at91/include/mach/board.h            |   15 +-
 arch/arm/mach-at91/pm.c                            |   13 -
 arch/arm/mach-at91/setup.c                         |  158 +++++++++
 arch/arm/mach-kirkwood/Makefile                    |    1 +
 arch/arm/mach-kirkwood/board-dreamplug.c           |  152 ++++++++
 arch/arm/mach-kirkwood/board-dt.c                  |  151 ++------
 arch/arm/mach-kirkwood/common.c                    |   11 +-
 arch/arm/mach-kirkwood/common.h                    |   15 +
 arch/arm/mach-spear6xx/Kconfig                     |    7 +-
 arch/arm/mach-spear6xx/Makefile                    |    6 -
 arch/arm/mach-spear6xx/clock.c                     |   14 +-
 arch/arm/mach-spear6xx/spear600.c                  |   25 --
 arch/arm/mach-spear6xx/spear600_evb.c              |   54 ---
 arch/arm/mach-spear6xx/spear6xx.c                  |  132 ++-----
 arch/arm/mach-ux500/Kconfig                        |    6 +
 arch/arm/mach-ux500/Makefile.boot                  |    1 +
 arch/arm/mach-ux500/board-mop500.c                 |   99 +++++-
 arch/arm/mach-ux500/cache-l2x0.c                   |    7 +-
 arch/arm/mach-ux500/cpu.c                          |   14 +-
 arch/arm/mach-ux500/timer.c                        |   11 +-
 arch/arm/plat-orion/common.c                       |    7 +-
 arch/arm/plat-orion/include/plat/audio.h           |    1 -
 arch/avr32/boards/atngw100/setup.c                 |    1 +
 arch/avr32/boards/atstk1000/atstk1002.c            |    1 +
 arch/avr32/mach-at32ap/include/mach/board.h        |   13 +-
 drivers/i2c/busses/i2c-gpio.c                      |   98 +++--
 drivers/mtd/nand/atmel_nand.c                      |  136 +++++--
 drivers/of/Kconfig                                 |    4 +
 drivers/of/Makefile                                |    1 +
 drivers/of/of_mtd.c                                |   85 +++++
 drivers/rtc/rtc-mv.c                               |    9 +
 drivers/spi/spi-orion.c                            |    5 -
 drivers/usb/Kconfig                                |    2 +-
 drivers/usb/gadget/Kconfig                         |    2 +-
 drivers/usb/gadget/at91_udc.c                      |   41 ++-
 drivers/usb/host/ehci-atmel.c                      |   24 +-
 drivers/usb/host/ohci-at91.c                       |  101 +++++-
 drivers/watchdog/orion_wdt.c                       |   24 +-
 include/linux/of.h                                 |   16 +
 include/linux/of_mtd.h                             |   19 +
 include/linux/platform_data/atmel.h                |   27 ++
 include/linux/spi/orion_spi.h                      |    1 -
 95 files changed, 2536 insertions(+), 554 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/atmel-pmc.txt
 create mode 100644 Documentation/devicetree/bindings/arm/spear.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio_i2c.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/atmel-nand.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/nand.txt
 create mode 100644 Documentation/devicetree/bindings/usb/atmel-usb.txt
 create mode 100644 arch/arm/boot/dts/db8500.dtsi
 create mode 100644 arch/arm/boot/dts/snowball.dts
 create mode 100644 arch/arm/boot/dts/spear600-evb.dts
 create mode 100644 arch/arm/boot/dts/spear600.dtsi
 create mode 100644 arch/arm/boot/dts/usb_a9g20-dab-mmx.dtsi
 create mode 100644 arch/arm/mach-kirkwood/board-dreamplug.c
 delete mode 100644 arch/arm/mach-spear6xx/spear600.c
 delete mode 100644 arch/arm/mach-spear6xx/spear600_evb.c
 create mode 100644 drivers/of/of_mtd.c
 create mode 100644 include/linux/of_mtd.h
 create mode 100644 include/linux/platform_data/atmel.h
