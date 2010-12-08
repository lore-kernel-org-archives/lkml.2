Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab0LHBar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:30:47 -0500
Received: from kroah.org ([198.145.64.141]:49120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932366Ab0LHBCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:01 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:37 2010
Message-Id: <20101208005737.328591150@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [159/289] ALSA: HDA: Add fixup pins for Ideapad Y550
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 6cb3b707f95954ac18f19b4b3919af235738371a upstream.

By adding the subwoofer as a speaker pin, it is treated correctly when auto-muting.

BugLink: https://launchpad.net/bugs/611803
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -18934,6 +18934,26 @@ static void alc662_auto_init(struct hda_
 		alc_inithook(codec);
 }
 
+enum {
+	ALC662_FIXUP_IDEAPAD,
+};
+
+static const struct alc_fixup alc662_fixups[] = {
+	[ALC662_FIXUP_IDEAPAD] = {
+		.pins = (const struct alc_pincfg[]) {
+			{ 0x17, 0x99130112 }, /* subwoofer */
+			{ }
+		}
+	},
+};
+
+static struct snd_pci_quirk alc662_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
+	{}
+};
+
+
+
 static int patch_alc662(struct hda_codec *codec)
 {
 	struct alc_spec *spec;
@@ -18966,6 +18986,7 @@ static int patch_alc662(struct hda_codec
 	}
 
 	if (board_config == ALC662_AUTO) {
+		alc_pick_fixup(codec, alc662_fixup_tbl, alc662_fixups, 1);
 		/* automatic parse from the BIOS config */
 		err = alc662_parse_auto_config(codec);
 		if (err < 0) {
@@ -19024,8 +19045,11 @@ static int patch_alc662(struct hda_codec
 	spec->vmaster_nid = 0x02;
 
 	codec->patch_ops = alc_patch_ops;
-	if (board_config == ALC662_AUTO)
+	if (board_config == ALC662_AUTO) {
 		spec->init_hook = alc662_auto_init;
+		alc_pick_fixup(codec, alc662_fixup_tbl, alc662_fixups, 0);
+	}
+
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	if (!spec->loopback.amplist)
 		spec->loopback.amplist = alc662_loopbacks;


