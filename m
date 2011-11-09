Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232Ab1KJEBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:01:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965857Ab1KJDqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:46:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:01 2011
Message-Id: <20111109213201.455602739@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Charles Chin <Charles.Chin@idt.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [190/264] ALSA: hda - Add support for 92HD65 / 92HD66 family of codecs
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Chin <Charles.Chin@idt.com>

commit ad5d8755116b431f0709c745ee17cb567a478d43 upstream.

These codecs have SPDIF-in, which is new to the 92HD83xxx compatible
families, so a bit of logic is added to support them.

Signed-off-by: Charles Chin <Charles.Chin@idt.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -5653,7 +5653,11 @@ again:
 	}
 #endif	
 
-	err = stac92xx_parse_auto_config(codec, 0x1d, 0);
+	/* 92HD65/66 series has S/PDIF-IN */
+	if (codec->vendor_id >= 0x111d76e8 && codec->vendor_id <= 0x111d76f3)
+		err = stac92xx_parse_auto_config(codec, 0x1d, 0x22);
+	else
+		err = stac92xx_parse_auto_config(codec, 0x1d, 0);
 	if (!err) {
 		if (spec->board_config < 0) {
 			printk(KERN_WARNING "hda_codec: No auto-config is "
@@ -6543,6 +6547,18 @@ static const struct hda_codec_preset snd
 	{ .id = 0x111d76e3, .name = "92HD98BXX", .patch = patch_stac92hd83xxx},
 	{ .id = 0x111d76e5, .name = "92HD99BXX", .patch = patch_stac92hd83xxx},
 	{ .id = 0x111d76e7, .name = "92HD90BXX", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76e8, .name = "92HD66B1X5", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76e9, .name = "92HD66B2X5", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76ea, .name = "92HD66B3X5", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76eb, .name = "92HD66C1X5", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76ec, .name = "92HD66C2X5", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76ed, .name = "92HD66C3X5", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76ee, .name = "92HD66B1X3", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76ef, .name = "92HD66B2X3", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76f0, .name = "92HD66B3X3", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76f1, .name = "92HD66C1X3", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76f2, .name = "92HD66C2X3", .patch = patch_stac92hd83xxx},
+	{ .id = 0x111d76f3, .name = "92HD66C3/65", .patch = patch_stac92hd83xxx},
 	{} /* terminator */
 };
 


