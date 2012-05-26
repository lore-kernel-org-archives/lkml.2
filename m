Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2EZHXV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:23:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2EZHXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:10 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/8] arm-soc: clock driver changes
Date: Sat, 26 May 2012 00:22:34 -0700
Message-Id: <1338016958-7887-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1338016958-7887-1-git-send-email-olof@lixom.net>
References: <1338016958-7887-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new clock subsystem was merged in linux-3.4 without any users, this
now moves the first three platforms over to it: imx, mxs and spear.

The series also contains the changes for the clock subsystem itself,
since Mike preferred to have it together with the platforms that require
these changes, in order to avoid interdependencies and conflicts.

----------------------------------------------------------------

The following changes since commit d4a80a59ed34bd8c099099e8a8320f49a7e6dc7a:

  Merge tag 'cleanup2' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/clock

for you to fetch changes up to 3c0dec5f58b3c7b3627715126d1bf9b030a076f0:

  Merge branch 'clk-next' of git://git.linaro.org/people/mturquette/linux into next/clock

----------------------------------------------------------------

Andrew Lunn (14):
      ARM: Orion: Add clocks using the generic clk infrastructure.
      ARM: Orion: SPI: Add clk/clkdev support.
      ARM: Orion: Eth: Add clk/clkdev support.
      ARM: Orion: WDT: Add clk/clkdev support
      ARM: Orion: UART: Get the clock rate via clk_get_rate().
      ARM: Orion: SATA: Add per channel clk/clkdev support.
      ARM: Orion: EHCI: Add support for enabling clocks
      ARM: Orion: NAND: Add support for clk, if there is one.
      ARM: Orion: SDIO: Add support for clk.
      ARM: Orion: CESA: Add support for clk
      ARM: Orion: XOR: Add support for clk
      ARM: Orion: PCIE: Add support for clk
      ARM: Orion: Audio: Add clk/clkdev support
      ARM: Kirkwood: Replace clock gating

Arnd Bergmann (10):
      Merge branch 'depends/clk/clk-next' into next/clock
      Merge branch 'depends/rmk/clkdev' into next/clock
      Merge tag 'imx-common-clk' of git://git.pengutronix.de/git/imx/linux-2.6 into next/clock
      Merge branch 'clk/mxs' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/clock
      Merge branch 'spear/clock' into next/clock
      Merge branch 'imx/pinctrl' into imx/clock
      Merge branch 'spear/pinctrl' into spear/clock
      Merge branch 'spear/dt' into spear/clock
      Merge branches 'spear/clock' and 'imx/clock' into next/clock
      Merge branch 'clk-next' of git://git.linaro.org/people/mturquette/linux into next/clock

Mark Brown (3):
      clk: Remove comment for end of CONFIG_COMMON_CLK section
      clk: Constify parent name arrays
      clk: Provide dummy clk_unregister()

Mike Turquette (10):
      clk: core: correct clk_set_rate kerneldoc
      clk: core: remove dead code paths
      clk: core: clk_calc_new_rates handles NULL parents
      clk: core: enforce clk_ops consistency
      clk: core: copy parent_names & return error codes
      clk: basic: improve parent_names & return errors
      MAINTAINERS: add entry for common clk framework
      clk: prevent spurious parent rate propagation
      clk: remove COMMON_CLK_DISABLE_UNUSED
      clk: mux: assign init data

Rajendra Nayak (2):
      clk: Make clk_get_rate() return 0 on error
      clk: constify parent name arrays in macros

Rob Herring (2):
      clk: select CLKDEV_LOOKUP for COMMON_CLK
      clk: remove trailing whitespace from clk.h

Saravana Kannan (2):
      clk: Use a separate struct for holding init data.
      clk: Fix CLK_SET_RATE_GATE flag validation in clk_set_rate().

