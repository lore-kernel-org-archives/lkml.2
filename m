Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2ICI1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:27:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35506 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab2ICI1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:27:24 -0400
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        gcembed@gmail.com, fabio.estevam@freescale.com, s.hauer@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [ASoC] Fix: Revert 'ASoC: imx-ssi: Remove mono support'.
Date: Mon,  3 Sep 2012 10:27:11 +0200
Message-Id: <1346660831-9662-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit should be reverted: 0865a75d4166bddc533fd50831829ceefb94f9b0

The bug this patch is meant to solve doesn't occur in Visstrim_M10 boards.
Furthermore, after applying this patch sound in Visstrim_M10 is played
at slower rates.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
diff --git b/sound/soc/fsl/imx-ssi.c a/sound/soc/fsl/imx-ssi.c
index ac337ac..28dd76c 100644
--- b/sound/soc/fsl/imx-ssi.c
+++ a/sound/soc/fsl/imx-ssi.c
@@ -380,13 +380,13 @@ static int imx_ssi_dai_probe(struct snd_soc_dai *dai)
 static struct snd_soc_dai_driver imx_ssi_dai = {
 	.probe = imx_ssi_dai_probe,
 	.playback = {
-		.channels_min = 2,
+		.channels_min = 1,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_96000,
 		.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	},
 	.capture = {
-		.channels_min = 2,
+		.channels_min = 1,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_96000,
 		.formats = SNDRV_PCM_FMTBIT_S16_LE,
