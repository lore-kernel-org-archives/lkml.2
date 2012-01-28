Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2A1BQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 20:16:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47927 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab2A1BQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 20:16:49 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH] regmap: Properly round reg_bytes and val_bytes
Date: Sat, 28 Jan 2012 02:16:41 +0100
Message-Id: <1327713401-16236-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
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

rebased to topic/core

 drivers/base/regmap/regmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index b4475d8..3c34526 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -167,9 +167,9 @@ struct regmap *regmap_init(struct device *dev,
 
 	mutex_init(&map->lock);
 	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
-	map->format.reg_bytes = config->reg_bits / 8;
+	map->format.reg_bytes = DIV_ROUND_UP(config->reg_bits, 8);
 	map->format.pad_bytes = config->pad_bits / 8;
-	map->format.val_bytes = config->val_bits / 8;
+	map->format.val_bytes = DIV_ROUND_UP(config->val_bits, 8);
 	map->format.buf_size += map->format.pad_bytes;
 	map->dev = dev;
 	map->bus = bus;
-- 
1.7.2.5

