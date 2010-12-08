Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0LHBCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:01 -0500
Received: from kroah.org ([198.145.64.141]:49109 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352Ab0LHBB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:57 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:37 2010
Message-Id: <20101208005737.117471132@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [157/289] ALSA: hda - Fixed ALC887-VD initial error
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 01e0f1378c47947b825eac05c98697ab1be1c86f upstream.

ALC887-VD is like ALC888-VD. It can not be initialized as ALC882.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -19038,7 +19038,10 @@ static int patch_alc888(struct hda_codec
 {
 	if ((alc_read_coef_idx(codec, 0) & 0x00f0)==0x0030){
 		kfree(codec->chip_name);
-		codec->chip_name = kstrdup("ALC888-VD", GFP_KERNEL);
+		if (codec->vendor_id == 0x10ec0887)
+			codec->chip_name = kstrdup("ALC887-VD", GFP_KERNEL);
+		else
+			codec->chip_name = kstrdup("ALC888-VD", GFP_KERNEL);
 		if (!codec->chip_name) {
 			alc_free(codec);
 			return -ENOMEM;
@@ -19520,7 +19523,7 @@ static struct hda_codec_preset snd_hda_p
 	{ .id = 0x10ec0885, .rev = 0x100103, .name = "ALC889A",
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0885, .name = "ALC885", .patch = patch_alc882 },
-	{ .id = 0x10ec0887, .name = "ALC887", .patch = patch_alc882 },
+	{ .id = 0x10ec0887, .name = "ALC887", .patch = patch_alc888 },
 	{ .id = 0x10ec0888, .rev = 0x100101, .name = "ALC1200",
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0888, .name = "ALC888", .patch = patch_alc888 },


