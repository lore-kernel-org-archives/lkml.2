Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2FTKLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:11:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51024 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407Ab2FTKLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:11:09 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Milo.Kim@ti.com, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: lp872x: Don't allow modular build
Date: Wed, 20 Jun 2012 11:11:00 +0100
Message-Id: <1340187060-15072-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes link failure due to devm_gpio_request_one()

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 870f730..434462a 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -20,6 +20,7 @@ menuconfig REGULATOR
 
 	  If unsure, say no.
 
+
 if REGULATOR
 
 config REGULATOR_DEBUG
@@ -225,7 +226,7 @@ config REGULATOR_LP3972
 	 on National Semiconductors LP3972 PMIC
 
 config REGULATOR_LP872X
-	tristate "TI/National Semiconductor LP8720/LP8725 voltage regulators"
+	bool "TI/National Semiconductor LP8720/LP8725 voltage regulators"
 	depends on I2C
 	select REGMAP_I2C
 	help
-- 
1.7.10

