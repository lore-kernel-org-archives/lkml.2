Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab1GFS63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:58:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44102 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab1GFS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:58:27 -0400
Date: Wed, 6 Jul 2011 21:57:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch] regulator/tps65912: storing error codes in u8
Message-ID: <20110706185718.GJ18655@shale.localdomain>
References: <20110623055715.GM14591@shale.localdomain>
 <1309795618.3272.9.camel@odin>
 <20110706183208.GK3021@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706183208.GK3021@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_ctrl_reg() returns -EINVAL so the error handling won't work here
if reg is a u8.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Resent to Samuel Ortiz who wasn't CC'd the first time.

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index d2c6542..3a9313e 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -417,7 +417,7 @@ static int tps65912_reg_enable(struct regulator_dev *dev)
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	struct tps65912 *mfd = pmic->mfd;
 	int id = rdev_get_id(dev);
-	u8 reg;
+	int reg;
 
 	if (id < TPS65912_REG_DCDC1 || id > TPS65912_REG_LDO10)
 		return -EINVAL;

