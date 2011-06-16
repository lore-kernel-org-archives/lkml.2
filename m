Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1FPHcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:32:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44762 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755938Ab1FPHBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:24 -0400
X-Sasl-enc: Y0lQPq3+ntuN5+rObcKRMqiYMy5+pIqZO1Ty2M5PDE4T 1308207683
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000235.465819907@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [66/89] ASoC: AD1836: Fix setting the PCM format
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 8ca695f273709a9d147826716a8dee3e0eb2407f upstream.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ad1836.c |   14 +++++++-------
 sound/soc/codecs/ad1836.h |    6 ++++++
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -145,22 +145,22 @@ static int ad1836_hw_params(struct snd_p
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


