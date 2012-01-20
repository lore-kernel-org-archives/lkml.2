Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2ATPMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:12:32 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:49643 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2ATPM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:12:28 -0500
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, Sangbeom Kim <sbkim73@samsung.com>
Subject: [PATCH 2/2] mfd: Add support for multiple s5m devices
Date: Fri, 20 Jan 2012 16:09:12 +0900
Message-Id: <1327043352-25037-2-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1327043352-25037-1-git-send-email-sbkim73@samsung.com>
References: <1327043352-25037-1-git-send-email-sbkim73@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many samsung mfd devices.
The s5m core driver try to support various samsung s5m series.
It will cover S5M8767A and S5M8763 and S5M8751.
This patch is enable to support various s5m series.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/s5m-core.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/s5m-core.c b/drivers/mfd/s5m-core.c
index 38bd353..7daef55 100644
--- a/drivers/mfd/s5m-core.c
+++ b/drivers/mfd/s5m-core.c
@@ -26,7 +26,27 @@
 #include <linux/mfd/s5m87xx/s5m-rtc.h>
 #include <linux/regmap.h>
 
-static struct mfd_cell s5m87xx_devs[] = {
+static struct mfd_cell s5m8751_devs[] = {
+	{
+		.name = "s5m8751-pmic",
+	}, {
+		.name = "s5m-charger",
+	}, {
+		.name = "s5m8751-codec",
+	},
+};
+
+static struct mfd_cell s5m8763_devs[] = {
+	{
+		.name = "s5m8763-pmic",
+	}, {
+		.name = "s5m-rtc",
+	}, {
+		.name = "s5m-charger",
+	},
+};
+
+static struct mfd_cell s5m8767_devs[] = {
 	{
 		.name = "s5m8767-pmic",
 	}, {
@@ -113,9 +133,23 @@ static int s5m87xx_i2c_probe(struct i2c_client *i2c,
 
 	pm_runtime_set_active(s5m87xx->dev);
 
-	ret = mfd_add_devices(s5m87xx->dev, -1,
-				s5m87xx_devs, ARRAY_SIZE(s5m87xx_devs),
-				NULL, 0);
+	switch (s5m87xx->device_type) {
+	case S5M8751X:
+		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8751_devs,
+					ARRAY_SIZE(s5m8751_devs), NULL, 0);
+		break;
+	case S5M8763X:
+		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8763_devs,
+					ARRAY_SIZE(s5m8763_devs), NULL, 0);
+		break;
+	case S5M8767X:
+		ret = mfd_add_devices(s5m87xx->dev, -1, s5m8767_devs,
+					ARRAY_SIZE(s5m8767_devs), NULL, 0);
+		break;
+	default:
+		/* If this happens the probe function is problem */
+		BUG();
+	}
 
 	if (ret < 0)
 		goto err;
-- 
1.7.1

