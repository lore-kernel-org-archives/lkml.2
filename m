Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab2C2HDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 03:03:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42926 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab2C2HDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 03:03:02 -0400
Message-ID: <1333004575.8548.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Fix setting low power mode for wm831x aldo
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 29 Mar 2012 15:02:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set BIT[8] of LDO7 ON Control mode for low power mode.

R16507 (407Bh)  LDO7 ON Control
BIT[8] LDO7_ON_MODE: LDO7 ON Operating Mode
        0 = Normal mode
        1 = Low Power mode

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index f1e4ab0..641e9f6 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -506,22 +506,19 @@ static int wm831x_aldo_set_mode(struct regulator_dev *rdev,
 {
 	struct wm831x_ldo *ldo = rdev_get_drvdata(rdev);
 	struct wm831x *wm831x = ldo->wm831x;
-	int ctrl_reg = ldo->base + WM831X_LDO_CONTROL;
 	int on_reg = ldo->base + WM831X_LDO_ON_CONTROL;
 	int ret;
 
 
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
-		ret = wm831x_set_bits(wm831x, on_reg,
-				      WM831X_LDO7_ON_MODE, 0);
+		ret = wm831x_set_bits(wm831x, on_reg, WM831X_LDO7_ON_MODE, 0);
 		if (ret < 0)
 			return ret;
 		break;
 
 	case REGULATOR_MODE_IDLE:
-		ret = wm831x_set_bits(wm831x, ctrl_reg,
-				      WM831X_LDO7_ON_MODE,
+		ret = wm831x_set_bits(wm831x, on_reg, WM831X_LDO7_ON_MODE,
 				      WM831X_LDO7_ON_MODE);
 		if (ret < 0)
 			return ret;
-- 
1.7.5.4



