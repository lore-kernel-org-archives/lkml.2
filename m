Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab2JOMQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:16:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57205 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab2JOMQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:16:43 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH] regulator: tps65910: fix BUG_ON() shown with vrtc regulator
Date: Mon, 15 Oct 2012 17:45:58 +0530
Message-ID: <1350303358-13667-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix BUG_ON() error if tps65910 VRTC regulator is used with out
rdev->desc->volt_table data. Recent changes in regulator core driver
which add support for "regulator_list_voltage_table" have BUG_ON() if
regulator descriptor do not voltage table information. This patch adds
the voltage table information to fix the issue.

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

