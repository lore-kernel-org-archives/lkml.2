Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab2HHMUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:20:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63327 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab2HHMUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:20:34 -0400
Message-ID: <1344428429.3199.4.camel@phoenix>
Subject: [PATCH 4/7] regulator: wm831x-dcdc: set_current_limit should select
 the maximum current in specific range
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Aug 2012 20:20:29 +0800
In-Reply-To: <1344428238.3199.1.camel@phoenix>
References: <1344428238.3199.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 7413885..90cbcc6 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -339,16 +339,15 @@ static int wm831x_buckv_set_current_limit(struct regulator_dev *rdev,
 	u16 reg = dcdc->base + WM831X_DCDC_CONTROL_2;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(wm831x_dcdc_ilim); i++) {
+	for (i = ARRAY_SIZE(wm831x_dcdc_ilim) - 1; i >= 0; i--) {
 		if ((min_uA <= wm831x_dcdc_ilim[i]) &&
 		    (wm831x_dcdc_ilim[i] <= max_uA))
-			break;
+			return wm831x_set_bits(wm831x, reg,
+					       WM831X_DC1_HC_THR_MASK,
+						i << WM831X_DC1_HC_THR_SHIFT);
 	}
-	if (i == ARRAY_SIZE(wm831x_dcdc_ilim))
-		return -EINVAL;
 
-	return wm831x_set_bits(wm831x, reg, WM831X_DC1_HC_THR_MASK,
-			       i << WM831X_DC1_HC_THR_SHIFT);
+	return -EINVAL;
 }
 
 static int wm831x_buckv_get_current_limit(struct regulator_dev *rdev)
-- 
1.7.9.5



