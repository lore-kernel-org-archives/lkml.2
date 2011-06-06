Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1FFLjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:39:55 -0400
Received: from smtp-out-228.synserver.de ([212.40.185.228]:1088 "HELO
	smtp-out-224.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756321Ab1FFLjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:39:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13762
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/6] ASoC: AD1836: Add input gain control for ADC2
Date: Mon,  6 Jun 2011 13:38:40 +0200
Message-Id: <1307360320-4727-6-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1307360320-4727-1-git-send-email-lars@metafoo.de>
References: <1307360320-4727-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AD1836 has a PGA for its second ADC. This patch adds a control for
adjusting the the gain of the PGA.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad1836.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/ad1836.c b/sound/soc/codecs/ad1836.c
index 75ff5a5..1e9a801 100644
--- a/sound/soc/codecs/ad1836.c
+++ b/sound/soc/codecs/ad1836.c
@@ -124,6 +124,13 @@ static const struct snd_soc_dapm_route ad183x_dapm_routes[] = {
 	{ "ADC", NULL, "ADC_PWR" },
 };
 
+static const DECLARE_TLV_DB_SCALE(ad1836_in_tlv, 0, 300, 0);
+
+static const struct snd_kcontrol_new ad1836_controls[] = {
+	SOC_DOUBLE_TLV("ADC2 Capture Volume", AD183X_ADC_CTRL1, 3, 0, 4, 0,
+	    ad1836_in_tlv),
+};
+
 /*
  * DAI ops entries
  */
@@ -280,6 +287,10 @@ static int ad1836_probe(struct snd_soc_codec *codec)
 	if (ad1836->type == AD1836) {
 		/* left/right diff:PGA/MUX */
 		snd_soc_write(codec, AD1836_ADC_CTRL3, 0x3A);
+		ret = snd_soc_add_controls(codec, ad1836_controls,
+				ARRAY_SIZE(ad1836_controls));
+		if (ret)
+			return ret;
 	} else {
 		snd_soc_write(codec, AD1836_ADC_CTRL3, 0x00);
 	}
-- 
1.7.2.5

