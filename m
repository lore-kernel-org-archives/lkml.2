Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2A0PKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:10:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50480 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab2A0PKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:10:35 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 1/3] regmap: Properly round reg_bytes and val_bytes
Date: Fri, 27 Jan 2012 16:10:21 +0100
Message-Id: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.8.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the upcoming 2/6-format, we don't see debugfs output otherwise,
since the current division results in 0. I'd think 10/14 is broken
currently, too.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/base/regmap/regmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6555803..8bd0232 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -159,8 +159,8 @@ struct regmap *regmap_init(struct device *dev,
 
 	mutex_init(&map->lock);
 	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
-	map->format.reg_bytes = config->reg_bits / 8;
-	map->format.val_bytes = config->val_bits / 8;
+	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
+	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
 	map->dev = dev;
 	map->bus = bus;
 	map->max_register = config->max_register;
-- 
1.7.8.3

