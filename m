Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2LXBNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 20:13:53 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61501 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2LXBNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 20:13:49 -0500
Message-ID: <1356311618.4697.1.camel@phoenix>
Subject: [PATCH 1/2] [PATCH] regulator: 88pm8607: Update update_bit for
 BUCK2 in pm8607_set_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Dec 2012 09:13:38 +0800
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
hi Haojian,
I prefer no behavior change during API conversion.
So I send this fix first, next patch is on top of this patch.

Regards,
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



