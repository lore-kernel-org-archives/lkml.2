Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2DCXYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:24:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53044 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184Ab2DCXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:24:38 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: tps6524x: Use module_spi_driver()
Date: Wed,  4 Apr 2012 00:24:33 +0100
Message-Id: <1333495473-23455-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unusual to see a regulator driver not using subsys_initcall() but the
deferred probe support should make this viable.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/tps6524x-regulator.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 2a828a0..b33105f 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -661,17 +661,7 @@ static struct spi_driver pmic_driver = {
 	},
 };
 
-static int __init pmic_driver_init(void)
-{
-	return spi_register_driver(&pmic_driver);
-}
-module_init(pmic_driver_init);
-
-static void __exit pmic_driver_exit(void)
-{
-	spi_unregister_driver(&pmic_driver);
-}
-module_exit(pmic_driver_exit);
+module_spi_driver(&pmic_driver);
 
 MODULE_DESCRIPTION("TPS6524X PMIC Driver");
 MODULE_AUTHOR("Cyril Chemparathy");
-- 
1.7.9.1

