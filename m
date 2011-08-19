Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1HSLub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:50:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58900 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab1HSLuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:50:01 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        <sameo@linux.intel.com>, <santosh.shilimkar@ti.com>, <premi@ti.com>,
        <david.woodhouse@intel.com>, Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH 0/3] AM35x: Adding PM init
Date: Fri, 19 Aug 2011 17:19:30 +0530
Message-ID: <1313754573-11498-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set fixes the power and voltage management initialization sequence
for AM35x.
These patches are dependent on the following patch-set
http://marc.info/?l=linux-omap&m=131247357813228&w=2
which gets the AM3517 EVM booting.

The patches are tested on master of tmlind/linux-omap-2.6.git.
Kernel version is 3.0.0-rc7 and last commit on top of which these patches
were added is:

        885cf6ff7d3dad4cc44be74b0577d3a554d3ab71: Linux-omap rebuilt:
        Updated to -rc7, added new boards

Cc: Sanjeev Premi <premi@ti.com>
---
Abhilash K V (1):
  OMAP3: Remove auto-selection of PMICs

Sanjeev Premi (2):
  AM35x: voltage: Basic initialization
  OMAP3: Add support for TPS65023 (AM35x only)

 arch/arm/configs/omap2plus_defconfig          |    3 +
 arch/arm/mach-omap2/Kconfig                   |    3 -
 arch/arm/mach-omap2/Makefile                  |    3 +-
 arch/arm/mach-omap2/omap_opp_data.h           |    1 +
 arch/arm/mach-omap2/opp3xxx_data.c            |   10 +++
 arch/arm/mach-omap2/pm.c                      |    4 +-
 arch/arm/mach-omap2/pm.h                      |    9 +++
 arch/arm/mach-omap2/pmic_tps65023.c           |   84 +++++++++++++++++++++++++
 arch/arm/mach-omap2/voltage.c                 |   18 +++++
 arch/arm/mach-omap2/voltagedomains3xxx_data.c |   40 +++++++++++-
 drivers/mfd/Kconfig                           |    4 +-
 11 files changed, 171 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm/mach-omap2/pmic_tps65023.c

