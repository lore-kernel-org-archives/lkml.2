Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2DQPsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:48:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56078 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab2DQPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:48:35 -0400
Message-ID: <1334677707.14393.2.camel@phoenix>
Subject: [PATCH 1/2] regulator: max8997: Remove is_enabled callback
 implementation for max8997_charger_fixedstate_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 17 Apr 2012 23:48:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If is_enabled callback is not implemented, the core assumes that the regulator
is on.

This is simpler than having a hack to retrun 1 in max8997_reg_is_enabled() if
max8997_get_enable_register() returns -EINVAL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 99d7cb3..0796ad8 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -278,9 +278,7 @@ static int max8997_reg_is_enabled(struct regulator_dev *rdev)
 	u8 val;
 
 	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
-	if (ret == -EINVAL)
-		return 1; /* "not controllable" */
-	else if (ret)
+	if (ret)
 		return ret;
 
 	ret = max8997_read_reg(i2c, reg, &val);
@@ -887,7 +885,6 @@ static struct regulator_ops max8997_charger_ops = {
 };
 
 static struct regulator_ops max8997_charger_fixedstate_ops = {
-	.is_enabled		= max8997_reg_is_enabled,
 	.get_current_limit	= max8997_get_current_limit,
 	.set_current_limit	= max8997_set_current_limit,
 };
-- 
1.7.5.4



