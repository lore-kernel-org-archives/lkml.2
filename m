Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2LMB47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:56:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54466 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2LMB4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:56:55 -0500
Date: Wed, 12 Dec 2012 17:56:54 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 2/5] ARM: arm-soc: multiplatform conversion patches
Message-ID: <20121213015654.GB28281@quad.lixom.net>
References: <20121213015543.GA18953@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213015543.GA18953@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are more patches in the progression towards multiplatform, sparse
irq conversions in particular.

Tegra has a handful of cleanups and general groundwork, but is
not quite there yet on full enablement.

Platforms that are enabled through this branch are VT8500 and Zynq. note
that i.MX was converted in one of the earlier cleanup branches as
well (before we started a separate topic for multiplatform). And both
new platforms for this merge window, sunxi and bcm, were merged with
multiplatform support enabled.


Conflicts seen with this merge:

arch/arm/Kconfig.debug:
Add/add. Keep both.

arch/arm/mach-nomadik/board-nhk8815.c:
arch/arm/mach-ux500/board-mop500-audio.c:
arch/arm/mach-ux500/board-mop500.c:
Looks like one branch got rebased, so the auto-resolve works poorly here.
Keep the versions from the branch in this file, not from HEAD.

arch/arm/mach-ux500/cpu-db8500.c:
Keep the version from HEAD + the two platform_data includes

drivers/clocksource/Kconfig:
Add/add. Keep both.

drivers/pinctrl/pinctrl-nomadik.c:
Keep version from branch but take out the #ifdef CONFIG_ARCH_U8500 block.


----------------------------------------------------------------

The following changes since commit 167be309858a109413302f87c51fa21b69c7c7bd:

  Merge branch 'next/dt' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/multiplatform

for you to fetch changes up to 3f54db784a6af9a6d53396949cbecf62edbad247:

  Merge branch 'zynq/multiplatform' of git://git.monstr.eu/linux-2.6-microblaze into next/multiplatform

----------------------------------------------------------------

Arnd Bergmann (2):
      Merge tag 'armsoc-for-3.8' of git://server.prisktech.co.nz/git/linuxwmt into next/multiplatform
      Merge tag 'mtu-clk-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/multiplatform

Josh Cartwright (3):
      ARM: zynq: remove TTC early mapping
      ARM: zynq: make use of debug_ll_io_init()
      ARM: zynq: add support for ARCH_MULTIPLATFORM

Linus Walleij (10):
      pinctrl/nomadik: move the platform data header
      pinctrl/nomadik: merge old pincfg header
      clk/ux500: explicitly include register header
      ARM: plat-nomadik: pass IRQ to timer driver
      ARM: plat-nomadik: use DIV_ROUND_CLOSEST()
      ARM: plat-nomadik: move DMA40 header to <linux/platform_data>
      ARM: plat-nomadik: move MTU, kill plat-nomadik
      mfd/ab8500-core: use irq_domain_add_simple()
      mfd/db8500-prcmu: use the irq_domain_add_simple()
      ARM: plat-nomadik: convert platforms to SPARSE_IRQ

Michal Simek (2):
      Merge branch 'devel/debug_ll_init' into zynq/multiplatform
      ARM: zynq: Remove all unused mach headers

Olof Johansson (4):
      Merge branch 'devel/debug_ll_init' into next/multiplatform
      Merge tag 'kill-plat-sparse-irq' of git://git.kernel.org/.../linusw/linux-pinctrl into next/multiplatform
      Merge tag 'tegra-for-3.8-single-zimage' of git://git.kernel.org/.../swarren/linux-tegra into next/multiplatform
      Merge branch 'zynq/multiplatform' of git://git.monstr.eu/linux-2.6-microblaze into next/multiplatform

Stephen Warren (12):
      Merge remote-tracking branch 'korg_arm-soc/devel/debug_ll_init' into for-3.8/single-zimage
      ARM: tegra: define DT bindings for and instantiate timer
      ARM: tegra: define DT bindings for and instantiate RTC
      ARM: tegra: add TWD to device tree
      ARM: timer: fix checkpatch warnings
      ARM: tegra: enhance timer.c to get IRQ info from device tree
      ARM: tegra: enhance timer.c to get IO address from device tree
      ARM: tegra: select SPARSE_IRQ
      ARM: tegra: simplify DEBUG_LL UART selection options
      ARM: tegra: decouple uncompress.h and debug-macro.S
      ARM: tegra: don't include iomap.h from debug-macro.S
      ARM: tegra: move debug-macro.S to include/debug

Tony Prisk (2):
      arm: vt8500: Convert irq.c for multiplatform integration
      ARM: vt8500: Convert arch-vt8500 to multiplatform

