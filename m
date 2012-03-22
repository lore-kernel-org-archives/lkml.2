Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031331Ab2CVWZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:25:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54531 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030963Ab2CVWZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:25:15 -0400
Message-ID: <1332455105.2948.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: Fix restoring pmic.dcdcx_hib_mode
 settings in wm8350_dcdc_set_suspend_enable
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 23 Mar 2012 06:25:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What we want is to restore wm8350->pmic.dcdcx_hib_mode settings to
WM8350_DCDCx_LOW_POWER registers. Current code also clears all other
bits of WM8350_DCDCx_LOW_POWER registers which is wrong.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index ab1e183..1c54821 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -495,25 +495,25 @@ static int wm8350_dcdc_set_suspend_enable(struct regulator_dev *rdev)
 		val = wm8350_reg_read(wm8350, WM8350_DCDC1_LOW_POWER)
 			& ~WM8350_DCDC_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC1_LOW_POWER,
-			wm8350->pmic.dcdc1_hib_mode);
+			val | wm8350->pmic.dcdc1_hib_mode);
 		break;
 	case WM8350_DCDC_3:
 		val = wm8350_reg_read(wm8350, WM8350_DCDC3_LOW_POWER)
 			& ~WM8350_DCDC_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC3_LOW_POWER,
-			wm8350->pmic.dcdc3_hib_mode);
+			val | wm8350->pmic.dcdc3_hib_mode);
 		break;
 	case WM8350_DCDC_4:
 		val = wm8350_reg_read(wm8350, WM8350_DCDC4_LOW_POWER)
 			& ~WM8350_DCDC_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC4_LOW_POWER,
-			wm8350->pmic.dcdc4_hib_mode);
+			val | wm8350->pmic.dcdc4_hib_mode);
 		break;
 	case WM8350_DCDC_6:
 		val = wm8350_reg_read(wm8350, WM8350_DCDC6_LOW_POWER)
 			& ~WM8350_DCDC_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC6_LOW_POWER,
-			wm8350->pmic.dcdc6_hib_mode);
+			val | wm8350->pmic.dcdc6_hib_mode);
 		break;
 	case WM8350_DCDC_2:
 	case WM8350_DCDC_5:
-- 
1.7.5.4



