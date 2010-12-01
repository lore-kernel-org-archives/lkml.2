Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0LAJQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:16:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40229 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab0LAJQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:16:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iwp22QGSB9DZtnDO/t/eZ9xvGN5fKSJ92EoxICUSLLmaidPgeHXPD6OJPcKuakMvGA
         qlOcYdGYMF4ovoJp8sHb0hWDTOK5A8EYt+cmvUDpv/ww4uBPyCbojRoUx3d10mP204k7
         EXZ41EFn2AazK+bSgdpu4wMpZEy9JrL/6+RIY=
Subject: [PATCH] ASoC: ak4535: Improve readability for setting mute
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <richard@openedhand.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Wed, 01 Dec 2010 17:22:34 +0800
Message-Id: <1291195354.5563.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mute/unmute is controled by SMUTE (Soft Mute Control bit):
        0: Normal Operation (Default)
        1: DAC outputs soft-muted

I think this change improves readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ak4535.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index 7367545..8b38739 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -366,9 +366,9 @@ static int ak4535_set_dai_fmt(struct snd_soc_dai *codec_dai,
 static int ak4535_mute(struct snd_soc_dai *dai, int mute)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	u16 mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC) & 0xffdf;
+	u16 mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC);
 	if (!mute)
-		ak4535_write(codec, AK4535_DAC, mute_reg);
+		ak4535_write(codec, AK4535_DAC, mute_reg & ~0x20);
 	else
 		ak4535_write(codec, AK4535_DAC, mute_reg | 0x20);
 	return 0;
@@ -381,11 +381,11 @@ static int ak4535_set_bias_level(struct snd_soc_codec *codec,
 
 	switch (level) {
 	case SND_SOC_BIAS_ON:
-		mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC) & 0xffdf;
-		ak4535_write(codec, AK4535_DAC, mute_reg);
+		mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC);
+		ak4535_write(codec, AK4535_DAC, mute_reg & ~0x20);
 		break;
 	case SND_SOC_BIAS_PREPARE:
-		mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC) & 0xffdf;
+		mute_reg = ak4535_read_reg_cache(codec, AK4535_DAC);
 		ak4535_write(codec, AK4535_DAC, mute_reg | 0x20);
 		break;
 	case SND_SOC_BIAS_STANDBY:
-- 
1.7.2



