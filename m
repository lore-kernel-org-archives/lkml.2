Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab1DLRjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:39:36 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1059 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755975Ab1DLRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:39:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 7621
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] ASoC: codecs: JZ4740: Fix OOPS
Date: Tue, 12 Apr 2011 19:33:28 +0200
Message-Id: <1302629609-21537-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ce6120cc(ASoC: Decouple DAPM from CODECs) changed the signature of
snd_soc_dapm_widgets_new to take an pointer to a snd_soc_dapm_context instead of
a snd_soc_codec. The call to snd_soc_dapm_widgets_new in jz4740_codec_dev_probe
was not updated to reflect this change, which results in a compiletime warning
and a runtime OOPS.

Since the core code calls snd_soc_dapm_widgets_new after the codec has been
registered it can be dropped here.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/jz4740.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/jz4740.c b/sound/soc/codecs/jz4740.c
index f7cd346..f5ccdbf7 100644
--- a/sound/soc/codecs/jz4740.c
+++ b/sound/soc/codecs/jz4740.c
@@ -308,8 +308,6 @@ static int jz4740_codec_dev_probe(struct snd_soc_codec *codec)
 	snd_soc_dapm_add_routes(dapm, jz4740_codec_dapm_routes,
 		ARRAY_SIZE(jz4740_codec_dapm_routes));
 
-	snd_soc_dapm_new_widgets(codec);
-
 	jz4740_codec_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	return 0;
-- 
1.7.2.5

