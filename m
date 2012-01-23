Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab2AWH1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 02:27:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64716 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2AWH1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 02:27:11 -0500
Date: Sun, 22 Jan 2012 23:27:16 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, arm@kernel.org
Subject: Re: [GIT PULL 0/2] Last batch of arm-soc merge window contents for
 3.3
Message-ID: <20120123072716.GA16764@quad.lixom.net>
References: <1326871498-22485-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326871498-22485-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jan 17, 2012 at 11:24:56PM -0800, Olof Johansson wrote:

> As mentioned with the first pull requests by Arnd, we had two sets of
> changes in arm-soc that were held until later in the merge window. One
> depended on external driver trees, and the other is a large code move
> that is best merged towards the end of the window. Here they are.

So, these two pull requests were two that did not get pulled before
the merge window closed. I'm hoping they were just on the missed list
instead of the too-much-work-to-check-them list.

In addition to this request to please still pull them, I have also
pushed a combined tag to the same repo with both branches merged on top
of v3.3-rc1, see below. Feel free to take that instead, or reference it
for conflict resolution.

For reference, the original individual pull requests were:

http://marc.info/?l=linux-kernel&m=132687170815781
http://marc.info/?l=linux-kernel&m=132687170915782


Thanks!

-Olof


The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git for-linus-late

for you to fetch changes up to 07425284b47742e18890a0df4348dd8eeb2f1316:

  Merge tag 'arm-soc-imx-move' into for-linus-late (2012-01-22 23:06:06 -0800)

----------------------------------------------------------------

arm-soc: late merge combined tag

This is a tag that combines the two late arm-soc pulls for the 3.3 merge window:

* One branch with driver that had late-fulfilled dependencies on driver
  trees that landed right at the end of the window
* One branch with a consolidation of the previously separate i.MX5
  platform code to the new shared i.MX tree.

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

Olof Johansson (2):
      Merge tag 'arm-soc-drivers-late' into for-linus-late
      Merge tag 'arm-soc-imx-move' into for-linus-late

Sascha Hauer (3):
      ARM i.MX5: remove unnecessary includes from board files
      ARM i.MX: Merge i.MX5 support into mach-imx
      ARM i.MX: Update defconfig

