Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab2CWIuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:50:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61401 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2CWIuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:50:46 -0400
Message-ID: <1332492640.27981.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: Convert pcap-regulator to get_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Daniel Ribeiro <drwyrm@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 23 Mar 2012 16:50:40 +0800
In-Reply-To: <1332492562.27981.1.camel@phoenix>
References: <1332492562.27981.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcap-regulator.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index b9666a2..781bf34 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -165,21 +165,18 @@ static int pcap_regulator_set_voltage_sel(struct regulator_dev *rdev,
 				 selector << vreg->index);
 }
 
-static int pcap_regulator_get_voltage(struct regulator_dev *rdev)
+static int pcap_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct pcap_regulator *vreg = &vreg_table[rdev_get_id(rdev)];
 	void *pcap = rdev_get_drvdata(rdev);
 	u32 tmp;
-	int mV;
 
 	if (vreg->n_voltages == 1)
-		return vreg->voltage_table[0] * 1000;
+		return 0;
 
 	ezx_pcap_read(pcap, vreg->reg, &tmp);
 	tmp = ((tmp >> vreg->index) & (vreg->n_voltages - 1));
-	mV = vreg->voltage_table[tmp];
-
-	return mV * 1000;
+	return tmp;
 }
 
 static int pcap_regulator_enable(struct regulator_dev *rdev)
@@ -228,7 +225,7 @@ static int pcap_regulator_list_voltage(struct regulator_dev *rdev,
 static struct regulator_ops pcap_regulator_ops = {
 	.list_voltage	= pcap_regulator_list_voltage,
 	.set_voltage_sel = pcap_regulator_set_voltage_sel,
-	.get_voltage	= pcap_regulator_get_voltage,
+	.get_voltage_sel = pcap_regulator_get_voltage_sel,
 	.enable		= pcap_regulator_enable,
 	.disable	= pcap_regulator_disable,
 	.is_enabled	= pcap_regulator_is_enabled,
-- 
1.7.5.4



