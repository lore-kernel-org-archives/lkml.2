Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1JMHZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:25:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39498 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1JMHZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:25:27 -0400
Subject: [PATCH 3/3] ASoC: wm8961: Convert codec->hw_read to regmap_read
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1318490575.2857.8.camel@phoenix>
References: <1318490575.2857.8.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 15:25:20 +0800
Message-ID: <1318490720.2857.11.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

codec->hw_read is broken now, let's covert to regmap_read.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8961.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index cdee810..2fa1672 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -960,6 +960,7 @@ static int wm8961_probe(struct snd_soc_codec *codec)
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int ret = 0;
 	u16 reg;
+	unsigned int val;
 
 	ret = snd_soc_codec_set_cache_io(codec, 8, 16, SND_SOC_I2C);
 	if (ret != 0) {
@@ -974,10 +975,10 @@ static int wm8961_probe(struct snd_soc_codec *codec)
 	}
 
 	/* This isn't volatile - readback doesn't correspond to write */
-	reg = codec->hw_read(codec, WM8961_RIGHT_INPUT_VOLUME);
+	regmap_read(codec->control_data, WM8961_RIGHT_INPUT_VOLUME, &val);
 	dev_info(codec->dev, "WM8961 family %d revision %c\n",
-		 (reg & WM8961_DEVICE_ID_MASK) >> WM8961_DEVICE_ID_SHIFT,
-		 ((reg & WM8961_CHIP_REV_MASK) >> WM8961_CHIP_REV_SHIFT)
+		 (val & WM8961_DEVICE_ID_MASK) >> WM8961_DEVICE_ID_SHIFT,
+		 ((val & WM8961_CHIP_REV_MASK) >> WM8961_CHIP_REV_SHIFT)
 		 + 'A');
 
 	ret = wm8961_reset(codec);
-- 
1.7.4.1



