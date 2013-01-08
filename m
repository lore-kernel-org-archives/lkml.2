Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab3AHStY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:49:24 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53938 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3AHStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:49:23 -0500
Date: Tue, 8 Jan 2013 10:49:20 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] ARM: arm-soc fixes for 3.8-rc
Message-ID: <20130108184920.GA1258@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A slightly larger delta than I'd ideally want by now, in part due to some
of the OMAP PM fixes that's adding a bit of code. I decided to include
it instead of push it to 3.9, but from here on out we'll be stricter.

Please pull.

Thanks!

-Olof


The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

for you to fetch changes up to 434fec16948cf5afa3cba31dcb00359bdbf24758:

  Merge tag 'omap-for-v3.8-rc2/fixes-signed-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2013-01-08 09:50:04 -0800)

----------------------------------------------------------------

ARM: arm-soc fixes for 3.8-rc

People are back from the holiday breaks, and it shows. Here are a bunch of
fixes for a number of platforms:
 - A couple of small fixes for Nomadik
 - A larger set of changes for kirkwood/mvebu
   - uart driver selection, dt clocks, gpio-poweroff fixups,
     a few __init annotation fixes and some error handling improvement
     in their xor dma driver.
 - i.MX had a couple of minor fixes (and a critical one for flexcan2
   clock setup)
 - MXS has a small board fix and a framebuffer bugfix
 - A set of fixes for Samsung Exynos, fixing default bootargs and some
   Exynos5440 clock issues
 - A set of OMAP changes including PM fixes and a few sparse warning
   fixups

All in all a bit more positive code delta than we'd ideally want to see
here, mostly from the OMAP PM changes, but nothing overly crazy.

----------------------------------------------------------------
Aaro Koskinen (1):
      ARM: OMAP1: fix USB configuration use-after-release

Andrew Lunn (5):
      ARM: Kirkwood: Fix missing clk for USB device.
      Power: gpio-poweroff: Fix documentation and gpio_is_valid
      ARM: Kirkwood: Fix missing sdio clock
      ARM: Kirkwood: Use fixed-regulator instead of board gpio call
      arm: mvebu: Add missing ; for cpu node.

Fabio Estevam (3):
      ARM: dts: imx23-olinuxino: Fix IOMUX settings
      clk: imx: Remove 'clock-output-names' from the examples
      ARM: dts: imx31-bug: Fix manufacturer compatible string

Gregory CLEMENT (1):
      arm: mvebu: Use dw-apb-uart instead of ns16650 as UART driver

Ivan Khoronzhuk (2):
      ARM: OMAP4: PRM: Correct reset source map
      ARM: OMAP4: PRM: Correct wrong instance usage for reading reset sources

Jon Hunter (1):
      ARM: OMAP3: clock data: Add missing enable/disable for EMU clock

Joshua Coombs (1):
      clk: mvebu: Remove inappropriate __init tagging

Kukjin Kim (5):
      ARM: SAMSUNG: fix the cpu id for EXYNOS5440
      ARM: dts: use uart port0 for console on exynos5440-ssdk5440
      ARM: dts: use uart port1 for console on exynos4210-smdkv310
      ARM: EXYNOS: enable PINCTRL for EXYNOS5440
      ARM: EXYNOS: skip the clock initialization for exynos5440

Linus Walleij (2):
      ARM: nomadik: delete dangling include
      ARM: nomadik: bump the IRQ numbers again

Lothar Waﬂmann (1):
      video: mxsfb: fix crash when unblanking the display

Marek Vasut (1):
      ARM: mx5: Fix MX53 flexcan2 clock

Nishanth Menon (1):
      ARM: OMAP4: PRM: fix RSTTIME and RSTST offsets

Nobuhiro Iwamatsu (1):
      ARM: Kirkwood: Switch TWSI1 of 88f6282 to DT clock providers

Olof Johansson (7):
      Merge tag 'nomadik-fixes-for-arm-soc' of git://git.kernel.org/.../linusw/linux-nomadik into fixes
      ARM: clps711x: Fix bad merge of clockevents setup
      Merge tag 'mvebu_fixes_for_v3.8' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'imx-fixes-3.8' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'mxs-fixes-3.8' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'v3.8-samsung-fixes-2' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'omap-for-v3.8-rc2/fixes-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Pantelis Antoniou (1):
      ARM: OMAP2+: am33xx-hwmod: Fix wrongly terminated am33xx_usbss_mpu_irqs array

Paul Walmsley (4):
      ARM: OMAP: 32k counter: resolve sparse warnings
      ARM: OMAP AM33xx: hwmod data: resolve sparse warnings
      ARM: OMAP: SRAM: resolve sparse warnings
      ARM: OMAP2/3: PRM: fix bogus OMAP2xxx powerstate return values

