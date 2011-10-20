Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab1JTCyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 22:54:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42703 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1JTCyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 22:54:21 -0400
Message-ID: <1319079253.5380.3.camel@phoenix>
Subject: [PATCH] ASoC: ak4671: Use snd_soc_update_bits for read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Thu, 20 Oct 2011 10:54:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ak4671.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index 41e3d55..de9ff66 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -168,18 +168,15 @@ static int ak4671_out2_event(struct snd_soc_dapm_widget *w,
 		struct snd_kcontrol *kcontrol, int event)
 {
 	struct snd_soc_codec *codec = w->codec;
-	u8 reg;
 
 	switch (event) {
 	case SND_SOC_DAPM_POST_PMU:
-		reg = snd_soc_read(codec, AK4671_LOUT2_POWER_MANAGERMENT);
-		reg |= AK4671_MUTEN;
-		snd_soc_write(codec, AK4671_LOUT2_POWER_MANAGERMENT, reg);
+		snd_soc_update_bits(codec, AK4671_LOUT2_POWER_MANAGERMENT,
+				    AK4671_MUTEN, AK4671_MUTEN);
 		break;
 	case SND_SOC_DAPM_PRE_PMD:
-		reg = snd_soc_read(codec, AK4671_LOUT2_POWER_MANAGERMENT);
-		reg &= ~AK4671_MUTEN;
-		snd_soc_write(codec, AK4671_LOUT2_POWER_MANAGERMENT, reg);
+		snd_soc_update_bits(codec, AK4671_LOUT2_POWER_MANAGERMENT,
+				    AK4671_MUTEN, 0);
 		break;
 	}
 
@@ -575,15 +572,12 @@ static int ak4671_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 static int ak4671_set_bias_level(struct snd_soc_codec *codec,
 		enum snd_soc_bias_level level)
 {
-	u8 reg;
-
 	switch (level) {
 	case SND_SOC_BIAS_ON:
 	case SND_SOC_BIAS_PREPARE:
 	case SND_SOC_BIAS_STANDBY:
-		reg = snd_soc_read(codec, AK4671_AD_DA_POWER_MANAGEMENT);
-		snd_soc_write(codec, AK4671_AD_DA_POWER_MANAGEMENT,
-				reg | AK4671_PMVCM);
+		snd_soc_update_bits(codec, AK4671_AD_DA_POWER_MANAGEMENT,
+				    AK4671_PMVCM, AK4671_PMVCM);
 		break;
 	case SND_SOC_BIAS_OFF:
 		snd_soc_write(codec, AK4671_AD_DA_POWER_MANAGEMENT, 0x00);
-- 
1.7.5.4



