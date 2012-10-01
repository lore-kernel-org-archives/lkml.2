Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab2JAX5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:57:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2JAX5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:37 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/12] ARM: soc: soc-specific updates
Date: Mon,  1 Oct 2012 16:56:59 -0700
Message-Id: <1349135827-24790-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most notable here is probably the addition of basic support for the
BCM2835, an SoC used in some of the Roku 2 players as well as the
much-hyped Raspberry Pi, cleaned up and contributed by Stephen
Warren. It's still early days on mainline support, with just the
basics working. But it has to start somewhere!

Beyond that there's some conversions of clock infrastructure on tegra
to common clock, misc updates for several other platforms, and OMAP
now has its own bus (under drivers/bus) to manage its devices through.

This branch adds two new directories outside of arch/arm:
drivers/irqchip for new irq controllers, and drivers/bus for the above
OMAP bus. It's expected that some of the other platforms will migrate
parts of their platforms to those directories over time as well.

Conflicts:
* Trivial add/add conflict in arch/arm/mach-ux500/cpu.c
* Trivial add/add conflict in drivers/clocksource/Makefile
* Change/delete conflict in arch/arm/mach-ux500/clock.c. Remove the file.


----------------------------------------------------------------

The following changes since commit f7b967bffefe69f1ad8b79e263237ec1feba7b9b:

  Merge branch 'next/maintainers' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc

for you to fetch changes up to b6e3b5c2fea9c76617e101cbbc54ed14961f9dee:

  Merge branch 'lpc32xx/core' of git://git.antcom.de/linux-2.6 into next/soc

----------------------------------------------------------------

Alex Gershgorin (1):
      ARM: i.MX35: Implement camera and keypad clocks

Arnd Bergmann (2):
      Merge branch 'ux500-core' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc
      ARM: shmobile: add new __iomem annotation for new code

Chander Kashyap (3):
      ARM: EXYNOS: Turn off clocks for NAND, OneNAND and TSI controllers
      ARM: EXYNOS: Put PCM, Slimbus, Spdif clocks to off state
      ARM: SAMSUNG: Add check for NULL in clock interface

Dave Martin (1):
      ARM: mxc: ssi-fiq: Make ssi-fiq.S Thumb-2 compatible

Joseph Lo (7):
      ARM: tegra: clocks: separate tegra_clk_32k_ops from Tegra20 and Tegra30
      ARM: tegra30: clocks: fix the wrong tegra_audio_sync_clk_ops name
      ARM: tegra: introduce tegra_cpu_car_ops structures
      ARM: tegra: replace the CPU CAR access code by tegra_cpu_car_ops
      ARM: tegra: clean up the common assembly macros into sleep.h
      ARM: tegra30: add CPU hotplug support
      ARM: tegra20: add CPU hotplug support

Kevin Hilman (4):
      ARM: OMAP: omap_device: keep track of driver bound status
      ARM: OMAP: omap_device: don't attempt late suspend if no driver bound
      ARM: OMAP: omap_device: idle devices with no driver bound
      ARM: OMAP: AM33xx hwmod: fixup SPI after platform_data move

Leela Krishna Amudala (1):
      ARM: EXYNOS: Add bus clock for FIMD

Linus Walleij (4):
      ARM: ux500: delete remnant U5500 macros
      ARM: ux500: add a U8520 detection macro
      ARM: ux500: reform Ux500 family names
      ARM: ux500: add detection for DB8500 ASIC v2.2

Loic PALLARDY (1):
      ARM: ux500: Correct Ux500 family names usage

Olof Johansson (14):
      Merge branch 'ux500/asic-id' into next/soc
      Merge branch 'kzm9g' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'lpc32xx/core' of git://git.antcom.de/linux-2.6 into next/soc
      Merge branch 'soc' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'renesas/pmu' into next/soc
      Merge tag 'imx-soc' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc
      Merge tag 'tegra-for-3.7-common-clk' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.7-cpu-hotplug' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'devel-omap-device-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-devel-am33xx-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'rpi-for-3.7' of git://git.kernel.org/.../swarren/linux-rpi into next/soc
      Merge branch 'next/devel-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge branch 'bcm2835/soc' into next/soc
      Merge branch 'lpc32xx/core' of git://git.antcom.de/linux-2.6 into next/soc

