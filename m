Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1KAQdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:33:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27232 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1KAQdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:33:11 -0400
From: Taylor Hutt <thutt@chromium.org>
To: thutt@chromium.org
Cc: miletus@chromium.org, swarren@nvidia.com,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoc : Tegra : Add audio map for Asymptote
Date: Tue,  1 Nov 2011 09:32:53 -0700
Message-Id: <1320165173-3951-1-git-send-email-thutt@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Details

  Add pin connections and audio map for the Asymptote board.

Testing

  Visual inspection with Chromium OS 2.6.38 code.
  Built kernel
  Built chromium os image
  Booted image on asymptote
  Booted image on kaen

Signed-off-by: Taylor Hutt <thutt@chromium.org>
---
 sound/soc/tegra/tegra_wm8903.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/sound/soc/tegra/tegra_wm8903.c b/sound/soc/tegra/tegra_wm8903.c
index b0aef55..e0beeda 100644
--- a/sound/soc/tegra/tegra_wm8903.c
+++ b/sound/soc/tegra/tegra_wm8903.c
@@ -310,6 +310,7 @@ static void tegra_wm8903_disconnect_pins(struct snd_soc_card *card,
 {
 #define MACHINES                               \
 	M(aebl)                                 \
+	M(asymptote)                            \
 	M(harmony)                              \
 	M(kaen)                                 \
 	M(seaboard)                             \
@@ -355,6 +356,7 @@ static void tegra_wm8903_disconnect_pins(struct snd_soc_card *card,
 			CONNECT(ventana),
 			CONNECT(seaboard),
 			CONNECT(kaen),
+			CONNECT(asymptote),
 		},
 		{
 			.name = "RON",
@@ -362,6 +364,7 @@ static void tegra_wm8903_disconnect_pins(struct snd_soc_card *card,
 			CONNECT(ventana),
 			CONNECT(seaboard),
 			CONNECT(kaen),
+			CONNECT(asymptote),
 		},
 		{
 			.name = "ROP",
@@ -369,6 +372,7 @@ static void tegra_wm8903_disconnect_pins(struct snd_soc_card *card,
 			CONNECT(ventana),
 			CONNECT(seaboard),
 			CONNECT(kaen),
+			CONNECT(asymptote),
 		},
 		{
 			.name = "LOP",
@@ -376,6 +380,7 @@ static void tegra_wm8903_disconnect_pins(struct snd_soc_card *card,
 			CONNECT(ventana),
 			CONNECT(seaboard),
 			CONNECT(kaen),
+			CONNECT(asymptote),
 		},
 		{
 			.name = "LINEOUTR",
@@ -544,13 +549,14 @@ static __devinit int tegra_wm8903_driver_probe(struct platform_device *pdev)
 	if (machine_is_harmony() || machine_is_ventana()) {
 		card->dapm_routes = harmony_audio_map;
 		card->num_dapm_routes = ARRAY_SIZE(harmony_audio_map);
-	} else if (machine_is_seaboard()) {
+	} else if (machine_is_seaboard() || machine_is_asymptote()) {
 		card->dapm_routes = seaboard_audio_map;
 		card->num_dapm_routes = ARRAY_SIZE(seaboard_audio_map);
 	} else if (machine_is_kaen()) {
 		card->dapm_routes = kaen_audio_map;
 		card->num_dapm_routes = ARRAY_SIZE(kaen_audio_map);
 	} else {
+		BUG_ON(!machine_is_aebl());
 		card->dapm_routes = aebl_audio_map;
 		card->num_dapm_routes = ARRAY_SIZE(aebl_audio_map);
 	}
-- 
1.7.3.1

