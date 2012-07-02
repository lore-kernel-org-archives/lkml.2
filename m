Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2GBIDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:03:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42975 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2GBIDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:03:10 -0400
Message-ID: <1341216180.20054.1.camel@phoenix>
Subject: [PATCH] mfd: mc13xxx-spi: fix merge conflict
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Marc Reilly <marc@cpdesign.com.au>,
        Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Date: Mon, 02 Jul 2012 16:03:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes conflict between commit 8ae3559
"mfd: mc13xxx workaround SPI hardware bug on i.Mx"
and commit 10c7a5d "mfd: Use devm_* APIs for mc13xxx".

commit 8ae3559 changes regmap_init_spi to regmap_init.
So now we need to use devm_regmap_init rather than devm_regmap_init_spi.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/mc13xxx-spi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 234207f..3563626 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -139,7 +139,9 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 	mc13xxx->dev = &spi->dev;
 	mutex_init(&mc13xxx->lock);
 
-	mc13xxx->regmap = devm_regmap_init_spi(spi, &mc13xxx_regmap_spi_config);
+	mc13xxx->regmap = devm_regmap_init(&spi->dev, &regmap_mc13xxx_bus,
+					   &spi->dev,
+					   &mc13xxx_regmap_spi_config);
 	if (IS_ERR(mc13xxx->regmap)) {
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
-- 
1.7.9.5



