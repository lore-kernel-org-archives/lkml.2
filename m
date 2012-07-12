Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab2GLKN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:13:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41488 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab2GLKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:10 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/7] MFD: Fix mc13xxx SPI regmap
Date: Thu, 12 Jul 2012 11:57:47 +0200
Message-Id: <1342087073-3892-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Rétornaz <philippe.retornaz@epfl.ch>

This fix the SPI regmap configuration, the wrong write flag was used.
Also, bits_per_word should not be set as the regmap spi implementation
uses a 8bits transfert granularity.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Marc Reilly <marc@cpdesign.com.au>
Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Origin: next-20120712, commit:e4ecf6ea84d68aea5a9785e89f52672e1e126998
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13xxx-spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 3fcdab3..5d1969f 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -49,6 +49,7 @@ static struct regmap_config mc13xxx_regmap_spi_config = {
 	.reg_bits = 7,
 	.pad_bits = 1,
 	.val_bits = 24,
+	.write_flag_mask = 0x80,
 
 	.max_register = MC13XXX_NUMREGS,
 
@@ -73,7 +74,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 
 	dev_set_drvdata(&spi->dev, mc13xxx);
 	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-	spi->bits_per_word = 32;
 
 	mc13xxx->dev = &spi->dev;
 	mutex_init(&mc13xxx->lock);
-- 
1.7.10.4

