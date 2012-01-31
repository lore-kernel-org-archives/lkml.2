Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab2AaHUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:20:41 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58308 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2AaHUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:20:40 -0500
Message-ID: <1327994011.9257.3.camel@phoenix>
Subject: [PATCH] regulator: Kill s5m8767_get_reg_id function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 31 Jan 2012 15:13:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling s5m8767_get_reg_id() is exactly the same as calling rdev_get_id().
It is pointless to add s5m8767_get_reg_id() function.
Use rdev_get_id() directly and remove s5m8767_get_reg_id() function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index a5b9d83..5b00e5a 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -120,16 +120,11 @@ static const struct s5m_voltage_desc *reg_voltage_map[] = {
 	[S5M8767_BUCK9] = &buck_voltage_val3,
 };
 
-static inline int s5m8767_get_reg_id(struct regulator_dev *rdev)
-{
-	return rdev_get_id(rdev);
-}
-
 static int s5m8767_list_voltage(struct regulator_dev *rdev,
 				unsigned int selector)
 {
 	const struct s5m_voltage_desc *desc;
-	int reg_id = s5m8767_get_reg_id(rdev);
+	int reg_id = rdev_get_id(rdev);
 	int val;
 
 	if (reg_id >= ARRAY_SIZE(reg_voltage_map) || reg_id < 0)
@@ -148,7 +143,7 @@ static int s5m8767_list_voltage(struct regulator_dev *rdev,
 
 static int s5m8767_get_register(struct regulator_dev *rdev, int *reg)
 {
-	int reg_id = s5m8767_get_reg_id(rdev);
+	int reg_id = rdev_get_id(rdev);
 
 	switch (reg_id) {
 	case S5M8767_LDO1 ... S5M8767_LDO2:
@@ -224,7 +219,7 @@ static int s5m8767_reg_disable(struct regulator_dev *rdev)
 
 static int s5m8767_get_voltage_register(struct regulator_dev *rdev, int *_reg)
 {
-	int reg_id = s5m8767_get_reg_id(rdev);
+	int reg_id = rdev_get_id(rdev);
 	int reg;
 
 	switch (reg_id) {
@@ -265,7 +260,7 @@ static int s5m8767_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int reg, mask = 0xff, ret;
-	int reg_id = s5m8767_get_reg_id(rdev);
+	int reg_id = rdev_get_id(rdev);
 	u8 val;
 
 	ret = s5m8767_get_voltage_register(rdev, &reg);
@@ -325,7 +320,7 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	int min_vol = min_uV, max_vol = max_uV;
 	const struct s5m_voltage_desc *desc;
-	int reg_id = s5m8767_get_reg_id(rdev);
+	int reg_id = rdev_get_id(rdev);
 	int reg, mask, ret;
 	int i;
 	u8 val;
@@ -387,7 +382,7 @@ static int s5m8767_set_voltage_buck(struct regulator_dev *rdev,
 				    int min_uV, int max_uV, unsigned *selector)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int reg_id = s5m8767_get_reg_id(rdev);
+	int reg_id = rdev_get_id(rdev);
 	const struct s5m_voltage_desc *desc;
 	int new_val, old_val, i = 0;
 	int min_vol = min_uV, max_vol = max_uV;
@@ -456,7 +451,7 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	const struct s5m_voltage_desc *desc;
-	int reg_id = s5m8767_get_reg_id(rdev);
+	int reg_id = rdev_get_id(rdev);
 	int mask;
 	int new_val, old_val;
 
-- 
1.7.5.4



