Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965928Ab2DLUL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:11:29 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11695 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2DLUL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:11:27 -0400
Date: Thu, 12 Apr 2012 22:11:25 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Kailang Yang <kailang@realtek.com.tw>,
        PeiSen Hou <pshou@realtek.com.tw>,
        Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: [PATCH] ALSA: hda/realtek - Fix mem leak (and rid us of trailing
 whitespace).
Message-ID: <alpine.LNX.2.00.1204122209560.7553@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sound/pci/hda/patch_realtek.c::alc_auto_fill_dac_nids(), in the
'for (;;)' loop, if the 'badness' value returned from
fill_and_eval_dacs() is negative, then we'll return from the function
without freeing the memory we allocated for 'best_cfg', thus leaking.
Fix the leak by kfree()'ing the memory when badness is negative.

While I was there I also noticed some trailing whitespace in the
function that I removed (along with all other trailing whitespace in
the file) - it didn't seem worth-while to do that as two patches, so I
hope it's OK that I just did it all as one patch.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/pci/hda/patch_realtek.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9917e55..c5e1a1a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3398,8 +3398,10 @@ static int alc_auto_fill_dac_nids(struct hda_codec *codec)
 	for (;;) {
 		badness = fill_and_eval_dacs(codec, fill_hardwired,
 					     fill_mio_first);
-		if (badness < 0)
+		if (badness < 0) {
+			kfree(best_cfg);
 			return badness;
+		}
 		debug_badness("==> lo_type=%d, wired=%d, mio=%d, badness=0x%x\n",
 			      cfg->line_out_type, fill_hardwired, fill_mio_first,
 			      badness);
@@ -3434,7 +3436,7 @@ static int alc_auto_fill_dac_nids(struct hda_codec *codec)
 			cfg->line_out_type = AUTO_PIN_SPEAKER_OUT;
 			fill_hardwired = true;
 			continue;
-		} 
+		}
 		if (cfg->hp_outs > 0 &&
 		    cfg->line_out_type == AUTO_PIN_SPEAKER_OUT) {
 			cfg->speaker_outs = cfg->line_outs;
@@ -3448,7 +3450,7 @@ static int alc_auto_fill_dac_nids(struct hda_codec *codec)
 			cfg->line_out_type = AUTO_PIN_HP_OUT;
 			fill_hardwired = true;
 			continue;
-		} 
+		}
 		break;
 	}
 
@@ -4423,7 +4425,7 @@ static int alc_parse_auto_config(struct hda_codec *codec,
 static int alc880_parse_auto_config(struct hda_codec *codec)
 {
 	static const hda_nid_t alc880_ignore[] = { 0x1d, 0 };
-	static const hda_nid_t alc880_ssids[] = { 0x15, 0x1b, 0x14, 0 }; 
+	static const hda_nid_t alc880_ssids[] = { 0x15, 0x1b, 0x14, 0 };
 	return alc_parse_auto_config(codec, alc880_ignore, alc880_ssids);
 }
 
@@ -6079,7 +6081,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	 * Basically the device should work as is without the fixup table.
 	 * If BIOS doesn't give a proper info, enable the corresponding
 	 * fixup entry.
-	 */ 
+	 */
 	SND_PCI_QUIRK(0x1043, 0x8330, "ASUS Eeepc P703 P900A",
 		      ALC269_FIXUP_AMIC),
 	SND_PCI_QUIRK(0x1043, 0x1013, "ASUS N61Da", ALC269_FIXUP_AMIC),
@@ -6296,7 +6298,7 @@ static void alc_fixup_no_jack_detect(struct hda_codec *codec,
 {
 	if (action == ALC_FIXUP_ACT_PRE_PROBE)
 		codec->no_jack_detect = 1;
-}	
+}
 
 static const struct alc_fixup alc861_fixups[] = {
 	[ALC861_FIXUP_FSC_AMILO_PI1505] = {
@@ -6714,7 +6716,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	 * Basically the device should work as is without the fixup table.
 	 * If BIOS doesn't give a proper info, enable the corresponding
 	 * fixup entry.
-	 */ 
+	 */
 	SND_PCI_QUIRK(0x1043, 0x1000, "ASUS N50Vm", ALC662_FIXUP_ASUS_MODE1),
 	SND_PCI_QUIRK(0x1043, 0x1092, "ASUS NB", ALC662_FIXUP_ASUS_MODE3),
 	SND_PCI_QUIRK(0x1043, 0x1173, "ASUS K73Jn", ALC662_FIXUP_ASUS_MODE1),
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

