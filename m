Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab1IHMEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:04:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57326 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758368Ab1IHMEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:04:37 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <khilman@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Abhilash K V <abhilash.kv@ti.com>, Sanjeev Premi <premi@ti.com>
Subject: [PATCH v3 0/2] AM3517: Booting up
Date: Thu, 8 Sep 2011 17:34:09 +0530
Message-ID: <1315483449-17460-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set gets the kernel booting up on a AM3517 EVM.
The board is able to boot with ramdisk after this,but the MMC and Ethernet
drivers are not up yet. Lots of warnings remain which will be addressed in
subsequent patches.

The patches are tested on master of tmlind/linux-omap-2.6.git.
Kernel version is 3.1-rc3 and last commit on top of which these patches
were added is:
	b148d763841161894ed6629794064065a834aa2b: Linux-omap rebuilt: Updated to
	use omap_sdrc_init

with the folowing commit reverted:
	f3637a5f2e2eb391ff5757bc83fb5de8f9726464: irq: Always set IRQF_ONESHOT
	if no primary handler is specified


Cc: Sanjeev Premi <premi@ti.com>
---
Changes in v3:
 Presence of SR feature is now used to decide if TWL4030 initialisation is to
 be done or not.
	
Abhilash K V (2):
  AM35x: Using OMAP3 generic hwmods
  omap_twl: Prevent SR to enable for am3517/am3505 devices

 arch/arm/mach-omap2/id.c                     |    2 +-
 arch/arm/mach-omap2/io.c                     |   11 +++++++++++
 arch/arm/mach-omap2/omap_hwmod.c             |    3 ++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |   18 ++++++++++++++++++
 arch/arm/mach-omap2/pm.c                     |    3 ++-
 arch/arm/plat-omap/include/plat/cpu.h        |    2 ++
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    3 +++
 7 files changed, 39 insertions(+), 3 deletions(-)

