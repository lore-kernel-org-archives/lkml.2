Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab1FAIOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:14:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757568Ab1FAIOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:14:38 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:02 2011
Message-Id: <20110601080401.402608919@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:30 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Adrian Wilkins <adrian.wilkins@nhs.net>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [094/146] ALSA: hda - Fix input-src parse in patch_analog.c
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adrian Wilkins <adrian.wilkins@nhs.net>

commit 5a2d227fdc7a02ed1b4cebba391d8fb9ad57caaf upstream.

Compare pin type enum to the pin type and not the array index.
Fixes bug#0005368.

Signed-off-by: Adrian Wilkins <adrian.wilkins@nhs.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -3167,6 +3167,7 @@ static void ad1988_auto_init_analog_inpu
 
 	for (i = 0; i < cfg->num_inputs; i++) {
 		hda_nid_t nid = cfg->inputs[i].pin;
+		int type = cfg->inputs[i].type;
 		switch (nid) {
 		case 0x15: /* port-C */
 			snd_hda_codec_write(codec, 0x33, 0, AC_VERB_SET_CONNECT_SEL, 0x0);
@@ -3176,7 +3177,7 @@ static void ad1988_auto_init_analog_inpu
 			break;
 		}
 		snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
-				    i == AUTO_PIN_MIC ? PIN_VREF80 : PIN_IN);
+				    type == AUTO_PIN_MIC ? PIN_VREF80 : PIN_IN);
 		if (nid != AD1988_PIN_CD_NID)
 			snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_AMP_GAIN_MUTE,
 					    AMP_OUT_MUTE);


