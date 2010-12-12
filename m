Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0LMA2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:28:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44753 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0LLXpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [33/223] ALSA: hda - Fix wrong SPDIF NID assignment for CA0110
Message-Id: <20101212234529.98EC1B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 24b55c69b66eb2a122842820ec14ab215fc8572f upstream.

The dig_out_nid field must take a digital-converter widget, but the current
ca0110 parser passed the pin wrongly instead.

Reported-by: Wai Yew CHAY <wychay@ctl.creative.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_ca0110.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/sound/pci/hda/patch_ca0110.c
===================================================================
--- linux.orig/sound/pci/hda/patch_ca0110.c
+++ linux/sound/pci/hda/patch_ca0110.c
@@ -489,7 +489,7 @@ static void parse_digital(struct hda_cod
 	if (cfg->dig_outs &&
 	    snd_hda_get_connections(codec, cfg->dig_out_pins[0],
 				    &spec->dig_out, 1) == 1)
-		spec->multiout.dig_out_nid = cfg->dig_out_pins[0];
+		spec->multiout.dig_out_nid = spec->dig_out;
 }
 
 static int ca0110_parse_auto_config(struct hda_codec *codec)
