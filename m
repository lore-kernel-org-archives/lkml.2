Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1CDHYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:24:22 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34792 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1CDHYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:24:20 -0500
Date: Fri, 04 Mar 2011 16:16:56 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] MAX8997/8966 PMIC: compiler warning removed (incompatible
 pointer)
In-reply-to: <1299221427-4726-3-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1299223016-8655-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <1299221427-4726-3-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 04 Mar 2011 07:16:56.0671 (UTC)
 FILETIME=[252BC6F0:01CBDA3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/max8997.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 30778c5..957063a 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -790,18 +790,27 @@ static struct regulator_ops max8997_fixedstate_ops = {
 	.set_voltage		= max8997_set_voltage_charger_cv,
 };
 
+static int max8997_set_voltage_ldo_wrap(struct regulator_dev *rdev,
+		int min_uV, int max_uV)
+{
+	unsigned dummy;
+
+	return max8997_set_voltage_ldo(rdev, min_uV, max_uV, &dummy);
+}
+
+
 static struct regulator_ops max8997_charger_ops = {
 	.is_enabled		= max8997_reg_is_enabled,
 	.enable			= max8997_reg_enable,
 	.disable		= max8997_reg_disable,
 	.get_current_limit	= max8997_get_voltage,
-	.set_current_limit	= max8997_set_voltage_ldo,
+	.set_current_limit	= max8997_set_voltage_ldo_wrap,
 };
 
 static struct regulator_ops max8997_charger_fixedstate_ops = {
 	.is_enabled		= max8997_reg_is_enabled,
 	.get_current_limit	= max8997_get_voltage,
-	.set_current_limit	= max8997_set_voltage_ldo,
+	.set_current_limit	= max8997_set_voltage_ldo_wrap,
 };
 
 #define regulator_desc_ldo(num)		{	\
-- 
1.7.1

