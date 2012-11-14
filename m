Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2KNFyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:54:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58043 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab2KNFyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:54:47 -0500
From: AnilKumar Ch <anilkumar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH RESEND] regulator: tps65910: fix BUG_ON() shown with vrtc regulator
Date: Wed, 14 Nov 2012 11:24:39 +0530
Message-ID: <1352872479-25462-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix BUG_ON() error if tps65910 VRTC regulator is used with out
rdev->desc->volt_table data. Recent changes in regulator core driver
which add support for "regulator_list_voltage_table" have BUG_ON() if
regulator descriptor do not have voltage table information. This patch
adds the voltage table information to fix the issue.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 drivers/regulator/tps65910-regulator.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 793adda..1d2dd18 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -38,6 +38,11 @@ static const unsigned int VIO_VSEL_table[] = {
 
 /* VSEL tables for TPS65910 specific LDOs and dcdc's */
 
+/* supported VRTC voltages in microvolts */
+static const unsigned int VRTC_VSEL_table[] = {
+	1800000,
+};
+
 /* supported VDD3 voltages in microvolts */
 static const unsigned int VDD3_VSEL_table[] = {
 	5000000,
@@ -95,6 +100,8 @@ static struct tps_info tps65910_regs[] = {
 	{
 		.name = "vrtc",
 		.vin_name = "vcc7",
+		.n_voltages = ARRAY_SIZE(VRTC_VSEL_table),
+		.voltage_table = VRTC_VSEL_table,
 		.enable_time_us = 2200,
 	},
 	{
-- 
1.7.9.5

