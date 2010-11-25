Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab0KYFij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 00:38:39 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60565 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0KYFii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 00:38:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mpTAPOeYGqN4fE0F7B2l7PpYDzSGisaOlexxQAtQw3tGRN+PDmioRpp2D45/tRmMCt
         wFRvNFVU3IfkNo5ery5NkV0l02QXBIGRToOlVBSmzHkW2/eZgalLKWH0V0/8CiqHZuGk
         P2woVqxndf0mgzAiBFNSPlKdCLbvOXNyyGh0s=
Subject: [PATCH] ASoC: Fix compile error for smartq_wm8987.c
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Thu, 25 Nov 2010 13:43:49 +0800
Message-Id: <1290663829.30158.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below compile error:

  CC      sound/soc/samsung/smartq_wm8987.o
sound/soc/samsung/smartq_wm8987.c: In function 'smartq_hifi_hw_params':
sound/soc/samsung/smartq_wm8987.c:42: error: 'struct snd_soc_pcm_runtime' has no member named 'dai'
sound/soc/samsung/smartq_wm8987.c:43: error: 'struct snd_soc_pcm_runtime' has no member named 'dai'
sound/soc/samsung/smartq_wm8987.c: In function 'smartq_wm8987_init':
sound/soc/samsung/smartq_wm8987.c:192: warning: passing argument 1 of 'snd_soc_jack_new' from incompatible pointer type
sound/soc/samsung/smartq_wm8987.c: At top level:
sound/soc/samsung/smartq_wm8987.c:216: warning: initialization from incompatible pointer type
make[3]: *** [sound/soc/samsung/smartq_wm8987.o] Error 1
make[2]: *** [sound/soc/samsung] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/samsung/smartq_wm8987.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/samsung/smartq_wm8987.c b/sound/soc/samsung/smartq_wm8987.c
index d6a340b8..0a46fa8 100644
--- a/sound/soc/samsung/smartq_wm8987.c
+++ b/sound/soc/samsung/smartq_wm8987.c
@@ -39,8 +39,8 @@ static int smartq_hifi_hw_params(struct snd_pcm_substream *substream,
 	struct snd_pcm_hw_params *params)
 {
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
-	struct snd_soc_dai *codec_dai = rtd->dai->codec_dai;
-	struct snd_soc_dai *cpu_dai = rtd->dai->cpu_dai;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
 	unsigned int clk = 0;
 	int ret;
 
@@ -153,8 +153,9 @@ static const struct snd_soc_dapm_route audio_map[] = {
 	{"LINPUT2", NULL, "Mic Bias"},
 };
 
-static int smartq_wm8987_init(struct snd_soc_codec *codec)
+static int smartq_wm8987_init(struct snd_soc_pcm_runtime *rtd)
 {
+	struct snd_soc_codec *codec = rtd->codec;
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int err = 0;
 
@@ -188,7 +189,7 @@ static int smartq_wm8987_init(struct snd_soc_codec *codec)
 		return err;
 
 	/* Headphone jack detection */
-	err = snd_soc_jack_new(&snd_soc_smartq, "Headphone Jack",
+	err = snd_soc_jack_new(codec, "Headphone Jack",
 			       SND_JACK_HEADPHONE, &smartq_jack);
 	if (err)
 		return err;
-- 
1.7.2



