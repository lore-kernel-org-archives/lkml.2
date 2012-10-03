Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab2JCOzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:55:12 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47417 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab2JCOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:55:09 -0400
From: Matt Porter <mporter@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: [PATCH v3 0/6] uio_pruss cleanup and platform support
Date: Wed,  3 Oct 2012 10:55:27 -0400
Message-Id: <1349276133-26408-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Ben Gardiner (2):
  ARM: davinci: sram: ioremap the davinci_soc_info specified sram
    regions
  ARM: davinci: da850-dm646x: remove the SRAM_VIRT iotable entry

Matt Porter (3):
  ARM: davinci: add platform hook to fetch the SRAM pool
  ARM: davinci: Add support for PRUSS on DA850
  uio: uio_pruss: replace private SRAM API with genalloc

Subhasish Ghosh (1):
  ARM: davinci: da850: changed SRAM allocator to shared ram.

 arch/arm/mach-davinci/board-da850-evm.c     |   12 +++++
 arch/arm/mach-davinci/da850.c               |   17 +++----
 arch/arm/mach-davinci/devices-da8xx.c       |   66 +++++++++++++++++++++++++++
 arch/arm/mach-davinci/dm355.c               |    6 ---
 arch/arm/mach-davinci/dm365.c               |    6 ---
 arch/arm/mach-davinci/dm644x.c              |    6 ---
 arch/arm/mach-davinci/dm646x.c              |    6 ---
 arch/arm/mach-davinci/include/mach/common.h |    2 -
 arch/arm/mach-davinci/include/mach/da8xx.h  |    3 ++
 arch/arm/mach-davinci/include/mach/sram.h   |    3 ++
 arch/arm/mach-davinci/sram.c                |   22 +++++++--
 drivers/uio/Kconfig                         |    1 +
 drivers/uio/uio_pruss.c                     |   24 +++++++---
 include/linux/platform_data/uio_pruss.h     |    3 +-
 14 files changed, 132 insertions(+), 45 deletions(-)

-- 
1.7.9.5

