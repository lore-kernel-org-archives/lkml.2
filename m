Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2DJGIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:08:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54023 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2DJGIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:08:24 -0400
Message-ID: <1334038099.15859.11.camel@phoenix>
Subject: [PATCH RESEND 3/3] regulator: Replace regulator_desc_[ldo|buck] by
 s5m8767_regulator_desc macro
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 14:08:19 +0800
In-Reply-To: <1334037944.15859.8.camel@phoenix>
References: <1334037944.15859.8.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |   89 ++++++++++++++++++++-----------------------
 1 files changed, 41 insertions(+), 48 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 8872ee0..b877df1 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -415,59 +415,52 @@ static struct regulator_ops s5m8767_ops = {
 	.set_voltage_time_sel	= s5m8767_set_voltage_time_sel,
 };
 
-#define regulator_desc_ldo(num)		{	\
-	.name		= "LDO"#num,		\
-	.id		= S5M8767_LDO##num,	\
-	.ops		= &s5m8767_ops,	\
-	.type		= REGULATOR_VOLTAGE,	\
-	.owner		= THIS_MODULE,		\
-}
-#define regulator_desc_buck(num)	{	\
-	.name		= "BUCK"#num,		\
-	.id		= S5M8767_BUCK##num,	\
-	.ops		= &s5m8767_ops,	\
+#define s5m8767_regulator_desc(_name) {		\
+	.name		= #_name,		\
+	.id		= S5M8767_##_name,	\
+	.ops		= &s5m8767_ops,		\
 	.type		= REGULATOR_VOLTAGE,	\
 	.owner		= THIS_MODULE,		\
 }
 
 static struct regulator_desc regulators[] = {
-	regulator_desc_ldo(1),
-	regulator_desc_ldo(2),
-	regulator_desc_ldo(3),
-	regulator_desc_ldo(4),
-	regulator_desc_ldo(5),
-	regulator_desc_ldo(6),
-	regulator_desc_ldo(7),
-	regulator_desc_ldo(8),
-	regulator_desc_ldo(9),
-	regulator_desc_ldo(10),
-	regulator_desc_ldo(11),
-	regulator_desc_ldo(12),
-	regulator_desc_ldo(13),
-	regulator_desc_ldo(14),
-	regulator_desc_ldo(15),
-	regulator_desc_ldo(16),
-	regulator_desc_ldo(17),
-	regulator_desc_ldo(18),
-	regulator_desc_ldo(19),
-	regulator_desc_ldo(20),
-	regulator_desc_ldo(21),
-	regulator_desc_ldo(22),
-	regulator_desc_ldo(23),
-	regulator_desc_ldo(24),
-	regulator_desc_ldo(25),
-	regulator_desc_ldo(26),
-	regulator_desc_ldo(27),
-	regulator_desc_ldo(28),
-	regulator_desc_buck(1),
-	regulator_desc_buck(2),
-	regulator_desc_buck(3),
-	regulator_desc_buck(4),
-	regulator_desc_buck(5),
-	regulator_desc_buck(6),
-	regulator_desc_buck(7),
-	regulator_desc_buck(8),
-	regulator_desc_buck(9),
+	s5m8767_regulator_desc(LDO1),
+	s5m8767_regulator_desc(LDO2),
+	s5m8767_regulator_desc(LDO3),
+	s5m8767_regulator_desc(LDO4),
+	s5m8767_regulator_desc(LDO5),
+	s5m8767_regulator_desc(LDO6),
+	s5m8767_regulator_desc(LDO7),
+	s5m8767_regulator_desc(LDO8),
+	s5m8767_regulator_desc(LDO9),
+	s5m8767_regulator_desc(LDO10),
+	s5m8767_regulator_desc(LDO11),
+	s5m8767_regulator_desc(LDO12),
+	s5m8767_regulator_desc(LDO13),
+	s5m8767_regulator_desc(LDO14),
+	s5m8767_regulator_desc(LDO15),
+	s5m8767_regulator_desc(LDO16),
+	s5m8767_regulator_desc(LDO17),
+	s5m8767_regulator_desc(LDO18),
+	s5m8767_regulator_desc(LDO19),
+	s5m8767_regulator_desc(LDO20),
+	s5m8767_regulator_desc(LDO21),
+	s5m8767_regulator_desc(LDO22),
+	s5m8767_regulator_desc(LDO23),
+	s5m8767_regulator_desc(LDO24),
+	s5m8767_regulator_desc(LDO25),
+	s5m8767_regulator_desc(LDO26),
+	s5m8767_regulator_desc(LDO27),
+	s5m8767_regulator_desc(LDO28),
+	s5m8767_regulator_desc(BUCK1),
+	s5m8767_regulator_desc(BUCK2),
+	s5m8767_regulator_desc(BUCK3),
+	s5m8767_regulator_desc(BUCK4),
+	s5m8767_regulator_desc(BUCK5),
+	s5m8767_regulator_desc(BUCK6),
+	s5m8767_regulator_desc(BUCK7),
+	s5m8767_regulator_desc(BUCK8),
+	s5m8767_regulator_desc(BUCK9),
 };
 
 static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
-- 
1.7.5.4



