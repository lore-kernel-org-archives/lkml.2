Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2KMQpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:45:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60457 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301Ab2KMQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:45:32 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@opensource.wolfsonmicro.com
Cc: patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] ASoC: wm5102: Remove mixer widgets on the ASRC
Date: Tue, 13 Nov 2012 16:40:33 +0000
Message-Id: <1352824834-11224-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352824834-11224-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1352824834-11224-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no mixer attached to the ASRC on the wm5102 only a multiplexer
to select the source for the single input line. This change correctly
defines this in the wm5102 CODEC driver.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/wm5102.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index f27527b..28a57cc5 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -280,10 +280,10 @@ ARIZONA_MIXER_ENUMS(AIF2TX2, ARIZONA_AIF2TX2MIX_INPUT_1_SOURCE);
 ARIZONA_MIXER_ENUMS(AIF3TX1, ARIZONA_AIF3TX1MIX_INPUT_1_SOURCE);
 ARIZONA_MIXER_ENUMS(AIF3TX2, ARIZONA_AIF3TX2MIX_INPUT_1_SOURCE);
 
-ARIZONA_MIXER_ENUMS(ASRC1L, ARIZONA_ASRC1LMIX_INPUT_1_SOURCE);
-ARIZONA_MIXER_ENUMS(ASRC1R, ARIZONA_ASRC1RMIX_INPUT_1_SOURCE);
-ARIZONA_MIXER_ENUMS(ASRC2L, ARIZONA_ASRC2LMIX_INPUT_1_SOURCE);
-ARIZONA_MIXER_ENUMS(ASRC2R, ARIZONA_ASRC2RMIX_INPUT_1_SOURCE);
+ARIZONA_MUX_ENUMS(ASRC1L, ARIZONA_ASRC1LMIX_INPUT_1_SOURCE);
+ARIZONA_MUX_ENUMS(ASRC1R, ARIZONA_ASRC1RMIX_INPUT_1_SOURCE);
+ARIZONA_MUX_ENUMS(ASRC2L, ARIZONA_ASRC2LMIX_INPUT_1_SOURCE);
+ARIZONA_MUX_ENUMS(ASRC2R, ARIZONA_ASRC2RMIX_INPUT_1_SOURCE);
 
 ARIZONA_MIXER_ENUMS(DSP1L, ARIZONA_DSP1LMIX_INPUT_1_SOURCE);
 ARIZONA_MIXER_ENUMS(DSP1R, ARIZONA_DSP1RMIX_INPUT_1_SOURCE);
@@ -538,10 +538,10 @@ ARIZONA_MIXER_WIDGETS(AIF2TX2, "AIF2TX2"),
 ARIZONA_MIXER_WIDGETS(AIF3TX1, "AIF3TX1"),
 ARIZONA_MIXER_WIDGETS(AIF3TX2, "AIF3TX2"),
 
-ARIZONA_MIXER_WIDGETS(ASRC1L, "ASRC1L"),
-ARIZONA_MIXER_WIDGETS(ASRC1R, "ASRC1R"),
-ARIZONA_MIXER_WIDGETS(ASRC2L, "ASRC2L"),
-ARIZONA_MIXER_WIDGETS(ASRC2R, "ASRC2R"),
+ARIZONA_MUX_WIDGETS(ASRC1L, "ASRC1L"),
+ARIZONA_MUX_WIDGETS(ASRC1R, "ASRC1R"),
+ARIZONA_MUX_WIDGETS(ASRC2L, "ASRC2L"),
+ARIZONA_MUX_WIDGETS(ASRC2R, "ASRC2R"),
 
 WM_ADSP2("DSP1", 0),
 
@@ -730,10 +730,10 @@ static const struct snd_soc_dapm_route wm5102_dapm_routes[] = {
 	ARIZONA_MIXER_ROUTES("LHPF3", "LHPF3"),
 	ARIZONA_MIXER_ROUTES("LHPF4", "LHPF4"),
 
-	ARIZONA_MIXER_ROUTES("ASRC1L", "ASRC1L"),
-	ARIZONA_MIXER_ROUTES("ASRC1R", "ASRC1R"),
-	ARIZONA_MIXER_ROUTES("ASRC2L", "ASRC2L"),
-	ARIZONA_MIXER_ROUTES("ASRC2R", "ASRC2R"),
+	ARIZONA_MUX_ROUTES("ASRC1L"),
+	ARIZONA_MUX_ROUTES("ASRC1R"),
+	ARIZONA_MUX_ROUTES("ASRC2L"),
+	ARIZONA_MUX_ROUTES("ASRC2R"),
 
 	ARIZONA_DSP_ROUTES("DSP1"),
 
-- 
1.7.2.5

