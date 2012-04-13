Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2DMEn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 00:43:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60665 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2DMEn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 00:43:57 -0400
Message-ID: <1334292232.6122.3.camel@phoenix>
Subject: [PATCH RFT 3/3] regulator: wm831x-ldo: Add dummy
 set_suspend_[enable|disable] callbacks implementation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 13 Apr 2012 12:43:52 +0800
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
the regulator core won't call set_suspend_voltage.

Thus add dummy implementation for set_suspend_[enable|disable] callbacks.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm831x-ldo.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 5f01040..f777f9b 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -291,11 +291,21 @@ static unsigned int wm831x_gp_ldo_get_optimum_mode(struct regulator_dev *rdev,
 }
 
 
+/* Dummy set_suspend_enable/set_suspend_disable callbacks implementation */
+static int wm831x_gp_ldo_set_suspend_enable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
+static int wm831x_gp_ldo_set_suspend_disable(struct regulator_dev *rdev)
+{
+	return 0;
+}
+
 static struct regulator_ops wm831x_gp_ldo_ops = {
 	.list_voltage = wm831x_gp_ldo_list_voltage,
 	.get_voltage_sel = wm831x_gp_ldo_get_voltage_sel,
 	.set_voltage = wm831x_gp_ldo_set_voltage,
-	.set_suspend_voltage = wm831x_gp_ldo_set_suspend_voltage,
 	.get_mode = wm831x_gp_ldo_get_mode,
 	.set_mode = wm831x_gp_ldo_set_mode,
 	.get_status = wm831x_gp_ldo_get_status,
@@ -304,6 +314,10 @@ static struct regulator_ops wm831x_gp_ldo_ops = {
 	.is_enabled = wm831x_ldo_is_enabled,
 	.enable = wm831x_ldo_enable,
 	.disable = wm831x_ldo_disable,
+
+	.set_suspend_enable = wm831x_gp_ldo_set_suspend_enable,
+	.set_suspend_disable = wm831x_gp_ldo_set_suspend_disable,
+	.set_suspend_voltage = wm831x_gp_ldo_set_suspend_voltage,
 };
 
 static __devinit int wm831x_gp_ldo_probe(struct platform_device *pdev)
-- 
1.7.5.4



