Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2FIFg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 01:36:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45097 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab2FIFfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 01:35:48 -0400
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        u.kleine-koenig@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] mfd: mc13xxx-spi: Convert to devm_regmap_init_spi()
Date: Sat,  9 Jun 2012 02:35:31 -0300
Message-Id: <1339220131-24189-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339220131-24189-1-git-send-email-festevam@gmail.com>
References: <1339220131-24189-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Current code misses a "regmap_exit(mc13xxx->regmap)" in the error and remove paths.

Converting to devm_regmap_init_i2c() makes the regmap_exit unnecessary.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/mc13xxx-spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 3fcdab3..62e537b 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -78,7 +78,7 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 	mc13xxx->dev = &spi->dev;
 	mutex_init(&mc13xxx->lock);
 
-	mc13xxx->regmap = regmap_init_spi(spi, &mc13xxx_regmap_spi_config);
+	mc13xxx->regmap = devm_regmap_init_spi(spi, &mc13xxx_regmap_spi_config);
 	if (IS_ERR(mc13xxx->regmap)) {
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
-- 
1.7.1

