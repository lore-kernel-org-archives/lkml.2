Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab2LKHET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:04:19 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59677 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2LKHER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:04:17 -0500
MIME-Version: 1.0
From: Mike Turquette <mturquette@linaro.org>
Date: Mon, 10 Dec 2012 23:03:56 -0800
Message-ID: <CAPtuhThTATx3AfKqNQmF8AhPxsgxhE6Ax1w=+cF4BPW_2qtAPQ@mail.gmail.com>
Subject: [GIT PULL] clk: changes for 3.8
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-for-linus

for you to fetch changes up to 8f87189653d60656e262060665f52c855508a301:

  MAINTAINERS: bad email address for Mike Turquette (2012-12-10 22:35:32 -0800)

----------------------------------------------------------------
The common clock framework changes for 3.8 are comprised of lots of
fixes for existing platforms as well as new ports for some ARM
platforms.  In addition there are new clk drivers for audio devices and
MFDs.

----------------------------------------------------------------
Axel Lin (1):
      clk: spear: Add stub functions for spear3[0|1|2]0_clk_init()

Deepak Sikri (2):
      CLK: SPEAr: Update clock rate table
      CLK: SPEAr: Correct index scanning done for clock synths

Fabio Estevam (1):
      clk: mxs: Use a better name for the USB PHY clock

Linus Walleij (4):
      clk: add GPLv2 headers to the Versatile clock files
      clk: make ICST driver handle the VCO registers
      clk: move IM-PD1 clocks to drivers/clk
      clk: ux500: fix bit error

Martin Fuzzey (1):
      clk: clock multiplexers may register out of order

Mike Turquette (2):
      clk: introduce optional disable_unused callback
      MAINTAINERS: bad email address for Mike Turquette

Pawel Moll (2):
      clk: Versatile Express clock generators ("osc") driver
      clk: Common clocks implementation for Versatile Express

Peter Ujfalusi (1):
      CLK: clk-twl6040: Initial clock driver for OMAP4+ McPDM fclk clock

Rajeev Kumar (1):
      CLK: SPEAr: Fix dev_id & con_id for multiple clocks

Shiraz Hashim (2):
      CLK: SPEAr13xx: Fix mux clock names
      CLK: SPEAr13xx: fix parent names of multiple clocks

Stephen Boyd (6):
      clk: Document .is_enabled op
      clk: Fix documentation typos
      clk: Don't return negative numbers for unsigned values with !clk
      clk: wm831x: Fix clk_register() error code checking
      clk: Add devm_clk_{register,unregister}()
      clk: wm831x: Use devm_clk_register() to simplify code

Tony Prisk (1):
      CLK: vt8500: Fix SDMMC clk special cases

Ulf Hansson (19):
      mfd: dbx500: Export prmcu_request_ape_opp_100_voltage
      clk: ux500: Support prcmu ape opp voltage clock
      clk: ux500: Update sdmmc clock to 100MHz for u8500
      ARM: ux500: Remove cpufreq platform device
      mfd: db8500: Provide cpufreq table as platform data
      cpufreq: db8500: Register as a platform driver
      cpufreq: db8500: Fetch cpufreq table from platform data
      mfd: db8500: Connect ARMSS clk to ARM OPP
      clk: ux500: Support for prcmu_scalable_rate clock
      clk: ux500: Add armss clk and fixup smp_twd clk for u8500
      cpufreq: db8500: Use armss clk to update frequency
      clk: ux500: Register i2c clock lookups for u8500
      clk: ux500: Register ssp clock lookups for u8500
      clk: ux500: Register msp clock lookups for u8500
      clk: ux500: Update rtc clock lookup for u8500
      clk: ux500: Register slimbus clock lookups for u8500
      clk: ux500: Register rng clock lookups for u8500
      clk: ux500: Register nomadik keypad clock lookups for u8500
      clk: ux500: Initial support for abx500 clock driver

