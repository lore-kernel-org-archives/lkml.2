Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab2DTKgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:36:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48911 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2DTKgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:36:19 -0400
Message-ID: <1334918174.11252.4.camel@phoenix>
Subject: [PATCH 2/2] regulator: max8952: Convert to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>
Date: Fri, 20 Apr 2012 18:36:14 +0800
In-Reply-To: <1334918032.11252.1.camel@phoenix>
References: <1334918032.11252.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index c0ab4dd..62ae140 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -69,11 +69,6 @@ static int max8952_write_reg(struct max8952_data *max8952,
 	return i2c_smbus_write_byte_data(max8952->client, reg, value);
 }
 
-static int max8952_voltage(struct max8952_data *max8952, u8 mode)
-{
-	return (max8952->pdata->dvs_mode[mode] * 10 + 770) * 1000;
-}
-
 static int max8952_list_voltage(struct regulator_dev *rdev,
 		unsigned int selector)
 {
@@ -82,7 +77,7 @@ static int max8952_list_voltage(struct regulator_dev *rdev,
 	if (rdev_get_id(rdev) != 0)
 		return -EINVAL;
 
-	return max8952_voltage(max8952, selector);
+	return (max8952->pdata->dvs_mode[selector] * 10 + 770) * 1000;
 }
 
 static int max8952_is_enabled(struct regulator_dev *rdev)
@@ -117,7 +112,7 @@ static int max8952_disable(struct regulator_dev *rdev)
 	return 0;
 }
 
-static int max8952_get_voltage(struct regulator_dev *rdev)
+static int max8952_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
 	u8 vid = 0;
@@ -127,7 +122,7 @@ static int max8952_get_voltage(struct regulator_dev *rdev)
 	if (max8952->vid1)
 		vid += 2;
 
-	return max8952_voltage(max8952, vid);
+	return vid;
 }
 
 static int max8952_set_voltage_sel(struct regulator_dev *rdev,
@@ -154,7 +149,7 @@ static struct regulator_ops max8952_ops = {
 	.is_enabled		= max8952_is_enabled,
 	.enable			= max8952_enable,
 	.disable		= max8952_disable,
-	.get_voltage		= max8952_get_voltage,
+	.get_voltage_sel	= max8952_get_voltage_sel,
 	.set_voltage_sel	= max8952_set_voltage_sel,
 	.set_suspend_disable	= max8952_disable,
 };
-- 
1.7.5.4



