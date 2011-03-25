Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1CZAbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:31:19 -0400
Received: from kroah.org ([198.145.64.141]:44174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab1CYXwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:39 2011
Message-Id: <20110325234839.415527317@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:46:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lydia Wang <lydiawang@viatech.com.cn>, Takashi Iwai <tiwai@suse.de>
Subject: [05/55] ALSA: hda - VIA: Fix codec type for VT1708BCE at the right timing
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lydia Wang <lydiawang@viatech.com.cn>

commit 0341ccd7557fecafe6a79c55158670cf629d269e upstream.

Add get_codec_type() in via_new_spec() function to make sure getting
correct codec type before building mixer controls.

Signed-off-by: Lydia Wang <lydiawang@viatech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_via.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -159,6 +159,7 @@ struct via_spec {
 #endif
 };
 
+static enum VIA_HDA_CODEC get_codec_type(struct hda_codec *codec);
 static struct via_spec * via_new_spec(struct hda_codec *codec)
 {
 	struct via_spec *spec;
@@ -169,6 +170,10 @@ static struct via_spec * via_new_spec(st
 
 	codec->spec = spec;
 	spec->codec = codec;
+	spec->codec_type = get_codec_type(codec);
+	/* VT1708BCE & VT1708S are almost same */
+	if (spec->codec_type == VT1708BCE)
+		spec->codec_type = VT1708S;
 	return spec;
 }
 
@@ -2204,10 +2209,6 @@ static int via_init(struct hda_codec *co
 	for (i = 0; i < spec->num_iverbs; i++)
 		snd_hda_sequence_write(codec, spec->init_verbs[i]);
 
-	spec->codec_type = get_codec_type(codec);
-	if (spec->codec_type == VT1708BCE)
-		spec->codec_type = VT1708S; /* VT1708BCE & VT1708S are almost
-					       same */
 	/* Lydia Add for EAPD enable */
 	if (!spec->dig_in_nid) { /* No Digital In connection */
 		if (spec->dig_in_pin) {