Tushar Behera (1):
      ARM: EXYNOS: Add apb_pclk clkdev entry for mdma1

 arch/arm/Makefile                                  |    1 -
 arch/arm/common/Kconfig                            |    3 -
 arch/arm/common/Makefile                           |    1 -
 arch/arm/common/pl330.c                            | 1959 --------------------
 .../configs/{mx5_defconfig => imx_v6_v7_defconfig} |   61 +-
 arch/arm/configs/mx3_defconfig                     |  144 --
 arch/arm/include/asm/hardware/pl330.h              |  338 ++--
 arch/arm/mach-at91/at91sam9263_devices.c           |   13 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |  113 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    8 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |   80 +-
 arch/arm/mach-at91/include/mach/board.h            |    6 +-
 arch/arm/mach-exynos/clock.c                       |    9 +
 arch/arm/mach-exynos/dma.c                         |  130 ++-
 arch/arm/mach-exynos/include/mach/irqs.h           |    2 +
 arch/arm/mach-exynos/include/mach/map.h            |    3 +-
 arch/arm/mach-imx/Kconfig                          |  239 +++
 arch/arm/mach-imx/Makefile                         |   22 +
 arch/arm/mach-imx/Makefile.boot                    |   12 +
 arch/arm/{mach-mx5 => mach-imx}/clock-mx51-mx53.c  |    2 +-
 arch/arm/{mach-mx5/cpu.c => mach-imx/cpu-imx5.c}   |    0
 arch/arm/{mach-mx5 => mach-imx}/cpu_op-mx51.c      |    0
 arch/arm/{mach-mx5 => mach-imx}/cpu_op-mx51.h      |    0
 .../crm_regs.h => mach-imx/crm-regs-imx5.h}        |    0
 arch/arm/{mach-mx5 => mach-imx}/devices-imx50.h    |    0
 arch/arm/{mach-mx5 => mach-imx}/devices-imx51.h    |    0
 arch/arm/{mach-mx5 => mach-imx}/devices-imx53.h    |    0
 arch/arm/{mach-mx5 => mach-imx}/efika.h            |    0
 arch/arm/{mach-mx5/ehci.c => mach-imx/ehci-imx5.c} |    0
 .../eukrea_mbimx51-baseboard.c                     |    0
 .../eukrea_mbimxsd-baseboard.c                     |    0
 arch/arm/{mach-mx5 => mach-imx}/imx51-dt.c         |    0
 arch/arm/{mach-mx5 => mach-imx}/imx53-dt.c         |    0
 .../board-cpuimx51.c => mach-imx/mach-cpuimx51.c}  |    0
 .../mach-cpuimx51sd.c}                             |    0
 .../board-mx50_rdp.c => mach-imx/mach-mx50_rdp.c}  |    0
 .../board-mx51_3ds.c => mach-imx/mach-mx51_3ds.c}  |    0
 .../mach-mx51_babbage.c}                           |    0
 .../mach-mx51_efikamx.c}                           |    0
 .../mach-mx51_efikasb.c}                           |    0
 .../board-mx53_ard.c => mach-imx/mach-mx53_ard.c}  |    1 -
 .../board-mx53_evk.c => mach-imx/mach-mx53_evk.c}  |    1 -
 .../mach-mx53_loco.c}                              |    1 -
 .../board-mx53_smd.c => mach-imx/mach-mx53_smd.c}  |    1 -
 arch/arm/{mach-mx5/mm.c => mach-imx/mm-imx5.c}     |    0
 arch/arm/{mach-mx5 => mach-imx}/mx51_efika.c       |    0
 arch/arm/{mach-mx5/system.c => mach-imx/pm-imx5.c} |   89 +-
 arch/arm/mach-mx5/Kconfig                          |  244 ---
 arch/arm/mach-mx5/Makefile                         |   26 -
 arch/arm/mach-mx5/Makefile.boot                    |    9 -
 arch/arm/mach-mx5/pm-imx5.c                        |   83 -
 arch/arm/mach-s3c2416/s3c2416.c                    |    2 +
 arch/arm/mach-s3c2443/s3c2443.c                    |    2 +
 arch/arm/plat-mxc/Kconfig                          |   15 +-
 arch/arm/plat-samsung/include/plat/dma-pl330.h     |   16 +
 arch/arm/plat-samsung/include/plat/regs-rtc.h      |   81 +-
 arch/arm/plat-samsung/include/plat/rtc-core.h      |   27 +
 drivers/dma/Kconfig                                |    1 -
 drivers/dma/pl330.c                                | 1850 ++++++++++++++++++
 drivers/rtc/rtc-s3c.c                              |   71 +-
 60 files changed, 2909 insertions(+), 2757 deletions(-)
 delete mode 100644 arch/arm/common/pl330.c
 rename arch/arm/configs/{mx5_defconfig => imx_v6_v7_defconfig} (80%)
 delete mode 100644 arch/arm/configs/mx3_defconfig
 rename arch/arm/{mach-mx5 => mach-imx}/clock-mx51-mx53.c (99%)
 rename arch/arm/{mach-mx5/cpu.c => mach-imx/cpu-imx5.c} (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/cpu_op-mx51.c (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/cpu_op-mx51.h (100%)
 rename arch/arm/{mach-mx5/crm_regs.h => mach-imx/crm-regs-imx5.h} (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/devices-imx50.h (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/devices-imx51.h (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/devices-imx53.h (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/efika.h (100%)
 rename arch/arm/{mach-mx5/ehci.c => mach-imx/ehci-imx5.c} (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/eukrea_mbimx51-baseboard.c (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/eukrea_mbimxsd-baseboard.c (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/imx51-dt.c (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/imx53-dt.c (100%)
 rename arch/arm/{mach-mx5/board-cpuimx51.c => mach-imx/mach-cpuimx51.c} (100%)
 rename arch/arm/{mach-mx5/board-cpuimx51sd.c => mach-imx/mach-cpuimx51sd.c} (100%)
 rename arch/arm/{mach-mx5/board-mx50_rdp.c => mach-imx/mach-mx50_rdp.c} (100%)
 rename arch/arm/{mach-mx5/board-mx51_3ds.c => mach-imx/mach-mx51_3ds.c} (100%)
 rename arch/arm/{mach-mx5/board-mx51_babbage.c => mach-imx/mach-mx51_babbage.c} (100%)
 rename arch/arm/{mach-mx5/board-mx51_efikamx.c => mach-imx/mach-mx51_efikamx.c} (100%)
 rename arch/arm/{mach-mx5/board-mx51_efikasb.c => mach-imx/mach-mx51_efikasb.c} (100%)
 rename arch/arm/{mach-mx5/board-mx53_ard.c => mach-imx/mach-mx53_ard.c} (99%)
 rename arch/arm/{mach-mx5/board-mx53_evk.c => mach-imx/mach-mx53_evk.c} (99%)
 rename arch/arm/{mach-mx5/board-mx53_loco.c => mach-imx/mach-mx53_loco.c} (99%)
 rename arch/arm/{mach-mx5/board-mx53_smd.c => mach-imx/mach-mx53_smd.c} (99%)
 rename arch/arm/{mach-mx5/mm.c => mach-imx/mm-imx5.c} (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/mx51_efika.c (100%)
 rename arch/arm/{mach-mx5/system.c => mach-imx/pm-imx5.c} (58%)
 delete mode 100644 arch/arm/mach-mx5/Kconfig
 delete mode 100644 arch/arm/mach-mx5/Makefile
 delete mode 100644 arch/arm/mach-mx5/Makefile.boot
 delete mode 100644 arch/arm/mach-mx5/pm-imx5.c
 create mode 100644 arch/arm/plat-samsung/include/plat/rtc-core.h
