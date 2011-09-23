Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1IWGuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:50:52 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:37877 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab1IWGu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:50:28 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH v2 5/6] ASoC: omap-mcpdm: Correct the supported number of channels
Date: Fri, 23 Sep 2011 09:49:43 +0300
Message-Id: <1316760584-27426-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316760584-27426-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 McPDM supports 5 downlink (playback), and
3 uplink (capture) channels.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-mcpdm.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
index 159a5e9..2c9fa51 100644
--- a/sound/soc/omap/omap-mcpdm.c
+++ b/sound/soc/omap/omap-mcpdm.c
@@ -299,15 +299,17 @@ static int omap_mcpdm_dai_hw_params(struct snd_pcm_substream *substream,
 
 	channels = params_channels(params);
 	switch (channels) {
+	case 5:
+		if (stream == SNDRV_PCM_STREAM_CAPTURE)
+			/* up to 3 channels for capture */
+			return -EINVAL;
+		link_mask |= 1 << 4;
 	case 4:
 		if (stream == SNDRV_PCM_STREAM_CAPTURE)
-			/* up to 2 channels for capture */
+			/* up to 3 channels for capture */
 			return -EINVAL;
 		link_mask |= 1 << 3;
 	case 3:
-		if (stream == SNDRV_PCM_STREAM_CAPTURE)
-			/* up to 2 channels for capture */
-			return -EINVAL;
 		link_mask |= 1 << 2;
 	case 2:
 		link_mask |= 1 << 1;
@@ -403,13 +405,13 @@ static struct snd_soc_dai_driver omap_mcpdm_dai = {
 	.remove_order = SND_SOC_COMP_ORDER_EARLY,
 	.playback = {
 		.channels_min = 1,
-		.channels_max = 4,
+		.channels_max = 5,
 		.rates = OMAP_MCPDM_RATES,
 		.formats = OMAP_MCPDM_FORMATS,
 	},
 	.capture = {
 		.channels_min = 1,
-		.channels_max = 2,
+		.channels_max = 3,
 		.rates = OMAP_MCPDM_RATES,
 		.formats = OMAP_MCPDM_FORMATS,
 	},
-- 
1.7.6.1

