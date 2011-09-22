Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1IVNaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:30:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46597 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679Ab1IVN3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:29:45 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        <sameo@linux.intel.com>, <santosh.shilimkar@ti.com>, <premi@ti.com>,
        <david.woodhouse@intel.com>, <christian.gmeiner@gmail.com>,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v3 0/3] AM35x: Adding PM init
Date: Thu, 22 Sep 2011 18:59:12 +0530
Message-ID: <1316698155-954-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set fixes the power and voltage management initialization sequence
for AM35x.
These patches are dependent on the following patch-set
	[PATCH v4 0/3] AM3517: Booting up
which gets the AM3517 EVM booting.

The patches are tested on master of git://github.com/tmlind/linux.git
Kernel version is 3.1.0-rc6 and last commit on top of which these patches
were added is:
	0c2838d00350afc5259730c35bbda81598e8875f: Linux-omap rebuilt: Updated
	to -rc7, merged in dmtimer

Cc: Sanjeev Premi <premi@ti.com>
---
Changes in v3:
  * Reworked against the cleaned-up voltage management layer.
Changes in v2:
  * TWL4030 CORE and POWER drivers are no longer built only for ARM and OMAP
  * changed comments to mark AM35x voltgate-scaling code as ad hoc

Abhilash K V (2):
  AM35x: voltage: Basic initialization
  OMAP3: Remove auto-selection of PMICs

Sanjeev Premi (1):
  OMAP3: Add support for TPS65023 (AM35x only)

 arch/arm/configs/omap2plus_defconfig          |    3 +
 arch/arm/mach-omap2/Kconfig                   |    3 -
 arch/arm/mach-omap2/Makefile                  |    3 +-
 arch/arm/mach-omap2/omap_opp_data.h           |    1 +
 arch/arm/mach-omap2/opp3xxx_data.c            |    9 +++
 arch/arm/mach-omap2/pm.c                      |    1 +
 arch/arm/mach-omap2/pm.h                      |    9 +++
 arch/arm/mach-omap2/pmic_tps65023.c           |   84 +++++++++++++++++++++++++
 arch/arm/mach-omap2/voltagedomains3xxx_data.c |   10 +++-
 drivers/mfd/Kconfig                           |    2 +-
 10 files changed, 118 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/mach-omap2/pmic_tps65023.c

