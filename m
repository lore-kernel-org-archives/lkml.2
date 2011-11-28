Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1K1Q1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:27:19 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:3540
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823Ab1K1Q1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:27:17 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <drivers@analog.com>, <device-drivers-devel@blackfin.uclinux.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/7] ASoC: ad193X: Provide dB ranges for the volume controls
Date: Mon, 28 Nov 2011 17:28:07 +0100
Message-ID: <1322497692-27868-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322497692-27868-1-git-send-email-lars@metafoo.de>
References: <1322497692-27868-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad193x.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 1dfda5c..7da7e29 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -35,16 +35,18 @@ static const char *ad193x_deemp[] = {"None", "48kHz", "44.1kHz", "32kHz"};
 static const struct soc_enum ad193x_deemp_enum =
 	SOC_ENUM_SINGLE(AD193X_DAC_CTRL2, 1, 4, ad193x_deemp);
 
+static const DECLARE_TLV_DB_MINMAX(adau193x_tlv, -9563, 0);
+
 static const struct snd_kcontrol_new ad193x_snd_controls[] = {
 	/* DAC volume control */
-	SOC_DOUBLE_R("DAC1 Volume", AD193X_DAC_L1_VOL,
-			AD193X_DAC_R1_VOL, 0, 0xFF, 1),
-	SOC_DOUBLE_R("DAC2 Volume", AD193X_DAC_L2_VOL,
-			AD193X_DAC_R2_VOL, 0, 0xFF, 1),
-	SOC_DOUBLE_R("DAC3 Volume", AD193X_DAC_L3_VOL,
-			AD193X_DAC_R3_VOL, 0, 0xFF, 1),
-	SOC_DOUBLE_R("DAC4 Volume", AD193X_DAC_L4_VOL,
-			AD193X_DAC_R4_VOL, 0, 0xFF, 1),
+	SOC_DOUBLE_R_TLV("DAC1 Volume", AD193X_DAC_L1_VOL,
+			AD193X_DAC_R1_VOL, 0, 0xFF, 1, adau193x_tlv),
+	SOC_DOUBLE_R_TLV("DAC2 Volume", AD193X_DAC_L2_VOL,
+			AD193X_DAC_R2_VOL, 0, 0xFF, 1, adau193x_tlv),
+	SOC_DOUBLE_R_TLV("DAC3 Volume", AD193X_DAC_L3_VOL,
+			AD193X_DAC_R3_VOL, 0, 0xFF, 1, adau193x_tlv),
+	SOC_DOUBLE_R_TLV("DAC4 Volume", AD193X_DAC_L4_VOL,
+			AD193X_DAC_R4_VOL, 0, 0xFF, 1, adau193x_tlv),
 
 	/* ADC switch control */
 	SOC_DOUBLE("ADC1 Switch", AD193X_ADC_CTRL0, AD193X_ADCL1_MUTE,
-- 
1.7.7.3


