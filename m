Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031335Ab2CVW1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:27:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61601 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030963Ab2CVW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:27:15 -0400
Message-ID: <1332455230.2948.3.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: Do proper shift to set correct bit for
 DC[2|5]_HIB_MODE setting
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 23 Mar 2012 06:27:10 +0800
In-Reply-To: <1332455105.2948.1.camel@phoenix>
References: <1332455105.2948.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DC[2|5]_HIB_MODE is BIT 12 of DCDC[2|5] Control register.
WM8350_DC2_HIB_MODE_ACTIVE/WM8350_DC2_HIB_MODE_DISABLE are defined as 1/0.
Thus we need to left shift WM8350_DC2_HIB_MODE_SHIFT bits.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 1c54821..ff34654 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -575,13 +575,13 @@ static int wm8350_dcdc25_set_suspend_enable(struct regulator_dev *rdev)
 		val = wm8350_reg_read(wm8350, WM8350_DCDC2_CONTROL)
 		    & ~WM8350_DC2_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC2_CONTROL, val |
-				 WM8350_DC2_HIB_MODE_ACTIVE);
+		    (WM8350_DC2_HIB_MODE_ACTIVE << WM8350_DC2_HIB_MODE_SHIFT));
 		break;
 	case WM8350_DCDC_5:
 		val = wm8350_reg_read(wm8350, WM8350_DCDC5_CONTROL)
-		    & ~WM8350_DC2_HIB_MODE_MASK;
+		    & ~WM8350_DC5_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC5_CONTROL, val |
-				 WM8350_DC5_HIB_MODE_ACTIVE);
+		    (WM8350_DC5_HIB_MODE_ACTIVE << WM8350_DC5_HIB_MODE_SHIFT));
 		break;
 	default:
 		return -EINVAL;
@@ -600,13 +600,13 @@ static int wm8350_dcdc25_set_suspend_disable(struct regulator_dev *rdev)
 		val = wm8350_reg_read(wm8350, WM8350_DCDC2_CONTROL)
 		    & ~WM8350_DC2_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC2_CONTROL, val |
-				 WM8350_DC2_HIB_MODE_DISABLE);
+		    (WM8350_DC2_HIB_MODE_DISABLE << WM8350_DC2_HIB_MODE_SHIFT));
 		break;
 	case WM8350_DCDC_5:
 		val = wm8350_reg_read(wm8350, WM8350_DCDC5_CONTROL)
-		    & ~WM8350_DC2_HIB_MODE_MASK;
+		    & ~WM8350_DC5_HIB_MODE_MASK;
 		wm8350_reg_write(wm8350, WM8350_DCDC5_CONTROL, val |
-				 WM8350_DC2_HIB_MODE_DISABLE);
+		    (WM8350_DC5_HIB_MODE_DISABLE << WM8350_DC5_HIB_MODE_SHIFT));
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.5.4



