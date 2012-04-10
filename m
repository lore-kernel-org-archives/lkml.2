Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab2DJGHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:07:21 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65365 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2DJGHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:07:20 -0400
Message-ID: <1334038035.15859.10.camel@phoenix>
Subject: [PATCH RESEND 2/3] regulator: Use one s5m8767_ops for both LDOs and
 BUCKs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 14:07:15 +0800
In-Reply-To: <1334037944.15859.8.camel@phoenix>
References: <1334037944.15859.8.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the callback function implementation are the same for both LDOs and BUCKs.
Merge them to one s5m8767_ops.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 7576134..8872ee0 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -405,17 +405,7 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 	return 0;
 }
 
-static struct regulator_ops s5m8767_ldo_ops = {
-	.list_voltage		= s5m8767_list_voltage,
-	.is_enabled		= s5m8767_reg_is_enabled,
-	.enable			= s5m8767_reg_enable,
-	.disable		= s5m8767_reg_disable,
-	.get_voltage_sel	= s5m8767_get_voltage_sel,
-	.set_voltage		= s5m8767_set_voltage,
-	.set_voltage_time_sel	= s5m8767_set_voltage_time_sel,
-};
-
-static struct regulator_ops s5m8767_buck_ops = {
+static struct regulator_ops s5m8767_ops = {
 	.list_voltage		= s5m8767_list_voltage,
 	.is_enabled		= s5m8767_reg_is_enabled,
 	.enable			= s5m8767_reg_enable,
@@ -428,14 +418,14 @@ static struct regulator_ops s5m8767_buck_ops = {
 #define regulator_desc_ldo(num)		{	\
 	.name		= "LDO"#num,		\
 	.id		= S5M8767_LDO##num,	\
-	.ops		= &s5m8767_ldo_ops,	\
+	.ops		= &s5m8767_ops,	\
 	.type		= REGULATOR_VOLTAGE,	\
 	.owner		= THIS_MODULE,		\
 }
 #define regulator_desc_buck(num)	{	\
 	.name		= "BUCK"#num,		\
 	.id		= S5M8767_BUCK##num,	\
-	.ops		= &s5m8767_buck_ops,	\
+	.ops		= &s5m8767_ops,	\
 	.type		= REGULATOR_VOLTAGE,	\
 	.owner		= THIS_MODULE,		\
 }
-- 
1.7.5.4



