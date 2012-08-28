Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2H1LKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:10:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59423 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2H1LKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:10:12 -0400
From: =?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>
To: linux-arm-kernel@lists.infradead.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        =?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>
Subject: [PATCH] MFD : MC13783 : add regulators sw1x and sw2x
Date: Tue, 28 Aug 2012 13:09:10 +0200
Message-Id: <1346152150-21669-1-git-send-email-gcembed@gmail.com>
X-Mailer: git-send-email 1.7.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gaëtan Carlier <gcembed@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |   66 +++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 4977b19..0801a6d 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -21,6 +21,30 @@
 #include <linux/module.h>
 #include "mc13xxx.h"
 
+#define MC13783_REG_SWITCHERS0			24
+/* Enable does not exist for SW1A */
+#define MC13783_REG_SWITCHERS0_SW1AEN			0
+#define MC13783_REG_SWITCHERS0_SW1AVSEL			0
+#define MC13783_REG_SWITCHERS0_SW1AVSEL_M		(63 << 0)
+
+#define MC13783_REG_SWITCHERS1			25
+/* Enable does not exist for SW1B */
+#define MC13783_REG_SWITCHERS1_SW1BEN			0
+#define MC13783_REG_SWITCHERS1_SW1BVSEL			0
+#define MC13783_REG_SWITCHERS1_SW1BVSEL_M		(63 << 0)
+
+#define MC13783_REG_SWITCHERS2			26
+/* Enable does not exist for SW2A */
+#define MC13783_REG_SWITCHERS2_SW2AEN			0
+#define MC13783_REG_SWITCHERS2_SW2AVSEL			0
+#define MC13783_REG_SWITCHERS2_SW2AVSEL_M		(63 << 0)
+
+#define MC13783_REG_SWITCHERS3			27
+/* Enable does not exist for SW2B */
+#define MC13783_REG_SWITCHERS3_SW2BEN			0
+#define MC13783_REG_SWITCHERS3_SW2BVSEL			0
+#define MC13783_REG_SWITCHERS3_SW2BVSEL_M		(63 << 0)
+
 #define MC13783_REG_SWITCHERS5			29
 #define MC13783_REG_SWITCHERS5_SW3EN			(1 << 20)
 #define MC13783_REG_SWITCHERS5_SW3VSEL			18
@@ -93,6 +117,44 @@
 
 
 /* Voltage Values */
+static const int mc13783_sw1x_val[] = {
+	900000, 925000, 950000, 975000,
+	1000000, 1025000, 1050000, 1075000,
+	1100000, 1125000, 1150000, 1175000,
+	1200000, 1225000, 1250000, 1275000,
+	1300000, 1325000, 1350000, 1375000,
+	1400000, 1425000, 1450000, 1475000,
+	1500000, 1525000, 1550000, 1575000,
+	1600000, 1625000, 1650000, 1675000,
+	1700000, 1700000, 1700000, 1700000,
+	1800000, 1800000, 1800000, 1800000,
+	1850000, 1850000, 1850000, 1850000,
+	2000000, 2000000, 2000000, 2000000,
+	2100000, 2100000, 2100000, 2100000,
+	2200000, 2200000, 2200000, 2200000,
+	2200000, 2200000, 2200000, 2200000,
+	2200000, 2200000, 2200000, 2200000,
+};
+
+static const int mc13783_sw2x_val[] = {
+	900000, 925000, 950000, 975000,
+	1000000, 1025000, 1050000, 1075000,
+	1100000, 1125000, 1150000, 1175000,
+	1200000, 1225000, 1250000, 1275000,
+	1300000, 1325000, 1350000, 1375000,
+	1400000, 1425000, 1450000, 1475000,
+	1500000, 1525000, 1550000, 1575000,
+	1600000, 1625000, 1650000, 1675000,
+	1700000, 1700000, 1700000, 1700000,
+	1800000, 1800000, 1800000, 1800000,
+	1900000, 1900000, 1900000, 1900000,
+	2000000, 2000000, 2000000, 2000000,
+	2100000, 2100000, 2100000, 2100000,
+	2200000, 2200000, 2200000, 2200000,
+	2200000, 2200000, 2200000, 2200000,
+	2200000, 2200000, 2200000, 2200000,
+};
+
 static const unsigned int mc13783_sw3_val[] = {
 	5000000, 5000000, 5000000, 5500000,
 };
@@ -188,6 +250,10 @@ static struct regulator_ops mc13783_gpo_regulator_ops;
 	MC13783_DEFINE(REG, _name, _reg, _vsel_reg, _voltages)
 
 static struct mc13xxx_regulator mc13783_regulators[] = {
+	MC13783_DEFINE_SW(SW1A, SWITCHERS0, SWITCHERS0, mc13783_sw1x_val),
+	MC13783_DEFINE_SW(SW1B, SWITCHERS1, SWITCHERS1, mc13783_sw1x_val),
+	MC13783_DEFINE_SW(SW2A, SWITCHERS2, SWITCHERS2, mc13783_sw2x_val),
+	MC13783_DEFINE_SW(SW2B, SWITCHERS3, SWITCHERS3, mc13783_sw2x_val),
 	MC13783_DEFINE_SW(SW3, SWITCHERS5, SWITCHERS5, mc13783_sw3_val),
 
 	MC13783_FIXED_DEFINE(REG, VAUDIO, REGULATORMODE0, mc13783_vaudio_val),
-- 
1.7.7.4

