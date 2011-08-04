Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1HDLfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:35:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57825 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1HDLeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:34:14 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>
Subject: [PATCH 1/4] regulator: tps65023: Fixes i2c configuration issues
Date: Thu,  4 Aug 2011 13:33:49 +0200
Message-Id: <1312457632-27075-2-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
 <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow i2c core voltage adjustments by clearing CORE ADJ Allowed bit in CTRL2

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 701a590..a81abd4 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -63,6 +63,13 @@
 #define TPS65023_REG_CTRL_LDO2_EN	BIT(2)
 #define TPS65023_REG_CTRL_LDO1_EN	BIT(1)
 
+/* REG_CTRL2 bitfields */
+#define TPS65023_REG_CTRL2_GO		BIT(7)
+#define TPS65023_REG_CTRL2_CORE_ADJ	BIT(6)
+#define TPS65023_REG_CTRL2_DCDC2	BIT(2)
+#define TPS65023_REG_CTRL2_DCDC1	BIT(2)
+#define TPS65023_REG_CTRL2_DCDC3	BIT(0)
+
 /* LDO_CTRL bitfields */
 #define TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_id)	((ldo_id)*4)
 #define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0xF0 >> ((ldo_id)*4))
@@ -475,6 +482,10 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, tps);
 
+	/* Enable setting output voltage by I2C */
+	tps_65023_clear_bits(tps, TPS65023_REG_CON_CTRL2,
+						TPS65023_REG_CTRL2_CORE_ADJ);
+
 	return 0;
 
  fail:
-- 
1.7.4.1

