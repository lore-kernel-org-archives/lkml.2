Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2DFNed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:34:33 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:50773 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757303Ab2DFNea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:34:30 -0400
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] ALSA: hda - fix record volume controls of CX20459 ("Venice")
Date: Fri,  6 Apr 2012 15:34:17 +0200
Message-Id: <1333719260-14504-4-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333719260-14504-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
References: <s5hk41ufe2j.wl%tiwai@suse.de>
 <1333719260-14504-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Originating-IP: 87.123.69.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "input converter" widget of the CX20459 has only one input amplifier,
expose that one as "Capture Volume/Capture Switch". The actual record
source selection is already exposed through the separately installed
input mux.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
---
 sound/pci/hda/patch_conexant.c |   31 ++++++-------------------------
 1 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index ab2cf5c..c36441c 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -797,10 +797,8 @@ static void cxt5045_hp_unsol_event(struct hda_codec *codec,
 }
 
 static const struct snd_kcontrol_new cxt5045_mixers[] = {
-	HDA_CODEC_VOLUME("Internal Mic Capture Volume", 0x1a, 0x01, HDA_INPUT),
-	HDA_CODEC_MUTE("Internal Mic Capture Switch", 0x1a, 0x01, HDA_INPUT),
-	HDA_CODEC_VOLUME("Mic Capture Volume", 0x1a, 0x02, HDA_INPUT),
-	HDA_CODEC_MUTE("Mic Capture Switch", 0x1a, 0x02, HDA_INPUT),
+	HDA_CODEC_VOLUME("Capture Volume", 0x1a, 0x00, HDA_INPUT),
+	HDA_CODEC_MUTE("Capture Switch", 0x1a, 0x0, HDA_INPUT),
 	HDA_CODEC_VOLUME("PCM Playback Volume", 0x17, 0x0, HDA_INPUT),
 	HDA_CODEC_MUTE("PCM Playback Switch", 0x17, 0x0, HDA_INPUT),
 	HDA_CODEC_VOLUME("Internal Mic Playback Volume", 0x17, 0x1, HDA_INPUT),
@@ -821,27 +819,18 @@ static const struct snd_kcontrol_new cxt5045_mixers[] = {
 };
 
 static const struct snd_kcontrol_new cxt5045_benq_mixers[] = {
-	HDA_CODEC_VOLUME("CD Capture Volume", 0x1a, 0x04, HDA_INPUT),
-	HDA_CODEC_MUTE("CD Capture Switch", 0x1a, 0x04, HDA_INPUT),
 	HDA_CODEC_VOLUME("CD Playback Volume", 0x17, 0x4, HDA_INPUT),
 	HDA_CODEC_MUTE("CD Playback Switch", 0x17, 0x4, HDA_INPUT),
 
-	HDA_CODEC_VOLUME("Line Capture Volume", 0x1a, 0x03, HDA_INPUT),
-	HDA_CODEC_MUTE("Line Capture Switch", 0x1a, 0x03, HDA_INPUT),
 	HDA_CODEC_VOLUME("Line Playback Volume", 0x17, 0x3, HDA_INPUT),
 	HDA_CODEC_MUTE("Line Playback Switch", 0x17, 0x3, HDA_INPUT),
 
-	HDA_CODEC_VOLUME("Mixer Capture Volume", 0x1a, 0x0, HDA_INPUT),
-	HDA_CODEC_MUTE("Mixer Capture Switch", 0x1a, 0x0, HDA_INPUT),
-
 	{}
 };
 
 static const struct snd_kcontrol_new cxt5045_mixers_hp530[] = {
-	HDA_CODEC_VOLUME("Internal Mic Capture Volume", 0x1a, 0x02, HDA_INPUT),
-	HDA_CODEC_MUTE("Internal Mic Capture Switch", 0x1a, 0x02, HDA_INPUT),
-	HDA_CODEC_VOLUME("Mic Capture Volume", 0x1a, 0x01, HDA_INPUT),
-	HDA_CODEC_MUTE("Mic Capture Switch", 0x1a, 0x01, HDA_INPUT),
+	HDA_CODEC_VOLUME("Capture Volume", 0x1a, 0x00, HDA_INPUT),
+	HDA_CODEC_MUTE("Capture Switch", 0x1a, 0x0, HDA_INPUT),
 	HDA_CODEC_VOLUME("PCM Playback Volume", 0x17, 0x0, HDA_INPUT),
 	HDA_CODEC_MUTE("PCM Playback Switch", 0x17, 0x0, HDA_INPUT),
 	HDA_CODEC_VOLUME("Internal Mic Playback Volume", 0x17, 0x2, HDA_INPUT),
@@ -977,16 +966,8 @@ static const struct snd_kcontrol_new cxt5045_test_mixer[] = {
 		.put = conexant_mux_enum_put,
 	},
 	/* Audio input controls */
-	HDA_CODEC_VOLUME("Input-1 Volume", 0x1a, 0x0, HDA_INPUT),
-	HDA_CODEC_MUTE("Input-1 Switch", 0x1a, 0x0, HDA_INPUT),
-	HDA_CODEC_VOLUME("Input-2 Volume", 0x1a, 0x1, HDA_INPUT),
-	HDA_CODEC_MUTE("Input-2 Switch", 0x1a, 0x1, HDA_INPUT),
-	HDA_CODEC_VOLUME("Input-3 Volume", 0x1a, 0x2, HDA_INPUT),
-	HDA_CODEC_MUTE("Input-3 Switch", 0x1a, 0x2, HDA_INPUT),
-	HDA_CODEC_VOLUME("Input-4 Volume", 0x1a, 0x3, HDA_INPUT),
-	HDA_CODEC_MUTE("Input-4 Switch", 0x1a, 0x3, HDA_INPUT),
-	HDA_CODEC_VOLUME("Input-5 Volume", 0x1a, 0x4, HDA_INPUT),
-	HDA_CODEC_MUTE("Input-5 Switch", 0x1a, 0x4, HDA_INPUT),
+	HDA_CODEC_VOLUME("Capture Volume", 0x1a, 0x0, HDA_INPUT),
+	HDA_CODEC_MUTE("Capture Switch", 0x1a, 0x0, HDA_INPUT),
 	{ } /* end */
 };
 
-- 
1.7.9.1

