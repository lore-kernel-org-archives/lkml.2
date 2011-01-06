Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1AFQhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:37:46 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29591 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab1AFQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:37:45 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6217"; a="69280375"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MSM changes for v2.6.38
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Thu, 06 Jan 2011 08:37:40 -0800
Message-ID: <8ya7hei9eej.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

These are changes that have been reviewed on the lists up to .37-rc6.
This branch has been included in linux-next since about Dec 21 or so.

There's a hand full of fixes, and a bunch of new functionality,
including USB support on our chips.

The following changes since commit cf7d7e5a1980d1116ee152d25dac382b112b9c17:

  Linux 2.6.37-rc5 (2010-12-06 20:09:04 -0800)

are available in the git repository at:
  git://codeaurora.org/quic/kernel/davidb/linux-msm.git for-linus

Daniel Walker (5):
      msm: trout: add gpio_to_irq
      msm: add CLK_MINMAX to pmdh_clk
      msm: trout: change name of pmdh_clk to mddi_clk
      msm: add handling for clocks tagged as CLK_MINMAX
      msm: initial framebuffer support

David Brown (6):
      msm: smd: Reduce driver log chatter
      msm: sirc: remove some unused variables
      msm: smd: ifdef adjustment to remove unused variables
      msm: make constant unsigned long to correct format warning
      Merge branches 'msm-core' and 'msm-mmc' into for-next
      Merge branch 'msm-usb' into for-next

Gregory Bean (2):
      msm: gpio: Add v2 gpio support to MSM SoCs.
      msm: gpio: Add irq support to v2 gpiolib.

Pavankumar Kondeti (3):
      msm: io: Export __msm_ioremap
      MSM: Add USB suport for QSD8x50
      MSM: Add USB support for MSM7x30

Sahitya Tummala (5):
      mmc: msm_sdcc: Fix possible circular locking dependency warning
      mmc: msm_sdcc: Add prog done interrupt support
      mmc: msm_sdcc: Reset SDCC in case of data transfer errors
      mmc: msm_sdcc: Fix bug in PIO mode when data size is not word aligned
      mmc: msm_sdcc: Check for only DATA_END interrupt to end a request

Stepan Moskovchenko (15):
      msm: iommu: Increase maximum MID size to 5 bits
      msm: iomap: Addresses and IRQs for 2nd GFX core IOMMU
      msm: iommu: Use more consistent naming in platform data
      msm: iommu: Revise GFX3D IOMMU contexts and M2V mappings
      msm: iommu: Revise GFX2D0 IOMMU contexts and M2V mappings
      msm: iommu: Support for the 2nd GFX core's IOMMU
      msm: iommu: Mark functions with the right section names
      msm: iommu: Don't flush page tables if no devices attached
      msm: iommu: Kconfig item for cacheable page tables
      msm: iommu: Check if device is already attached
      msm: iommu: Kconfig dependency for the IOMMU API
      msm: iommu: Definitions for extended memory attributes
      msm: iommu: Support cache-coherent memory access
      msm: iommu: Miscellaneous code cleanup
      msm: iommu: Use the correct memory allocation flag

Tobias Klauser (1):
      msm_serial: Remove redundant unlikely()

 arch/arm/mach-msm/Kconfig                       |    8 +
 arch/arm/mach-msm/Makefile                      |    5 +-
 arch/arm/mach-msm/board-msm7x30.c               |   20 +
 arch/arm/mach-msm/board-qsd8x50.c               |   19 +
 arch/arm/mach-msm/board-trout-gpio.c            |    8 +
 arch/arm/mach-msm/board-trout-panel.c           |  297 ++++++++++++++++
 arch/arm/mach-msm/clock.c                       |   15 +
 arch/arm/mach-msm/devices-msm7x00.c             |   69 ++++-
 arch/arm/mach-msm/devices-msm7x30.c             |   72 ++++
 arch/arm/mach-msm/devices-msm8x60-iommu.c       |  243 +++++++------
 arch/arm/mach-msm/devices-qsd8x50.c             |   71 ++++
 arch/arm/mach-msm/devices.h                     |    6 +
 arch/arm/mach-msm/gpio-v2.c                     |  426 +++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/iommu.h          |   15 +-
 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h  |   22 ++-
 arch/arm/mach-msm/include/mach/irqs-8x60.h      |    7 +-
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |    3 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    3 +
 arch/arm/mach-msm/io.c                          |    1 +
 arch/arm/mach-msm/iommu.c                       |  146 ++++++--
 arch/arm/mach-msm/iommu_dev.c                   |    4 +-
 arch/arm/mach-msm/sirc.c                        |    3 -
 arch/arm/mach-msm/smd.c                         |   17 +-
 arch/arm/mach-msm/smd_debug.c                   |    2 +
 drivers/mmc/host/msm_sdcc.c                     |  139 ++++++--
 drivers/mmc/host/msm_sdcc.h                     |    8 +-
 drivers/serial/msm_serial.c                     |    2 +-
 27 files changed, 1434 insertions(+), 197 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-trout-panel.c
 create mode 100644 arch/arm/mach-msm/gpio-v2.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
