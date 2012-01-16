Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab2APSsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:48:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab2APSsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:48:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:16 2012
Message-Id: <20120116184516.451696824@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [08/48] ALSA: HDA: Fix master control for Cirrus Logic 421X
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 40d03e63e91af8ddccdfd5a536cc2a6e51433e1d upstream.

The control name "HP/Speakers" is non-standard, and since there is
only one DAC on this chip there is no need for a virtual master
anyway.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_cirrus.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -1756,30 +1756,19 @@ static int build_cs421x_output(struct hd
 	struct auto_pin_cfg *cfg = &spec->autocfg;
 	struct snd_kcontrol *kctl;
 	int err;
-	char *name = "HP/Speakers";
+	char *name = "Master";
 
 	fix_volume_caps(codec, dac);
-	if (!spec->vmaster_sw) {
-		err = add_vmaster(codec, dac);
-		if (err < 0)
-			return err;
-	}
 
 	err = add_mute(codec, name, 0,
 			HDA_COMPOSE_AMP_VAL(dac, 3, 0, HDA_OUTPUT), 0, &kctl);
 	if (err < 0)
 		return err;
-	err = snd_ctl_add_slave(spec->vmaster_sw, kctl);
-	if (err < 0)
-		return err;
 
 	err = add_volume(codec, name, 0,
 			HDA_COMPOSE_AMP_VAL(dac, 3, 0, HDA_OUTPUT), 0, &kctl);
 	if (err < 0)
 		return err;
-	err = snd_ctl_add_slave(spec->vmaster_vol, kctl);
-	if (err < 0)
-		return err;
 
 	if (cfg->speaker_outs) {
 		err = snd_hda_ctl_add(codec, 0,


