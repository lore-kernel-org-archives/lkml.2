Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2BFM67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:58:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56969 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab2BFM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:58:58 -0500
Message-ID: <1328533132.4535.3.camel@phoenix>
Subject: [PATCH] regulatore: Remove redundant regmap_update_bits call for
 TPS65023_REG_CON_CTRL2
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 06 Feb 2012 20:58:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like a merge mistake.  Calling regmap_update_bits once is enough.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 18d61a0..43e4902 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -491,10 +491,6 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 	regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
 			TPS65023_REG_CTRL2_CORE_ADJ, TPS65023_REG_CTRL2_CORE_ADJ);
 
-	/* Enable setting output voltage by I2C */
-	regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
-			TPS65023_REG_CTRL2_CORE_ADJ, TPS65023_REG_CTRL2_CORE_ADJ);
-
 	return 0;
 
  fail:
-- 
1.7.5.4



