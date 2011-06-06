Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1FFLjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:39:36 -0400
Received: from smtp-out-228.synserver.de ([212.40.185.228]:1066 "HELO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755673Ab1FFLje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:39:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13762
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/6] ASoC: AD1836: Fix setting the PCM format
Date: Mon,  6 Jun 2011 13:38:35 +0200
Message-Id: <1307360320-4727-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
This patch doesn't need to go into stable since there are currently no users of
PCM formats other than S32, which is the default.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad1836.c |   14 +++++++-------
 sound/soc/codecs/ad1836.h |    6 ++++++
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index ab63d52..754c496 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -145,22 +145,22 @@ static int ad1836_hw_params(struct snd_pcm_substream *substream,
 	/* bit size */
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
-		word_len = 3;
+		word_len = AD1836_WORD_LEN_16;
 		break;
 	case SNDRV_PCM_FORMAT_S20_3LE:
-		word_len = 1;
+		word_len = AD1836_WORD_LEN_20;
 		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
 	case SNDRV_PCM_FORMAT_S32_LE:
-		word_len = 0;
+		word_len = AD1836_WORD_LEN_24;
 		break;
 	}
 
-	snd_soc_update_bits(codec, AD1836_DAC_CTRL1,
-		AD1836_DAC_WORD_LEN_MASK, word_len);
+	snd_soc_update_bits(codec, AD1836_DAC_CTRL1, AD1836_DAC_WORD_LEN_MASK,
+		word_len << AD1836_DAC_WORD_LEN_OFFSET);
 
-	snd_soc_update_bits(codec, AD1836_ADC_CTRL2,
-		AD1836_ADC_WORD_LEN_MASK, word_len);
+	snd_soc_update_bits(codec, AD1836_ADC_CTRL2, AD1836_ADC_WORD_LEN_MASK,
+		word_len << AD1836_ADC_WORD_OFFSET);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/ad1836.h b/sound/soc/codecs/ad1836.h
index 8455967..9d6a3f8 100644
--- a/sound/soc/codecs/ad1836.h
+++ b/sound/soc/codecs/ad1836.h
@@ -25,6 +25,7 @@
 #define AD1836_DAC_SERFMT_PCK256       (0x4 << 5)
 #define AD1836_DAC_SERFMT_PCK128       (0x5 << 5)
 #define AD1836_DAC_WORD_LEN_MASK       0x18
+#define AD1836_DAC_WORD_LEN_OFFSET     3
 
 #define AD1836_DAC_CTRL2               1
 #define AD1836_DACL1_MUTE              0
@@ -51,6 +52,7 @@
 #define AD1836_ADCL2_MUTE 		2
 #define AD1836_ADCR2_MUTE 		3
 #define AD1836_ADC_WORD_LEN_MASK       0x30
+#define AD1836_ADC_WORD_OFFSET         5
 #define AD1836_ADC_SERFMT_MASK	       (7 << 6)
 #define AD1836_ADC_SERFMT_PCK256       (0x4 << 6)
 #define AD1836_ADC_SERFMT_PCK128       (0x5 << 6)
@@ -60,4 +62,8 @@
 
 #define AD1836_NUM_REGS                16
 
+#define AD1836_WORD_LEN_24 0x0
+#define AD1836_WORD_LEN_20 0x1
+#define AD1836_WORD_LEN_16 0x2
+
 #endif
-- 
1.7.2.5

