Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab2LMOEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:04:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44203 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab2LMOD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 053/241] ALSA: hda - Force to reset IEC958 status bits for AD codecs
Date: Thu, 13 Dec 2012 11:56:58 -0200
Message-Id: <1355407206-17100-54-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ae24c3191ba2ab03ec6b4be323e730e00404b4b6 upstream.

Several bug reports suggest that the forcibly resetting IEC958 status
bits is required for AD codecs to get the SPDIF output working
properly after changing streams.

Original fix credit to Javeed Shaikh.

BugLink: https://bugs.launchpad.net/ubuntu/+source/alsa-driver/+bug/359361

Reported-by: Robin Kreis <r.kreis@uni-bremen.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index d8b2d6d..b1180b5 100644
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -545,6 +545,7 @@ static int ad198x_build_pcms(struct hda_codec *codec)
 	if (spec->multiout.dig_out_nid) {
 		info++;
 		codec->num_pcms++;
+		codec->spdif_status_reset = 1;
 		info->name = "AD198x Digital";
 		info->pcm_type = HDA_PCM_TYPE_SPDIF;
 		info->stream[SNDRV_PCM_STREAM_PLAYBACK] = ad198x_pcm_digital_playback;
-- 
1.7.9.5