Ulf Hansson (2):
      clk: ux500: Register mtu apb_pclocks
      clocksource/mtu-nomadik: use apb_pclk


 .../bindings/rtc/nvidia,tegra20-rtc.txt         |  19 ++
 .../bindings/timer/nvidia,tegra20-timer.txt     |  21 ++
 .../bindings/timer/nvidia,tegra30-timer.txt     |  23 ++
 arch/arm/Kconfig                                |  24 +-
 arch/arm/Kconfig.debug                          |  39 ++++
 arch/arm/Makefile                               |   1 -
 arch/arm/boot/dts/tegra20.dtsi                  |  21 ++
 arch/arm/boot/dts/tegra30.dtsi                  |  23 ++
 arch/arm/include/debug/tegra.S                  | 223 +++++++++++++++++++
 .../mach/debug-macro.S => include/debug/zynq.S} |  23 +-
 arch/arm/mach-nomadik/Kconfig                   |   2 +-
 arch/arm/mach-nomadik/board-nhk8815.c           |  10 +-
 arch/arm/mach-nomadik/include/mach/irqs.h       |   2 +-
 arch/arm/mach-tegra/Kconfig                     |  51 -----
 arch/arm/mach-tegra/common.c                    |   9 +-
 arch/arm/mach-tegra/include/mach/debug-macro.S  | 100 ---------
 arch/arm/mach-tegra/include/mach/irqs.h         | 182 ---------------
 arch/arm/mach-tegra/include/mach/uncompress.h   |  65 +-----
 arch/arm/mach-tegra/io.c                        |   1 +
 arch/arm/mach-tegra/iomap.h                     |  14 --
 arch/arm/mach-tegra/irammap.h                   |   9 -
 arch/arm/mach-tegra/pcie.c                      |   3 +
 arch/arm/mach-tegra/timer.c                     |  78 ++++---
 arch/arm/mach-ux500/Kconfig                     |   2 +-
 arch/arm/mach-ux500/board-mop500-audio.c        |   3 +-
 arch/arm/mach-ux500/board-mop500-sdi.c          |   2 +-
 arch/arm/mach-ux500/board-mop500.c              |   3 +-
 arch/arm/mach-ux500/cpu-db8500.c                |   3 +
 arch/arm/mach-ux500/devices-common.c            |   1 +
 arch/arm/mach-ux500/devices-db8500.c            |   4 +-
 arch/arm/mach-ux500/devices-db8500.h            |   1 +
 arch/arm/mach-ux500/include/mach/irqs.h         |   2 +-
 arch/arm/mach-ux500/include/mach/msp.h          |   2 +-
 arch/arm/mach-ux500/timer.c                     |   5 +-
 arch/arm/mach-ux500/usb.c                       |   4 +-
 arch/arm/mach-vt8500/Kconfig                    |  12 +
 arch/arm/mach-vt8500/common.h                   |   3 +
 arch/arm/mach-vt8500/include/mach/entry-macro.S |  26 ---
 arch/arm/mach-vt8500/include/mach/irqs.h        |  22 --
 arch/arm/mach-vt8500/irq.c                      | 108 +++++----
 arch/arm/mach-vt8500/vt8500.c                   |   1 +
 arch/arm/mach-zynq/Kconfig                      |  13 ++
 arch/arm/mach-zynq/common.c                     |  38 +---
 arch/arm/mach-zynq/include/mach/hardware.h      |  18 --
 arch/arm/mach-zynq/include/mach/irqs.h          |  21 --
 arch/arm/mach-zynq/include/mach/timex.h         |  23 --
 arch/arm/mach-zynq/include/mach/uart.h          |  25 ---
 arch/arm/mach-zynq/include/mach/uncompress.h    |  51 -----
 arch/arm/mach-zynq/include/mach/zynq_soc.h      |  53 -----
 arch/arm/mach-zynq/timer.c                      |   1 -
 arch/arm/plat-nomadik/Kconfig                   |  29 ---
 arch/arm/plat-nomadik/Makefile                  |   5 -
 drivers/char/hw_random/Kconfig                  |   2 +-
 drivers/clk/ux500/u8500_clk.c                   |  11 +-
 drivers/clocksource/Kconfig                     |  17 +-
 drivers/clocksource/Makefile                    |   1 +
 .../clocksource/nomadik-mtu.c                   |  19 +-
 drivers/crypto/ux500/cryp/cryp_core.c           |   3 +-
 drivers/dma/ste_dma40.c                         |   3 +-
 drivers/dma/ste_dma40_ll.c                      |   2 +-
 drivers/input/keyboard/Kconfig                  |   2 +-
 drivers/mfd/ab8500-core.c                       |  13 +-
 drivers/mfd/db8500-prcmu.c                      |  12 +-
 drivers/mtd/nand/Kconfig                        |   2 +-
 drivers/pinctrl/pinctrl-nomadik.c               |   2 +
 .../platform_data/clocksource-nomadik-mtu.h     |   2 +-
 include/linux/platform_data/crypto-ux500.h      |   2 +-
 .../linux/platform_data/dma-ste-dma40.h         |   0
 sound/soc/ux500/ux500_pcm.c                     |   3 +-
 69 files changed, 656 insertions(+), 864 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/nvidia,tegra20-rtc.txt
 create mode 100644 Documentation/devicetree/bindings/timer/nvidia,tegra20-timer.txt
 create mode 100644 Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
 create mode 100644 arch/arm/include/debug/tegra.S
 rename arch/arm/{mach-zynq/include/mach/debug-macro.S => include/debug/zynq.S} (61%)
 delete mode 100644 arch/arm/mach-tegra/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-tegra/include/mach/irqs.h
 create mode 100644 arch/arm/mach-vt8500/Kconfig
 delete mode 100644 arch/arm/mach-vt8500/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-vt8500/include/mach/irqs.h
 create mode 100644 arch/arm/mach-zynq/Kconfig
 delete mode 100644 arch/arm/mach-zynq/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/timex.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/uart.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h
 delete mode 100644 arch/arm/plat-nomadik/Kconfig
 delete mode 100644 arch/arm/plat-nomadik/Makefile
 rename arch/arm/plat-nomadik/timer.c => drivers/clocksource/nomadik-mtu.c (93%)
 rename arch/arm/plat-nomadik/include/plat/mtu.h => include/linux/platform_data/clocksource-nomadik-mtu.h (71%)
 rename arch/arm/plat-nomadik/include/plat/ste_dma40.h => include/linux/platform_data/dma-ste-dma40.h (100%)
