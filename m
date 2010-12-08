Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0LHCK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:10:58 -0500
Received: from kroah.org ([198.145.64.141]:58336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756105Ab0LHArQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:16 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:29 2010
Message-Id: <20101208004429.504998144@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [052/127] ALSA: HDA: Add an extra DAC for Realtek ALC887-VD
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit cc1c452e509aefc28f7ad2deed75bc69d4f915f7 upstream.

The patch enables ALC887-VD to use the DAC at nid 0x26,
which makes it possible to use this DAC for e g Headphone
volume.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -17260,6 +17260,8 @@ static inline hda_nid_t alc662_mix_to_da
 		return 0x02;
 	else if (nid >= 0x0c && nid <= 0x0e)
 		return nid - 0x0c + 0x02;
+	else if (nid == 0x26) /* ALC887-VD has this DAC too */
+		return 0x25;
 	else
 		return 0;
 }
@@ -17268,7 +17270,7 @@ static inline hda_nid_t alc662_mix_to_da
 static hda_nid_t alc662_dac_to_mix(struct hda_codec *codec, hda_nid_t pin,
 				   hda_nid_t dac)
 {
-	hda_nid_t mix[4];
+	hda_nid_t mix[5];
 	int i, num;
 
 	num = snd_hda_get_connections(codec, pin, mix, ARRAY_SIZE(mix));


