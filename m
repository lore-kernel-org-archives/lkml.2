Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2CXC6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 22:58:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46909 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab2CXC57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 22:57:59 -0400
Message-ID: <1332557873.10528.2.camel@phoenix>
Subject: [PATCH 2/2] regulator: Remove _en_reg, _en_bit and _ops parameters
 from tps65090_REG macro
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 24 Mar 2012 10:57:53 +0800
In-Reply-To: <1332557760.10528.0.camel@phoenix>
References: <1332557760.10528.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both _en_bit and _ops parameters for all DCDCs and FETs are the same, so we
can hardcode it in tps65090_REG macro.

_en_reg can be calculated by _id + 12, so we can also remove it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65090-regulator.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 470ca7e..7baff2e 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -94,31 +94,31 @@ static struct regulator_ops tps65090_ops = {
 	.is_enabled	= tps65090_reg_is_enabled,
 };
 
-#define tps65090_REG(_id, _en_reg, _en_bit, _ops)	\
+#define tps65090_REG(_id)				\
 {							\
-	.reg_en_reg	= _en_reg,			\
-	.en_bit		= _en_bit,			\
+	.reg_en_reg	= (TPS65090_ID_##_id) + 12,	\
+	.en_bit		= 0,				\
 	.id		= TPS65090_ID_##_id,		\
 	.desc = {					\
 		.name = tps65090_rails(_id),		\
 		.id = TPS65090_ID_##_id,		\
-		.ops = &_ops,				\
+		.ops = &tps65090_ops,			\
 		.type = REGULATOR_VOLTAGE,		\
 		.owner = THIS_MODULE,			\
 	},						\
 }
 
 static struct tps65090_regulator TPS65090_regulator[] = {
-	tps65090_REG(DCDC1, 12, 0, tps65090_ops),
-	tps65090_REG(DCDC2, 13, 0, tps65090_ops),
-	tps65090_REG(DCDC3, 14, 0, tps65090_ops),
-	tps65090_REG(FET1,  15, 0, tps65090_ops),
-	tps65090_REG(FET2,  16, 0, tps65090_ops),
-	tps65090_REG(FET3,  17, 0, tps65090_ops),
-	tps65090_REG(FET4,  18, 0, tps65090_ops),
-	tps65090_REG(FET5,  19, 0, tps65090_ops),
-	tps65090_REG(FET6,  20, 0, tps65090_ops),
-	tps65090_REG(FET7,  21, 0, tps65090_ops),
+	tps65090_REG(DCDC1),
+	tps65090_REG(DCDC2),
+	tps65090_REG(DCDC3),
+	tps65090_REG(FET1),
+	tps65090_REG(FET2),
+	tps65090_REG(FET3),
+	tps65090_REG(FET4),
+	tps65090_REG(FET5),
+	tps65090_REG(FET6),
+	tps65090_REG(FET7),
 };
 
 static inline struct tps65090_regulator *find_regulator_info(int id)
-- 
1.7.5.4



