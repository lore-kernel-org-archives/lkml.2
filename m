Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0LMAJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:09:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36244 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0LLXrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:01 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: herton@mandriva.com.br, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [119/223] ALSA: hda - Fix ALC660-VD/ALC861-VD capture/playback mixers
Message-Id: <20101212234700.8C413B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

commit 7167594a3da7dcc33203b85d62e519594baee390 upstream.

The mixer nids passed to alc_auto_create_input_ctls are wrong: 0x15 is
a pin, and 0x09 is the ADC on both ALC660-VD/ALC861-VD. Thus with
current code, input playback volume/switches and input source mixer
controls are not created, and recording doesn't work. Select correct
mixers, 0x0b (input playback mixer) and 0x22 (capture source mixer).

Reference: https://qa.mandriva.com/show_bug.cgi?id=61159

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/sound/pci/hda/patch_realtek.c
===================================================================
--- linux.orig/sound/pci/hda/patch_realtek.c
+++ linux/sound/pci/hda/patch_realtek.c
@@ -16302,7 +16302,7 @@ static struct alc_config_preset alc861vd
 static int alc861vd_auto_create_input_ctls(struct hda_codec *codec,
 						const struct auto_pin_cfg *cfg)
 {
-	return alc_auto_create_input_ctls(codec, cfg, 0x15, 0x09, 0);
+	return alc_auto_create_input_ctls(codec, cfg, 0x0b, 0x22, 0);
 }
 
 
