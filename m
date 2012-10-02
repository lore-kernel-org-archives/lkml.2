Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2JBP7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:59:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43985 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab2JBP7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:59:52 -0400
Message-ID: <1349193584.14338.3.camel@phoenix>
Subject: [PATCH] extcon: max77693: Use max77693_update_reg for rmw operations
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 02 Oct 2012 23:59:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/extcon/extcon-max77693.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index e21387e..e0ed622 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -239,25 +239,19 @@ const char *max77693_extcon_cable[] = {
 static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
 		enum max77693_muic_adc_debounce_time time)
 {
-	int ret = 0;
-	u8 ctrl3;
+	int ret;
 
 	switch (time) {
 	case ADC_DEBOUNCE_TIME_5MS:
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = max77693_read_reg(info->max77693->regmap_muic,
-				MAX77693_MUIC_REG_CTRL3, &ctrl3);
-		ctrl3 &= ~CONTROL3_ADCDBSET_MASK;
-		ctrl3 |= (time << CONTROL3_ADCDBSET_SHIFT);
-
-		ret = max77693_write_reg(info->max77693->regmap_muic,
-				MAX77693_MUIC_REG_CTRL3, ctrl3);
-		if (ret) {
+		ret = max77693_update_reg(info->max77693->regmap_muic,
+					  MAX77693_MUIC_REG_CTRL3,
+					  time << CONTROL3_ADCDBSET_SHIFT,
+					  CONTROL3_ADCDBSET_MASK);
+		if (ret)
 			dev_err(info->dev, "failed to set ADC debounce time\n");
-			ret = -EINVAL;
-		}
 		break;
 	default:
 		dev_err(info->dev, "invalid ADC debounce time\n");
-- 
1.7.9.5



