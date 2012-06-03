Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2FCURh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 16:17:37 -0400
Received: from mail.serverraum.org ([78.47.150.89]:41187 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2FCURg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 16:17:36 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2012 16:17:35 EDT
From: Michael Walle <michael@walle.cc>
To: linux-arm-kernel@lists.infradead.org
Cc: Michael Walle <michael@walle.cc>,
        spi-devel-general@lists.sourceforge.net (open list:SPI SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] spi-orion: remove uneeded spi_info
Date: Sun,  3 Jun 2012 22:10:14 +0200
Message-Id: <1338754215-16022-1-git-send-email-michael@walle.cc>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was formerly used to store the tclk value. Remove it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/spi/spi-orion.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index dfd04e9..2760450 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -45,7 +45,6 @@ struct orion_spi {
 	void __iomem		*base;
 	unsigned int		max_speed;
 	unsigned int		min_speed;
-	struct orion_spi_info	*spi_info;
 	struct clk              *clk;
 };
 
@@ -450,12 +449,9 @@ static int __init orion_spi_probe(struct platform_device *pdev)
 	struct spi_master *master;
 	struct orion_spi *spi;
 	struct resource *r;
-	struct orion_spi_info *spi_info;
 	unsigned long tclk_hz;
 	int status = 0;
 
-	spi_info = pdev->dev.platform_data;
-
 	master = spi_alloc_master(&pdev->dev, sizeof *spi);
 	if (master == NULL) {
 		dev_dbg(&pdev->dev, "master allocation failed\n");
@@ -476,7 +472,6 @@ static int __init orion_spi_probe(struct platform_device *pdev)
 
 	spi = spi_master_get_devdata(master);
 	spi->master = master;
-	spi->spi_info = spi_info;
 
 	spi->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(spi->clk)) {
-- 
1.7.2.5

