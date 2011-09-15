Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab1IONBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:01:25 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:54719 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933719Ab1IONAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:00:03 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-input@vger.kernel.org
Subject: [PATCH 5/8] ASoC: twl6040: Fix the number of channels for vibra
Date: Thu, 15 Sep 2011 15:59:18 +0300
Message-Id: <1316091561-30899-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
References: <1316091561-30899-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only mono audio can be used for vibra (DL4 channel).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 8eecf4a..a386cb3 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1548,8 +1548,8 @@ static struct snd_soc_dai_driver twl6040_dai[] = {
 	.name = "twl6040-vib",
 	.playback = {
 		.stream_name = "Vibra Playback",
-		.channels_min = 2,
-		.channels_max = 2,
+		.channels_min = 1,
+		.channels_max = 1,
 		.rates = SNDRV_PCM_RATE_CONTINUOUS,
 		.formats = TWL6040_FORMATS,
 	},
-- 
1.7.6.1

