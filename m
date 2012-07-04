Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205Ab2GDFNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:13:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54675 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2GDFNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:13:20 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/25] leds: convert DAC124S085 LED driver to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:10:11 +0800
Message-Id: <1341378617-10386-20-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Guennadi Liakhovetski <lg@denx.de>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-dac124s085.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/leds/leds-dac124s085.c b/drivers/leds/leds-dac124s085.c
index d56c142..1f9d8e6 100644
--- a/drivers/leds/leds-dac124s085.c
+++ b/drivers/leds/leds-dac124s085.c
@@ -69,7 +69,7 @@ static int dac124s085_probe(struct spi_device *spi)
 	struct dac124s085_led	*led;
 	int i, ret;
 
-	dac = kzalloc(sizeof(*dac), GFP_KERNEL);
+	dac = devm_kzalloc(&spi->dev, sizeof(*dac), GFP_KERNEL);
 	if (!dac)
 		return -ENOMEM;
 
@@ -102,7 +102,6 @@ eledcr:
 		led_classdev_unregister(&dac->leds[i].ldev);
 
 	spi_set_drvdata(spi, NULL);
-	kfree(dac);
 	return ret;
 }
 
@@ -117,7 +116,6 @@ static int dac124s085_remove(struct spi_device *spi)
 	}
 
 	spi_set_drvdata(spi, NULL);
-	kfree(dac);
 
 	return 0;
 }
-- 
1.7.10.4

