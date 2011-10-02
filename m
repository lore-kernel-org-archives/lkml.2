Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432Ab1JBDUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 23:20:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35305 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1JBDU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 23:20:26 -0400
Subject: [PATCH] ASoC: samsung: Add __devexit_p at necessary places
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaswinder Singh <jassi.brar@samsung.com>, Ben Dooks <ben@simtec.co.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 11:20:13 +0800
Message-ID: <1317525613.2990.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comments in include/linux/init.h:

"Pointers to __devexit functions must use __devexit_p(function_name), the
wrapper will insert either the function_name or NULL, depending on the confi
options."

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Jaswinder Singh <jassi.brar@samsung.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Seungwhan Youn <sw.youn@samsung.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
---
 sound/soc/samsung/ac97.c        |    2 +-
 sound/soc/samsung/i2s.c         |    2 +-
 sound/soc/samsung/pcm.c         |    2 +-
 sound/soc/samsung/s3c2412-i2s.c |    2 +-
 sound/soc/samsung/s3c24xx-i2s.c |    2 +-
 sound/soc/samsung/spdif.c       |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
index bc4e234..16521e3 100644
--- a/sound/soc/samsung/ac97.c
+++ b/sound/soc/samsung/ac97.c
@@ -502,7 +502,7 @@ static __devexit int s3c_ac97_remove(struct platform_device *pdev)
 
 static struct platform_driver s3c_ac97_driver = {
 	.probe  = s3c_ac97_probe,
-	.remove = s3c_ac97_remove,
+	.remove = __devexit_p(s3c_ac97_remove),
 	.driver = {
 		.name = "samsung-ac97",
 		.owner = THIS_MODULE,
diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 79d4bce..bff42bf 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1137,7 +1137,7 @@ static __devexit int samsung_i2s_remove(struct platform_device *pdev)
 
 static struct platform_driver samsung_i2s_driver = {
 	.probe  = samsung_i2s_probe,
-	.remove = samsung_i2s_remove,
+	.remove = __devexit_p(samsung_i2s_remove),
 	.driver = {
 		.name = "samsung-i2s",
 		.owner = THIS_MODULE,
diff --git a/sound/soc/samsung/pcm.c b/sound/soc/samsung/pcm.c
index 4c191f0..05a47cf 100644
--- a/sound/soc/samsung/pcm.c
+++ b/sound/soc/samsung/pcm.c
@@ -625,7 +625,7 @@ static __devexit int s3c_pcm_dev_remove(struct platform_device *pdev)
 
 static struct platform_driver s3c_pcm_driver = {
 	.probe  = s3c_pcm_dev_probe,
-	.remove = s3c_pcm_dev_remove,
+	.remove = __devexit_p(s3c_pcm_dev_remove),
 	.driver = {
 		.name = "samsung-pcm",
 		.owner = THIS_MODULE,
diff --git a/sound/soc/samsung/s3c2412-i2s.c b/sound/soc/samsung/s3c2412-i2s.c
index f01d4c4..7bbec25 100644
--- a/sound/soc/samsung/s3c2412-i2s.c
+++ b/sound/soc/samsung/s3c2412-i2s.c
@@ -177,7 +177,7 @@ static __devexit int s3c2412_iis_dev_remove(struct platform_device *pdev)
 
 static struct platform_driver s3c2412_iis_driver = {
 	.probe  = s3c2412_iis_dev_probe,
-	.remove = s3c2412_iis_dev_remove,
+	.remove = __devexit_p(s3c2412_iis_dev_remove),
 	.driver = {
 		.name = "s3c2412-iis",
 		.owner = THIS_MODULE,
diff --git a/sound/soc/samsung/s3c24xx-i2s.c b/sound/soc/samsung/s3c24xx-i2s.c
index c5a30d0..558c64b 100644
--- a/sound/soc/samsung/s3c24xx-i2s.c
+++ b/sound/soc/samsung/s3c24xx-i2s.c
@@ -482,7 +482,7 @@ static __devexit int s3c24xx_iis_dev_remove(struct platform_device *pdev)
 
 static struct platform_driver s3c24xx_iis_driver = {
 	.probe  = s3c24xx_iis_dev_probe,
-	.remove = s3c24xx_iis_dev_remove,
+	.remove = __devexit_p(s3c24xx_iis_dev_remove),
 	.driver = {
 		.name = "s3c24xx-iis",
 		.owner = THIS_MODULE,
diff --git a/sound/soc/samsung/spdif.c b/sound/soc/samsung/spdif.c
index 7ca5bdc..965b2bd 100644
--- a/sound/soc/samsung/spdif.c
+++ b/sound/soc/samsung/spdif.c
@@ -476,7 +476,7 @@ static __devexit int spdif_remove(struct platform_device *pdev)
 
 static struct platform_driver samsung_spdif_driver = {
 	.probe	= spdif_probe,
-	.remove	= spdif_remove,
+	.remove	= __devexit_p(spdif_remove),
 	.driver	= {
 		.name	= "samsung-spdif",
 		.owner	= THIS_MODULE,
-- 
1.7.4.1



