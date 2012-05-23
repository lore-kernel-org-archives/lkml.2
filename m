Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab2EWJb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:31:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35524 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859Ab2EWJb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:31:56 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Use select .. if to get IRQ_DOMAIN enabled
Date: Wed, 23 May 2012 10:31:53 +0100
Message-Id: <1337765513-16663-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that we can't get randconfig breakage by doing the IRQ_DOMAIN
select automatically. Don't just do the select from REGMAP_IRQ to ensure
that the select actually gets noticed.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/Kconfig |    1 +
 drivers/mfd/Kconfig         |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
index 9ef0a53..6be390b 100644
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -6,6 +6,7 @@ config REGMAP
 	default y if (REGMAP_I2C || REGMAP_SPI)
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
+	select IRQ_DOMAIN if REGMAP_IRQ
 	bool
 
 config REGMAP_I2C
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e35cb6b..213304d 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -376,7 +376,6 @@ config PMIC_DA9052
 
 config MFD_DA9052_SPI
 	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with SPI"
-	select IRQ_DOMAIN
 	select REGMAP_SPI
 	select REGMAP_IRQ
 	select PMIC_DA9052
@@ -389,7 +388,6 @@ config MFD_DA9052_SPI
 
 config MFD_DA9052_I2C
 	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with I2C"
-	select IRQ_DOMAIN
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select PMIC_DA9052
@@ -560,7 +558,6 @@ config MFD_WM8994
 	bool "Support Wolfson Microelectronics WM8994"
 	select MFD_CORE
 	select REGMAP_I2C
-	select IRQ_DOMAIN
 	select REGMAP_IRQ
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
-- 
1.7.10