Sascha Hauer (31):
      dmaengine i.MX SDMA: do not depend on grouped clocks
      spi i.MX: do not depend on grouped clocks
      video imxfb: do not depend on grouped clocks
      net fec: do not depend on grouped clocks
      mmc mxcmmc: do not depend on grouped clocks
      mmc sdhc i.MX: do not depend on grouped clocks
      serial i.MX: do not depend on grouped clocks
      mtd mxc_nand: prepare/unprepare clock
      USB ehci mxc: prepare/unprepare clock
      USB ehci mxc: sanitize clock handling
      w1 i.MX: prepare/unprepare clock
      watchdog imx2: prepare clk before enabling it
      media mx3 camera: prepare clk before enabling it
      dmaengine i.MX ipu: clk_prepare/unprepare clock
      rtc: imx dryice: Add missing clk_prepare
      ARM i.MX5: prepare gpc_dvfs_clk
      ARM i.MX timer: request correct clock
      ARM i.MX3: Make ccm base address a variable
      ARM i.MX: prepare for common clock framework
      ARM i.MX: Add common clock support for pllv1
      ARM i.MX: Add common clock support for pllv2
      ARM i.MX: Add common clock support for 2bit gate
      ARM i.MX25: implement clocks using common clock framework
      ARM i.MX1: implement clocks using common clock framework
      ARM i.MX21: implement clocks using common clock framework
      ARM i.MX27: implement clocks using common clock framework
      ARM i.MX31: implement clocks using common clock framework
      clk: add a fixed factor clock
      ARM i.MX5: implement clocks using common clock framework
      ARM i.MX35: implement clocks using common clock framework
      ARM i.MX: remove now unused clock files

Shawn Guo (19):
      clk: use kzalloc in clk_register_mux
      clk: remove unnecessary EXPORT_SYMBOL_GPL
      clk: add "const" for clk_ops of basic clks
      clk: declare clk_ops of basic clks in clk-provider.h
      clk: always pass parent_rate into .round_rate
      clk: pass parent_rate into .set_rate
      clk: propagate round_rate for CLK_SET_RATE_PARENT case
      ARM: imx: add common clock support for pllv3
      ARM: imx: add common clock support for pfd
      ARM: imx: add common clock support for clk busy
      clk: mxs: add mxs specific clocks
      clk: mxs: add clock support for imx23
      clk: mxs: add clock support for imx28
      ARM: mxs: request clock for timer
      ARM: mxs: change the lookup name for fec phy clock
      ARM: mxs: switch to common clk framework
      ARM: mxs: remove old clock support
      ARM: mxs: remove now unused timer_clk argument from mxs_timer_init
      ARM: i.MX6: implement clocks using common clock framework

