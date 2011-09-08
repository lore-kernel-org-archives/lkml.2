Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab1IHMsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:48:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37607 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab1IHMs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:48:28 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        <sameo@linux.intel.com>, <santosh.shilimkar@ti.com>, <premi@ti.com>,
        <david.woodhouse@intel.com>, Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v2 3/3] OMAP3: Remove auto-selection of PMICs
Date: Thu, 8 Sep 2011 18:18:11 +0530
Message-ID: <1315486091-835-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation almost assumes that only
TWL4030/TWL5030/TWl6030 are (or can be) used with the
OMAP processors. This is, however, not true.

This patch removes the automatic selection of the PMIC
from Kconfig.
All currently used PMICs are now added to omap2plus_defconfig;
any new PMIC that gets supported in future could now be
enabled here rather than by changing Kconfig for
ARCH_OMAP2PLUS_TYPICAL

TWL4030 CORE and POWER drivers are no longer built only for ARM and OMAP,
as per the discussion here:
	http://marc.info/?l=linux-omap&m=131402877315314&w=2

Signed-off-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/configs/omap2plus_defconfig |    3 +++
 arch/arm/mach-omap2/Kconfig          |    3 ---
 drivers/mfd/Kconfig                  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index d5f00d7..076b131 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -130,6 +130,9 @@ CONFIG_POWER_SUPPLY=y
 CONFIG_WATCHDOG=y
 CONFIG_OMAP_WATCHDOG=y
 CONFIG_TWL4030_WATCHDOG=y
+CONFIG_MENELAUS=y
+CONFIG_TWL4030_CORE=y
+CONFIG_TWL4030_POWER=y
 CONFIG_REGULATOR_TWL4030=y
 CONFIG_REGULATOR_TPS65023=y
 CONFIG_REGULATOR_TPS6507X=y
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 7edf802..d40f6d2 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -15,9 +15,6 @@ config ARCH_OMAP2PLUS_TYPICAL
 	select I2C
 	select I2C_OMAP
 	select MFD_SUPPORT
-	select MENELAUS if ARCH_OMAP2
-	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
-	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
 	help
 	  Compile a kernel suitable for booting most boards
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 21574bd..72e15c8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -238,7 +238,7 @@ config TWL4030_MADC
 
 config TWL4030_POWER
 	bool "Support power resources on TWL4030 family chips"
-	depends on TWL4030_CORE && ARM
+	depends on TWL4030_CORE
 	help
 	  Say yes here if you want to use the power resources on the
 	  TWL4030 family chips.  Most of these resources are regulators,
-- 
1.7.1

