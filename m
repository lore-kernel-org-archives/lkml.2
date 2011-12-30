Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1L3DQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 22:16:42 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40828 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab1L3DQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 22:16:39 -0500
Message-ID: <1325214992.2569.6.camel@phoenix>
Subject: [PATCH 2/3] ASoC: Convert corgi to table based DAPM and control init
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Fri, 30 Dec 2011 11:16:32 +0800
In-Reply-To: <1325214804.2569.3.camel@phoenix>
References: <1325214804.2569.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/pxa/corgi.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/sound/soc/pxa/corgi.c b/sound/soc/pxa/corgi.c
index 5ff6dac..30ebce2 100644
--- a/sound/soc/pxa/corgi.c
+++ b/sound/soc/pxa/corgi.c
@@ -227,7 +227,7 @@ SND_SOC_DAPM_HP("Headset Jack", NULL),
 };
 
 /* Corgi machine audio map (connections to the codec pins) */
-static const struct snd_soc_dapm_route audio_map[] = {
+static const struct snd_soc_dapm_route corgi_audio_map[] = {
 
 	/* headset Jack  - in = micin, out = LHPOUT*/
 	{"Headset Jack", NULL, "LHPOUT"},
@@ -269,24 +269,10 @@ static int corgi_wm8731_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_codec *codec = rtd->codec;
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int err;
 
 	snd_soc_dapm_nc_pin(dapm, "LLINEIN");
 	snd_soc_dapm_nc_pin(dapm, "RLINEIN");
 
-	/* Add corgi specific controls */
-	err = snd_soc_add_controls(codec, wm8731_corgi_controls,
-				ARRAY_SIZE(wm8731_corgi_controls));
-	if (err < 0)
-		return err;
-
-	/* Add corgi specific widgets */
-	snd_soc_dapm_new_controls(dapm, wm8731_dapm_widgets,
-				  ARRAY_SIZE(wm8731_dapm_widgets));
-
-	/* Set up corgi specific audio path audio_map */
-	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
-
 	return 0;
 }
 
@@ -310,6 +296,13 @@ static struct snd_soc_card snd_soc_corgi = {
 	.owner = THIS_MODULE,
 	.dai_link = &corgi_dai,
 	.num_links = 1,
+
+	.controls = wm8731_corgi_controls,
+	.num_controls = ARRAY_SIZE(wm8731_corgi_controls),
+	.dapm_widgets = wm8731_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(wm8731_dapm_widgets),
+	.dapm_routes = corgi_audio_map,
+	.num_dapm_routes = ARRAY_SIZE(corgi_audio_map),
 };
 
 static struct platform_device *corgi_snd_device;
-- 
1.7.5.4



