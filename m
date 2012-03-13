Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab2CMAyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:54:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:47921 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791Ab2CMAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:53 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 093/196] ASoC: Fix output PGA enabling in wm_hubs CODECs
Date: Mon, 12 Mar 2012 20:20:06 -0400
Message-Id: <1331598109-31424-48-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 39cca168bdfaef9d0c496ec27f292445d6184946 upstream.

The output PGA was not being powered up in headphone and speaker paths,
removing the ability to offer volume control and mute with the output
PGA.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/soc/codecs/wm_hubs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index e1f225a..db6122f 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -701,12 +701,12 @@ static const struct snd_soc_dapm_route analogue_routes[] = {
 
 	{ "SPKL", "Input Switch", "MIXINL" },
 	{ "SPKL", "IN1LP Switch", "IN1LP" },
-	{ "SPKL", "Output Switch", "Left Output Mixer" },
+	{ "SPKL", "Output Switch", "Left Output PGA" },
 	{ "SPKL", NULL, "TOCLK" },
 
 	{ "SPKR", "Input Switch", "MIXINR" },
 	{ "SPKR", "IN1RP Switch", "IN1RP" },
-	{ "SPKR", "Output Switch", "Right Output Mixer" },
+	{ "SPKR", "Output Switch", "Right Output PGA" },
 	{ "SPKR", NULL, "TOCLK" },
 
 	{ "SPKL Boost", "Direct Voice Switch", "Direct Voice" },
@@ -728,8 +728,8 @@ static const struct snd_soc_dapm_route analogue_routes[] = {
 	{ "SPKOUTRP", NULL, "SPKR Driver" },
 	{ "SPKOUTRN", NULL, "SPKR Driver" },
 
-	{ "Left Headphone Mux", "Mixer", "Left Output Mixer" },
-	{ "Right Headphone Mux", "Mixer", "Right Output Mixer" },
+	{ "Left Headphone Mux", "Mixer", "Left Output PGA" },
+	{ "Right Headphone Mux", "Mixer", "Right Output PGA" },
 
 	{ "Headphone PGA", NULL, "Left Headphone Mux" },
 	{ "Headphone PGA", NULL, "Right Headphone Mux" },
-- 
1.7.9.3

