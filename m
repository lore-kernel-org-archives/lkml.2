Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2ARHZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 02:25:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43505 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab2ARHZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 02:25:24 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, arm@kernel.org
Subject: [GIT PULL 1/2] arm-soc: late driver changes
Date: Tue, 17 Jan 2012 23:24:57 -0800
Message-Id: <1326871498-22485-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.rc1.3.gb6310
In-Reply-To: <1326871498-22485-1-git-send-email-olof@lixom.net>
References: <1326871498-22485-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Below is the last new code pull request for arm-soc for this merge
window. It has been pending on the v4l and dma-engine trees going in,
which is why it's this late in the window.

Some of this was really messy to deal with this development window,
and Arnd did the work on sorting it out. It's done in the merges of
the per-vendor branches into this shared branch, see those if you want
the details.

There is one remaining trivial merge conflict on the pl330 driver,
the contents from HEAD is the right one to keep.


Thanks,

-Olof


The following changes since commit 142f2101a86ade2d6c9dfbedf82e1b5b31c8fce6:

  Merge branch 'samsung/cleanup' into samsung/driver (2012-01-09 16:14:07 +0000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git arm-soc-drivers-late

for you to fetch changes up to 4bd7c44a7c4fad5ccc74ab9cafa327ba13b7080e:

  ARM: at91: add Atmel ISI and ov2640 support on sam9m10g45 board (2012-01-17 21:32:08 -0800)

----------------------------------------------------------------
Late-merge batch of driver changes for arm-soc. Branches that had
dependencies on other trees that have now landed upstream, so these can
go in:

* A driver branch for Samsung which includes a move of the pl330 driver
  from arch/arm to drivers/dma
* RTC updates for Samsung
* AT91 updates that depended on the dma-slave tree
* I also cherry-picked in two of the changes that depended on v4l that
  we were considering dropping for this merge window, but they apply
  cleanly now and build so I brought them in.

The merges of Samsung branches were quite conflict ridden due to changes
colliding with the moves, the chnages are further documented in the merge
changesets by Arnd.

----------------------------------------------------------------
Arnd Bergmann (8):
      Merge branch 'next-samsung-devel-dma' of git://git.kernel.org/.../kgene/linux-samsung into samsung/dma
      Merge branches 'samsung/dt' and 'depends/dma-slave/next' into next/drivers2
      Merge branch 'samsung/dma' into next/drivers2
      Merge branch 'next-samsung-devel-rtc' of git://git.kernel.org/.../kgene/linux-samsung into samsung/rtc
      Merge branch 'samsung/rtc' into next/drivers2
      Merge branch 'samsung/driver' into next/drivers3
      Merge branch 'for-arnd-3.3-device_boardV3' of git://github.com/at91linux/linux-at91 into at91/board
      Merge branch 'at91/board' into next/drivers3

Boojin Kim (5):
      DMA: PL330: Merge PL330 driver into drivers/dma/
      DMA: PL330: Removes useless function
      DMA: PL330: Support MEMTOMEM transmit w/o RMB, WMB
      ARM: EXYNOS: Enable MDMA driver
      ARM: EXYNOS: Support DMA for EXYNOS4X12 SoCs

Heiko Stuebner (4):
      ARM: SAMSUNG: cleanup of rtc register definitions
      rtc-s3c: make room for more variants in devicetree block
      rtc-s3c: add variants for S3C2443 and S3C2416
      ARM: S3C2443/S3C2416: add s3c_rtc_setname and rename rtc devices

Hong Xu (1):
      ARM: at91: Update struct atmel_nand_data to support PMECC

Josh Wu (2):
      ARM: at91: add clock selection parameter for at91_add_device_isi()
      ARM: at91: add Atmel ISI and ov2640 support on sam9m10g45 board

Kukjin Kim (1):
      Merge branch 'next-samsung-devel-dt1' into for-vkoul-samsung-dma

Nicolas Ferre (2):
      ARM: at91/dma: remove platform data from DMA controller
      ARM: at91/dma: DMA controller registering with DT support

Tushar Behera (1):
      ARM: EXYNOS: Add apb_pclk clkdev entry for mdma1


 arch/arm/common/Kconfig                        |    3 -
 arch/arm/common/Makefile                       |    1 -
 arch/arm/common/pl330.c                        | 1959 ------------------------
 arch/arm/include/asm/hardware/pl330.h          |  338 +++--
 arch/arm/mach-at91/at91sam9263_devices.c       |   13 +-
 arch/arm/mach-at91/at91sam9g45_devices.c       |  113 ++-
 arch/arm/mach-at91/at91sam9rl_devices.c        |    8 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c        |   80 +-
 arch/arm/mach-at91/include/mach/board.h        |    6 +-
 arch/arm/mach-exynos/clock.c                   |    9 +
 arch/arm/mach-exynos/dma.c                     |  130 ++-
 arch/arm/mach-exynos/include/mach/irqs.h       |    2 +
 arch/arm/mach-exynos/include/mach/map.h        |    3 +-
 arch/arm/mach-s3c2416/s3c2416.c                |    2 +
 arch/arm/mach-s3c2443/s3c2443.c                |    2 +
 arch/arm/plat-samsung/include/plat/dma-pl330.h |   16 +
 arch/arm/plat-samsung/include/plat/regs-rtc.h  |   81 +-
 arch/arm/plat-samsung/include/plat/rtc-core.h  |   27 +
 drivers/dma/Kconfig                            |    1 -
 drivers/dma/pl330.c                            | 1850 ++++++++++++++++++++++
 drivers/rtc/rtc-s3c.c                          |   71 +-
 21 files changed, 2517 insertions(+), 2198 deletions(-)


