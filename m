Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2KMIbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:31:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60108 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab2KMI3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:29:10 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/13] mfd: twl4030-madc: Change TWL4030_MODULE_* ids to TWL_MODULE_*
Date: Tue, 13 Nov 2012 09:28:51 +0100
Message-ID: <1352795334-7406-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To facilitate upcoming cleanup in twl stack.
No functional changes.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl4030-madc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 456ecb5..2baabaa 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -173,7 +173,7 @@ static int twl4030battery_temperature(int raw_volt)
 
 	volt = (raw_volt * TEMP_STEP_SIZE) / TEMP_PSR_R;
 	/* Getting and calculating the supply current in micro ampers */
-	ret = twl_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE, &val,
+	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE, &val,
 		REG_BCICTL2);
 	if (ret < 0)
 		return ret;
@@ -196,7 +196,7 @@ static int twl4030battery_current(int raw_volt)
 	int ret;
 	u8 val;
 
-	ret = twl_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE, &val,
+	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE, &val,
 		TWL4030_BCI_BCICTL1);
 	if (ret)
 		return ret;
@@ -635,7 +635,7 @@ static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
 	int ret;
 	u8 regval;
 
-	ret = twl_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE,
+	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE,
 			      &regval, TWL4030_BCI_BCICTL1);
 	if (ret) {
 		dev_err(madc->dev, "unable to read BCICTL1 reg 0x%X",
@@ -646,7 +646,7 @@ static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
 		regval |= chan ? TWL4030_BCI_ITHEN : TWL4030_BCI_TYPEN;
 	else
 		regval &= chan ? ~TWL4030_BCI_ITHEN : ~TWL4030_BCI_TYPEN;
-	ret = twl_i2c_write_u8(TWL4030_MODULE_MAIN_CHARGE,
+	ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
 			       regval, TWL4030_BCI_BCICTL1);
 	if (ret) {
 		dev_err(madc->dev, "unable to write BCICTL1 reg 0x%X\n",
@@ -668,7 +668,7 @@ static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on)
 	u8 regval;
 	int ret;
 
-	ret = twl_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE,
+	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE,
 			      &regval, TWL4030_MADC_CTRL1);
 	if (ret) {
 		dev_err(madc->dev, "unable to read madc ctrl1 reg 0x%X\n",
@@ -725,7 +725,7 @@ static int __devinit twl4030_madc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_current_generator;
 
-	ret = twl_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE,
+	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE,
 			      &regval, TWL4030_BCI_BCICTL1);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to read reg BCI CTL1 0x%X\n",
@@ -733,7 +733,7 @@ static int __devinit twl4030_madc_probe(struct platform_device *pdev)
 		goto err_i2c;
 	}
 	regval |= TWL4030_BCI_MESBAT;
-	ret = twl_i2c_write_u8(TWL4030_MODULE_MAIN_CHARGE,
+	ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
 			       regval, TWL4030_BCI_BCICTL1);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to write reg BCI Ctl1 0x%X\n",
-- 
1.8.0

