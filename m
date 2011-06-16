Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab1FPHBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:33 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54746 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755573Ab1FPHB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:27 -0400
X-Sasl-enc: MOoGBNctnOmbCZQ3WzxQ97IWbS4EuBqGwACoUFnQZ7S6 1308207686
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000235.662724794@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [68/89] ASoC: WM8804 does not support sample rates below 32kHz
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 3115ae174620eeab4b16f52c8d0a9a35d2717e3c upstream.

Reported-by: Kieran O'Leary <Kieran.O'Leary@wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8804.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -680,20 +680,25 @@ static struct snd_soc_dai_ops wm8804_dai
 #define WM8804_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE | \
 			SNDRV_PCM_FMTBIT_S24_LE)
 
+#define WM8804_RATES (SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 | \
+		      SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_64000 | \
+		      SNDRV_PCM_RATE_88200 | SNDRV_PCM_RATE_96000 | \
+		      SNDRV_PCM_RATE_176400 | SNDRV_PCM_RATE_192000)
+
 static struct snd_soc_dai_driver wm8804_dai = {
 	.name = "wm8804-spdif",
 	.playback = {
 		.stream_name = "Playback",
 		.channels_min = 2,
 		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_8000_192000,
+		.rates = WM8804_RATES,
 		.formats = WM8804_FORMATS,
 	},
 	.capture = {
 		.stream_name = "Capture",
 		.channels_min = 2,
 		.channels_max = 2,
-		.rates = SNDRV_PCM_RATE_8000_192000,
+		.rates = WM8804_RATES,
 		.formats = WM8804_FORMATS,
 	},
 	.ops = &wm8804_dai_ops,