Rob Herring (6):
      ARM: dts: add device_type prop to cpu nodes on Calxeda platforms
      ARM: dts: fix highbank cpu mpidr values
      ARM: highbank: fix typos with hignbank in power request functions
      ARM: highbank: fix secondary boot and hotplug
      ARM: highbank: add a power request clear
      ARM: highbank: save and restore L2 cache and GIC on suspend

Sean Paul (1):
      ARM: EXYNOS: Revise HDMI resource size

Sebastian Hesselbarth (2):
      ARM: Dove: Add pinctrl clock to DT
      pinctrl: mvebu: make pdma clock on dove mandatory

Thomas Petazzoni (4):
      arm: mvebu: Armada XP MV78230 has two cores, not one
      arm: mvebu: Armada XP MV78230 has only three Ethernet interfaces
      dma: mv_xor: fix error handling of mv_xor_channel_add()
      dma: mv_xor: fix error handling for clocks

Tony Lindgren (1):
      Merge tag 'omap-fixes-a2-for-v3.8-rc' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.8-rc2/fixes

 .../devicetree/bindings/clock/imx23-clock.txt      |  5 --
 .../devicetree/bindings/clock/imx25-clock.txt      |  4 -
 .../devicetree/bindings/clock/imx28-clock.txt      |  5 --
 .../devicetree/bindings/clock/imx6q-clock.txt      |  4 -
 .../devicetree/bindings/gpio/gpio-poweroff.txt     | 20 ++++-
 arch/arm/Kconfig                                   |  1 -
 arch/arm/boot/dts/armada-370-xp.dtsi               |  6 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |  9 ++-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |  8 ++
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           |  8 ++
 arch/arm/boot/dts/armada-xp.dtsi                   | 14 +---
 arch/arm/boot/dts/dove.dtsi                        |  1 +
 arch/arm/boot/dts/ecx-2000.dts                     |  4 +
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |  2 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |  2 +-
 arch/arm/boot/dts/exynos5440-ssdk5440.dts          |  2 +-
 arch/arm/boot/dts/highbank.dts                     | 20 +++--
 arch/arm/boot/dts/imx23-olinuxino.dts              |  8 +-
 arch/arm/boot/dts/imx31-bug.dts                    |  2 +-
 arch/arm/boot/dts/imx53.dtsi                       |  2 +-
 arch/arm/boot/dts/kirkwood-6282.dtsi               |  1 +
 arch/arm/boot/dts/kirkwood-topkick.dts             | 17 +++++
 arch/arm/boot/dts/kirkwood.dtsi                    |  1 +
 arch/arm/configs/mvebu_defconfig                   |  4 +-
 arch/arm/mach-exynos/Kconfig                       |  2 +
 arch/arm/mach-exynos/common.c                      |  7 ++
 arch/arm/mach-highbank/highbank.c                  |  2 +-
 arch/arm/mach-highbank/hotplug.c                   |  2 +-
 arch/arm/mach-highbank/platsmp.c                   | 12 +--
 arch/arm/mach-highbank/pm.c                        | 19 ++++-
 arch/arm/mach-highbank/sysregs.h                   | 23 +++++-
 arch/arm/mach-highbank/system.c                    |  4 +-
 arch/arm/mach-kirkwood/board-dt.c                  |  4 +
 arch/arm/mach-kirkwood/board-usi_topkick.c         |  4 -
 arch/arm/mach-nomadik/board-nhk8815.c              |  1 -
 arch/arm/mach-nomadik/include/mach/irqs.h          | 78 +++++++++----------
 arch/arm/mach-omap1/board-ams-delta.c              |  2 +-
 arch/arm/mach-omap1/usb.c                          |  8 +-
 arch/arm/mach-omap2/cclock3xxx_data.c              |  2 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |  6 +-
 arch/arm/mach-omap2/prm2xxx.c                      | 88 +++++++++++++++++++++-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 | 22 ------
 arch/arm/mach-omap2/prm3xxx.c                      | 28 ++++++-
 arch/arm/mach-omap2/prm44xx.c                      |  6 +-
 arch/arm/mach-omap2/prm44xx.h                      |  4 +-
 arch/arm/plat-omap/counter_32k.c                   |  2 +
 arch/arm/plat-omap/sram.c                          |  2 +
 arch/arm/plat-samsung/include/plat/cpu.h           |  2 +-
 drivers/clk/mvebu/clk-gating-ctrl.c                |  2 +-
 drivers/dma/mv_xor.c                               |  9 ++-
 drivers/pinctrl/mvebu/pinctrl-dove.c               |  7 +-
 drivers/power/reset/gpio-poweroff.c                | 33 ++++----
 drivers/video/mxsfb.c                              |  3 +-
 53 files changed, 351 insertions(+), 183 deletions(-)
