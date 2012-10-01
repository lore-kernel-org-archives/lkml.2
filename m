Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab2JAX67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:58:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758823Ab2JAX5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:45 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 8/12] ARM: soc: driver specific changes
Date: Mon,  1 Oct 2012 16:57:03 -0700
Message-Id: <1349135827-24790-9-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- A long-coming conversion of various platforms to a common LED
  infrastructure
- AT91 is moved over to use the newer MCI driver for MMC
- Pincontrol conversions for samsung platforms
- DT bindings for gscaler on samsung
- i2c driver fixes for tegra, acked by i2c maintainer

Conflicts:
* add/add conflicts in arch/arm/boot/dts/omap4.dtsi, keep both sides.
* remove/remove conflict in arch/arm/mach-clps711x/common.c, keep HEAD
* Add/add conflicts on arch/arm/mach-omap*/*, keep both sides.
* driver/Makefile add/add conflict with bus and irqchip. Keep both.
* drivers/bus/omap_l3_noc.c conflicts with static vs variable IRQs, keep
  the variable case (from this branch).
* Removal/change conflict of two led files and an nxp4008 file, remove
  them all.

----------------------------------------------------------------

The following changes since commit 5c008d7029fcd12a9a54fa618781b71353f6c4bd:

  Merge branch 'next/soc2' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers

for you to fetch changes up to 04ef037c926ddb31088c976538e29eada4fd1490:

  Merge branch 'samsung/pinctrl' into next/drivers

----------------------------------------------------------------

Arnd Bergmann (4):
      Merge branch 'for-arm-soc' of git://git.kernel.org/.../cooloney/linux-leds into next/drivers
      Merge tag 'at91-for-next-soc' of git://github.com/at91linux/linux-at91 into at91/mci
      Merge branch 'drivers/ocp2scp' into next/drivers
      Merge branch 'drivers/ocp2scp' into next/drivers

Bryan Wu (18):
      led-triggers: create a trigger for CPU activity
      ARM: at91: convert old leds drivers to gpio_led and led_trigger drivers
      ARM: mach-realview and mach-versatile: retire custom LED code
      ARM: mach-ks8695: remove leds driver, since nobody use it
      ARM: mach-shark: retire custom LED code
      ARM: mach-orion5x: convert custom LED code to gpio_led and LED CPU trigger
      ARM: mach-integrator: move CM_CTRL to header file for accessing by other functions
      ARM: mach-integrator: retire custom LED code
      ARM: mach-clps711x: retire custom LED code of P720T machine
      ARM: mach-ebsa110: retire custom LED code
      ARM: mach-footbridge: retire custom LED code
      char: nwflash: remove old led event code
      ARM: mach-pxa: retire custom LED code
      ARM: plat-samsung: remove including old leds event API header file
      ARM: mach-pnx4008: remove including old leds event API header file
      ARM: mach-omap1: retire custom LED code
      ARM: mach-sa1100: retire custom LED code
      ARM: use new LEDS CPU trigger stub to replace old one

Kishon Vijay Abraham I (3):
      drivers: bus: add a new driver for omap-ocp2scp
      arm/dts: omap4: Add ocp2scp data
      drivers: bus: omap-ocp2scp: Fix compile error

Laxman Dewangan (6):
      ARM: tegra: clock: add i2c fast clock entry in clock table
      i2c: tegra: pass proper name for getting clock
      ARM: tegra: clock: add connection name in i2c clock entry
      ARM: tegra: clock: remove unused clock entry for i2c
      i2c: tegra: I2_M_NOSTART functionality not supported in Tegra20
      i2c: tegra: dynamically control fast clk

Ludovic Desroches (1):
      ARM: at91: add atmel-mci support for chips and boards which can use it

Nicolas Ferre (1):
      ARM: at91/defconfig: change the MCI driver to use in defconfigs

Olof Johansson (7):
      Merge branch 'drivers/ocp2scp' into next/drivers
      Merge tag 'tegra-for-3.7-drivers-i2c' of git://git.kernel.org/.../swarren/linux-tegra into next/drivers
      drivers: bus: omap_l3: use resources instead of hardcoded irqs
      Merge branch 'drivers/ocp2scp' into next/drivers
      Merge branch 'next/pinctrl-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'next/dt-gscaler' of git://git.kernel.org/.../kgene/linux-samsung into next/drivers
      Merge branch 'samsung/pinctrl' into next/drivers

Paul Bolle (1):
      ARM: at91: set i2c_board_info.type to "ds1339" directly

Richard Genoud (1):
      ARM: at91/defconfig: Remove unaffected config option

Santosh Shilimkar (1):
      drivers: bus: Move the OMAP interconnect driver to drivers/bus/

Shaik Ameer Basha (2):
      ARM: EXYNOS: Add clock support for G-Scaler
      ARM: EXYNOS: Adds G-Scaler device from Device Tree

Thomas Abraham (6):
      pinctrl: add samsung pinctrl and gpiolib driver
      pinctrl: add exynos4210 specific extensions for samsung pinctrl driver
      gpio: exynos4: skip gpiolib registration if pinctrl driver is used
      ARM: EXYNOS: skip wakeup interrupt setup if pinctrl driver is used
      ARM: dts: Add pinctrl node entries for SAMSUNG EXYNOS4210 SoC
      ARM: EXYNOS: Enable pinctrl driver support for EXYNOS4 device tree enabled platform

Tomasz Figa (7):
      pinctrl: exynos: Set pin function to EINT in irq_set_type of GPIO EINTa
      pinctrl: exynos: Fix typos in gpio/wkup _irq_mask
      pinctrl: exynos: Handle only unmasked wakeup interrupts
      pinctrl: exynos: Mark exynos_irq_demux_eint as inline
      pinctrl: exynos: Correct the detection of wakeup-eint node
      pinctrl: samsung: Uninline samsung_pinctrl_get_soc_data
      pinctrl: exynos: Fix wakeup IRQ domain registration check


 .../devicetree/bindings/bus/omap-ocp2scp.txt    |  10 +
 .../devicetree/bindings/media/exynos5-gsc.txt   |  30 +
 .../bindings/pinctrl/samsung-pinctrl.txt        | 196 ++++
 arch/arm/Kconfig                                |  53 --
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi       | 457 ++++++++++
 arch/arm/boot/dts/exynos4210.dtsi               |  37 +
 arch/arm/boot/dts/exynos5250.dtsi               |  28 +
 arch/arm/boot/dts/omap4.dtsi                    |   8 +
 arch/arm/configs/afeb9260_defconfig             |   1 -
 arch/arm/configs/at91rm9200_defconfig           |   2 +-
 arch/arm/configs/at91sam9261_defconfig          |   2 +-
 arch/arm/configs/at91sam9263_defconfig          |   3 +-
 arch/arm/configs/at91sam9g20_defconfig          |   2 +-
 arch/arm/configs/at91sam9rl_defconfig           |   2 +-
 arch/arm/configs/cpu9260_defconfig              |   2 +-
 arch/arm/configs/cpu9g20_defconfig              |   2 +-
 arch/arm/configs/qil-a9260_defconfig            |   3 +-
 arch/arm/configs/stamp9g20_defconfig            |   1 -
 arch/arm/configs/usb-a9260_defconfig            |   1 -
 arch/arm/include/asm/leds.h                     |  50 --
 arch/arm/kernel/Makefile                        |   1 -
 arch/arm/kernel/leds.c                          | 121 ---
 arch/arm/kernel/process.c                       |   6 +-
 arch/arm/kernel/time.c                          |  17 -
 arch/arm/mach-at91/at91rm9200_devices.c         |  92 +-
 arch/arm/mach-at91/at91sam9260_devices.c        |  84 +-
 arch/arm/mach-at91/at91sam9261_devices.c        |  60 +-
 arch/arm/mach-at91/at91sam9263.c                |   4 +-
 arch/arm/mach-at91/at91sam9263_devices.c        | 161 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c         |  60 +-
 arch/arm/mach-at91/board-afeb-9260v1.c          |  14 +-
 arch/arm/mach-at91/board-carmeva.c              |  14 +-
 arch/arm/mach-at91/board-cpu9krea.c             |  17 +-
 arch/arm/mach-at91/board-cpuat91.c              |  13 +-
 arch/arm/mach-at91/board-csb337.c               |  16 +-
 arch/arm/mach-at91/board-eb9200.c               |  14 +-
 arch/arm/mach-at91/board-ecbat91.c              |  32 +-
 arch/arm/mach-at91/board-eco920.c               |  36 +-
 arch/arm/mach-at91/board-flexibity.c            |  14 +-
 arch/arm/mach-at91/board-foxg20.c               |  16 +-
 arch/arm/mach-at91/board-kafa.c                 |  17 +-
 arch/arm/mach-at91/board-kb9202.c               |  37 +-
 arch/arm/mach-at91/board-neocore926.c           |  13 +-
 arch/arm/mach-at91/board-picotux200.c           |  14 +-
 arch/arm/mach-at91/board-qil-a9260.c            |  14 +-
 arch/arm/mach-at91/board-rm9200dk.c             |  17 +-
 arch/arm/mach-at91/board-rm9200ek.c             |  17 +-
 arch/arm/mach-at91/board-rsi-ews.c              |  16 +-
 arch/arm/mach-at91/board-sam9-l9260.c           |  39 +-
 arch/arm/mach-at91/board-sam9260ek.c            |  16 +-
 arch/arm/mach-at91/board-sam9261ek.c            |  16 +-
 arch/arm/mach-at91/board-sam9263ek.c            |  13 +-
 arch/arm/mach-at91/board-sam9g20ek.c            |  16 +-
 arch/arm/mach-at91/board-sam9rlek.c             |  13 +-
 arch/arm/mach-at91/board-stamp9g20.c            |  14 -
 arch/arm/mach-at91/board-usb-a926x.c            |   2 -
 arch/arm/mach-at91/board-yl-9200.c              |  16 +-
 arch/arm/mach-at91/include/mach/board.h         |   1 -
 arch/arm/mach-at91/leds.c                       | 105 ---
 arch/arm/mach-clps711x/Makefile                 |   2 -
 arch/arm/mach-clps711x/p720t-leds.c             |  63 --
 arch/arm/mach-clps711x/p720t.c                  |  62 ++
 arch/arm/mach-ebsa110/Makefile                  |   4 +-
 arch/arm/mach-ebsa110/leds.c                    |  81 +-
 arch/arm/mach-exynos/Kconfig                    |   2 +
 arch/arm/mach-exynos/clock-exynos5.c            |  86 ++
 arch/arm/mach-exynos/common.c                   |  26 +
 arch/arm/mach-exynos/include/mach/map.h         |   5 +
 arch/arm/mach-exynos/mach-exynos5-dt.c          |   8 +
 arch/arm/mach-footbridge/Makefile               |   4 -
 arch/arm/mach-footbridge/ebsa285-leds.c         | 138 ---
 arch/arm/mach-footbridge/ebsa285.c              |  81 ++
 arch/arm/mach-footbridge/netwinder-hw.c         | 112 ++-
 arch/arm/mach-footbridge/netwinder-leds.c       | 138 ---
 arch/arm/mach-integrator/Makefile               |   3 +-
 arch/arm/mach-integrator/core.c                 |   3 -
 arch/arm/mach-integrator/include/mach/cm.h      |   2 +
 arch/arm/mach-integrator/leds.c                 | 161 ++--
 arch/arm/mach-ks8695/Makefile                   |   3 -
 arch/arm/mach-ks8695/devices.c                  |  21 -
 arch/arm/mach-ks8695/include/mach/devices.h     |   5 -
 arch/arm/mach-ks8695/leds.c                     |  92 --
 arch/arm/mach-omap1/Makefile                    |   8 -
 arch/arm/mach-omap1/board-h2.c                  |  32 +
 arch/arm/mach-omap1/board-h3.c                  |  32 +
 arch/arm/mach-omap1/board-osk.c                 |  33 +
 arch/arm/mach-omap1/leds-h2p2-debug.c           | 169 ----
 arch/arm/mach-omap1/leds-innovator.c            |  98 --
 arch/arm/mach-omap1/leds-osk.c                  | 113 ---
 arch/arm/mach-omap1/leds.c                      |  70 --
 arch/arm/mach-omap1/leds.h                      |   3 -
 arch/arm/mach-omap1/time.c                      |   1 -
 arch/arm/mach-omap1/timer32k.c                  |   1 -
 arch/arm/mach-omap2/Kconfig                     |   2 +
 arch/arm/mach-omap2/Makefile                    |   5 -
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c    |   1 -
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c     |   1 -
 arch/arm/mach-orion5x/rd88f5182-setup.c         |  72 +-
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c    |   1 -
 arch/arm/mach-pxa/Makefile                      |   8 -
 arch/arm/mach-pxa/idp.c                         |  81 ++
 arch/arm/mach-pxa/leds-idp.c                    | 115 ---
 arch/arm/mach-pxa/leds-lubbock.c                | 124 ---
 arch/arm/mach-pxa/leds-mainstone.c              | 119 ---
 arch/arm/mach-pxa/leds.c                        |  32 -
 arch/arm/mach-pxa/leds.h                        |  13 -
 arch/arm/mach-pxa/lubbock.c                     |  95 ++
 arch/arm/mach-pxa/mainstone.c                   |  94 ++
 arch/arm/mach-realview/core.c                   |  39 -
 arch/arm/mach-realview/core.h                   |   2 -
 arch/arm/mach-realview/realview_eb.c            |   5 -
 arch/arm/mach-realview/realview_pb1176.c        |   5 -
 arch/arm/mach-realview/realview_pb11mp.c        |   5 -
 arch/arm/mach-realview/realview_pba8.c          |   5 -
 arch/arm/mach-realview/realview_pbx.c           |   5 -
 arch/arm/mach-sa1100/Makefile                   |   9 -
 arch/arm/mach-sa1100/assabet.c                  |  85 ++
 arch/arm/mach-sa1100/badge4.c                   |  30 +
 arch/arm/mach-sa1100/cerf.c                     |  42 +
 arch/arm/mach-sa1100/hackkit.c                  |  32 +
 arch/arm/mach-sa1100/lart.c                     |  26 +
 arch/arm/mach-sa1100/leds-assabet.c             | 113 ---
 arch/arm/mach-sa1100/leds-badge4.c              | 110 ---
 arch/arm/mach-sa1100/leds-cerf.c                | 110 ---
 arch/arm/mach-sa1100/leds-hackkit.c             | 112 ---
 arch/arm/mach-sa1100/leds-lart.c                | 101 ---
 arch/arm/mach-sa1100/leds.c                     |  50 --
 arch/arm/mach-sa1100/leds.h                     |  13 -
 arch/arm/mach-shark/Makefile                    |   4 +-
 arch/arm/mach-shark/core.c                      |   1 -
 arch/arm/mach-shark/leds.c                      | 220 ++---
 arch/arm/mach-tegra/tegra20_clocks_data.c       |  20 +-
 arch/arm/mach-tegra/tegra30_clocks_data.c       |  15 +-
 arch/arm/mach-versatile/core.c                  |   5 -
 arch/arm/plat-omap/Kconfig                      |   3 +-
 arch/arm/plat-omap/debug-leds.c                 | 293 ++----
 arch/arm/plat-samsung/time.c                    |   1 -
 arch/arm/plat-versatile/Kconfig                 |   4 +-
 arch/arm/plat-versatile/leds.c                  |   8 +-
 drivers/Kconfig                                 |   2 +
 drivers/Makefile                                |   1 +
 drivers/bus/Kconfig                             |  21 +
 drivers/bus/Makefile                            |   8 +
 drivers/bus/omap-ocp2scp.c                      |  88 ++
 .../mach-omap2 => drivers/bus}/omap_l3_noc.c    |   4 +-
 .../mach-omap2 => drivers/bus}/omap_l3_noc.h    |   0
 .../mach-omap2 => drivers/bus}/omap_l3_smx.c    |   0
 .../mach-omap2 => drivers/bus}/omap_l3_smx.h    |   0
 drivers/char/nwflash.c                          |  34 -
 drivers/gpio/gpio-samsung.c                     |  21 +
 drivers/i2c/busses/i2c-tegra.c                  | 130 ++-
 drivers/leds/Kconfig                            |  10 +
 drivers/leds/Makefile                           |   1 +
 drivers/leds/ledtrig-cpu.c                      | 163 ++++
 drivers/mtd/nand/Kconfig                        |  40 -
 drivers/pinctrl/Kconfig                         |   9 +
 drivers/pinctrl/Makefile                        |   2 +
 drivers/pinctrl/pinctrl-exynos.c                | 579 ++++++++++++
 drivers/pinctrl/pinctrl-exynos.h                | 218 +++++
 drivers/pinctrl/pinctrl-samsung.c               | 888 +++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h               | 239 +++++
 include/linux/leds.h                            |  16 +
 162 files changed, 4908 insertions(+), 3542 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-gsc.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/samsung-pinctrl.txt
 create mode 100644 arch/arm/boot/dts/exynos4210-pinctrl.dtsi
 delete mode 100644 arch/arm/include/asm/leds.h
 delete mode 100644 arch/arm/kernel/leds.c
 delete mode 100644 arch/arm/mach-clps711x/p720t-leds.c
 delete mode 100644 arch/arm/mach-footbridge/ebsa285-leds.c
 delete mode 100644 arch/arm/mach-footbridge/netwinder-leds.c
 delete mode 100644 arch/arm/mach-ks8695/leds.c
 delete mode 100644 arch/arm/mach-omap1/leds-h2p2-debug.c
 delete mode 100644 arch/arm/mach-omap1/leds-innovator.c
 delete mode 100644 arch/arm/mach-omap1/leds-osk.c
 delete mode 100644 arch/arm/mach-omap1/leds.c
 delete mode 100644 arch/arm/mach-omap1/leds.h
 delete mode 100644 arch/arm/mach-pxa/leds-idp.c
 delete mode 100644 arch/arm/mach-pxa/leds-lubbock.c
 delete mode 100644 arch/arm/mach-pxa/leds-mainstone.c
 delete mode 100644 arch/arm/mach-pxa/leds.c
 delete mode 100644 arch/arm/mach-pxa/leds.h
 delete mode 100644 arch/arm/mach-sa1100/leds-assabet.c
 delete mode 100644 arch/arm/mach-sa1100/leds-badge4.c
 delete mode 100644 arch/arm/mach-sa1100/leds-cerf.c
 delete mode 100644 arch/arm/mach-sa1100/leds-hackkit.c
 delete mode 100644 arch/arm/mach-sa1100/leds-lart.c
 delete mode 100644 arch/arm/mach-sa1100/leds.c
 delete mode 100644 arch/arm/mach-sa1100/leds.h
 create mode 100644 drivers/bus/Kconfig
 create mode 100644 drivers/bus/Makefile
 create mode 100644 drivers/bus/omap-ocp2scp.c
 rename {arch/arm/mach-omap2 => drivers/bus}/omap_l3_noc.c (98%)
 rename {arch/arm/mach-omap2 => drivers/bus}/omap_l3_noc.h (100%)
 rename {arch/arm/mach-omap2 => drivers/bus}/omap_l3_smx.c (100%)
 rename {arch/arm/mach-omap2 => drivers/bus}/omap_l3_smx.h (100%)
 create mode 100644 drivers/leds/ledtrig-cpu.c
 create mode 100644 drivers/pinctrl/pinctrl-exynos.c
 create mode 100644 drivers/pinctrl/pinctrl-exynos.h
 create mode 100644 drivers/pinctrl/pinctrl-samsung.c
 create mode 100644 drivers/pinctrl/pinctrl-samsung.h
