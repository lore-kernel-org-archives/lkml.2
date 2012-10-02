Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2JBP4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:56:13 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:37208 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab2JBP4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:56:12 -0400
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: j-keerthy@ti.com, sameo@linux.intel.com,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: [PATCH] mfd: spelling/cleanup of twl4030 madc
Date: Tue,  2 Oct 2012 17:55:21 +0200
Message-Id: <1349193321-28793-1-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <p.meerwald@bct-electronic.com>

fixe typos in comments and correct trivial debug output

Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
---
 drivers/mfd/twl4030-madc.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 456ecb5..dfacf6c 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -86,13 +86,13 @@ twl4030_divider_ratios[16] = {
 	{15, 100},	/* CHANNEL 11 */
 	{1, 4},		/* CHANNEL 12 */
 	{1, 1},		/* CHANNEL 13 Reserved channels */
-	{1, 1},		/* CHANNEL 14 Reseved channels */
+	{1, 1},		/* CHANNEL 14 Reserved channels */
 	{5, 11},	/* CHANNEL 15 */
 };
 
 
 /*
- * Conversion table from -3 to 55 degree Celcius
+ * Conversion table from -3 to 55 degree Celsius
  */
 static int therm_tbl[] = {
 30800,	29500,	28300,	27100,
@@ -107,8 +107,8 @@ static int therm_tbl[] = {
 /*
  * Structure containing the registers
  * of different conversion methods supported by MADC.
- * Hardware or RT real time conversion request initiated by external host
- * processor for RT Signal conversions.
+ * Hardware or RT (real time) conversion request initiated by external host
+ * processor for RT signal conversions.
  * External host processors can also request for non RT conversions
  * SW1 and SW2 software conversions also called asynchronous or GPC request.
  */
@@ -209,7 +209,7 @@ static int twl4030battery_current(int raw_volt)
  * Function to read channel values
  * @madc - pointer to twl4030_madc_data struct
  * @reg_base - Base address of the first channel
- * @Channels - 16 bit bitmap. If the bit is set, channel value is read
+ * @channels - 16 bit bitmap. If the bit is set, channel value is read
  * @buf - The channel values are stored here. if read fails error
  * value is stored
  * Returns the number of successfully read channels.
@@ -360,7 +360,7 @@ static irqreturn_t twl4030_madc_threaded_irq_handler(int irq, void *_madc)
 			continue;
 		ret = twl4030_madc_disable_irq(madc, i);
 		if (ret < 0)
-			dev_dbg(madc->dev, "Disable interrupt failed%d\n", i);
+			dev_dbg(madc->dev, "Disable interrupt %d failed\n", i);
 		madc->requests[i].result_pending = 1;
 	}
 	for (i = 0; i < TWL4030_MADC_NUM_METHODS; i++) {
@@ -536,7 +536,7 @@ int twl4030_madc_conversion(struct twl4030_madc_request *req)
 	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, ch_lsb, method->sel);
 	if (ret) {
 		dev_err(twl4030_madc->dev,
-			"unable to write sel register 0x%X\n", method->sel + 1);
+			"unable to write sel register 0x%X\n", method->sel);
 		goto out;
 	}
 	/* Select averaging for all channels if do_avg is set */
@@ -553,8 +553,8 @@ int twl4030_madc_conversion(struct twl4030_madc_request *req)
 				       ch_lsb, method->avg);
 		if (ret) {
 			dev_err(twl4030_madc->dev,
-				"unable to write sel reg 0x%X\n",
-				method->sel + 1);
+				"unable to write avg register 0x%X\n",
+				method->avg);
 			goto out;
 		}
 	}
@@ -660,7 +660,7 @@ static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
 /*
  * Function that sets MADC software power on bit to enable MADC
  * @madc - pointer to twl4030_madc_data struct
- * @on - Enable or disable MADC software powen on bit.
+ * @on - Enable or disable MADC software power on bit.
  * returns error if i2c read/write fails else 0
  */
 static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on)
@@ -728,7 +728,7 @@ static int __devinit twl4030_madc_probe(struct platform_device *pdev)
 	ret = twl_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE,
 			      &regval, TWL4030_BCI_BCICTL1);
 	if (ret) {
-		dev_err(&pdev->dev, "unable to read reg BCI CTL1 0x%X\n",
+		dev_err(&pdev->dev, "unable to read reg BCICTL1 0x%X\n",
 			TWL4030_BCI_BCICTL1);
 		goto err_i2c;
 	}
@@ -736,7 +736,7 @@ static int __devinit twl4030_madc_probe(struct platform_device *pdev)
 	ret = twl_i2c_write_u8(TWL4030_MODULE_MAIN_CHARGE,
 			       regval, TWL4030_BCI_BCICTL1);
 	if (ret) {
-		dev_err(&pdev->dev, "unable to write reg BCI Ctl1 0x%X\n",
+		dev_err(&pdev->dev, "unable to write reg BCICTL1 0x%X\n",
 			TWL4030_BCI_BCICTL1);
 		goto err_i2c;
 	}
-- 
1.7.9.5

