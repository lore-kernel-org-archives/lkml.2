Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1CYXwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:52:15 -0400
Received: from kroah.org ([198.145.64.141]:41370 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab1CYXwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:08 2011
Message-Id: <20110325234508.396992972@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:43:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lydia Wang <lydiawang@viatech.com.cn>, Takashi Iwai <tiwai@suse.de>
Subject: [05/63] ALSA: hda - VIA: Fix invalid A-A path volume adjust issue
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lydia Wang <lydiawang@viatech.com.cn>

commit 169222813eec8403c76394fb7b35ecab98e3c607 upstream.

Modify vt_auto_create_analog_input_ctls() function to fix invalid a-a path
volume adjust issue for VT1708S, VT1702 and VT1716S codecs.

Signed-off-by: Lydia Wang <lydiawang@viatech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_via.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -2456,7 +2456,14 @@ static int vt_auto_create_analog_input_c
 		else
 			type_idx = 0;
 		label = hda_get_autocfg_input_label(codec, cfg, i);
-		err = via_new_analog_input(spec, label, type_idx, idx, cap_nid);
+		if (spec->codec_type == VT1708S ||
+		    spec->codec_type == VT1702 ||
+		    spec->codec_type == VT1716S)
+			err = via_new_analog_input(spec, label, type_idx,
+						   idx+1, cap_nid);
+		else
+			err = via_new_analog_input(spec, label, type_idx,
+						   idx, cap_nid);
 		if (err < 0)
 			return err;
 		snd_hda_add_imux_item(imux, label, idx, NULL);