Vipul Kumar Samar (3):
      CLK: SPEAr: Set CLK_SET_RATE_PARENT for few clocks
      CLK: SPEAr: Add missing clocks
      CLK: SPEAr: Remove unused dummy apb_pclk

Viresh Kumar (1):
      clk: SPEAr: Vco-pll: Fix compilation warning

Wei Yongjun (4):
      clk: fix return value check in of_fixed_clk_setup()
      clk: fix return value check in sirfsoc_of_clk_init()
      clk: fix return value check in bcm2835_init_clocks()
      CLK: clk-twl6040: fix return value check in twl6040_clk_probe()

 .../devicetree/bindings/clock/imx23-clock.txt      |    2 +-
 .../devicetree/bindings/clock/imx28-clock.txt      |    4 +-
 MAINTAINERS                                        |    1 -
 arch/arm/include/asm/hardware/sp810.h              |    2 +
 arch/arm/mach-integrator/impd1.c                   |   69 +-----
 arch/arm/mach-ux500/cpu-db8500.c                   |    6 -
 drivers/clk/Kconfig                                |   16 +-
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-bcm2835.c                          |    8 +-
 drivers/clk/clk-fixed-rate.c                       |    2 +-
 drivers/clk/clk-prima2.c                           |   84 +++----
 drivers/clk/clk-twl6040.c                          |  126 +++++++++++
 drivers/clk/clk-vt8500.c                           |   18 ++
 drivers/clk/clk-wm831x.c                           |   34 +--
 drivers/clk/clk.c                                  |  154 ++++++++++---
 drivers/clk/mxs/clk-imx23.c                        |    6 +-
 drivers/clk/mxs/clk-imx28.c                        |   10 +-
 drivers/clk/spear/clk-aux-synth.c                  |    3 +-
 drivers/clk/spear/clk-vco-pll.c                    |    2 +-
 drivers/clk/spear/clk.c                            |    3 +
 drivers/clk/spear/spear1310_clock.c                |  106 +++++----
 drivers/clk/spear/spear1340_clock.c                |  237 ++++++++++++--------
 drivers/clk/spear/spear3xx_clock.c                 |  154 ++++++++-----
 drivers/clk/spear/spear6xx_clock.c                 |   13 +-
 drivers/clk/ux500/Makefile                         |    3 +
 drivers/clk/ux500/abx500-clk.c                     |   73 ++++++
 drivers/clk/ux500/clk-prcmu.c                      |   72 ++++++
 drivers/clk/ux500/clk.h                            |   12 +
 drivers/clk/ux500/u8500_clk.c                      |   78 +++++--
 drivers/clk/versatile/Makefile                     |    3 +
 drivers/clk/versatile/clk-icst.c                   |   66 +++++-
 drivers/clk/versatile/clk-icst.h                   |   14 +-
 drivers/clk/versatile/clk-impd1.c                  |   97 ++++++++
 drivers/clk/versatile/clk-integrator.c             |   55 ++---
 drivers/clk/versatile/clk-realview.c               |   65 ++----
 drivers/clk/versatile/clk-vexpress-osc.c           |  146 ++++++++++++
 drivers/clk/versatile/clk-vexpress.c               |  142 ++++++++++++
 drivers/cpufreq/db8500-cpufreq.c                   |  101 +++++----
 drivers/mfd/db8500-prcmu.c                         |   86 +++++--
 include/linux/clk-provider.h                       |   24 +-
 include/linux/mfd/db8500-prcmu.h                   |    4 +-
 include/linux/mfd/dbx500-prcmu.h                   |   10 +
 include/linux/platform_data/clk-integrator.h       |    2 +
 43 files changed, 1537 insertions(+), 577 deletions(-)
 create mode 100644 drivers/clk/clk-twl6040.c
 create mode 100644 drivers/clk/ux500/abx500-clk.c
 create mode 100644 drivers/clk/versatile/clk-impd1.c
 create mode 100644 drivers/clk/versatile/clk-vexpress-osc.c
 create mode 100644 drivers/clk/versatile/clk-vexpress.c
