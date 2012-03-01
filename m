Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030448Ab2CAB1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:27:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55821 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab2CAB1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:27:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.229.5 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330565249.5373.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: Kill max8998_get_ldo function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 01 Mar 2012 09:27:29 +0800
In-Reply-To: <1330565187.5373.1.camel@phoenix>
References: <1330565187.5373.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rdev_get_id() directly.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 2d38c24..634f257 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -112,16 +112,11 @@ static const struct voltage_map_desc *ldo_voltage_map[] = {
 	&buck4_voltage_map_desc,	/* BUCK4 */
 };
 
-static inline int max8998_get_ldo(struct regulator_dev *rdev)
-{
-	return rdev_get_id(rdev);
-}
-
 static int max8998_list_voltage(struct regulator_dev *rdev,
 				unsigned int selector)
 {
 	const struct voltage_map_desc *desc;
-	int ldo = max8998_get_ldo(rdev);
+	int ldo = rdev_get_id(rdev);
 	int val;
 
 	if (ldo >= ARRAY_SIZE(ldo_voltage_map))
@@ -141,7 +136,7 @@ static int max8998_list_voltage(struct regulator_dev *rdev,
 static int max8998_get_enable_register(struct regulator_dev *rdev,
 					int *reg, int *shift)
 {
-	int ldo = max8998_get_ldo(rdev);
+	int ldo = rdev_get_id(rdev);
 
 	switch (ldo) {
 	case MAX8998_LDO2 ... MAX8998_LDO5:
@@ -222,7 +217,7 @@ static int max8998_ldo_disable(struct regulator_dev *rdev)
 static int max8998_get_voltage_register(struct regulator_dev *rdev,
 				int *_reg, int *_shift, int *_mask)
 {
-	int ldo = max8998_get_ldo(rdev);
+	int ldo = rdev_get_id(rdev);
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
 	int reg, shift = 0, mask = 0xff;
 
@@ -310,7 +305,7 @@ static int max8998_set_voltage_ldo(struct regulator_dev *rdev,
 	struct i2c_client *i2c = max8998->iodev->i2c;
 	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	const struct voltage_map_desc *desc;
-	int ldo = max8998_get_ldo(rdev);
+	int ldo = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
 	int i = 0;
 
@@ -362,7 +357,7 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	struct i2c_client *i2c = max8998->iodev->i2c;
 	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	const struct voltage_map_desc *desc;
-	int buck = max8998_get_ldo(rdev);
+	int buck = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
 	int difference = 0, i = 0, j = 0, previous_vol = 0;
 	u8 val = 0;
-- 
1.7.5.4



