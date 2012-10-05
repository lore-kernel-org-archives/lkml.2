Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2JEREQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:04:16 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39054 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab2JEREP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:04:15 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH v4 0/7] uio_pruss cleanup and platform support
Date: Fri,  5 Oct 2012 13:04:39 -0400
Message-Id: <1349456686-22736-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v3:
	- Reordered series to avoid dependency breakage
	- Squashed iotable/ioremap patches to one and removed
	  deprecated description comment about the SRAM
	  consolidation series
	- Separated gen_pool_add_virt status assignment and
	  conditional
	- Cleaned up board-da850-evm.c include ordering
	- Changed the pdata l3ram_pool->sram_pool
	- Separated DA850 SoC and board file changes
	- Fixed pruss clk_lookup entry to have a dev_id value 
	- Moved pruss mem base definition in order with others
	- Use DMA_BIT_MASK for our dma_mask
	- Added testing information to commit descriptions

Changes since v2:
	- Dropped AM33xx/OMAP support from series.
	- Changed the DA850 L3 RAM gen_pool support to be based
	  on a previous Davinci SRAM series from Subhasish Ghosh
	  and Ben Gardiner.
	
Changes since v1:
	- Replaced uio_pruss private SRAM API use with genalloc
	- Added DA850 platform device and clock support
	- Added DA850 L3 RAM gen_pool support
	- Split out DT binding

This series enables uio_pruss on DA850 and removes use of the
private SRAM API by the driver. The driver previously was not
enabled by any platform and the private SRAM API was accessing
an invalid SRAM bank.

It is regression tested on AM180x EVM with suspend/resume due
to the new use of the shared SRAM for both PM and PRUSS. The
uio_pruss driver is tested on the same platform using the
PRU_memAccessPRUDataRam and PRU_memAccessL3andDDR examples from
the PRU userspace tools available from http://www.ti.com/tool/sprc940

Ben Gardiner (1):
  ARM: davinci: sram: switch from iotable to ioremapped regions

Matt Porter (5):
  uio: uio_pruss: replace private SRAM API with genalloc
  ARM: davinci: add platform hook to fetch the SRAM pool
  ARM: davinci: add DA850 PRUSS support
  ARM: davinci: clean up DA850 EVM include ordering
  ARM: davinci: register pruss_uio device on DA850 EVM

Subhasish Ghosh (1):
  ARM: davinci: da850: changed SRAM allocator to shared ram.

 arch/arm/mach-davinci/board-da850-evm.c     |   40 +++++++++++------
 arch/arm/mach-davinci/da850.c               |   17 +++----
 arch/arm/mach-davinci/devices-da8xx.c       |   65 +++++++++++++++++++++++++++
 arch/arm/mach-davinci/dm355.c               |    6 ---
 arch/arm/mach-davinci/dm365.c               |    6 ---
 arch/arm/mach-davinci/dm644x.c              |    6 ---
 arch/arm/mach-davinci/dm646x.c              |    6 ---
 arch/arm/mach-davinci/include/mach/common.h |    2 -
 arch/arm/mach-davinci/include/mach/da8xx.h  |    3 ++
 arch/arm/mach-davinci/include/mach/sram.h   |    3 ++
 arch/arm/mach-davinci/sram.c                |   23 ++++++++--
 drivers/uio/Kconfig                         |    1 +
 drivers/uio/uio_pruss.c                     |   24 +++++++---
 include/linux/platform_data/uio_pruss.h     |    3 +-
 14 files changed, 146 insertions(+), 59 deletions(-)

-- 
1.7.9.5

