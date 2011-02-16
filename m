Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1BPBht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:37:49 -0500
Received: from kroah.org ([198.145.64.141]:39088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab1BPAU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:34 2011
Message-Id: <20110216001434.012952346@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [089/272] ALSA: hda - Fix multi-headphone handling for Realtek codecs
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b2d0576055bd1cafcd91a23cf85064815f1396cd upstream.

When multiple headphone pins are defined without line-out pins, the
driver takes them as primary outputs.  But it forgot to set line_out_type
to HP by assuming there is some rest of HP pins.  This results in some
mis-handling of these pins for Realtek codec parser.  It takes as if
these are pure line-out jacks.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_codec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4571,6 +4571,9 @@ int snd_hda_parse_pin_def_config(struct
 		}
 		memset(cfg->hp_pins + cfg->hp_outs, 0,
 		       sizeof(hda_nid_t) * (AUTO_CFG_MAX_OUTS - cfg->hp_outs));
+		if (!cfg->hp_outs)
+			cfg->line_out_type = AUTO_PIN_HP_OUT;
+
 	}
 
 	/* sort by sequence */


