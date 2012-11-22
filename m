Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab2KVW2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:28:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:49023 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab2KVSd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Robin Kreis <r.kreis@uni-bremen.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 014/171] ALSA: hda - Force to reset IEC958 status bits for AD codecs
Date: Wed, 21 Nov 2012 16:39:20 -0800
Message-Id: <20121122004034.762516067@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -544,6 +544,7 @@ static int ad198x_build_pcms(struct hda_
 	if (spec->multiout.dig_out_nid) {
 		info++;
 		codec->num_pcms++;
+		codec->spdif_status_reset = 1;
 		info->name = "AD198x Digital";
 		info->pcm_type = HDA_PCM_TYPE_SPDIF;
 		info->stream[SNDRV_PCM_STREAM_PLAYBACK] = ad198x_pcm_digital_playback;


