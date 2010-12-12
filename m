Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab0LMAKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:10:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36205 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0LLXqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:54 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: kailang@realtek.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [112/223] ALSA: hda - Fixed ALC887-VD initial error
Message-Id: <20101212234653.2DBB2B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Kailang Yang <kailang@realtek.com>

commit 01e0f1378c47947b825eac05c98697ab1be1c86f upstream.

ALC887-VD is like ALC888-VD. It can not be initialized as ALC882.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux/sound/pci/hda/patch_realtek.c
===================================================================
--- linux.orig/sound/pci/hda/patch_realtek.c
+++ linux/sound/pci/hda/patch_realtek.c
@@ -18783,7 +18783,10 @@ static int patch_alc888(struct hda_codec
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
@@ -18825,7 +18828,7 @@ static struct hda_codec_preset snd_hda_p
 	{ .id = 0x10ec0885, .rev = 0x100103, .name = "ALC889A",
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0885, .name = "ALC885", .patch = patch_alc882 },
-	{ .id = 0x10ec0887, .name = "ALC887", .patch = patch_alc882 },
+	{ .id = 0x10ec0887, .name = "ALC887", .patch = patch_alc888 },
 	{ .id = 0x10ec0888, .rev = 0x100101, .name = "ALC1200",
 	  .patch = patch_alc882 },
 	{ .id = 0x10ec0888, .name = "ALC888", .patch = patch_alc888 },
