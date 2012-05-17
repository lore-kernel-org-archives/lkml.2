Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab2EQBCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 21:02:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44970 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865Ab2EQBCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 21:02:48 -0400
Message-ID: <1337216562.5759.5.camel@phoenix>
Subject: [PATCH] regulator: max8649: Remove unused check_range() function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 17 May 2012 09:02:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been converted to use regulator_map_voltage_linear and
set_voltage_sel now. regulator_map_voltage_linear will check the the voltage
falls within specified range. The check_range() function is not used, remove it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 39fffb2..1f4bb80 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -60,16 +60,6 @@ struct max8649_regulator_info {
 	unsigned	ramp_down:1;
 };
 
-/* I2C operations */
-
-static inline int check_range(int min_uV, int max_uV)
-{
-	if ((min_uV < MAX8649_DCDC_VMIN) || (max_uV > MAX8649_DCDC_VMAX)
-		|| (min_uV > max_uV))
-		return -EINVAL;
-	return 0;
-}
-
 /* EN_PD means pulldown on EN input */
 static int max8649_enable(struct regulator_dev *rdev)
 {
-- 
1.7.5.4



