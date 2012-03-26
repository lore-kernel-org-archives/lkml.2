Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab2CZOkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:40:07 -0400
Received: from mail.meprolight.com ([194.90.149.17]:55457 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932528Ab2CZOkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:40:05 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <marc.reilly@gmail.com>, <s.hauer@pengutronix.de>,
        <fabio.estevam@freescale.com>, Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH] mfd: mc13xxx: add I2C support fix building v3.3
Date: Mon, 26 Mar 2012 16:32:50 +0200
Message-ID: <1332772370-13272-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the compilation errors after the patches
from series mc13xxx-add-I2C-support-V4 were applied.
It was successfully tested on i.MX35 PDK  v3.3

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 drivers/mfd/Kconfig        |    2 ++
 drivers/mfd/mc13xxx-core.c |    2 +-
 include/linux/regmap.h     |    2 ++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da32a2..74e00cf 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -576,6 +576,8 @@ config MFD_MC13XXX
 	depends on SPI_MASTER || I2C
 	select MFD_CORE
 	select MFD_MC13783
+	select REGMAP_I2C if I2C
+	select REGMAP_SPI if SPI_MASTER
 	help
 	  Enable support for the Freescale MC13783 and MC13892 PMICs.
 	  This driver provides common support for accessing the device,
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index 31dbf91..5a60273 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -616,7 +616,7 @@ static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
 #ifdef CONFIG_OF
 static int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
 {
-	struct device_node *np = mc13xxx->dev.of_node;
+	struct device_node *np = mc13xxx->dev->of_node;
 
 	if (!np)
 		return -ENODEV;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index eb93921..8c6f5e9 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -45,6 +45,7 @@ struct reg_default {
  *
  * @reg_bits: Number of bits in a register address, mandatory.
  * @val_bits: Number of bits in a register value, mandatory.
+ * @pad_bits: Number of bits in a register pad, mandatory.
  *
  * @writeable_reg: Optional callback returning true if the register
  *                 can be written to.
@@ -75,6 +76,7 @@ struct reg_default {
 struct regmap_config {
 	int reg_bits;
 	int val_bits;
+	int pad_bits;
 
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
-- 
1.7.0.4

