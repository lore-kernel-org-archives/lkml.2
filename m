Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2DIP0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 11:26:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab2DIP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 11:26:10 -0400
Message-ID: <1333985163.9076.3.camel@phoenix>
Subject: [PATCH] regulator: twl-regulator: Use DIV_ROUND_UP at appropriate
 places
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 09 Apr 2012 23:26:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   24 ++++--------------------
 1 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 964946f..bc5e21c 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -806,11 +806,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 			vsel = 0;
 		else if ((min_uV >= 600000) && (min_uV <= 1300000)) {
 			int calc_uV;
-			vsel = (min_uV - 600000) / 125;
-			if (vsel % 100)
-				vsel += 100;
-			vsel /= 100;
-			vsel++;
+			vsel = DIV_ROUND_UP(min_uV - 600000, 12500);
 			calc_uV = twl6030smps_list_voltage(rdev, vsel);
 			if (calc_uV > max_uV)
 				return -EINVAL;
@@ -836,11 +832,7 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 			vsel = 0;
 		else if ((min_uV >= 700000) && (min_uV <= 1420000)) {
 			int calc_uV;
-			vsel = (min_uV - 700000) / 125;
-			if (vsel % 100)
-				vsel += 100;
-			vsel /= 100;
-			vsel++;
+			vsel = DIV_ROUND_UP(min_uV - 700000, 12500);
 			calc_uV = twl6030smps_list_voltage(rdev, vsel);
 			if (calc_uV > max_uV)
 				return -EINVAL;
@@ -865,22 +857,14 @@ twl6030smps_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV,
 		if (min_uV == 0)
 			vsel = 0;
 		else if ((min_uV >= 1852000) && (max_uV <= 4013600)) {
-			vsel = (min_uV - 1852000) / 386;
-			if (vsel % 100)
-				vsel += 100;
-			vsel /= 100;
-			vsel++;
+			vsel = DIV_ROUND_UP(min_uV - 1852000, 38600);
 		}
 		break;
 	case SMPS_OFFSET_EN|SMPS_EXTENDED_EN:
 		if (min_uV == 0)
 			vsel = 0;
 		else if ((min_uV >= 2161000) && (max_uV <= 4321000)) {
-			vsel = (min_uV - 2161000) / 386;
-			if (vsel % 100)
-				vsel += 100;
-			vsel /= 100;
-			vsel++;
+			vsel = DIV_ROUND_UP(min_uV - 2161000, 38600);
 		}
 		break;
 	}
-- 
1.7.5.4



