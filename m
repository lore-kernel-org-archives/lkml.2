Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab1FFLkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:40:20 -0400
Received: from smtp-out-228.synserver.de ([212.40.185.228]:1085 "HELO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756315Ab1FFLji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:39:38 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13762
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 5/6] ASoC: AD1836: Remove unused fields from private struct
Date: Mon,  6 Jun 2011 13:38:39 +0200
Message-Id: <1307360320-4727-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307360320-4727-1-git-send-email-lars@metafoo.de>
References: <1307360320-4727-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The control_type field is never used, so it can be removed.
The control_data field is used to initialize the codec's control_data field, but
since this is also done by the snd-soc-cache core, the redundant assignment can
be removed and the field can be dropped.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad1836.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index a443cfe..75ff5a5 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -38,8 +38,6 @@ enum ad1836_type {
 
 /* codec private data */
 struct ad1836_priv {
-	enum snd_soc_control_type control_type;
-	void *control_data;
 	enum ad1836_type type;
 };
 
@@ -257,7 +255,6 @@ static int ad1836_probe(struct snd_soc_codec *codec)
 	num_dacs = ad183x_dais[ad1836->type].playback.channels_max / 2;
 	num_adcs = ad183x_dais[ad1836->type].capture.channels_max / 2;
 
-	codec->control_data = ad1836->control_data;
 	ret = snd_soc_codec_set_cache_io(codec, 4, 12, SND_SOC_SPI);
 	if (ret < 0) {
 		dev_err(codec->dev, "failed to set cache I/O: %d\n",
@@ -350,8 +347,6 @@ static int __devinit ad1836_spi_probe(struct spi_device *spi)
 	ad1836->type = spi_get_device_id(spi)->driver_data;
 
 	spi_set_drvdata(spi, ad1836);
-	ad1836->control_data = spi;
-	ad1836->control_type = SND_SOC_SPI;
 
 	ret = snd_soc_register_codec(&spi->dev,
 			&soc_codec_dev_ad1836, &ad183x_dais[ad1836->type], 1);
-- 
1.7.2.5

