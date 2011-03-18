Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1CRLsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:48:36 -0400
Received: from smtp207.alice.it ([82.57.200.103]:54343 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab1CRLsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:48:30 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: alsa-devel@alsa-project.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Jarkko Nikula <jhnikula@gmail.com>, Timur Tabi <timur@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/soc/pxa/zylonite.c: set .codec_dai_name in initializer
Date: Fri, 18 Mar 2011 12:47:33 +0100
Message-Id: <1300448853-15651-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.4.1
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the initialization of .codec_dai_name in zylonite_dai initializer,
do not mix it with the initialization of .codec_name which is set
already a few lines above.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

Hi,

I didn't test that because I don't have the hardware, I just noticed it by 
reading the code from 2.6.38 and thought this may be the right fix.

Is there any mechanism to spot out when the same field in a struct initializer 
is set more than once?

Regards,
   Antonio Ospite
   http://ao2.it

 sound/soc/pxa/zylonite.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/pxa/zylonite.c b/sound/soc/pxa/zylonite.c
index 25bba10..5e96f7e 100644
--- a/sound/soc/pxa/zylonite.c
+++ b/sound/soc/pxa/zylonite.c
@@ -167,7 +167,7 @@ static struct snd_soc_dai_link zylonite_dai[] = {
 	.codec_name = "wm9713-codec",
 	.platform_name = "pxa-pcm-audio",
 	.cpu_dai_name = "pxa2xx-ac97",
-	.codec_name = "wm9713-hifi",
+	.codec_dai_name = "wm9713-hifi",
 	.init = zylonite_wm9713_init,
 },
 {
@@ -176,7 +176,7 @@ static struct snd_soc_dai_link zylonite_dai[] = {
 	.codec_name = "wm9713-codec",
 	.platform_name = "pxa-pcm-audio",
 	.cpu_dai_name = "pxa2xx-ac97-aux",
-	.codec_name = "wm9713-aux",
+	.codec_dai_name = "wm9713-aux",
 },
 {
 	.name = "WM9713 Voice",
@@ -184,7 +184,7 @@ static struct snd_soc_dai_link zylonite_dai[] = {
 	.codec_name = "wm9713-codec",
 	.platform_name = "pxa-pcm-audio",
 	.cpu_dai_name = "pxa-ssp-dai.2",
-	.codec_name = "wm9713-voice",
+	.codec_dai_name = "wm9713-voice",
 	.ops = &zylonite_voice_ops,
 },
 };
-- 
1.7.4.1

