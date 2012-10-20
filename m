Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab2JTAJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:09:10 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62136 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab2JTAJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:09:07 -0400
Date: Fri, 19 Oct 2012 17:09:05 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: soc fixes for -rc2
Message-ID: <20121020000905.GA29057@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 70f3900ee5c78d498dbbf880ec409f4b8f4da21e:

  Merge tag 'kirkwood_fixes_for_v3.7' of git://git.infradead.org/users/jcooper/linux into fixes (2012-10-19 16:17:51 -0700)

----------------------------------------------------------------

ARM: soc: Fixes for 3.7-rc2

A set of fixes and some minor cleanups for -rc2:

- A series from Arnd that fixes warnings in drivers and other code
  included by ARM defconfigs. Most have been acked by corresponding
  maintainers (and seem quite hard to argue not picking up anyway in the
  few exception cases).
- A few misc patches from the list for integrator/vt8500/i.MX
- A batch of fixes to OMAP platforms, fixing:
  - boot problems on beaglebone,
  - regression fixes for local timers
  - clockdomain locking fixes
  - a few boot/sparse warnings
- For Tegra:
  - Clock rate calculation overflow fix
  - Revert a change that removed timer clocks and a fix for symbol name clashes
- For Renesas:
  - IO accessor / annotation cleanups to remove warnings
- For Kirkwood/Dove/mvebu:
  - Fixes for device trees for Dove (some minor cleanups, some fixes)
  - Fixes for the mvebu gpio driver
  - Fix build problem for Feroceon due to missing ifdefs
  - Fix lsxl DTS files

----------------------------------------------------------------
Arnd Bergmann (7):
      SCSI: ARM: ncr5380/oak uses no interrupts
      SCSI: ARM: make fas216_dumpinfo function conditional
      mm/slob: use min_t() to compare ARCH_SLAB_MINALIGN
      USB: EHCI: mark ehci_orion_conf_mbus_windows __devinit
      pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops
      spi/s3c64xx: use correct dma_transfer_direction type
      ARM: s3c: mark s3c2440_clk_add as __init_refok

Axel Lin (1):
      gpio: mvebu: Add missing breaks in mvebu_gpio_irq_set_type

Benoit Cousson (1):
      ARM: OMAP2+: clock data: Add dev-id for the omap-gpmc dummy fck

Jason Gunthorpe (1):
      ARM: Kirkwood: fix disabling CACHE_FEROCEON_L2

Jon Hunter (1):
      ARM: OMAP2+: Allow kernel to boot even if GPMC fails to reserve memory

Kuninori Morimoto (2):
      ARM: shmobile: armadillo800eva: __io abuse cleanup
      ARM: shmobile: r8a7779: use __iomem pointers for MMIO

Linus Walleij (1):
      ARM: dts: compile Integrator device trees

Mark Zhang (1):
      ARM: tegra30: clk: Fix output_rate overflow

Michael Walle (2):
      ARM: kirkwood: fix LEDs names for lsxl boards
      ARM: kirkwood: fix buttons on lsxl boards

Olof Johansson (7):
      Merge branch 'fixes' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'tegra-for-3.7-fixes-for-rc2' of git://git.kernel.org/.../swarren/linux-tegra into fixes
      Merge tag 'omap-for-v3.7-rc1/fixes-take5-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'mvebu_dove_late_fixes_for_v3.7' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'mvebu_gpio_fixes_for_v3.7' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge branch 'testing/driver-warnings' of git://git.kernel.org/.../arm/arm-soc into fixes
      Merge tag 'kirkwood_fixes_for_v3.7' of git://git.infradead.org/users/jcooper/linux into fixes

Paul Walmsley (1):
      ARM: OMAP: resolve sparse warning concerning debug_card_init()

Sebastian Hesselbarth (6):
      ARM: dove: Add pcie clock support
      ARM: dove: Fix tauros2 device tree init
      ARM: dove: Fix clock names of sata and gbe
      ARM: dove: Restructure SoC device tree descriptor
      ARM: dove: Remove watchdog from DT
      ARM: dove: Add crypto engine to DT

Sebastien Guiriec (1):
      ARM: OMAP4: devices: fixup OMAP4 DMIC platform device error message

Shawn Guo (1):
      ARM: dts: imx6q-arm2: move NANDF_CS pins out of 'hog'

Sivaram Nair (2):
      ARM: tegra: rename tegra system timer
      ARM: tegra: add tegra_timer clock

Tero Kristo (1):
      ARM: OMAP: clockdomain: Fix locking on _clkdm_clk_hwmod_enable / disable

Tony Lindgren (1):
      ARM: OMAP4: Fix twd_local_timer_register regression

Tony Prisk (1):
      dtb: fix interrupt assignment for ehci/uhci on wm8505

 arch/arm/boot/dts/Makefile                     |  2 ++
 arch/arm/boot/dts/dove.dtsi                    | 49 +++++++++++++++++---------
 arch/arm/boot/dts/imx6q-arm2.dts               | 10 +++++-
 arch/arm/boot/dts/kirkwood-lsxl.dtsi           | 18 +++++-----
 arch/arm/boot/dts/wm8505.dtsi                  |  4 +--
 arch/arm/mach-dove/common.c                    |  8 ++---
 arch/arm/mach-dove/pcie.c                      |  5 +++
 arch/arm/mach-kirkwood/board-dt.c              |  2 --
 arch/arm/mach-kirkwood/common.c                |  4 +--
 arch/arm/mach-omap2/clock44xx_data.c           |  2 +-
 arch/arm/mach-omap2/clockdomain.c              | 15 +++++---
 arch/arm/mach-omap2/devices.c                  |  2 +-
 arch/arm/mach-omap2/gpmc.c                     | 24 ++++++++++---
 arch/arm/mach-omap2/timer.c                    |  2 +-
 arch/arm/mach-s3c24xx/clock-s3c2440.c          |  2 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c |  2 +-
 arch/arm/mach-shmobile/clock-r8a7779.c         | 22 ++++++------
 arch/arm/mach-tegra/board-dt-tegra20.c         |  2 +-
 arch/arm/mach-tegra/board-dt-tegra30.c         |  2 +-
 arch/arm/mach-tegra/board.h                    |  2 +-
 arch/arm/mach-tegra/tegra20_clocks_data.c      |  1 +
 arch/arm/mach-tegra/tegra30_clocks.c           |  2 +-
 arch/arm/mach-tegra/tegra30_clocks_data.c      |  1 +
 arch/arm/mach-tegra/timer.c                    |  2 +-
 arch/arm/plat-omap/debug-devices.c             |  1 +
 drivers/gpio/gpio-mvebu.c                      |  3 ++
 drivers/pcmcia/pxa2xx_sharpsl.c                |  2 +-
 drivers/scsi/arm/fas216.c                      |  2 +-
 drivers/scsi/arm/oak.c                         |  1 +
 drivers/spi/spi-s3c64xx.c                      |  6 ++--
 drivers/usb/host/ehci-orion.c                  |  2 +-
 mm/slob.c                                      |  6 ++--
 32 files changed, 133 insertions(+), 75 deletions(-)
