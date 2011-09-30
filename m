Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1I3GNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 02:13:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32865 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab1I3GNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 02:13:00 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <aneesh@ti.com>, <khilman@ti.com>,
        <santosh.shilimkar@ti.com>, <christian.gmeiner@gmail.com>,
        Abhilash K V <abhilash.kv@ti.com>, Sanjeev Premi <premi@ti.com>
Subject: [PATCH v5 0/3] AM3517: Booting up
Date: Fri, 30 Sep 2011 11:42:30 +0530
Message-ID: <1317363153-10259-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhilash K V <abhilash.kv@ti.com>

This patch-set gets the kernel booting up on a AM3517 EVM.
The board is able to boot with ramdisk after this,but the MMC and Ethernet
drivers are not up yet. Lots of warnings remain which will be addressed in
subsequent patches.

The patches are tested on master of git://github.com/tmlind/linux.git
Kernel version is 3.1.0-rc8 and last commit on top of which these patches
were added is:
	1dd8838c74476fe13e51334ad2444e6c963cf5ff: Linux-omap rebuilt:
	 Updated to -rc8, merged l3 fixes

Cc: Sanjeev Premi <premi@ti.com>
---
Changes in v5:
 -[1/3] was reworked to use the new method to select hwmods between
  different omap3 variants/revisions. 
 -minor code reformatting in [3/3]

Changes in v4:
 -Rebased and tested against the latest 3.1.0-rc6.
 -Added a patch [3/3] to check for missing PMIC info in vp init.

Changes in v3:
 Presence of SR feature is now used to decide if TWL4030 initialisation is to
 be done or not.

Changes in v2: Incorporated Kevin's comments to add SmartReflex as a FEATURE,
  and use omap3_has_sr() to fall out of omap3_twl_init() for AM35x case.
	

Abhilash K V (3):
  AM35x: Using OMAP3 generic hwmods
  omap_twl: Prevent SR to enable for am3517/am3505 devices
  OMAP2+: voltage: add check for missing PMIC info in vp init

 arch/arm/mach-omap2/id.c                   |    2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   17 ++++++++++++-----
 arch/arm/mach-omap2/pm.c                   |    3 ++-
 arch/arm/mach-omap2/vp.c                   |    7 +++++++
 arch/arm/plat-omap/include/plat/cpu.h      |    2 ++
 5 files changed, 24 insertions(+), 7 deletions(-)

