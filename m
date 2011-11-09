Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138Ab1KJDXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:23:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934113Ab1KJDW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:22:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:03 2011
Message-Id: <20111109212703.614595237@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Charles Chin <Charles.Chin@idt.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [033/262] ALSA: hda - Remove bad code for IDT 92HD83 family patch
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Chin <Charles.Chin@idt.com>

commit 6c5c04e509b7000617b09d4301f0b9b6d171d1e6 upstream.

The purpose of this patch is to remove a section of "bad" code that
assigns the last DAC to ports E or F in order to support notebooks
with docking in earlier days, around ALSA 1.0.19 - 21.  This is not
necessary now and actually breaks some configurations that use these
ports as other devices.  This have been tested on several different
configurations to make sure that it is working for different combinations.

Signed-off-by: Charles Chin <Charles.Chin@idt.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -5425,9 +5425,7 @@ static void stac92hd8x_fill_auto_spec(st
 static int patch_stac92hd83xxx(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
-	hda_nid_t conn[STAC92HD83_DAC_COUNT + 1];
 	int err;
-	int num_dacs;
 
 	spec  = kzalloc(sizeof(*spec), GFP_KERNEL);
 	if (spec == NULL)
@@ -5522,22 +5520,6 @@ again:
 		return err;
 	}
 
-	/* docking output support */
-	num_dacs = snd_hda_get_connections(codec, 0xF,
-				conn, STAC92HD83_DAC_COUNT + 1) - 1;
-	/* skip non-DAC connections */
-	while (num_dacs >= 0 &&
-			(get_wcaps_type(get_wcaps(codec, conn[num_dacs]))
-					!= AC_WID_AUD_OUT))
-		num_dacs--;
-	/* set port E and F to select the last DAC */
-	if (num_dacs >= 0) {
-		snd_hda_codec_write_cache(codec, 0xE, 0,
-			AC_VERB_SET_CONNECT_SEL, num_dacs);
-		snd_hda_codec_write_cache(codec, 0xF, 0,
-			AC_VERB_SET_CONNECT_SEL, num_dacs);
-	}
-
 	codec->proc_widget_hook = stac92hd_proc_hook;
 
 	return 0;


