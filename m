Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0IRTaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:30:15 -0400
Received: from kroah.org ([198.145.64.141]:43453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab0IRTPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:20 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191302.423359289@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [059/129] ALSA: hda - Fix wrong HP pin detection in snd_hda_parse_pin_def_config()
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 122661b67899980f1372812d907e73ebcfb3d037 upstream.

snd_hda_parse_pin_def_config() has some workaround for re-assigning
some pins declared as headphones to line-outs.  This didn't work properly
for some cases because it used memmove() stupidly wrongly.

Reference: Novell bnc#637263
	https://bugzilla.novell.com/show_bug.cgi?id=637263

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4360,7 +4360,7 @@ int snd_hda_parse_pin_def_config(struct
 			cfg->hp_outs--;
 			memmove(cfg->hp_pins + i, cfg->hp_pins + i + 1,
 				sizeof(cfg->hp_pins[0]) * (cfg->hp_outs - i));
-			memmove(sequences_hp + i - 1, sequences_hp + i,
+			memmove(sequences_hp + i, sequences_hp + i + 1,
 				sizeof(sequences_hp[0]) * (cfg->hp_outs - i));
 		}
 	}