Phil Edworthy (1):
      r8a7779: add SDHI clock support

Prashant Gaikwad (8):
      ARM: tegra30: Separate out clk ops and clk data
      ARM: tegra20: Separate out clk ops and clk data
      ARM: tegra: Rename tegra20 clock file
      ARM: tegra: Add clk_tegra structure and helper functions
      ARM: tegra: Port tegra to generic clock framework
      ARM: tegra: Remove duplicate code
      ARM: tegra: Fix data type for io address
      ARM: Tegra: Add smp_twd clock for Tegra20

Roland Stigge (6):
      ARM: LPC32xx: Use handle_edge_irq() callback on edge type irqs
      ARM: LPC32xx: Provide DMA filter callbacks via platform data
      ARM: LPC32xx: Remove board specific GPIO init
      ARM: LPC32xx: Board cleanup
      ARM: LPC32xx: Platform update for devicetree completion of spi-pl022
      ARM: LPC32xx: Support GPI 28

Sachin Kamat (2):
      ARM: EXYNOS: Fix incorrect help text
      ARM: SAMSUNG: Fix HDMI related warnings

Sascha Hauer (1):
      ARM i.MX53: register CAN clocks

Simon Arlott (5):
      ARM: add infra-structure for BCM2835 and Raspberry Pi
      ARM: bcm2835: add interrupt controller driver
      ARM: bcm2835: add system timer
      ARM: bcm2835: add stub clock driver
      ARM: bcm2835: instantiate console UART

Stephen Warren (7):
      ARM: tegra: turn on UART A clock at boot
      ARM: tegra: fix U16 divider range check
      ARM: tegra: remove tegra_timer from tegra_list_clks
      ARM: tegra: fix overflow in tegra20_pll_clk_round_rate()
      ARM: tegra: cpu-tegra: explicitly manage re-parenting
      MAINTAINERS: add an entry for the BCM2835 ARM sub-architecture
      irqchip: fill in empty Kconfig

Sylwester Nawrocki (1):
      ARM: S3C24XX: Add .get_rate callback for "camif-upll" clock

Tetsuyuki Kobayashi (3):
      ARM: shmobile: kzm9g: enable restarting
      ARM: shmobile: sh73a0: enable PMU(Performance Monitoring Unit)
      ARM: shmobile: emev2: enable PMU(Performance Monitoring Unit)

Tony Lindgren (2):
      Merge tag 'for_3.7-omap_device' of git://git.kernel.org/.../khilman/linux-omap-pm into devel-omap-device
      Merge tag 'omap-devel-a2-for-3.7' of git://git.kernel.org/.../pjw/omap-pending into devel-am33xx

Torben Hohn (1):
      arm imx31: add a few pinmux settings the tt01 needs

