Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2FFAgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 20:36:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44482 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab2FFAgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 20:36:51 -0400
Message-ID: <1338942997.9940.1.camel@phoenix>
Subject: [PATCH RFT] regulator: pcap: Convert to regulator_list_voltage_table
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Ribeiro <drwyrm@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 06 Jun 2012 08:36:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcap-regulator.c |   95 ++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 53 deletions(-)

diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index 8211101..68777ac 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -18,80 +18,80 @@
 #include <linux/regulator/machine.h>
 #include <linux/mfd/ezx-pcap.h>
 
-static const u16 V1_table[] = {
-	2775, 1275, 1600, 1725, 1825, 1925, 2075, 2275,
+static const unsigned int V1_table[] = {
+	2775000, 1275000, 1600000, 1725000, 1825000, 1925000, 2075000, 2275000,
 };
 
-static const u16 V2_table[] = {
-	2500, 2775,
+static const unsigned int V2_table[] = {
+	2500000, 2775000,
 };
 
-static const u16 V3_table[] = {
-	1075, 1275, 1550, 1725, 1876, 1950, 2075, 2275,
+static const unsigned int V3_table[] = {
+	1075000, 1275000, 1550000, 1725000, 1876000, 1950000, 2075000, 2275000,
 };
 
-static const u16 V4_table[] = {
-	1275, 1550, 1725, 1875, 1950, 2075, 2275, 2775,
+static const unsigned int V4_table[] = {
+	1275000, 1550000, 1725000, 1875000, 1950000, 2075000, 2275000, 2775000,
 };
 
-static const u16 V5_table[] = {
-	1875, 2275, 2475, 2775,
+static const unsigned int V5_table[] = {
+	1875000, 2275000, 2475000, 2775000,
 };
 
-static const u16 V6_table[] = {
-	2475, 2775,
+static const unsigned int V6_table[] = {
+	2475000, 2775000,
 };
 
-static const u16 V7_table[] = {
-	1875, 2775,
+static const unsigned int V7_table[] = {
+	1875000, 2775000,
 };
 
 #define V8_table V4_table
 
-static const u16 V9_table[] = {
-	1575, 1875, 2475, 2775,
+static const unsigned int V9_table[] = {
+	1575000, 1875000, 2475000, 2775000,
 };
 
-static const u16 V10_table[] = {
-	5000,
+static const unsigned int V10_table[] = {
+	5000000,
 };
 
-static const u16 VAUX1_table[] = {
-	1875, 2475, 2775, 3000,
+static const unsigned int VAUX1_table[] = {
+	1875000, 2475000, 2775000, 3000000,
 };
 
 #define VAUX2_table VAUX1_table
 
-static const u16 VAUX3_table[] = {
-	1200, 1200, 1200, 1200, 1400, 1600, 1800, 2000,
-	2200, 2400, 2600, 2800, 3000, 3200, 3400, 3600,
+static const unsigned int VAUX3_table[] = {
+	1200000, 1200000, 1200000, 1200000, 1400000, 1600000, 1800000, 2000000,
+	2200000, 2400000, 2600000, 2800000, 3000000, 3200000, 3400000, 3600000,
 };
 
-static const u16 VAUX4_table[] = {
-	1800, 1800, 3000, 5000,
+static const unsigned int VAUX4_table[] = {
+	1800000, 1800000, 3000000, 5000000,
 };
 
-static const u16 VSIM_table[] = {
-	1875, 3000,
+static const unsigned int VSIM_table[] = {
+	1875000, 3000000,
 };
 
-static const u16 VSIM2_table[] = {
-	1875,
+static const unsigned int VSIM2_table[] = {
+	1875000,
 };
 
-static const u16 VVIB_table[] = {
-	1300, 1800, 2000, 3000,
+static const unsigned int VVIB_table[] = {
+	1300000, 1800000, 2000000, 3000000,
 };
 
-static const u16 SW1_table[] = {
-	900, 950, 1000, 1050, 1100, 1150, 1200, 1250,
-	1300, 1350, 1400, 1450, 1500, 1600, 1875, 2250,
+static const unsigned int SW1_table[] = {
+	 900000,  950000, 1000000, 1050000, 1100000, 1150000, 1200000, 1250000,
+	1300000, 1350000, 1400000, 1450000, 1500000, 1600000, 1875000, 2250000,
 };
 
 #define SW2_table SW1_table
 
-static const u16 SW3_table[] = {
-	4000, 4500, 5000, 5500,
+static const unsigned int SW3_table[] = {
+	4000000, 4500000, 5000000, 5500000,
 };
 
 struct pcap_regulator {
@@ -100,8 +100,6 @@ struct pcap_regulator {
 	const u8 index;
 	const u8 stby;
 	const u8 lowpwr;
-	const u8 n_voltages;
-	const u16 *voltage_table;
 };
 
 #define NA 0xff
@@ -113,8 +111,6 @@ struct pcap_regulator {
 		.index		= _index,				\
 		.stby		= _stby,				\
 		.lowpwr		= _lowpwr,				\
-		.n_voltages	= ARRAY_SIZE(_vreg##_table),		\
-		.voltage_table	= _vreg##_table,			\
 	}
 
 static struct pcap_regulator vreg_table[] = {
@@ -157,11 +153,11 @@ static int pcap_regulator_set_voltage_sel(struct regulator_dev *rdev,
 	void *pcap = rdev_get_drvdata(rdev);
 
 	/* the regulator doesn't support voltage switching */
-	if (vreg->n_voltages == 1)
+	if (rdev->desc->n_voltages == 1)
 		return -EINVAL;
 
 	return ezx_pcap_set_bits(pcap, vreg->reg,
-				 (vreg->n_voltages - 1) << vreg->index,
+				 (rdev->desc->n_voltages - 1) << vreg->index,
 				 selector << vreg->index);
 }
 
@@ -171,11 +167,11 @@ static int pcap_regulator_get_voltage_sel(struct regulator_dev *rdev)
 	void *pcap = rdev_get_drvdata(rdev);
 	u32 tmp;
 
-	if (vreg->n_voltages == 1)
+	if (rdev->desc->n_voltages == 1)
 		return 0;
 
 	ezx_pcap_read(pcap, vreg->reg, &tmp);
-	tmp = ((tmp >> vreg->index) & (vreg->n_voltages - 1));
+	tmp = ((tmp >> vreg->index) & (rdev->desc->n_voltages - 1));
 	return tmp;
 }
 
@@ -214,16 +210,8 @@ static int pcap_regulator_is_enabled(struct regulator_dev *rdev)
 	return (tmp >> vreg->en) & 1;
 }
 
-static int pcap_regulator_list_voltage(struct regulator_dev *rdev,
-							unsigned int index)
-{
-	struct pcap_regulator *vreg = &vreg_table[rdev_get_id(rdev)];
-
-	return vreg->voltage_table[index] * 1000;
-}
-
 static struct regulator_ops pcap_regulator_ops = {
-	.list_voltage	= pcap_regulator_list_voltage,
+	.list_voltage	= regulator_list_voltage_table,
 	.set_voltage_sel = pcap_regulator_set_voltage_sel,
 	.get_voltage_sel = pcap_regulator_get_voltage_sel,
 	.enable		= pcap_regulator_enable,
@@ -236,6 +224,7 @@ static struct regulator_ops pcap_regulator_ops = {
 		.name		= #_vreg,			\
 		.id		= _vreg,			\
 		.n_voltages	= ARRAY_SIZE(_vreg##_table),	\
+		.volt_table	= _vreg##_table,		\
 		.ops		= &pcap_regulator_ops,		\
 		.type		= REGULATOR_VOLTAGE,		\
 		.owner		= THIS_MODULE,			\
-- 
1.7.9.5



