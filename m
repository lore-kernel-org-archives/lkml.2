Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030405Ab2LIDlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 22:41:39 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50702 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030390Ab2LIDli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 22:41:38 -0500
Message-ID: <1355024486.16481.1.camel@phoenix>
Subject: [PATCH RFT] regulator: 88pm8607: Update update_bit for BUCK2 in
 pm8607_set_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Dec 2012 11:41:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUCK2 has the update_bit setting, but current code does not set update_bit
in pm8607_set_voltage_sel.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Haojian,
I don't have the datasheet, can you check if this patch is correct or not?
Thanks,
Axel
 drivers/regulator/88pm8607.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 2b55711..5c4879a 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -236,6 +236,7 @@ static int pm8607_set_voltage_sel(struct regulator_dev *rdev, unsigned selector)
 		return ret;
 	switch (info->desc.id) {
 	case PM8607_ID_BUCK1:
+	case PM8607_ID_BUCK2:
 	case PM8607_ID_BUCK3:
 		ret = pm860x_set_bits(info->i2c, info->update_reg,
 				      1 << info->update_bit,
-- 
1.7.9.5



