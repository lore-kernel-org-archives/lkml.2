Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2COHxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:53:21 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33969 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab2COHxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:53:20 -0400
Message-ID: <1331797985.7129.1.camel@phoenix>
Subject: [PATCH] regulator: Fix set and get current limit for wm831x_buckv
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 15 Mar 2012 15:53:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WM831X_DC1_HC_THR_MASK is 0x0070.
We need to do proper shift for setting and getting current limit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 4904a40..3044001 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -386,7 +386,8 @@ static int wm831x_buckv_set_current_limit(struct regulator_dev *rdev,
 	if (i == ARRAY_SIZE(wm831x_dcdc_ilim))
 		return -EINVAL;
 
-	return wm831x_set_bits(wm831x, reg, WM831X_DC1_HC_THR_MASK, i);
+	return wm831x_set_bits(wm831x, reg, WM831X_DC1_HC_THR_MASK,
+			       i << WM831X_DC1_HC_THR_SHIFT);
 }
 
 static int wm831x_buckv_get_current_limit(struct regulator_dev *rdev)
@@ -400,7 +401,8 @@ static int wm831x_buckv_get_current_limit(struct regulator_dev *rdev)
 	if (val < 0)
 		return val;
 
-	return wm831x_dcdc_ilim[val & WM831X_DC1_HC_THR_MASK];
+	val = (val & WM831X_DC1_HC_THR_MASK) >> WM831X_DC1_HC_THR_SHIFT;
+	return wm831x_dcdc_ilim[val];
 }
 
 static struct regulator_ops wm831x_buckv_ops = {
-- 
1.7.5.4



