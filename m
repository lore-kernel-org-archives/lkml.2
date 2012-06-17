Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab2FQFdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 01:33:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38896 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2FQFdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 01:33:52 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8656:0:226:bbff:fe05:e090]
Date: Sat, 16 Jun 2012 22:33:51 -0700
Message-ID: <CAOesGMhiVcmMjRmAg85rsmSyMQAoDg-GszZ9K5n0eWXKpmn-2g@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to 128789a8293653a4f889f2b1601eea07c00ff65e:

  ARM: Kirkwood: Fix clk problems modular ethernet driver (2012-06-16
18:45:20 -0700)

----------------------------------------------------------------
ARM: SoC fixes

A bit larger set than usual, unfortunately -- I've been sitting on them
longer than I meant to so it's really more like 2 -rc pull requests in
one, volume-wise.

Nearly everything is fixes for fallout from the merge window, or other
fixes for bugs. The one exception is the highbank L2-enablement patch,
but it was contained enough that I picked it up anyway:

- i.MX fixes, mostly for clock and pinctrl changes
- OMAP fixes, mostly PM-related
- A patch to enable L2 on highbank
- A couple of fixes for PXA, Kirkwood, Versatile

----------------------------------------------------------------
Andrew Lunn (1):
      ARM: Kirkwood: Fix clk problems modular ethernet driver

Arnd Bergmann (1):
      arm: versatile: fix and enable PCI I/O space

Fabio Estevam (3):
      ARM: mx31_3ds: Fix build due to missing IMX_HAVE_PLATFORM_IMX_SSI
      ARM: mx31: Add pinctrl_provide_dummies()
      ARM: mx51: Add pinctrl_provide_dummies()

Govindraj.R (1):
      OMAP2+: UART: Add mechanism to probe uart pins and configure rx wakeup

Haojian Zhuang (2):
      ARM: dts: update memory size on brownstone
      ARM: mmp: fix missing cascade_irq in irq handler

Jaccon Bastiaansen (1):
      ARM i.MX imx21ads: Fix overlapping static i/o mappings

Javier Martin (1):
      ARM i.MX27 Visstrim M10: fix gpio handling.

Kevin Hilman (3):
      ARM: OMAP3: PM: fix shared PRCM interrupts: leave disabled at boot
      ARM: OMAP3: clock data: cleanup AM3[35]x SoC detection
      ARM: OMAP: SoC detection: remove unused cpu_is macros

Mark A. Greer (1):
      arm: omap3: am35x: Don't mark missing features as present

NeilBrown (1):
      ARM: OMAP2+: INTC: fix suspend abort, set IRQCHIP_SKIP_SET_WAKE

Olof Johansson (6):
      Merge tag 'imx-clk-common-fixes' of
git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge branch 'imx/fixes-for-3.5' of
git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'imx/clk-fixes' of
git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge branch 'imx/fixes' of
git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge tag 'omap-fixes-for-v3.5-rc1' of
git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes

Richard Zhao (2):
      ARM: i.MX: change timer clock from ipg to perclk
      ARM: imx6q: prepare and enable init on clks directly instead of
clk_get first

Rob Herring (1):
      ARM: highbank: Add smc calls to enable/disable the L2

Sascha Hauer (5):
      ARM i.MX5: fix gpt peripheral clock path
      ARM i.MX: remove now unnecessary argument from mxc_timer_init
      ARM i.MX pllv2: use standard register set unconditionally
      ARM i.MX pllv2: make round_rate accurate
      ARM i.MX53: Fix PLL4 base address

Shawn Guo (1):
      ARM: imx6: exit coherency when shutting down a cpu

Tony Lindgren (6):
      Merge branch 'for_3.5/fixes/pm' of
git://git.kernel.org/.../khilman/linux-omap-pm into fixes
      Merge branch 'for_3.5/cleanup/am3xxx-cpu-is-leftovers' of
git://git.kernel.org/.../khilman/linux-omap-pm into fixes
      ARM: OMAP: Fix lis3lv02d accelerometer to use gpio_to_irq
      ARM: OMAP: Fix MMC_OMAP build when only MMC_OMAP_HS is selected
      ARM: OMAP3: Fix omap3_l3_block_irq warning when CONFIG_BUG is not set
      ARM: OMAP2+: Fix compile for CONFIG_TIDSPBRIDGE platform init code

