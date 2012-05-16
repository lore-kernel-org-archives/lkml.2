Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2EPRvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:51:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45842 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab2EPRvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:51:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: mc13xxx: Core should not be user visible
Date: Wed, 16 May 2012 18:51:08 +0100
Message-Id: <1337190669-29328-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the core is not usable without one of the bus modules it should not
be presented in the UI but should instead be selected by the bus modules.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ffb7c05..8bc76aa 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -614,7 +614,7 @@ config MFD_MC13783
 	tristate
 
 config MFD_MC13XXX
-	tristate "Support Freescale MC13783 and MC13892"
+	tristate
 	depends on SPI_MASTER || I2C
 	select MFD_CORE
 	select MFD_MC13783
@@ -624,12 +624,11 @@ config MFD_MC13XXX
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
-if MFD_MC13XXX
-
 config MFD_MC13XXX_SPI
 	tristate "MC13xxx SPI interface" if SPI_MASTER
 	default SPI_MASTER
 	select REGMAP_SPI
+	select MFD_MC13XXX
 	help
 	  Select this if your MC13xxx is connected via an SPI bus.
 
@@ -637,11 +636,10 @@ config MFD_MC13XXX_I2C
 	tristate "MC13xxx I2C interface" if I2C
 	default I2C
 	select REGMAP_I2C
+	select MFD_MC13XXX
 	help
 	  Select this if your MC13xxx is connected via an I2C bus.
 
-endif
-
 config ABX500_CORE
 	bool "ST-Ericsson ABX500 Mixed Signal Circuit register functions"
 	default y if ARCH_U300 || ARCH_U8500
-- 
1.7.10

