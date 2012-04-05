Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2DENto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 09:49:44 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:38342 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab2DENtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 09:49:42 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 09:49:40 EDT
Message-ID: <1333632625.4159.14.camel@localhost>
Subject: [PATCH 4/6] sound/pci/hda: Remove CD control from model=benq for
 CX20549
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Date: Thu, 05 Apr 2012 15:30:25 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Originating-IP: 89.247.230.181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ID used for detection of the BenQ R55E actually identifies the
Quana TW3 ODM design, which is also used for the Gigabyte W551 laptop
series. Schematics on the internet clearly indicate that the "Port C"
(analog input connected to record source #4 and mixer input #4) is
unconnected.

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index bd7e7ce..8d7a977 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -695,7 +695,6 @@ static const struct hda_input_mux cxt5045_capture_source = {
 static const struct hda_input_mux cxt5045_capture_source_benq = {
 	.num_items = 5,
 	.items = {
-		{ "CD",     0x4 },
 		{ "Internal Mic", 0x1 },
 		{ "Mic", 0x2 },
 		{ "Line In", 0x3 },
@@ -820,9 +819,6 @@ static const struct snd_kcontrol_new cxt5045_mixers[] = {
 };
 
 static const struct snd_kcontrol_new cxt5045_benq_mixers[] = {
-	HDA_CODEC_VOLUME("CD Playback Volume", 0x17, 0x4, HDA_INPUT),
-	HDA_CODEC_MUTE("CD Playback Switch", 0x17, 0x4, HDA_INPUT),
-
 	HDA_CODEC_VOLUME("Line In Playback Volume", 0x17, 0x3, HDA_INPUT),
 	HDA_CODEC_MUTE("Line In Playback Switch", 0x17, 0x3, HDA_INPUT),
 
-- 
1.7.9.1



