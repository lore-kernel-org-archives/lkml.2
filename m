Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2DMEm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 00:42:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53258 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab2DMEm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 00:42:56 -0400
Message-ID: <1334292171.6122.2.camel@phoenix>
Subject: [PATCH RFT 2/3] regulator: wm831x-dcdc: Add dummy
 set_suspend_[enable|disable] callbacks implementation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 13 Apr 2012 12:42:51 +0800
In-Reply-To: <1334292098.6122.1.camel@phoenix>
References: <1334292098.6122.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the implementation of set_suspend_enable and set_suspend_disable callbacks,
the regulator core won't call set_suspend_voltage and set_suspend_mode.

Thus add dummy implementation for set_suspend_[enable|disable] callbacks.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-dcdc.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index f0da23c..c9e52a8 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -406,11 +406,21 @@ static int wm831x_buckv_get_current_limit(struct regulator_dev *rdev)
 	return wm831x_dcdc_ilim[val];
 }
 
+/* Dummy set_suspend_enable/set_suspend_disable callbacks implementation */
+static int wm831x_buckv_set_suspend_enable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
+static int wm831x_buckv_set_suspend_disable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
 static struct regulator_ops wm831x_buckv_ops = {
 	.set_voltage = wm831x_buckv_set_voltage,
 	.get_voltage_sel = wm831x_buckv_get_voltage_sel,
 	.list_voltage = wm831x_buckv_list_voltage,
-	.set_suspend_voltage = wm831x_buckv_set_suspend_voltage,
 	.set_current_limit = wm831x_buckv_set_current_limit,
 	.get_current_limit = wm831x_buckv_get_current_limit,
 
@@ -420,6 +430,10 @@ static struct regulator_ops wm831x_buckv_ops = {
 	.get_status = wm831x_dcdc_get_status,
 	.get_mode = wm831x_dcdc_get_mode,
 	.set_mode = wm831x_dcdc_set_mode,
+
+	.set_suspend_enable = wm831x_buckv_set_suspend_enable,
+	.set_suspend_disable = wm831x_buckv_set_suspend_disable,
+	.set_suspend_voltage = wm831x_buckv_set_suspend_voltage,
 	.set_suspend_mode = wm831x_dcdc_set_suspend_mode,
 };
 
-- 
1.7.5.4



