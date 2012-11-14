Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2KNGBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:01:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55141 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719Ab2KNFuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:39 -0500
Message-Id: <20121114053941.590830243@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Robin Kreis <r.kreis@uni-bremen.de>
Subject: [ 56/82] ALSA: hda - Force to reset IEC958 status bits for AD codecs
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
index cdd43ea..1eeba73 100644
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


