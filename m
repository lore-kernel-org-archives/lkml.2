Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab1FFLjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:39:39 -0400
Received: from smtp-out-228.synserver.de ([212.40.185.228]:1073 "HELO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756270Ab1FFLjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:39:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13762
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/6] ASoC: AD1836: Use snd_soc_update_bits for read-modify-write
Date: Mon,  6 Jun 2011 13:38:37 +0200
Message-Id: <1307360320-4727-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307360320-4727-1-git-send-email-lars@metafoo.de>
References: <1307360320-4727-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad1836.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index 5c6d239..fde0f17 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -174,19 +174,15 @@ static int ad1836_soc_suspend(struct snd_soc_codec *codec,
 		pm_message_t state)
 {
 	/* reset clock control mode */
-	u16 adc_ctrl2 = snd_soc_read(codec, AD1836_ADC_CTRL2);
-	adc_ctrl2 &= ~AD1836_ADC_SERFMT_MASK;
-
-	return snd_soc_write(codec, AD1836_ADC_CTRL2, adc_ctrl2);
+	return snd_soc_update_bits(codec, AD1836_ADC_CTRL2,
+		AD1836_ADC_SERFMT_MASK, 0);
 }
 
 static int ad1836_soc_resume(struct snd_soc_codec *codec)
 {
 	/* restore clock control mode */
-	u16 adc_ctrl2 = snd_soc_read(codec, AD1836_ADC_CTRL2);
-	adc_ctrl2 |= AD1836_ADC_AUX;
-
-	return snd_soc_write(codec, AD1836_ADC_CTRL2, adc_ctrl2);
+	return snd_soc_update_bits(codec, AD1836_ADC_CTRL2,
+		AD1836_ADC_SERFMT_MASK, AD1836_ADC_AUX);
 }
 #else
 #define ad1836_soc_suspend NULL
@@ -266,10 +262,8 @@ static int ad1836_probe(struct snd_soc_codec *codec)
 static int ad1836_remove(struct snd_soc_codec *codec)
 {
 	/* reset clock control mode */
-	u16 adc_ctrl2 = snd_soc_read(codec, AD1836_ADC_CTRL2);
-	adc_ctrl2 &= ~AD1836_ADC_SERFMT_MASK;
-
-	return snd_soc_write(codec, AD1836_ADC_CTRL2, adc_ctrl2);
+	return snd_soc_update_bits(codec, AD1836_ADC_CTRL2,
+		AD1836_ADC_SERFMT_MASK, 0);
 }
 
 static struct snd_soc_codec_driver soc_codec_dev_ad1836 = {
-- 
1.7.2.5