Vaibhav Hiremath (4):
      ARM: OMAP2+: hwmod: Hook-up am33xx support in omap_hwmod framework
      ARM: OMAP3+: hwmod: Add AM33XX HWMOD data
      ARM: OMAP2+: dpll: Add missing soc_is_am33xx() check for common functions
      ARM: AM33XX: clock: Add dcan clock aliases for device-tree


 .../devicetree/bindings/arm/bcm2835.txt         |    8 +
 .../brcm,bcm2835-armctrl-ic.txt                 |  110 +
 .../timer/brcm,bcm2835-system-timer.txt         |   22 +
 .../devicetree/bindings/vendor-prefixes.txt     |    1 +
 MAINTAINERS                                     |   10 +
 arch/arm/Kconfig                                |   18 +
 arch/arm/Makefile                               |    1 +
 arch/arm/boot/dts/bcm2835-rpi-b.dts             |   12 +
 arch/arm/boot/dts/bcm2835.dtsi                  |   39 +
 arch/arm/configs/bcm2835_defconfig              |   95 +
 arch/arm/configs/kzm9d_defconfig                |    1 +
 arch/arm/configs/kzm9g_defconfig                |    1 +
 arch/arm/mach-bcm2835/Makefile                  |    1 +
 arch/arm/mach-bcm2835/Makefile.boot             |    5 +
 arch/arm/mach-bcm2835/bcm2835.c                 |   64 +
 .../arm/mach-bcm2835/include/mach/bcm2835_soc.h |   29 +
 .../arm/mach-bcm2835/include/mach/debug-macro.S |   21 +
 arch/arm/mach-bcm2835/include/mach/timex.h      |   26 +
 arch/arm/mach-bcm2835/include/mach/uncompress.h |   45 +
 arch/arm/mach-exynos/Kconfig                    |    4 +-
 arch/arm/mach-exynos/clock-exynos4.c            |   31 +
 arch/arm/mach-exynos/clock-exynos5.c            |   32 +-
 arch/arm/mach-imx/clk-imx35.c                   |   11 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             |   14 +-
 .../mach-lpc32xx/include/mach/gpio-lpc32xx.h    |    2 +-
 arch/arm/mach-lpc32xx/irq.c                     |    7 +-
 arch/arm/mach-lpc32xx/phy3250.c                 |   42 +-
 arch/arm/mach-omap2/Makefile                    |    1 +
 arch/arm/mach-omap2/clkt_dpll.c                 |    4 +-
 arch/arm/mach-omap2/clock33xx_data.c            |    2 +
 arch/arm/mach-omap2/dpll3xxx.c                  |    4 +-
 arch/arm/mach-omap2/io.c                        |    2 +
 arch/arm/mach-omap2/omap_hwmod.c                |  178 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c      | 3381 ++++++++++++++++++
 arch/arm/mach-s3c24xx/clock-s3c2440.c           |   14 +
 arch/arm/mach-shmobile/board-kzm9g.c            |    8 +
 arch/arm/mach-shmobile/clock-r8a7779.c          |   11 +-
 arch/arm/mach-shmobile/setup-emev2.c            |   21 +
 arch/arm/mach-shmobile/setup-sh73a0.c           |   21 +
 arch/arm/mach-tegra/Makefile                    |    6 +-
 arch/arm/mach-tegra/board-dt-tegra20.c          |    1 +
 arch/arm/mach-tegra/clock.c                     |  574 +--
 arch/arm/mach-tegra/clock.h                     |   40 +-
 arch/arm/mach-tegra/common.c                    |    4 +-
 arch/arm/mach-tegra/cpu-tegra.c                 |   48 +-
 arch/arm/mach-tegra/headsmp.S                   |    6 +-
 arch/arm/mach-tegra/hotplug.c                   |  118 +-
 arch/arm/mach-tegra/include/mach/clk.h          |    3 +
 arch/arm/mach-tegra/platsmp.c                   |   29 +-
 arch/arm/mach-tegra/sleep-t20.S                 |   82 +
 arch/arm/mach-tegra/sleep-t30.S                 |  107 +
 arch/arm/mach-tegra/sleep.S                     |   33 +-
 arch/arm/mach-tegra/sleep.h                     |   85 +
 arch/arm/mach-tegra/tegra20_clocks.c            | 1625 +++++++++
 arch/arm/mach-tegra/tegra20_clocks.h            |   42 +
 arch/arm/mach-tegra/tegra20_clocks_data.c       | 1144 ++++++
 arch/arm/mach-tegra/tegra2_clocks.c             | 2484 -------------
 arch/arm/mach-tegra/tegra30_clocks.c            | 2593 +++++---------
 arch/arm/mach-tegra/tegra30_clocks.h            |   53 +
 arch/arm/mach-tegra/tegra30_clocks_data.c       | 1372 +++++++
 arch/arm/mach-tegra/tegra_cpu_car.h             |   87 +
 arch/arm/mach-ux500/cache-l2x0.c                |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                |    2 +-
 arch/arm/mach-ux500/cpu.c                       |    2 +-
 arch/arm/mach-ux500/include/mach/id.h           |   44 +-
 arch/arm/mach-ux500/platsmp.c                   |    4 +-
 arch/arm/mach-ux500/timer.c                     |    2 +-
 arch/arm/plat-mxc/include/mach/iomux-mx3.h      |    5 +
 arch/arm/plat-mxc/ssi-fiq.S                     |   89 +-
 arch/arm/plat-omap/include/plat/omap_device.h   |    2 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h    |    1 +
 arch/arm/plat-omap/omap_device.c                |   56 +-
 arch/arm/plat-samsung/clock.c                   |    8 +-
 arch/arm/plat-samsung/devs.c                    |    3 +-
 drivers/Kconfig                                 |    2 +
 drivers/Makefile                                |    2 +
 drivers/clk/Makefile                            |    1 +
 drivers/clk/clk-bcm2835.c                       |   59 +
 drivers/clocksource/Makefile                    |    1 +
 drivers/clocksource/bcm2835_timer.c             |  161 +
 drivers/irqchip/Kconfig                         |    1 +
 drivers/irqchip/Makefile                        |    1 +
 drivers/irqchip/irq-bcm2835.c                   |  223 ++
 include/linux/bcm2835_timer.h                   |   22 +
 include/linux/clk/bcm2835.h                     |   24 +
 include/linux/irqchip/bcm2835.h                 |   29 +
 86 files changed, 10542 insertions(+), 5039 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm2835.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm2835-armctrl-ic.txt
 create mode 100644 Documentation/devicetree/bindings/timer/brcm,bcm2835-system-timer.txt
 create mode 100644 arch/arm/boot/dts/bcm2835-rpi-b.dts
 create mode 100644 arch/arm/boot/dts/bcm2835.dtsi
 create mode 100644 arch/arm/configs/bcm2835_defconfig
 create mode 100644 arch/arm/mach-bcm2835/Makefile
 create mode 100644 arch/arm/mach-bcm2835/Makefile.boot
 create mode 100644 arch/arm/mach-bcm2835/bcm2835.c
 create mode 100644 arch/arm/mach-bcm2835/include/mach/bcm2835_soc.h
 create mode 100644 arch/arm/mach-bcm2835/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-bcm2835/include/mach/timex.h
 create mode 100644 arch/arm/mach-bcm2835/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_33xx_data.c
 create mode 100644 arch/arm/mach-tegra/sleep-t20.S
 create mode 100644 arch/arm/mach-tegra/sleep-t30.S
 create mode 100644 arch/arm/mach-tegra/sleep.h
 create mode 100644 arch/arm/mach-tegra/tegra20_clocks.c
 create mode 100644 arch/arm/mach-tegra/tegra20_clocks.h
 create mode 100644 arch/arm/mach-tegra/tegra20_clocks_data.c
 delete mode 100644 arch/arm/mach-tegra/tegra2_clocks.c
 create mode 100644 arch/arm/mach-tegra/tegra30_clocks.h
 create mode 100644 arch/arm/mach-tegra/tegra30_clocks_data.c
 create mode 100644 arch/arm/mach-tegra/tegra_cpu_car.h
 create mode 100644 drivers/clk/clk-bcm2835.c
 create mode 100644 drivers/clocksource/bcm2835_timer.c
 create mode 100644 drivers/irqchip/Kconfig
 create mode 100644 drivers/irqchip/Makefile
 create mode 100644 drivers/irqchip/irq-bcm2835.c
 create mode 100644 include/linux/bcm2835_timer.h
 create mode 100644 include/linux/clk/bcm2835.h
 create mode 100644 include/linux/irqchip/bcm2835.h
