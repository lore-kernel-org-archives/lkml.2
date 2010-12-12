Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0LMAIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:08:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36248 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab0LLXrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:03 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: david.henningsson@canonical.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [120/223] ALSA: HDA: Add an extra DAC for Realtek ALC887-VD
Message-Id: <20101212234701.99C4DB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Henningsson <david.henningsson@canonical.com>

commit cc1c452e509aefc28f7ad2deed75bc69d4f915f7 upstream.

The patch enables ALC887-VD to use the DAC at nid 0x26,
which makes it possible to use this DAC for e g Headphone
volume.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/sound/pci/hda/patch_realtek.c
===================================================================
--- linux.orig/sound/pci/hda/patch_realtek.c
+++ linux/sound/pci/hda/patch_realtek.c
@@ -18357,6 +18357,8 @@ static inline hda_nid_t alc662_mix_to_da
 		return 0x02;
 	else if (nid >= 0x0c && nid <= 0x0e)
 		return nid - 0x0c + 0x02;
+	else if (nid == 0x26) /* ALC887-VD has this DAC too */
+		return 0x25;
 	else
 		return 0;
 }
@@ -18365,7 +18367,7 @@ static inline hda_nid_t alc662_mix_to_da
 static hda_nid_t alc662_dac_to_mix(struct hda_codec *codec, hda_nid_t pin,
 				   hda_nid_t dac)
 {
-	hda_nid_t mix[4];
+	hda_nid_t mix[5];
 	int i, num;
 
 	num = snd_hda_get_connections(codec, pin, mix, ARRAY_SIZE(mix));