Viresh Kumar (14):
      clk: Fix typo in comment
      clk: clk-gate: Create clk_gate_endisable()
      clk: clk-private: Add DEFINE_CLK macro
      clk: Don't set clk->new_rate twice
      clk: clk_set_rate() must fail if CLK_SET_RATE_GATE is set and clk is enabled
      SPEAr: Add DT bindings for SPEAr's timer
      SPEAr: clk: Add VCO-PLL Synthesizer clock
      SPEAr: clk: Add Auxiliary Synthesizer clock
      SPEAr: clk: Add Fractional Synthesizer clock
      SPEAr: clk: Add General Purpose Timer Synthesizer clock
      SPEAr: Call clk_prepare() before calling clk_enable
      SPEAr: Switch to common clock framework
      SPEAr: Add SMI NOR partition info in dts files
      SPEAr: Update defconfigs


 .../devicetree/bindings/arm/spear-timer.txt     |   18 +
 MAINTAINERS                                     |   14 +-
 arch/arm/Kconfig                                |    3 +
 arch/arm/boot/dts/spear300-evb.dts              |   25 +
 arch/arm/boot/dts/spear310-evb.dts              |   20 +-
 arch/arm/boot/dts/spear320-evb.dts              |   25 +
 arch/arm/boot/dts/spear3xx.dtsi                 |    6 +
 arch/arm/boot/dts/spear600-evb.dts              |   29 +
 arch/arm/boot/dts/spear600.dtsi                 |    6 +
 arch/arm/configs/spear3xx_defconfig             |    4 +
 arch/arm/configs/spear6xx_defconfig             |    5 +-
 arch/arm/mach-dove/common.c                     |   39 +-
 arch/arm/mach-dove/dove-db-setup.c              |    1 -
 arch/arm/mach-imx/Kconfig                       |    8 +
 arch/arm/mach-imx/Makefile                      |   19 +-
 arch/arm/mach-imx/clk-busy.c                    |  189 ++
 arch/arm/mach-imx/clk-gate2.c                   |  118 +
 arch/arm/mach-imx/clk-imx1.c                    |  115 +
 arch/arm/mach-imx/clk-imx21.c                   |  186 ++
 arch/arm/mach-imx/clk-imx25.c                   |  248 ++
 arch/arm/mach-imx/clk-imx27.c                   |  290 +++
 arch/arm/mach-imx/clk-imx31.c                   |  182 ++
 arch/arm/mach-imx/clk-imx35.c                   |  278 +++
 arch/arm/mach-imx/clk-imx51-imx53.c             |  466 ++++
 arch/arm/mach-imx/clk-imx6q.c                   |  439 ++++
 arch/arm/mach-imx/clk-pfd.c                     |  147 ++
 arch/arm/mach-imx/clk-pllv1.c                   |   66 +
 arch/arm/mach-imx/clk-pllv2.c                   |  249 +++
 arch/arm/mach-imx/clk-pllv3.c                   |  419 ++++
 arch/arm/mach-imx/clk.h                         |   83 +
 arch/arm/mach-imx/clock-imx1.c                  |  636 ------
 arch/arm/mach-imx/clock-imx21.c                 | 1239 ----------
 arch/arm/mach-imx/clock-imx25.c                 |  346 ---
 arch/arm/mach-imx/clock-imx27.c                 |  785 -------
 arch/arm/mach-imx/clock-imx31.c                 |  630 ------
 arch/arm/mach-imx/clock-imx35.c                 |  536 -----
 arch/arm/mach-imx/clock-imx6q.c                 | 2111 ------------------
 arch/arm/mach-imx/clock-mx51-mx53.c             | 1675 --------------
 arch/arm/mach-imx/crmregs-imx3.h                |   79 +-
 arch/arm/mach-imx/mm-imx3.c                     |    6 +
 arch/arm/mach-imx/mm-imx5.c                     |    1 +
 arch/arm/mach-imx/pm-imx3.c                     |    4 +-
 arch/arm/mach-kirkwood/board-dreamplug.c        |    1 -
 arch/arm/mach-kirkwood/board-dt.c               |    3 +
 arch/arm/mach-kirkwood/common.c                 |  285 ++-
 arch/arm/mach-kirkwood/common.h                 |    1 +
 .../mach-kirkwood/include/mach/bridge-regs.h    |   16 +
 arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c  |    1 -
 arch/arm/mach-kirkwood/pcie.c                   |   25 +-
 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c    |    1 -
 arch/arm/mach-kirkwood/t5325-setup.c            |    1 -
 arch/arm/mach-kirkwood/tsx1x-common.c           |    1 -
 arch/arm/mach-mv78xx0/common.c                  |   45 +-
 arch/arm/mach-mxs/Makefile                      |    5 +-
 arch/arm/mach-mxs/clock-mx23.c                  |  536 -----
 arch/arm/mach-mxs/clock-mx28.c                  |  803 -------
 arch/arm/mach-mxs/clock.c                       |  211 --
 arch/arm/mach-mxs/include/mach/clock.h          |   62 -
 arch/arm/mach-mxs/include/mach/common.h         |    6 +-
 arch/arm/mach-mxs/mach-mx28evk.c                |    2 +-
 arch/arm/mach-mxs/regs-clkctrl-mx23.h           |  331 ---
 arch/arm/mach-mxs/regs-clkctrl-mx28.h           |  486 ----
 arch/arm/mach-mxs/system.c                      |   16 -
 arch/arm/mach-mxs/timer.c                       |   11 +-
 arch/arm/mach-orion5x/common.c                  |   27 +-
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c    |    1 -
 arch/arm/mach-spear3xx/Makefile                 |    2 +-
 arch/arm/mach-spear3xx/clock.c                  |  892 --------
 arch/arm/mach-spear3xx/include/mach/generic.h   |   21 +-
 arch/arm/mach-spear3xx/include/mach/irqs.h      |    1 -
 arch/arm/mach-spear3xx/include/mach/misc_regs.h |    2 +
 arch/arm/mach-spear3xx/include/mach/spear.h     |   14 +-
 arch/arm/mach-spear3xx/spear300.c               |    1 -
 arch/arm/mach-spear3xx/spear310.c               |    1 -
 arch/arm/mach-spear3xx/spear320.c               |   12 +-
 arch/arm/mach-spear3xx/spear3xx.c               |    4 +-
 arch/arm/mach-spear6xx/Makefile                 |    2 +-
 arch/arm/mach-spear6xx/clock.c                  |  789 -------
 arch/arm/mach-spear6xx/include/mach/generic.h   |    2 +-
 arch/arm/mach-spear6xx/include/mach/irqs.h      |    3 -
 arch/arm/mach-spear6xx/include/mach/misc_regs.h |    2 +
 arch/arm/mach-spear6xx/include/mach/spear.h     |    1 -
 arch/arm/mach-spear6xx/spear6xx.c               |    7 +-
 arch/arm/plat-mxc/clock.c                       |   11 +
 arch/arm/plat-mxc/include/mach/clock.h          |    4 +
 arch/arm/plat-mxc/time.c                        |   14 +
 arch/arm/plat-orion/common.c                    |  104 +-
 arch/arm/plat-orion/include/plat/common.h       |   34 +-
 arch/arm/plat-orion/include/plat/orion_wdt.h    |   18 -
 arch/arm/plat-orion/pcie.c                      |    4 +-
 arch/arm/plat-spear/Makefile                    |    2 +-
 arch/arm/plat-spear/clock.c                     | 1005 ---------
 arch/arm/plat-spear/include/plat/clock.h        |  249 ---
 arch/arm/plat-spear/time.c                      |   39 +-
 drivers/ata/sata_mv.c                           |   40 +-
 drivers/clk/Kconfig                             |   12 +-
 drivers/clk/Makefile                            |    5 +-
 drivers/clk/clk-divider.c                       |   68 +-
 drivers/clk/clk-fixed-factor.c                  |   95 +
 drivers/clk/clk-fixed-rate.c                    |   49 +-
 drivers/clk/clk-gate.c                          |  104 +-
 drivers/clk/clk-mux.c                           |   27 +-
 drivers/clk/clk.c                               |  279 ++-
 drivers/clk/mxs/Makefile                        |    8 +
 drivers/clk/mxs/clk-div.c                       |  110 +
 drivers/clk/mxs/clk-frac.c                      |  139 ++
 drivers/clk/mxs/clk-imx23.c                     |  204 ++
 drivers/clk/mxs/clk-imx28.c                     |  337 +++
 drivers/clk/mxs/clk-pll.c                       |  116 +
 drivers/clk/mxs/clk-ref.c                       |  154 ++
 drivers/clk/mxs/clk.c                           |   28 +
 drivers/clk/mxs/clk.h                           |   66 +
 drivers/clk/spear/Makefile                      |    8 +
 drivers/clk/spear/clk-aux-synth.c               |  198 ++
 drivers/clk/spear/clk-frac-synth.c              |  165 ++
 drivers/clk/spear/clk-gpt-synth.c               |  154 ++
 drivers/clk/spear/clk-vco-pll.c                 |  363 +++
 drivers/clk/spear/clk.c                         |   36 +
 drivers/clk/spear/clk.h                         |  134 ++
 drivers/clk/spear/spear3xx_clock.c              |  612 +++++
 drivers/clk/spear/spear6xx_clock.c              |  342 +++
 drivers/crypto/mv_cesa.c                        |   14 +
 drivers/dma/imx-sdma.c                          |   40 +-
 drivers/dma/ipu/ipu_idmac.c                     |    6 +-
 drivers/dma/mv_xor.c                            |   15 +
 drivers/dma/mv_xor.h                            |    1 +
 drivers/media/video/mx3_camera.c                |    4 +-
 drivers/mmc/host/mvsdio.c                       |   14 +
 drivers/mmc/host/mxcmmc.c                       |   39 +-
 drivers/mmc/host/sdhci-esdhc-imx.c              |   42 +-
 drivers/mtd/nand/mxc_nand.c                     |    6 +-
 drivers/mtd/nand/orion_nand.c                   |   18 +
 drivers/net/ethernet/freescale/fec.c            |   35 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c      |   42 +-
 drivers/rtc/rtc-imxdi.c                         |    6 +-
 drivers/spi/spi-imx.c                           |   30 +-
 drivers/spi/spi-orion.c                         |   30 +-
 drivers/tty/serial/imx.c                        |   38 +-
 drivers/usb/host/ehci-mxc.c                     |   62 +-
 drivers/usb/host/ehci-orion.c                   |   16 +
 drivers/video/imxfb.c                           |   50 +-
 drivers/w1/masters/mxc_w1.c                     |    4 +-
 drivers/watchdog/imx2_wdt.c                     |    2 +-
 drivers/watchdog/orion_wdt.c                    |   16 +-
 include/linux/clk-private.h                     |   99 +-
 include/linux/clk-provider.h                    |  120 +-
 include/linux/clk.h                             |    6 +-
 include/linux/mv643xx_eth.h                     |    1 -
 include/linux/spi/orion_spi.h                   |   17 -
 sound/soc/kirkwood/kirkwood-i2s.c               |   13 +
 sound/soc/kirkwood/kirkwood.h                   |    1 +
 151 files changed, 8310 insertions(+), 14192 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/spear-timer.txt
 create mode 100644 arch/arm/mach-imx/clk-busy.c
 create mode 100644 arch/arm/mach-imx/clk-gate2.c
 create mode 100644 arch/arm/mach-imx/clk-imx1.c
 create mode 100644 arch/arm/mach-imx/clk-imx21.c
 create mode 100644 arch/arm/mach-imx/clk-imx25.c
 create mode 100644 arch/arm/mach-imx/clk-imx27.c
 create mode 100644 arch/arm/mach-imx/clk-imx31.c
 create mode 100644 arch/arm/mach-imx/clk-imx35.c
 create mode 100644 arch/arm/mach-imx/clk-imx51-imx53.c
 create mode 100644 arch/arm/mach-imx/clk-imx6q.c
 create mode 100644 arch/arm/mach-imx/clk-pfd.c
 create mode 100644 arch/arm/mach-imx/clk-pllv1.c
 create mode 100644 arch/arm/mach-imx/clk-pllv2.c
 create mode 100644 arch/arm/mach-imx/clk-pllv3.c
 create mode 100644 arch/arm/mach-imx/clk.h
 delete mode 100644 arch/arm/mach-imx/clock-imx1.c
 delete mode 100644 arch/arm/mach-imx/clock-imx21.c
 delete mode 100644 arch/arm/mach-imx/clock-imx25.c
 delete mode 100644 arch/arm/mach-imx/clock-imx27.c
 delete mode 100644 arch/arm/mach-imx/clock-imx31.c
 delete mode 100644 arch/arm/mach-imx/clock-imx35.c
 delete mode 100644 arch/arm/mach-imx/clock-imx6q.c
 delete mode 100644 arch/arm/mach-imx/clock-mx51-mx53.c
 delete mode 100644 arch/arm/mach-mxs/clock-mx23.c
 delete mode 100644 arch/arm/mach-mxs/clock-mx28.c
 delete mode 100644 arch/arm/mach-mxs/clock.c
 delete mode 100644 arch/arm/mach-mxs/include/mach/clock.h
 delete mode 100644 arch/arm/mach-mxs/regs-clkctrl-mx23.h
 delete mode 100644 arch/arm/mach-mxs/regs-clkctrl-mx28.h
 delete mode 100644 arch/arm/mach-spear3xx/clock.c
 delete mode 100644 arch/arm/mach-spear6xx/clock.c
 delete mode 100644 arch/arm/plat-orion/include/plat/orion_wdt.h
 delete mode 100644 arch/arm/plat-spear/clock.c
 delete mode 100644 arch/arm/plat-spear/include/plat/clock.h
 create mode 100644 drivers/clk/clk-fixed-factor.c
 create mode 100644 drivers/clk/mxs/Makefile
 create mode 100644 drivers/clk/mxs/clk-div.c
 create mode 100644 drivers/clk/mxs/clk-frac.c
 create mode 100644 drivers/clk/mxs/clk-imx23.c
 create mode 100644 drivers/clk/mxs/clk-imx28.c
 create mode 100644 drivers/clk/mxs/clk-pll.c
 create mode 100644 drivers/clk/mxs/clk-ref.c
 create mode 100644 drivers/clk/mxs/clk.c
 create mode 100644 drivers/clk/mxs/clk.h
 create mode 100644 drivers/clk/spear/Makefile
 create mode 100644 drivers/clk/spear/clk-aux-synth.c
 create mode 100644 drivers/clk/spear/clk-frac-synth.c
 create mode 100644 drivers/clk/spear/clk-gpt-synth.c
 create mode 100644 drivers/clk/spear/clk-vco-pll.c
 create mode 100644 drivers/clk/spear/clk.c
 create mode 100644 drivers/clk/spear/clk.h
 create mode 100644 drivers/clk/spear/spear3xx_clock.c
 create mode 100644 drivers/clk/spear/spear6xx_clock.c
 delete mode 100644 include/linux/spi/orion_spi.h
