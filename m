Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1IMOoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:44:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42031 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab1IMOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:44:33 -0400
Subject: [PATCH] ASoC: samsung: Fix checking return value of clk_get
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christian Pellegrin <chripell@evolware.org>, Ben Dooks <ben@simtec.co.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 22:44:22 +0800
Message-ID: <1315925062.6042.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a pointer to the struct clk or an ERR_PTR().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Christian Pellegrin <chripell@evolware.org>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
---
 sound/soc/samsung/s3c2412-i2s.c     |    2 +-
 sound/soc/samsung/s3c24xx-i2s.c     |    2 +-
 sound/soc/samsung/s3c24xx_uda134x.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/samsung/s3c2412-i2s.c b/sound/soc/samsung/s3c2412-i2s.c
index 841ab14..cecdbad 100644
--- a/sound/soc/samsung/s3c2412-i2s.c
+++ b/sound/soc/samsung/s3c2412-i2s.c
@@ -69,7 +69,7 @@ static int s3c2412_i2s_probe(struct snd_soc_dai *dai)
 	s3c2412_i2s.dma_playback = &s3c2412_i2s_pcm_stereo_out;
 
 	s3c2412_i2s.iis_cclk = clk_get(dai->dev, "i2sclk");
-	if (s3c2412_i2s.iis_cclk == NULL) {
+	if (IS_ERR(s3c2412_i2s.iis_cclk)) {
 		pr_err("failed to get i2sclk clock\n");
 		iounmap(s3c2412_i2s.regs);
 		return -ENODEV;
diff --git a/sound/soc/samsung/s3c24xx-i2s.c b/sound/soc/samsung/s3c24xx-i2s.c
index 63d8849..9f888bc 100644
--- a/sound/soc/samsung/s3c24xx-i2s.c
+++ b/sound/soc/samsung/s3c24xx-i2s.c
@@ -383,7 +383,7 @@ static int s3c24xx_i2s_probe(struct snd_soc_dai *dai)
 		return -ENXIO;
 
 	s3c24xx_i2s.iis_clk = clk_get(dai->dev, "iis");
-	if (s3c24xx_i2s.iis_clk == NULL) {
+	if (IS_ERR(s3c24xx_i2s.iis_clk)) {
 		pr_err("failed to get iis_clock\n");
 		iounmap(s3c24xx_i2s.regs);
 		return -ENODEV;
diff --git a/sound/soc/samsung/s3c24xx_uda134x.c b/sound/soc/samsung/s3c24xx_uda134x.c
index dc9d551..4da57cd 100644
--- a/sound/soc/samsung/s3c24xx_uda134x.c
+++ b/sound/soc/samsung/s3c24xx_uda134x.c
@@ -66,13 +66,13 @@ static int s3c24xx_uda134x_startup(struct snd_pcm_substream *substream)
 	pr_debug("%s %d\n", __func__, clk_users);
 	if (clk_users == 0) {
 		xtal = clk_get(&s3c24xx_uda134x_snd_device->dev, "xtal");
-		if (!xtal) {
+		if (IS_ERR(xtal)) {
 			printk(KERN_ERR "%s cannot get xtal\n", __func__);
 			ret = -EBUSY;
 		} else {
 			pclk = clk_get(&s3c24xx_uda134x_snd_device->dev,
 				       "pclk");
-			if (!pclk) {
+			if (IS_ERR(pclk)) {
 				printk(KERN_ERR "%s cannot get pclk\n",
 				       __func__);
 				clk_put(xtal);
-- 
1.7.4.1



