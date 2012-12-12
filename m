Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2LLQl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:41:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43566 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2LLQlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:41:25 -0500
Date: Wed, 12 Dec 2012 08:41:23 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 2/5] ARM: arm-soc: Header cleanups
Message-ID: <20121212164123.GB16288@quad.lixom.net>
References: <20121212163942.GA16036@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212163942.GA16036@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


This is a collection of header file cleanups, mostly for OMAP and AT91,
that keeps moving the platforms in the direction of multiplatform by
removing the need for mach-dependent header files used in drivers and
other places.


Conflicts seen with this merge:

arch/arm/mach-omap2/drm.c:
context conflict with DRM tree. Keep <plat/cpu.h> include for now,
we'll revisit and remove it properly later.

arch/arm/mach-omap2/omap_hwmod_44xx_data.c:
Context conflicts in header files.

arch/arm/plat-omap/i2c.c:
Drop both omap-pm.h and omap_device.h. Drop the whole block starting
with omap_i2c_nr_ports() -- there are conflicts between a fix that went
in during 3.7-rc and other cleanups. The fix will be re-addressed.

drivers/video/omap2/dss/dss.c:
Drop the HEAD version (cpu_is_xxx() pieces -- it was a temporary fix to
3.7 while the cleanups happened for 3.8. No longer needed.

drivers/tty/serial/atmel_serial.c:
Both new includes are needed.

include/linux/platform_data/mmc-omap.h:
Keep both sides, but renumber so there are no aliases.

Two removed defconfigs upstream, remove them:
afeb9260_defconfig and stamp9g20_defconfig.


----------------------------------------------------------------

The following changes since commit aa98bc51f299a2aab8937ef72684258fe322990a:

  Merge branch 'next/fixes-non-critical' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/headers

for you to fetch changes up to 8556650dd3370a927217f16444aac5cc0c71e61b:

  Merge tag 'omap-for-v3.8/cleanup-headers-iommu-signed' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into next/headers

----------------------------------------------------------------

Afzal Mohammed (16):
      ARM: OMAP2+: nand: unify init functions
      ARM: OMAP2+: onenand: refactor for clarity
      ARM: OMAP2+: gpmc: remove cs# in sync clk div calc
      mtd: onenand: omap: cleanup gpmc dependency
      mtd: nand: omap: free region as per resource size
      mtd: nand: omap: read nand using register address
      ARM: OMAP2+: onenand: connected soc info in pdata
      mtd: onenand: omap: use pdata info instead of cpu_is
      ARM: OMAP2+: onenand: header cleanup
      ARM: OMAP2+: nand: header cleanup
      mtd: nand: omap: bring in gpmc nand macros
      ARM: OMAP2+: nand: bch capability check
      ARM: OMAP2+: gpmc: nand register helper bch update
      mtd: nand: omap: handle gpmc bch[48]
      ARM: OMAP2+: gpmc: remove exported nand functions
      ARM: OMAP2+: gpmc: localize gpmc header

Arnd Bergmann (3):
      Merge tag 'omap-for-v3.8/cleanup-headers-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/headers
      Merge tag 'omap-for-v3.8/cleanup-headers-prepare-multiplatform-v3-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/headers
      Merge tag 'for-3.8-at91_header_clean' of git://github.com/at91linux/linux-at91 into next/headers

Felipe Balbi (1):
      ARM: OMAP: move OMAP USB platform data to <linux/platform_data/omap-usb.h>

Ido Yariv (3):
      ARM: OMAP: Merge iommu2.h into iommu.h
      ARM: OMAP2+: Move iopgtable header to drivers/iommu/
      ARM: OMAP2+: Make some definitions local

Jean-Christophe PLAGNIOL-VILLARD (11):
      arm: at91: drop machine defconfig
      arm: at91: move platfarm_data to include/linux/platform_data/atmel.h
      arm: at91 move board.h to arch/arm/mach-at91
      arm: at91 move at91_aic.h to arch/arm/mach-at91
      arn: at91: move at91_tc.h to arch/arm/mach-at91
      arm: at91: move board header to arch/arm/mach-at91
      arm: at91: move at91_shdwc.h to arch/arm/mach-at91
      arm: at91: move pit define to the driver
      arm: at91: move reset controller header to arm/arm/mach-at91
      arm: at91: move at91rm9200 rtc header in drivers/rtc
      atmel: move ATMEL_MAX_UART to platform_data/atmel.h

Jon Hunter (1):
      ARM: OMAP2+: GPMC: Remove unused OneNAND get_freq() platform function

Lokesh Vutla (7):
      ARM: OMAP: DMA: Removing plat/dma-44xx.h
      ARM: OMAP1: DMA: Moving OMAP1 DMA channel definitions to mach-omap1
      ARM: OMAP2+: DMA: Moving OMAP2+ DMA channel definitions to mach-omap2
      ARM: OMAP: DMA: Move plat/dma.h to plat-omap/dma-omap.h
      ARM: OMAP1: Remove omap_reserve() callback for all omap1 boards
      ARM: OMAP2+: Move omap_reserve() locally to mach-omap2
      ARM: OMAP: Move plat/omap-secure.h locally to mach-omap2

Olof Johansson (8):
      Merge branch 'depends/tty' into next/headers
      Merge tag 'omap-for-v3.8/cleanup-headers-serial-take2-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/headers
      Merge branch 'depends/omap-cleanup-headers-usb' into next/headers
      Merge branch 'depends/omap-cleanup-headers-menelaus' into next/headers
      Merge tag 'omap-for-v3.8/cleanup-headers-part3-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/headers
      Merge tag 'omap-for-v3.8/cleanup-prcm-part1-take2-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/headers
      Merge tag 'at91-header' of git://github.com/at91linux/linux-at91 into next/headers
      Merge tag 'omap-for-v3.8/cleanup-headers-iommu-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/headers

Paul Walmsley (18):
      staging: tidspbridge: remove unnecessary include of <plat/clock.h>
      ARM: OMAP: move plat-omap/include/plat/sdrc.h into mach-omap2/sdrc.h
      ARM: OMAP: duplicate plat-omap/clock.c into mach-omap[12]/clock.c
      ARM: OMAP: remove plat/clock.h
      ARM: OMAP: clock: split plat/clkdev_omap.h into OMAP1/2 files
      ARM: OMAP2+: PRM: remove PRM weak functions
      ARM: OMAP2+: PRM: split PRM functions into OMAP2, OMAP3-specific files
      ARM: OMAP2+: powerdomain/PRM: move the low-level powerdomain functions into PRM
      ARM: OMAP2+: CM/hwmod: split CM functions into OMAP2, OMAP3-specific files
      ARM: OMAP2/3: clockdomain/PRM/CM: move the low-level clockdomain functions into PRM/CM
      ARM: OMAP2+: PRM: prepare for use of prm_ll_data function pointers
      ARM: OMAP2+: CM: prepare for use of cm_ll_data function pointers
      ARM: OMAP1: create read_reset_sources() function (for initial use by watchdog)
      ARM: OMAP2+: PRM: create PRM reset source API for the watchdog timer driver
      ARM: OMAP2+: fix build breakage introduced by commit b7754452b3e27716347a528b47b0a1083af32520
      ARM: OMAP1: fix build breakage introduced by commit 25c7d49ed48b4843da7dea56a81ae7f620211ee0
      ARM: OMAP1: fix sparse warning added by commit 4c98dc6b8ef2f73bdbfa78186db9a76507ba9ea3
      ARM: OMAP1: usb: fix sparse warnings

Tomi Valkeinen (12):
      OMAPDSS: add omapdss_version
      OMAPDSS: use omapdss_version in dss_features.c
      OMAPDSS: DISPC: use omapdss_version
      OMAPDSS: DSS: use omapdss_version
      OMAPDSS: HDMI: use omapdss_version
      OMAPDSS: remove <plat/cpu.h> includes
      OMAP: VRFB: convert vrfb to platform device
      OMAP: move arch/arm/plat-omap/include/plat/vrfb.h
      OMAP: SDRC: remove VRFB code
      OMAPDSS: VRFB: add omap_vrfb_supported()
      OMAPFB: use omap_vrfb_supported()
      ARM: OMAP: Remove omap_init_consistent_dma_size()

Tony Lindgren (50):
      ARM: OMAP: Split plat/mmc.h into local headers and platform_data
      mmc: omap: Remove cpu_is_omap usage from the driver
      ARM: OMAP2: Move plat/menelaus.h to linux/mfd/menelaus.h
      ARM: OMAP: Trivial driver changes to remove include plat/cpu.h
      Merge tag 'gpmc-czimage' of git://gitorious.org/x0148406-public/linux-kernel into omap-for-v3.8/cleanup-headers-gpmc
      Merge remote-tracking branch 'tomi/3.8/vrfb-conversion' into omap-for-v3.8/cleanup-headers-dss
      Merge branch 'omap-for-v3.8/cleanup-headers-dma' into omap-for-v3.8/cleanup-headers
      Merge branch 'omap-for-v3.8/cleanup-headers-gpmc' into omap-for-v3.8/cleanup-headers
      Merge branch 'omap-for-v3.8/cleanup-headers-mmc' into omap-for-v3.8/cleanup-headers
      Merge branch 'omap-for-v3.8/cleanup-headers-dss' into omap-for-v3.8/cleanup-headers
      ARM: OMAP: Make plat/fpga.h local to arch/arm/plat-omap
      ARM: OMAP1: Move plat/tc.h to mach/tc.h for omap1
      ARM: OMAP2+: Make board-zoom.h local
      ARM: OMAP: Split plat-omap/i2c.c into mach-omap1 and mach-omap2
      ARM: OMAP: Make plat/common.h local to mach-omap1 and mach-omap2
      ARM: OMAP: Move plat/led.h to include/linux/platform_data
      ARM: OMAP: Make plat/sram.h local to plat-omap
      ARM: OMAP: Make omap_device local to mach-omap2
      Merge branch 'omap-for-v3.8/cleanup-headers-asoc' into omap-for-v3.8/cleanup-headers
      ARM: OMAP: Make plat/omap_hwmod.h local to mach-omap2
      ARM: OMAP: Merge plat/multi.h into plat/cpu.h
      ARM: OMAP: Make plat/omap-pm.h local to mach-omap2
      ARM: OMAP: Split plat/cpu.h into local soc.h for mach-omap1 and mach-omap2
      Merge tag 'omap-for-v3.8/cleanup-headers-signed' into omap-for-v3.8/cleanup-headers-serial-take2
      ARM: OMAP: Split uncompress.h to mach-omap1 and mach-omap2
      ARM: OMAP: Split plat/serial.h for omap1 and omap2+
      ARM: OMAP2+: Introduce local usb.h
      Merge branch 'omap-for-v3.8/cleanup-headers-usb' into omap-for-v3.8/cleanup-headers
      Merge tag 'omap-cleanup-a-for-3.8' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.8/cleanup-prcm
      Merge branch 'omap-for-v3.8/cleanup-headers-menelaus' into omap-for-v3.8/cleanup-headers
      Merge tag 'omap-cleanup-fixes-a-for-3.8' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.8/cleanup-headers
      Merge branch 'omap-for-v3.8/cleanup-headers' into omap-for-v3.8/cleanup-prcm
      ARM: OMAP: Split sram.h to local headers and minimal shared header
      ARM: OMAP: Introduce common omap_map_sram() and omap_sram_reset()
      ARM: OMAP: Move omap1 specific code to local sram.c
      ARM: OMAP: Move omap2+ specific parts of sram.c to mach-omap2
      ARM: OMAP: Make plat-omap/i2c.c port checks local
      ARM: OMAP: Fix relative includes for shared i2c.h file
      ARM: OMAP: Move omap-pm-noop.c local to mach-omap2
      ARM: OMAP: Remove plat-omap/common.h
      ARM: OMAP: Fix relative includes for debug-devices.h
      ARM: OMAP: Remove cpu_is_omap usage from plat-omap/dma.c
      ARM: OMAP1: Remove relative includes
      ARM: OMAP: Fix relative includes for fpga.h
      ARM: OMAP2+: Fix relative includes for serial.h
      ARM: OMAP: Remove unnecessary mach and plat includes
      ARM: OMAP: Remove NEED_MACH_GPIO_H
      ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
      ARM: OMAP2+: Move iommu2 to drivers/iommu/omap-iommu2.c
      ARM: OMAP2+: Move iommu/iovmm headers to platform_data


 arch/arm/Kconfig                                |   1 -
 arch/arm/configs/cam60_defconfig                | 173 ------
 arch/arm/configs/cpu9260_defconfig              | 116 ----
 arch/arm/configs/cpu9g20_defconfig              | 116 ----
 arch/arm/configs/qil-a9260_defconfig            | 114 ----
 arch/arm/configs/sam9_l9260_defconfig           | 148 -----
 arch/arm/configs/usb-a9260_defconfig            | 105 ----
 .../arm/mach-at91/{include/mach => }/at91_aic.h |   0
 .../mach-at91/{include/mach => }/at91_rstc.h    |   0
 .../mach-at91/{include/mach => }/at91_shdwc.h   |   0
 arch/arm/mach-at91/{include/mach => }/at91_tc.h |   0
 arch/arm/mach-at91/at91rm9200.c                 |   2 +-
 arch/arm/mach-at91/at91rm9200_devices.c         |   2 +-
 arch/arm/mach-at91/at91sam9260.c                |   4 +-
 arch/arm/mach-at91/at91sam9260_devices.c        |   2 +-
 arch/arm/mach-at91/at91sam9261.c                |   4 +-
 arch/arm/mach-at91/at91sam9261_devices.c        |   2 +-
 arch/arm/mach-at91/at91sam9263.c                |   4 +-
 arch/arm/mach-at91/at91sam9263_devices.c        |   2 +-
 arch/arm/mach-at91/at91sam926x_time.c           |  14 +-
 arch/arm/mach-at91/at91sam9_alt_reset.S         |   2 +-
 arch/arm/mach-at91/at91sam9g45.c                |   2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c        |   2 +-
 arch/arm/mach-at91/at91sam9g45_reset.S          |   3 +-
 arch/arm/mach-at91/at91sam9n12.c                |   2 +-
 arch/arm/mach-at91/at91sam9rl.c                 |   4 +-
 arch/arm/mach-at91/at91sam9rl_devices.c         |   2 +-
 arch/arm/mach-at91/at91sam9x5.c                 |   2 +-
 arch/arm/mach-at91/at91x40.c                    |   3 +-
 arch/arm/mach-at91/at91x40_time.c               |   3 +-
 arch/arm/mach-at91/board-1arm.c                 |   4 +-
 arch/arm/mach-at91/board-afeb-9260v1.c          |   5 +-
 arch/arm/mach-at91/board-cam60.c                |   4 +-
 arch/arm/mach-at91/board-carmeva.c              |   4 +-
 arch/arm/mach-at91/board-cpu9krea.c             |   4 +-
 arch/arm/mach-at91/board-cpuat91.c              |   4 +-
 arch/arm/mach-at91/board-csb337.c               |   4 +-
 arch/arm/mach-at91/board-csb637.c               |   4 +-
 arch/arm/mach-at91/board-dt.c                   |   5 +-
 arch/arm/mach-at91/board-eb01.c                 |   5 +-
 arch/arm/mach-at91/board-eb9200.c               |   5 +-
 arch/arm/mach-at91/board-ecbat91.c              |   4 +-
 arch/arm/mach-at91/board-eco920.c               |   4 +-
 arch/arm/mach-at91/board-flexibity.c            |   4 +-
 arch/arm/mach-at91/board-foxg20.c               |   4 +-
 arch/arm/mach-at91/board-gsia18s.c              |   8 +-
 arch/arm/mach-at91/board-kafa.c                 |   4 +-
 arch/arm/mach-at91/board-kb9202.c               |   4 +-
 arch/arm/mach-at91/board-neocore926.c           |   4 +-
 arch/arm/mach-at91/board-pcontrol-g20.c         |   6 +-
 arch/arm/mach-at91/board-picotux200.c           |   4 +-
 arch/arm/mach-at91/board-qil-a9260.c            |   6 +-
 arch/arm/mach-at91/board-rm9200dk.c             |   4 +-
 arch/arm/mach-at91/board-rm9200ek.c             |   4 +-
 arch/arm/mach-at91/board-rsi-ews.c              |   4 +-
 arch/arm/mach-at91/board-sam9-l9260.c           |   4 +-
 arch/arm/mach-at91/board-sam9260ek.c            |   6 +-
 arch/arm/mach-at91/board-sam9261ek.c            |   6 +-
 arch/arm/mach-at91/board-sam9263ek.c            |   6 +-
 arch/arm/mach-at91/board-sam9g20ek.c            |   4 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c         |   6 +-
 arch/arm/mach-at91/board-sam9rlek.c             |   7 +-
 arch/arm/mach-at91/board-snapper9260.c          |   4 +-
 arch/arm/mach-at91/board-stamp9g20.c            |   4 +-
 arch/arm/mach-at91/board-usb-a926x.c            |   6 +-
 arch/arm/mach-at91/board-yl-9200.c              |   4 +-
 arch/arm/mach-at91/{include/mach => }/board.h   |  55 --
 arch/arm/mach-at91/{include/mach => }/gsia18s.h |   0
 arch/arm/mach-at91/include/mach/at91_pit.h      |  32 --
 arch/arm/mach-at91/include/mach/hardware.h      |   3 -
 arch/arm/mach-at91/irq.c                        |   2 +-
 arch/arm/mach-at91/leds.c                       |   2 +-
 arch/arm/mach-at91/pm.c                         |   6 +-
 arch/arm/mach-at91/setup.c                      |   2 +-
 .../mach-at91/{include/mach => }/stamp9g20.h    |   0
 arch/arm/mach-omap1/Makefile                    |   3 +-
 arch/arm/mach-omap1/board-ams-delta.c           |   1 -
 arch/arm/mach-omap1/board-fsample.c             |   9 +-
 arch/arm/mach-omap1/board-generic.c             |   1 -
 arch/arm/mach-omap1/board-h2-mmc.c              |   5 +-
 arch/arm/mach-omap1/board-h2.c                  |   6 +-
 arch/arm/mach-omap1/board-h3-mmc.c              |   3 +-
 arch/arm/mach-omap1/board-h3.c                  |   5 +-
 arch/arm/mach-omap1/board-htcherald.c           |   3 +-
 arch/arm/mach-omap1/board-innovator.c           |  30 +-
 arch/arm/mach-omap1/board-nokia770.c            |   5 +-
 arch/arm/mach-omap1/board-osk.c                 |   3 +-
 arch/arm/mach-omap1/board-palmte.c              |   6 +-
 arch/arm/mach-omap1/board-palmtt.c              |   8 +-
 arch/arm/mach-omap1/board-palmz71.c             |   6 +-
 arch/arm/mach-omap1/board-perseus2.c            |   9 +-
 arch/arm/mach-omap1/board-sx1-mmc.c             |   3 +-
 arch/arm/mach-omap1/board-sx1.c                 |   6 +-
 arch/arm/mach-omap1/board-voiceblue.c           |   3 +-
 arch/arm/mach-omap1/clock.c                     | 507 ++++++++++++++++-
 arch/arm/mach-omap1/clock.h                     | 178 +++++-
 arch/arm/mach-omap1/clock_data.c                |  16 +-
 arch/arm/mach-omap1/common.h                    |   7 +-
 arch/arm/mach-omap1/devices.c                   |  14 +-
 arch/arm/mach-omap1/dma.c                       |   9 +-
 arch/arm/mach-omap1/dma.h                       |  83 +++
 arch/arm/mach-omap1/flash.c                     |   2 +-
 arch/arm/mach-omap1/fpga.c                      |   4 +-
 arch/arm/mach-omap1/fpga.h                      |  52 ++
 arch/arm/mach-omap1/gpio15xx.c                  |   2 +
 arch/arm/mach-omap1/gpio16xx.c                  |   2 +
 arch/arm/mach-omap1/gpio7xx.c                   |   2 +
 arch/arm/mach-omap1/i2c.c                       |  64 ++-
 arch/arm/mach-omap1/id.c                        |   2 +-
 arch/arm/mach-omap1/include/mach/debug-macro.S  |   2 +-
 arch/arm/mach-omap1/include/mach/entry-macro.S  |   2 -
 arch/arm/mach-omap1/include/mach/gpio.h         |   3 -
 arch/arm/mach-omap1/include/mach/hardware.h     |   9 +-
 arch/arm/mach-omap1/include/mach/memory.h       |   2 +-
 arch/arm/mach-omap1/include/mach/omap1510.h     | 113 ++++
 arch/arm/mach-omap1/include/mach/serial.h       |  53 ++
 arch/arm/mach-omap1/include/mach/soc.h          | 229 ++++++++
 .../plat => mach-omap1/include/mach}/tc.h       |   0
 arch/arm/mach-omap1/include/mach/uncompress.h   | 121 ++++-
 arch/arm/mach-omap1/io.c                        |   5 +-
 arch/arm/mach-omap1/iomap.h                     |   3 -
 arch/arm/mach-omap1/irq.c                       |   2 +-
 arch/arm/mach-omap1/lcd_dma.c                   |   4 +-
 arch/arm/mach-omap1/mcbsp.c                     |   5 +-
 arch/arm/mach-omap1/mmc.h                       |  18 +
 arch/arm/mach-omap1/opp_data.c                  |   2 +-
 arch/arm/mach-omap1/pm.c                        |  10 +-
 arch/arm/mach-omap1/pm_bus.c                    |   3 +-
 arch/arm/mach-omap1/reset.c                     |  38 ++
 arch/arm/mach-omap1/serial.c                    |   1 -
 arch/arm/mach-omap1/sleep.S                     |   2 +
 arch/arm/mach-omap1/soc.h                       |   4 +
 arch/arm/mach-omap1/sram-init.c                 |  76 +++
 arch/arm/mach-omap1/sram.h                      |   7 +
 arch/arm/mach-omap1/timer32k.c                  |   1 +
 arch/arm/mach-omap1/usb.c                       |   6 +-
 arch/arm/mach-omap2/Makefile                    | 118 ++--
 arch/arm/mach-omap2/am35xx-emac.c               |   2 +-
 arch/arm/mach-omap2/board-2430sdp.c             |   4 +-
 arch/arm/mach-omap2/board-3430sdp.c             |   6 +-
 arch/arm/mach-omap2/board-3630sdp.c             |   3 +-
 arch/arm/mach-omap2/board-4430sdp.c             |   4 +-
 arch/arm/mach-omap2/board-am3517crane.c         |   1 -
 arch/arm/mach-omap2/board-am3517evm.c           |   2 +-
 arch/arm/mach-omap2/board-apollon.c             |   4 +-
 arch/arm/mach-omap2/board-cm-t35.c              |  10 +-
 arch/arm/mach-omap2/board-cm-t3517.c            |   6 +-
 arch/arm/mach-omap2/board-devkit8000.c          |  11 +-
 arch/arm/mach-omap2/board-flash.c               |  52 +-
 arch/arm/mach-omap2/board-flash.h               |   8 +-
 arch/arm/mach-omap2/board-h4.c                  |   8 +-
 arch/arm/mach-omap2/board-igep0020.c            |   9 +-
 arch/arm/mach-omap2/board-ldp.c                 |   9 +-
 arch/arm/mach-omap2/board-n8x0.c                |   5 +-
 arch/arm/mach-omap2/board-omap3beagle.c         |  16 +-
 arch/arm/mach-omap2/board-omap3evm.c            |  11 +-
 arch/arm/mach-omap2/board-omap3logic.c          |   7 +-
 arch/arm/mach-omap2/board-omap3pandora.c        |   4 +-
 arch/arm/mach-omap2/board-omap3stalker.c        |   3 +-
 arch/arm/mach-omap2/board-omap3touchbook.c      |  11 +-
 arch/arm/mach-omap2/board-omap4panda.c          |   6 +-
 arch/arm/mach-omap2/board-overo.c               |  11 +-
 arch/arm/mach-omap2/board-rm680.c               |   9 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |   7 +-
 arch/arm/mach-omap2/board-rx51.c                |   8 +-
 arch/arm/mach-omap2/board-ti8168evm.c           |   3 +-
 arch/arm/mach-omap2/board-zoom-debugboard.c     |   4 +-
 arch/arm/mach-omap2/board-zoom-display.c        |   3 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c    |   3 +-
 arch/arm/mach-omap2/board-zoom.c                |   8 +-
 .../mach-omap2/{include/mach => }/board-zoom.h  |   0
 arch/arm/mach-omap2/clkt2xxx_apll.c             |   3 +-
 arch/arm/mach-omap2/clkt2xxx_dpll.c             |   4 +-
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c         |   6 +-
 arch/arm/mach-omap2/clkt2xxx_osc.c              |   2 -
 arch/arm/mach-omap2/clkt2xxx_sys.c              |   2 -
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c    |   6 +-
 arch/arm/mach-omap2/clkt34xx_dpll3m2.c          |   5 +-
 arch/arm/mach-omap2/clkt_clksel.c               |   2 -
 arch/arm/mach-omap2/clkt_dpll.c                 |   2 -
 arch/arm/mach-omap2/clkt_iclk.c                 |   1 -
 arch/arm/mach-omap2/clock.c                     | 521 +++++++++++++++++-
 arch/arm/mach-omap2/clock.h                     | 317 ++++++++++-
 arch/arm/mach-omap2/clock2420_data.c            |   6 +-
 arch/arm/mach-omap2/clock2430.c                 |   4 +-
 arch/arm/mach-omap2/clock2430_data.c            |   6 +-
 arch/arm/mach-omap2/clock2xxx.c                 |   2 -
 arch/arm/mach-omap2/clock33xx_data.c            |   5 +-
 arch/arm/mach-omap2/clock34xx.c                 |   4 +-
 arch/arm/mach-omap2/clock3517.c                 |   4 +-
 arch/arm/mach-omap2/clock36xx.c                 |   2 -
 arch/arm/mach-omap2/clock3xxx.c                 |   2 -
 arch/arm/mach-omap2/clock3xxx_data.c            |   6 +-
 arch/arm/mach-omap2/clock44xx_data.c            |   4 -
 arch/arm/mach-omap2/clockdomain.c               |   3 +-
 arch/arm/mach-omap2/clockdomain.h               |   5 +-
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c      | 339 ------------
 arch/arm/mach-omap2/clockdomain33xx.c           |  74 ---
 arch/arm/mach-omap2/clockdomain44xx.c           | 151 -----
 arch/arm/mach-omap2/clockdomains2420_data.c     |   1 +
 arch/arm/mach-omap2/clockdomains2430_data.c     |   1 +
 arch/arm/mach-omap2/clockdomains3xxx_data.c     |   1 +
 arch/arm/mach-omap2/cm.h                        |  12 +
 arch/arm/mach-omap2/cm2xxx.c                    | 255 +++++++++
 arch/arm/mach-omap2/cm2xxx.h                    |  66 +++
 arch/arm/mach-omap2/cm2xxx_3xxx.h               | 119 ++--
 arch/arm/mach-omap2/cm33xx.c                    |  58 +-
 arch/arm/mach-omap2/{cm2xxx_3xxx.c => cm3xxx.c} | 307 ++++++-----
 arch/arm/mach-omap2/cm3xxx.h                    |  86 +++
 arch/arm/mach-omap2/cm_common.c                 |  71 +++
 arch/arm/mach-omap2/cminst44xx.c                | 142 ++++-
 arch/arm/mach-omap2/common-board-devices.c      |  46 --
 arch/arm/mach-omap2/common-board-devices.h      |   1 -
 arch/arm/mach-omap2/common.c                    |  22 +-
 arch/arm/mach-omap2/common.h                    |  13 +-
 arch/arm/mach-omap2/control.c                   |   8 +-
 arch/arm/mach-omap2/devices.c                   |  10 +-
 arch/arm/mach-omap2/display.c                   |  45 +-
 arch/arm/mach-omap2/dma.c                       |  11 +-
 arch/arm/mach-omap2/dma.h                       | 131 +++++
 arch/arm/mach-omap2/dpll3xxx.c                  |   2 -
 arch/arm/mach-omap2/dpll44xx.c                  |   2 -
 arch/arm/mach-omap2/drm.c                       |   5 +-
 arch/arm/mach-omap2/dsp.c                       |   2 +-
 arch/arm/mach-omap2/gpio.c                      |   6 +-
 arch/arm/mach-omap2/gpmc-nand.c                 |  85 ++-
 arch/arm/mach-omap2/gpmc-nand.h                 |  27 +
 arch/arm/mach-omap2/gpmc-onenand.c              | 214 ++++----
 arch/arm/mach-omap2/gpmc-onenand.h              |  24 +
 arch/arm/mach-omap2/gpmc-smc91x.c               |   2 +-
 arch/arm/mach-omap2/gpmc-smsc911x.c             |   2 +-
 arch/arm/mach-omap2/gpmc.c                      | 464 +---------------
 .../include/plat => mach-omap2}/gpmc.h          |  61 +--
 arch/arm/mach-omap2/hdq1w.c                     |   4 +-
 arch/arm/mach-omap2/hdq1w.h                     |   2 +-
 arch/arm/mach-omap2/hsmmc.c                     |   8 +-
 arch/arm/mach-omap2/hwspinlock.c                |   4 +-
 arch/arm/mach-omap2/i2c.c                       |  69 ++-
 arch/arm/mach-omap2/i2c.h                       |  42 ++
 arch/arm/mach-omap2/include/mach/debug-macro.S  |   2 +-
 arch/arm/mach-omap2/include/mach/gpio.h         |   3 -
 .../plat => mach-omap2/include/mach}/serial.h   |  20 -
 arch/arm/mach-omap2/include/mach/uncompress.h   | 175 +++++-
 arch/arm/mach-omap2/io.c                        |  25 +-
 arch/arm/mach-omap2/mcbsp.c                     |   7 +-
 arch/arm/mach-omap2/mmc.h                       |  23 +
 arch/arm/mach-omap2/msdi.c                      |   7 +-
 arch/arm/mach-omap2/mux.c                       |   3 +-
 arch/arm/mach-omap2/omap-iommu.c                |   2 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c       |   1 +
 .../{plat-omap => mach-omap2}/omap-pm-noop.c    |   5 +-
 .../include/plat => mach-omap2}/omap-pm.h       |   0
 arch/arm/mach-omap2/omap-secure.c               |   1 -
 arch/arm/mach-omap2/omap-secure.h               |   7 +
 arch/arm/mach-omap2/omap4-common.c              |   8 +-
 .../arm/{plat-omap => mach-omap2}/omap_device.c |   5 +-
 .../include/plat => mach-omap2}/omap_device.h   |   2 +-
 arch/arm/mach-omap2/omap_hwmod.c                |  55 +-
 .../include/plat => mach-omap2}/omap_hwmod.h    |   1 -
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      |  13 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      |  12 +-
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c    |   3 +-
 .../omap_hwmod_2xxx_3xxx_ipblock_data.c         |   9 +-
 .../omap_hwmod_2xxx_interconnect_data.c         |   4 +-
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   |   6 +-
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c      |  10 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      |  16 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      |  13 +-
 arch/arm/mach-omap2/omap_hwmod_common_data.c    |   2 +-
 arch/arm/mach-omap2/omap_hwmod_common_data.h    |   2 +-
 arch/arm/mach-omap2/omap_opp_data.h             |   2 +-
 arch/arm/mach-omap2/omap_phy_internal.c         |   4 +-
 arch/arm/mach-omap2/omap_twl.c                  |   1 +
 arch/arm/mach-omap2/opp.c                       |   2 +-
 arch/arm/mach-omap2/opp3xxx_data.c              |   1 +
 arch/arm/mach-omap2/pm-debug.c                  |   5 +-
 arch/arm/mach-omap2/pm.c                        |   5 +-
 arch/arm/mach-omap2/pm24xx.c                    |  13 +-
 arch/arm/mach-omap2/pm34xx.c                    |  14 +-
 arch/arm/mach-omap2/pm44xx.c                    |   1 +
 arch/arm/mach-omap2/pmu.c                       |   5 +-
 arch/arm/mach-omap2/powerdomain.h               |   2 -
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c      | 242 ---------
 arch/arm/mach-omap2/powerdomain33xx.c           | 229 --------
 arch/arm/mach-omap2/powerdomain44xx.c           | 285 ----------
 arch/arm/mach-omap2/powerdomains2xxx_data.c     |   1 +
 arch/arm/mach-omap2/prcm.c                      |   1 +
 arch/arm/mach-omap2/prm-regbits-24xx.h          |   6 +-
 arch/arm/mach-omap2/prm-regbits-34xx.h          |  12 +-
 arch/arm/mach-omap2/prm.h                       |  53 ++
 arch/arm/mach-omap2/prm2xxx.c                   | 126 +++++
 arch/arm/mach-omap2/prm2xxx.h                   | 132 +++++
 arch/arm/mach-omap2/prm2xxx_3xxx.c              | 332 ++++-------
 arch/arm/mach-omap2/prm2xxx_3xxx.h              | 277 +++-------
 arch/arm/mach-omap2/prm33xx.c                   | 204 ++++++-
 arch/arm/mach-omap2/prm3xxx.c                   | 403 ++++++++++++++
 arch/arm/mach-omap2/prm3xxx.h                   | 160 ++++++
 arch/arm/mach-omap2/prm44xx.c                   | 355 +++++++++++-
 arch/arm/mach-omap2/prm44xx.h                   |   2 +
 arch/arm/mach-omap2/prm_common.c                | 105 ++--
 .../mach-omap2/sdram-hynix-h8mbx00u0mer-0em.h   |   2 +-
 .../mach-omap2/sdram-micron-mt46h32m32lf-6.h    |   2 +-
 arch/arm/mach-omap2/sdram-nokia.c               |   4 +-
 arch/arm/mach-omap2/sdram-numonyx-m65kxxxxam.h  |   2 +-
 .../mach-omap2/sdram-qimonda-hyb18m512160af-6.h |   2 +-
 arch/arm/mach-omap2/sdrc.c                      |  21 +-
 arch/arm/mach-omap2/sdrc.h                      | 146 ++++-
 arch/arm/mach-omap2/sdrc2xxx.c                  |   7 +-
 arch/arm/mach-omap2/serial.c                    |  13 +-
 arch/arm/mach-omap2/serial.h                    |   1 +
 arch/arm/mach-omap2/sleep34xx.S                 |   7 +-
 arch/arm/mach-omap2/soc.h                       | 468 +++++++++++++++-
 arch/arm/mach-omap2/sr_device.c                 |   4 +-
 arch/arm/mach-omap2/sram.c                      | 305 +++++++++++
 arch/arm/mach-omap2/sram.h                      |  83 +++
 arch/arm/mach-omap2/sram242x.S                  |   4 +-
 arch/arm/mach-omap2/sram243x.S                  |   4 +-
 arch/arm/mach-omap2/sram34xx.S                  |   2 +-
 arch/arm/mach-omap2/timer.c                     |   9 +-
 arch/arm/mach-omap2/twl-common.c                |   3 -
 arch/arm/mach-omap2/usb-host.c                  |   6 +-
 arch/arm/mach-omap2/usb-musb.c                  |   8 +-
 arch/arm/mach-omap2/usb-tusb6010.c              |   3 +-
 arch/arm/mach-omap2/usb.h                       |  82 +++
 arch/arm/mach-omap2/wd_timer.c                  |   2 +-
 arch/arm/mach-omap2/wd_timer.h                  |   2 +-
 arch/arm/plat-omap/Makefile                     |   4 +-
 arch/arm/plat-omap/clock.c                      | 544 -------------------
 arch/arm/plat-omap/common.c                     |  48 --
 arch/arm/plat-omap/counter_32k.c                |   3 -
 arch/arm/plat-omap/debug-devices.c              |   3 +-
 arch/arm/plat-omap/debug-leds.c                 |  23 +-
 arch/arm/plat-omap/dma.c                        | 132 ++---
 arch/arm/plat-omap/dmtimer.c                    |  20 +-
 arch/arm/plat-omap/fb.c                         |  62 ++-
 arch/arm/plat-omap/i2c.c                        | 174 +-----
 .../{plat/dma.h => plat-omap/dma-omap.h}        | 201 +------
 arch/arm/plat-omap/include/plat/clkdev_omap.h   |  51 --
 arch/arm/plat-omap/include/plat/clock.h         | 309 -----------
 arch/arm/plat-omap/include/plat/common.h        |  42 --
 arch/arm/plat-omap/include/plat/counter-32k.h   |   1 +
 arch/arm/plat-omap/include/plat/cpu.h           | 468 +---------------
 .../include/plat}/debug-devices.h               |   7 -
 arch/arm/plat-omap/include/plat/dma-44xx.h      | 147 -----
 arch/arm/plat-omap/include/plat/dmtimer.h       |   2 +
 arch/arm/plat-omap/include/plat/fpga.h          | 193 -------
 arch/arm/plat-omap/include/plat/i2c.h           |  30 +-
 arch/arm/plat-omap/include/plat/iommu2.h        |  96 ----
 arch/arm/plat-omap/include/plat/iovmm.h         |  89 ---
 arch/arm/plat-omap/include/plat/multi.h         | 120 ----
 arch/arm/plat-omap/include/plat/omap-secure.h   |  14 -
 arch/arm/plat-omap/include/plat/sdrc.h          | 164 ------
 arch/arm/plat-omap/include/plat/sram.h          |  97 +---
 arch/arm/plat-omap/include/plat/uncompress.h    | 204 -------
 arch/arm/plat-omap/include/plat/usb.h           | 179 ------
 arch/arm/plat-omap/sram.c                       | 366 +------------
 arch/arm/plat-omap/sram.h                       |   6 -
 arch/avr32/mach-at32ap/include/mach/board.h     |   8 -
 drivers/ata/pata_at91.c                         |   2 +-
 drivers/char/hw_random/omap-rng.c               |   2 -
 drivers/crypto/omap-aes.c                       |   8 +-
 drivers/crypto/omap-sham.c                      |  10 +-
 drivers/dma/omap-dma.c                          |   5 +-
 drivers/input/touchscreen/atmel_tsadcc.c        |   2 +-
 drivers/iommu/Makefile                          |   1 +
 drivers/iommu/omap-iommu-debug.c                |   8 +-
 drivers/iommu/omap-iommu.c                      |  39 +-
 .../plat/iommu.h => drivers/iommu/omap-iommu.h  | 133 ++---
 .../iommu2.c => drivers/iommu/omap-iommu2.c     |  11 +-
 .../iommu/omap-iopgtable.h                      |  22 -
 drivers/iommu/omap-iovmm.c                      |  50 +-
 drivers/media/platform/omap/omap_vout.c         |   4 +-
 drivers/media/platform/omap/omap_vout_vrfb.c    |   6 +-
 drivers/media/platform/omap/omap_voutdef.h      |   2 +-
 drivers/media/platform/omap3isp/isp.c           |   1 +
 drivers/media/platform/omap3isp/isp.h           |   4 +-
 drivers/media/platform/omap3isp/ispccdc.c       |   1 +
 drivers/media/platform/omap3isp/isphist.c       |   2 +
 drivers/media/platform/omap3isp/ispstat.c       |   1 +
 drivers/media/platform/omap3isp/ispstat.h       |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c      |   1 +
 .../media/platform/soc_camera/omap1_camera.c    |   3 +-
 drivers/media/rc/ir-rx51.c                      |   1 -
 drivers/mfd/menelaus.c                          |   2 +-
 drivers/mfd/omap-usb-host.c                     |   5 +-
 drivers/mfd/omap-usb-tll.c                      |   2 +-
 drivers/mfd/omap-usb.h                          |   2 +
 drivers/mmc/host/atmel-mci.c                    |   2 +-
 drivers/mmc/host/omap.c                         |  35 +-
 drivers/mmc/host/omap_hsmmc.c                   |   4 +-
 drivers/mtd/nand/omap2.c                        | 129 ++++-
 drivers/mtd/onenand/omap2.c                     |  47 +-
 drivers/net/can/at91_can.c                      |   3 +-
 drivers/net/ethernet/cadence/at91_ether.c       |   2 +-
 drivers/pcmcia/at91_cf.c                        |   2 +-
 drivers/pcmcia/omap_cf.c                        |   2 +-
 drivers/rtc/rtc-at91rm9200.c                    |   2 +-
 .../at91_rtc.h => drivers/rtc/rtc-at91rm9200.h  |   0
 drivers/rtc/rtc-at91sam9.c                      |   2 +-
 drivers/spi/spi-atmel.c                         |   2 +-
 .../tidspbridge/include/dspbridge/host_os.h     |   1 -
 drivers/tty/serial/atmel_serial.c               |   2 +-
 drivers/usb/gadget/at91_udc.c                   |   2 +-
 drivers/usb/gadget/atmel_usba_udc.c             |   2 +-
 drivers/usb/gadget/omap_udc.c                   |   4 +-
 drivers/usb/host/ehci-omap.c                    |   3 +-
 drivers/usb/host/ohci-at91.c                    |   2 +-
 drivers/usb/host/ohci-omap.c                    |   5 +-
 drivers/usb/host/ohci-omap3.c                   |   1 -
 drivers/usb/musb/am35x.c                        |   3 +-
 drivers/usb/musb/musb_dsps.c                    |   3 +-
 drivers/usb/musb/omap2430.h                     |   2 +-
 drivers/usb/musb/tusb6010_omap.c                |   9 +-
 drivers/video/atmel_lcdfb.c                     |   2 +-
 drivers/video/omap/lcd_inn1510.c                |   7 +-
 drivers/video/omap/lcdc.c                       |   2 +-
 drivers/video/omap/omapfb_main.c                |   2 +-
 drivers/video/omap/sossi.c                      |   2 +-
 drivers/video/omap2/dss/core.c                  |   2 +-
 drivers/video/omap2/dss/dispc.c                 |  43 +-
 drivers/video/omap2/dss/dss.c                   |  41 +-
 drivers/video/omap2/dss/dss_features.c          |  64 ++-
 drivers/video/omap2/dss/dss_features.h          |   5 +-
 drivers/video/omap2/dss/hdmi.c                  |   3 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c       |   2 +-
 drivers/video/omap2/omapfb/omapfb-main.c        |   8 +-
 drivers/video/omap2/omapfb/omapfb-sysfs.c       |   2 +-
 drivers/video/omap2/vrfb.c                      | 142 ++++-
 .../plat => include/linux/mfd}/menelaus.h       |   2 -
 include/linux/omap-iommu.h                      |  52 ++
 include/linux/platform_data/atmel.h             |  73 +++
 include/linux/platform_data/gpio-omap.h         |   1 -
 include/linux/platform_data/iommu-omap.h        |  49 ++
 .../linux/platform_data/leds-omap.h             |   2 -
 .../linux/platform_data/mmc-omap.h              |  48 +-
 include/linux/platform_data/mtd-nand-omap2.h    |  46 +-
 include/linux/platform_data/mtd-onenand-omap2.h |  28 +-
 include/linux/platform_data/usb-omap.h          |  80 +++
 include/video/omapdss.h                         |  14 +
 .../plat/vrfb.h => include/video/omapvrfb.h     |   2 +
 sound/soc/omap/am3517evm.c                      |   2 -
 sound/soc/omap/n810.c                           |   1 -
 sound/soc/omap/omap-pcm.c                       |   9 +-
 sound/soc/omap/osk5912.c                        |   1 -
 sound/soc/omap/sdp3430.c                        |   2 -
 445 files changed, 8660 insertions(+), 8283 deletions(-)
 delete mode 100644 arch/arm/configs/cam60_defconfig
 delete mode 100644 arch/arm/configs/cpu9260_defconfig
 delete mode 100644 arch/arm/configs/cpu9g20_defconfig
 delete mode 100644 arch/arm/configs/qil-a9260_defconfig
 delete mode 100644 arch/arm/configs/sam9_l9260_defconfig
 delete mode 100644 arch/arm/configs/usb-a9260_defconfig
 rename arch/arm/mach-at91/{include/mach => }/at91_aic.h (100%)
 rename arch/arm/mach-at91/{include/mach => }/at91_rstc.h (100%)
 rename arch/arm/mach-at91/{include/mach => }/at91_shdwc.h (100%)
 rename arch/arm/mach-at91/{include/mach => }/at91_tc.h (100%)
 rename arch/arm/mach-at91/{include/mach => }/board.h (69%)
 rename arch/arm/mach-at91/{include/mach => }/gsia18s.h (100%)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_pit.h
 rename arch/arm/mach-at91/{include/mach => }/stamp9g20.h (100%)
 create mode 100644 arch/arm/mach-omap1/dma.h
 create mode 100644 arch/arm/mach-omap1/fpga.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/gpio.h
 create mode 100644 arch/arm/mach-omap1/include/mach/serial.h
 create mode 100644 arch/arm/mach-omap1/include/mach/soc.h
 rename arch/arm/{plat-omap/include/plat => mach-omap1/include/mach}/tc.h (100%)
 create mode 100644 arch/arm/mach-omap1/mmc.h
 create mode 100644 arch/arm/mach-omap1/soc.h
 create mode 100644 arch/arm/mach-omap1/sram-init.c
 create mode 100644 arch/arm/mach-omap1/sram.h
 rename arch/arm/mach-omap2/{include/mach => }/board-zoom.h (100%)
 delete mode 100644 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c
 delete mode 100644 arch/arm/mach-omap2/clockdomain33xx.c
 delete mode 100644 arch/arm/mach-omap2/clockdomain44xx.c
 create mode 100644 arch/arm/mach-omap2/cm2xxx.c
 create mode 100644 arch/arm/mach-omap2/cm2xxx.h
 rename arch/arm/mach-omap2/{cm2xxx_3xxx.c => cm3xxx.c} (72%)
 create mode 100644 arch/arm/mach-omap2/cm3xxx.h
 create mode 100644 arch/arm/mach-omap2/cm_common.c
 create mode 100644 arch/arm/mach-omap2/dma.h
 create mode 100644 arch/arm/mach-omap2/gpmc-nand.h
 create mode 100644 arch/arm/mach-omap2/gpmc-onenand.h
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/gpmc.h (67%)
 create mode 100644 arch/arm/mach-omap2/i2c.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/gpio.h
 rename arch/arm/{plat-omap/include/plat => mach-omap2/include/mach}/serial.h (87%)
 create mode 100644 arch/arm/mach-omap2/mmc.h
 rename arch/arm/{plat-omap => mach-omap2}/omap-pm-noop.c (98%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/omap-pm.h (100%)
 rename arch/arm/{plat-omap => mach-omap2}/omap_device.c (99%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/omap_device.h (99%)
 rename arch/arm/{plat-omap/include/plat => mach-omap2}/omap_hwmod.h (99%)
 delete mode 100644 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c
 delete mode 100644 arch/arm/mach-omap2/powerdomain33xx.c
 delete mode 100644 arch/arm/mach-omap2/powerdomain44xx.c
 create mode 100644 arch/arm/mach-omap2/prm2xxx.c
 create mode 100644 arch/arm/mach-omap2/prm2xxx.h
 create mode 100644 arch/arm/mach-omap2/prm3xxx.c
 create mode 100644 arch/arm/mach-omap2/prm3xxx.h
 create mode 100644 arch/arm/mach-omap2/serial.h
 create mode 100644 arch/arm/mach-omap2/sram.c
 create mode 100644 arch/arm/mach-omap2/sram.h
 create mode 100644 arch/arm/mach-omap2/usb.h
 delete mode 100644 arch/arm/plat-omap/clock.c
 delete mode 100644 arch/arm/plat-omap/common.c
 rename arch/arm/plat-omap/include/{plat/dma.h => plat-omap/dma-omap.h} (60%)
 delete mode 100644 arch/arm/plat-omap/include/plat/clkdev_omap.h
 delete mode 100644 arch/arm/plat-omap/include/plat/clock.h
 delete mode 100644 arch/arm/plat-omap/include/plat/common.h
 create mode 100644 arch/arm/plat-omap/include/plat/counter-32k.h
 rename arch/arm/{mach-omap2 => plat-omap/include/plat}/debug-devices.h (54%)
 delete mode 100644 arch/arm/plat-omap/include/plat/dma-44xx.h
 delete mode 100644 arch/arm/plat-omap/include/plat/fpga.h
 delete mode 100644 arch/arm/plat-omap/include/plat/iommu2.h
 delete mode 100644 arch/arm/plat-omap/include/plat/iovmm.h
 delete mode 100644 arch/arm/plat-omap/include/plat/multi.h
 delete mode 100644 arch/arm/plat-omap/include/plat/omap-secure.h
 delete mode 100644 arch/arm/plat-omap/include/plat/sdrc.h
 delete mode 100644 arch/arm/plat-omap/include/plat/uncompress.h
 delete mode 100644 arch/arm/plat-omap/include/plat/usb.h
 delete mode 100644 arch/arm/plat-omap/sram.h
 rename arch/arm/plat-omap/include/plat/iommu.h => drivers/iommu/omap-iommu.h (69%)
 rename arch/arm/mach-omap2/iommu2.c => drivers/iommu/omap-iommu2.c (96%)
 rename arch/arm/plat-omap/include/plat/iopgtable.h => drivers/iommu/omap-iopgtable.h (85%)
 create mode 100644 drivers/mfd/omap-usb.h
 rename arch/arm/mach-at91/include/mach/at91_rtc.h => drivers/rtc/rtc-at91rm9200.h (100%)
 rename {arch/arm/plat-omap/include/plat => include/linux/mfd}/menelaus.h (96%)
 create mode 100644 include/linux/omap-iommu.h
 create mode 100644 include/linux/platform_data/iommu-omap.h
 rename arch/arm/plat-omap/include/plat/led.h => include/linux/platform_data/leds-omap.h (91%)
 rename arch/arm/plat-omap/include/plat/mmc.h => include/linux/platform_data/mmc-omap.h (80%)
 create mode 100644 include/linux/platform_data/usb-omap.h
 rename arch/arm/plat-omap/include/plat/vrfb.h => include/video/omapvrfb.h (95%)
