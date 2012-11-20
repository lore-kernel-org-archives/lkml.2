Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2KTBFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:05:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51400 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509Ab2KTBFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:05:31 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: wm831x: Set the new rather than old value for DVS VSEL
Date: Tue, 20 Nov 2012 10:04:09 +0900
Message-Id: <1353373449-5563-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 782c228..416fe0a 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -290,7 +290,7 @@ static int wm831x_buckv_set_voltage_sel(struct regulator_dev *rdev,
 	if (vsel > dcdc->dvs_vsel) {
 		ret = wm831x_set_bits(wm831x, dvs_reg,
 				      WM831X_DC1_DVS_VSEL_MASK,
-				      dcdc->dvs_vsel);
+				      vsel);
 		if (ret == 0)
 			dcdc->dvs_vsel = vsel;
 		else
-- 
1.7.10.4

