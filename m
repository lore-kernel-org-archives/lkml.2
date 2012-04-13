Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab2DMElr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 00:41:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60406 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab2DMElq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 00:41:46 -0400
Message-ID: <1334292098.6122.1.camel@phoenix>
Subject: [PATCH RFT 1/3] regulator: ab3100: Add dummy
 set_suspend_[enable|disable] callbacks implementation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 13 Apr 2012 12:41:38 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the implementation of set_suspend_enable and set_suspend_disable callbacks,
the regulator core won't call set_suspend_voltage.

Thus add dummy implementation for set_suspend_[enable|disable] callbacks.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index ce61925..b08d92b 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -367,6 +367,17 @@ static int ab3100_set_voltage_regulator_sel(struct regulator_dev *reg,
 	return err;
 }
 
+/* Dummy set_suspend_enable/set_suspend_disable callbacks implementation */
+static int ab3100_set_suspend_enable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
+static int ab3100_set_suspend_disable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
 static int ab3100_set_suspend_voltage_regulator(struct regulator_dev *reg,
 						int uV)
 {
@@ -467,9 +478,12 @@ static struct regulator_ops regulator_ops_variable_sleepable = {
 	.is_enabled  = ab3100_is_enabled_regulator,
 	.get_voltage = ab3100_get_voltage_regulator,
 	.set_voltage_sel = ab3100_set_voltage_regulator_sel,
-	.set_suspend_voltage = ab3100_set_suspend_voltage_regulator,
 	.list_voltage = ab3100_list_voltage_regulator,
 	.enable_time = ab3100_enable_time_regulator,
+
+	.set_suspend_enable = ab3100_set_suspend_enable,
+	.set_suspend_disable = ab3100_set_suspend_disable,
+	.set_suspend_voltage = ab3100_set_suspend_voltage_regulator,
 };
 
 /*
-- 
1.7.5.4