Uwe Kleine-König (2):
      ARM: imx: only specify i2c device type once
      ARM: imx: only call l2x0_init if it's available

 arch/arm/Kconfig                                |  1 +
 arch/arm/boot/dts/mmp2-brownstone.dts           |  4 +-
 arch/arm/mach-highbank/Makefile                 |  6 +-
 arch/arm/mach-highbank/core.h                   |  1 +
 arch/arm/mach-highbank/highbank.c               | 14 ++++
 arch/arm/mach-highbank/smc.S                    | 27 +++++++
 arch/arm/mach-imx/Kconfig                       |  1 +
 arch/arm/mach-imx/clk-imx1.c                    |  3 +-
 arch/arm/mach-imx/clk-imx21.c                   |  4 +-
 arch/arm/mach-imx/clk-imx25.c                   |  2 +-
 arch/arm/mach-imx/clk-imx27.c                   |  3 +-
 arch/arm/mach-imx/clk-imx31.c                   |  3 +-
 arch/arm/mach-imx/clk-imx35.c                   |  6 +-
 arch/arm/mach-imx/clk-imx51-imx53.c             | 12 ++--
 arch/arm/mach-imx/clk-imx6q.c                   | 22 ++----
 arch/arm/mach-imx/clk-pllv2.c                   | 93 +++++++++++++++----------
 arch/arm/mach-imx/crm-regs-imx5.h               |  2 +-
 arch/arm/mach-imx/hotplug.c                     | 42 ++++++++++-
 arch/arm/mach-imx/mach-cpuimx35.c               |  1 -
 arch/arm/mach-imx/mach-cpuimx51sd.c             |  1 -
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     | 36 +++++++---
 arch/arm/mach-imx/mach-mx21ads.c                |  2 +-
 arch/arm/mach-imx/mm-imx3.c                     |  4 ++
 arch/arm/mach-imx/mm-imx5.c                     |  2 +
 arch/arm/mach-kirkwood/common.c                 |  8 ++-
 arch/arm/mach-mmp/irq.c                         |  7 ++
 arch/arm/mach-omap2/board-rx51-peripherals.c    |  6 +-
 arch/arm/mach-omap2/clock3xxx_data.c            |  2 +-
 arch/arm/mach-omap2/dsp.c                       |  3 +
 arch/arm/mach-omap2/id.c                        | 11 +++
 arch/arm/mach-omap2/irq.c                       |  1 +
 arch/arm/mach-omap2/mux.c                       |  3 +-
 arch/arm/mach-omap2/mux.h                       | 11 +++
 arch/arm/mach-omap2/omap_l3_smx.c               |  3 +-
 arch/arm/mach-imx/clk-pllv2.c                   | 93 +++++++++++++++----------
 arch/arm/mach-imx/crm-regs-imx5.h               |  2 +-
 arch/arm/mach-imx/hotplug.c                     | 42 ++++++++++-
 arch/arm/mach-imx/mach-cpuimx35.c               |  1 -
 arch/arm/mach-imx/mach-cpuimx51sd.c             |  1 -
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     | 36 +++++++---
 arch/arm/mach-imx/mach-mx21ads.c                |  2 +-
 arch/arm/mach-imx/mm-imx3.c                     |  4 ++
 arch/arm/mach-imx/mm-imx5.c                     |  2 +
 arch/arm/mach-kirkwood/common.c                 |  8 ++-
 arch/arm/mach-mmp/irq.c                         |  7 ++
 arch/arm/mach-omap2/board-rx51-peripherals.c    |  6 +-
 arch/arm/mach-omap2/clock3xxx_data.c            |  2 +-
 arch/arm/mach-omap2/dsp.c                       |  3 +
 arch/arm/mach-omap2/id.c                        | 11 +++
 arch/arm/mach-omap2/irq.c                       |  1 +
 arch/arm/mach-omap2/mux.c                       |  3 +-
 arch/arm/mach-omap2/mux.h                       | 11 +++
 arch/arm/mach-omap2/omap_l3_smx.c               |  3 +-
 arch/arm/mach-omap2/pm34xx.c                    |  1 +
 arch/arm/mach-omap2/prm2xxx_3xxx.c              | 14 +++-
 arch/arm/mach-omap2/serial.c                    | 67 ++++++++++++++++--
 arch/arm/mach-versatile/core.c                  | 19 +----
 arch/arm/mach-versatile/include/mach/hardware.h |  3 +-
 arch/arm/mach-versatile/include/mach/io.h       | 27 +++++++
 arch/arm/mach-versatile/pci.c                   | 18 ++++-
 arch/arm/plat-mxc/epit.c                        | 11 ++-
 arch/arm/plat-mxc/include/mach/common.h         |  4 +-
 arch/arm/plat-mxc/time.c                        | 24 +++----
 arch/arm/plat-omap/include/plat/cpu.h           | 33 ---------
 arch/arm/plat-omap/include/plat/mmc.h           |  4 +-
 46 files changed, 396 insertions(+), 176 deletions(-)
 create mode 100644 arch/arm/mach-highbank/smc.S
 create mode 100644 arch/arm/mach-versatile/include/mach/io.h
