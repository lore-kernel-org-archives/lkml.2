Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2DSDQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:16:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50279 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2DSDQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:16:13 -0400
Message-ID: <1334805358.22839.2.camel@phoenix>
Subject: [PATCH] regulator: 88pm8607: Fix writting value to vol_reg in
 pm8607_set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>
Date: Thu, 19 Apr 2012 11:15:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4ca1e1d "regulator: Convert 88pm8607 to set_voltage_sel" accidentally
changed the value writing to vol_reg.
What we want is to write val instead of selector to vol_reg.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This only impact is setting LDO13, for other LDOs/BUCKs the shift is 0.

 drivers/regulator/88pm8607.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index d04fbe9..06d9c4b 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -232,7 +232,7 @@ static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 	val = (uint8_t)(selector << info->vol_shift);
 	mask = (rdev->desc->n_voltages - 1)  << info->vol_shift;
 
-	ret = pm860x_set_bits(info->i2c, info->vol_reg, mask, selector);
+	ret = pm860x_set_bits(info->i2c, info->vol_reg, mask, val);
 	if (ret)
 		return ret;
 	switch (info->desc.id) {
-- 
1.7.5.4



