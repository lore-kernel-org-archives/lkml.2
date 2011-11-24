Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1KXDGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:06:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58337 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1KXDGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:06:32 -0500
Message-ID: <1322103983.16201.7.camel@phoenix>
Subject: [PATCH] ARM: add subname parameter to mfp_set_groupg callers
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 24 Nov 2011 11:06:23 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 798681bf "ARM: 7158/1: add new MFP implement for NUC900"
adds subname parameter for mfp_set_groupg.

Thus add subname parameter to the callers.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
commit 798681bf is in Russell King's tree,
I think this patch should route via Russell's tree.
This patch is against linux-next 20111123.

Axel
 drivers/i2c/busses/i2c-nuc900.c |    2 +-
 drivers/spi/spi-nuc900.c        |    2 +-
 sound/soc/nuc900/nuc900-ac97.c  |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nuc900.c b/drivers/i2c/busses/i2c-nuc900.c
index 835e47b..03b6157 100644
--- a/drivers/i2c/busses/i2c-nuc900.c
+++ b/drivers/i2c/busses/i2c-nuc900.c
@@ -593,7 +593,7 @@ static int __devinit nuc900_i2c_probe(struct platform_device *pdev)
 	i2c->adap.algo_data = i2c;
 	i2c->adap.dev.parent = &pdev->dev;
 
-	mfp_set_groupg(&pdev->dev);
+	mfp_set_groupg(&pdev->dev, NULL);
 
 	clk_get_rate(i2c->clk);
 
diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index e763254..21c70b2 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -426,7 +426,7 @@ static int __devinit nuc900_spi_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	mfp_set_groupg(&pdev->dev);
+	mfp_set_groupg(&pdev->dev, NULL);
 	nuc900_init_spi(hw);
 
 	err = spi_bitbang_start(&hw->bitbang);
diff --git a/sound/soc/nuc900/nuc900-ac97.c b/sound/soc/nuc900/nuc900-ac97.c
index d9343ee..dbf597f 100644
--- a/sound/soc/nuc900/nuc900-ac97.c
+++ b/sound/soc/nuc900/nuc900-ac97.c
@@ -365,7 +365,8 @@ static int __devinit nuc900_ac97_drvprobe(struct platform_device *pdev)
 	if (ret)
 		goto out3;
 
-	mfp_set_groupg(nuc900_audio->dev); /* enbale ac97 multifunction pin*/
+	/* enbale ac97 multifunction pin */
+	mfp_set_groupg(nuc900_audio->dev, "nuc900-audio");
 
 	return 0;
 
-- 
1.7.5.4



