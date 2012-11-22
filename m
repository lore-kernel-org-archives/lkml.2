Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2KVUrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:47:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33143 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab2KVUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:46:58 -0500
Message-ID: <1353548828.9090.1.camel@phoenix>
Subject: [PATCH] regulator: max8973: Fix callback setting for
 max8973_dcdc_ops.enable
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Nov 2012 09:47:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8973-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8973-regulator.c b/drivers/regulator/max8973-regulator.c
index e6328f9..140ff9d 100644
--- a/drivers/regulator/max8973-regulator.c
+++ b/drivers/regulator/max8973-regulator.c
@@ -401,7 +401,7 @@ static int __devinit max8973_probe(struct i2c_client *client,
 	if (pdata->enable_ext_control) {
 		max->desc.enable_reg = MAX8973_VOUT;
 		max->desc.enable_mask = MAX8973_VOUT_ENABLE;
-		max8973_dcdc_ops.enable = regulator_is_enabled_regmap;
+		max8973_dcdc_ops.enable = regulator_enable_regmap;
 		max8973_dcdc_ops.disable = regulator_disable_regmap;
 		max8973_dcdc_ops.is_enabled = regulator_is_enabled_regmap;
 	}
-- 
1.7.9.5



