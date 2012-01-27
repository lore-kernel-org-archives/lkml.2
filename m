Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2A0PKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:10:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2A0PKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:10:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 2/3] regmap: Add support for 2/6 register formating
Date: Fri, 27 Jan 2012 16:10:22 +0100
Message-Id: <1327677023-29310-2-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
References: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/base/regmap/regmap.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 8bd0232..fb3c132 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -76,6 +76,14 @@ static bool regmap_volatile_range(struct regmap *map, unsigned int reg,
 	return true;
 }
 
+static void regmap_format_2_6_write(struct regmap *map,
+				     unsigned int reg, unsigned int val)
+{
+	u8 *out = map->work_buf;
+
+	*out = (reg << 6) | val;
+}
+
 static void regmap_format_4_12_write(struct regmap *map,
 				     unsigned int reg, unsigned int val)
 {
@@ -178,6 +186,16 @@ struct regmap *regmap_init(struct device *dev,
 	}
 
 	switch (config->reg_bits) {
+	case 2:
+		switch (config->val_bits) {
+		case 6:
+			map->format.format_write = regmap_format_2_6_write;
+			break;
+		default:
+			goto err_map;
+		}
+		break;
+
 	case 4:
 		switch (config->val_bits) {
 		case 12:
-- 
1.7.8.3

