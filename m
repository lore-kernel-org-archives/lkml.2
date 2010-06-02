Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab0FBGvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:51:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0FBGvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:51:33 -0400
From: Thomas Weber <weber@corscience.de>
Cc: Thomas Weber <weber@corscience.de>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Input: ads7846: Fix warning about output format
Date: Wed,  2 Jun 2010 08:50:29 +0200
Message-Id: <1275461429-4838-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
X-Provags-ID: V01U2FsdGVkX1/7hWnMjvw34VMb4ipqh4rPMGKOtl24PFKkaUK
 pyyF+XyAjpD7YmqlCSjrUeG/gB2K1Tu94v+iPNd9xa5pbB3Ztp
 sn5UaBxMB/wRBQhrvzRfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compiler warning about wrong output format.

drivers/input/touchscreen/ads7846.c: In function 'ads7846_probe':
drivers/input/touchscreen/ads7846.c:1167: warning: format '%ld' expects
type 'long int', but argument 4 has type 'int'

Introduced by commit 067fb2f648543894ce775082c5636f4c32b99e4f ("Input:
ads7846 - return error on regulator_get() failure").

The ERR_PTR returns a long so the variable err needs to be long.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/input/touchscreen/ads7846.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 634f6f6..9ba7d2e 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -885,7 +885,7 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 	struct spi_message		*m;
 	struct spi_transfer		*x;
 	int				vref;
-	int				err;
+	long				err;
 
 	if (!spi->irq) {
 		dev_dbg(&spi->dev, "no IRQ?\n");
@@ -1170,7 +1170,7 @@ static int __devinit ads7846_probe(struct spi_device *spi)
 
 	err = regulator_enable(ts->reg);
 	if (err) {
-		dev_err(&spi->dev, "unable to enable regulator: %d\n", err);
+		dev_err(&spi->dev, "unable to enable regulator: %ld\n", err);
 		goto err_put_regulator;
 	}
 
-- 
1.7.1

