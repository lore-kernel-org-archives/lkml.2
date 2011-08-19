Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1HSLuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:50:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58901 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab1HSLuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:50:01 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        <sameo@linux.intel.com>, <santosh.shilimkar@ti.com>, <premi@ti.com>,
        <david.woodhouse@intel.com>, Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH 3/3] OMAP3: Remove auto-selection of PMICs
Date: Fri, 19 Aug 2011 17:19:33 +0530
Message-ID: <1313754573-11498-4-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1313754573-11498-3-git-send-email-abhilash.kv@ti.com>
References: <1313754573-11498-1-git-send-email-abhilash.kv@ti.com>
 <1313754573-11498-2-git-send-email-abhilash.kv@ti.com>
 <1313754573-11498-3-git-send-email-abhilash.kv@ti.com>
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

Signed-off-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/configs/omap2plus_defconfig |    3 +++
 arch/arm/mach-omap2/Kconfig          |    3 ---
 drivers/mfd/Kconfig                  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index eb96dc3..7a79fbb 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -134,6 +134,9 @@ CONFIG_POWER_SUPPLY=y
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
index d5e4b60..c5d4966 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -16,9 +16,6 @@ config ARCH_OMAP2PLUS_TYPICAL
 	select I2C
 	select I2C_OMAP
 	select MFD_SUPPORT
-	select MENELAUS if ARCH_OMAP2
-	select TWL4030_CORE if ARCH_OMAP3 || ARCH_OMAP4
-	select TWL4030_POWER if ARCH_OMAP3 || ARCH_OMAP4
 	help
 	  Compile a kernel suitable for booting most boards
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 37b83eb..08db166 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -183,7 +183,7 @@ config MENELAUS
 
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
-	depends on I2C=y && GENERIC_HARDIRQS
+	depends on I2C=y && GENERIC_HARDIRQS && (ARCH_OMAP3 || ARCH_OMAP4)
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
@@ -207,7 +207,7 @@ config TWL4030_MADC
 
 config TWL4030_POWER
 	bool "Support power resources on TWL4030 family chips"
-	depends on TWL4030_CORE && ARM
+	depends on TWL4030_CORE && (ARCH_OMAP3 || ARCH_OMAP4)
 	help
 	  Say yes here if you want to use the power resources on the
 	  TWL4030 family chips.  Most of these resources are regulators,
-- 
1.7.1

