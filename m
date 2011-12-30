Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1L3BTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 20:19:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60792 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1L3BTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:19:38 -0500
Message-ID: <1325207972.9599.4.camel@phoenix>
Subject: [PATCH 2/3] ASoC: Convert poodle to table based DAPM and control
 init
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Fri, 30 Dec 2011 09:19:32 +0800
In-Reply-To: <1325207771.9599.1.camel@phoenix>
References: <1325207771.9599.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/pxa/poodle.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/sound/soc/pxa/poodle.c b/sound/soc/pxa/poodle.c
index c9e24bf..a321b4d 100644
--- a/sound/soc/pxa/poodle.c
+++ b/sound/soc/pxa/poodle.c
@@ -214,7 +214,7 @@ SND_SOC_DAPM_SPK("Ext Spk", poodle_amp_event),
 };
 
 /* Corgi machine connections to the codec pins */
-static const struct snd_soc_dapm_route audio_map[] = {
+static const struct snd_soc_dapm_route poodle_audio_map[] = {
 
 	/* headphone connected to LHPOUT1, RHPOUT1 */
 	{"Headphone Jack", NULL, "LHPOUT"},
@@ -246,25 +246,11 @@ static int poodle_wm8731_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_codec *codec = rtd->codec;
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
-	int err;
 
 	snd_soc_dapm_nc_pin(dapm, "LLINEIN");
 	snd_soc_dapm_nc_pin(dapm, "RLINEIN");
 	snd_soc_dapm_enable_pin(dapm, "MICIN");
 
-	/* Add poodle specific controls */
-	err = snd_soc_add_controls(codec, wm8731_poodle_controls,
-				ARRAY_SIZE(wm8731_poodle_controls));
-	if (err < 0)
-		return err;
-
-	/* Add poodle specific widgets */
-	snd_soc_dapm_new_controls(dapm, wm8731_dapm_widgets,
-				  ARRAY_SIZE(wm8731_dapm_widgets));
-
-	/* Set up poodle specific audio path audio_map */
-	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
-
 	return 0;
 }
 
@@ -286,6 +272,13 @@ static struct snd_soc_card poodle = {
 	.dai_link = &poodle_dai,
 	.num_links = 1,
 	.owner = THIS_MODULE,
+
+	.controls = wm8731_poodle_controls,
+	.num_controls = ARRAY_SIZE(wm8731_poodle_controls),
+	.dapm_widgets = wm8731_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(wm8731_dapm_widgets),
+	.dapm_routes = poodle_audio_map,
+	.num_dapm_routes = ARRAY_SIZE(poodle_audio_map),
 };
 
 static int __devinit poodle_probe(struct platform_device *pdev)
-- 
1.7.5.4



