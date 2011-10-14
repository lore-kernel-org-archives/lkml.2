Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078Ab1JNEJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:09:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39270 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1JNEJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:09:55 -0400
Subject: [PATCH 2/2] ASoC: wm8991: Use snd_soc_update_bits for
 read-modify-write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1318565280.10049.1.camel@phoenix>
References: <1318565280.10049.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 12:09:48 +0800
Message-ID: <1318565388.10049.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snd_soc_update_bits for read-modify-write register access instead of
open-coding it using snd_soc_read and snd_soc_write

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8991.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 708d251..c9ab3ba 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -1264,7 +1264,6 @@ static int wm8991_probe(struct snd_soc_codec *codec)
 {
 	struct wm8991_priv *wm8991;
 	int ret;
-	unsigned int reg;
 
 	wm8991 = snd_soc_codec_get_drvdata(codec);
 
@@ -1282,19 +1281,18 @@ static int wm8991_probe(struct snd_soc_codec *codec)
 
 	wm8991_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
-	reg = snd_soc_read(codec, WM8991_AUDIO_INTERFACE_4);
-	snd_soc_write(codec, WM8991_AUDIO_INTERFACE_4, reg | WM8991_ALRCGPIO1);
+	snd_soc_update_bits(codec, WM8991_AUDIO_INTERFACE_4,
+			    WM8991_ALRCGPIO1, WM8991_ALRCGPIO1);
 
-	reg = snd_soc_read(codec, WM8991_GPIO1_GPIO2) &
-	      ~WM8991_GPIO1_SEL_MASK;
-	snd_soc_write(codec, WM8991_GPIO1_GPIO2, reg | 1);
+	snd_soc_update_bits(codec, WM8991_GPIO1_GPIO2,
+			    WM8991_GPIO1_SEL_MASK, 1);
 
-	reg = snd_soc_read(codec, WM8991_POWER_MANAGEMENT_1);
-	snd_soc_write(codec, WM8991_POWER_MANAGEMENT_1, reg | WM8991_VREF_ENA|
-		      WM8991_VMID_MODE_MASK);
+	snd_soc_update_bits(codec, WM8991_POWER_MANAGEMENT_1,
+			    WM8991_VREF_ENA | WM8991_VMID_MODE_MASK,
+			    WM8991_VREF_ENA | WM8991_VMID_MODE_MASK);
 
-	reg = snd_soc_read(codec, WM8991_POWER_MANAGEMENT_2);
-	snd_soc_write(codec, WM8991_POWER_MANAGEMENT_2, reg | WM8991_OPCLK_ENA);
+	snd_soc_update_bits(codec, WM8991_POWER_MANAGEMENT_2,
+			    WM8991_OPCLK_ENA, WM8991_OPCLK_ENA);
 
 	snd_soc_write(codec, WM8991_DAC_CTRL, 0);
 	snd_soc_write(codec, WM8991_LEFT_OUTPUT_VOLUME, 0x50 | (1<<8));
-- 
1.7.4.1



