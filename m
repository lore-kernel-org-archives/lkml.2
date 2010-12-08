Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab0LHBAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:08 -0500
Received: from kroah.org ([198.145.64.141]:48681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab0LHBAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:02 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:28 2010
Message-Id: <20101208005728.241752007@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [069/289] ALSA: hda - Fix wrong SPDIF NID assignment for CA0110
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 24b55c69b66eb2a122842820ec14ab215fc8572f upstream.

The dig_out_nid field must take a digital-converter widget, but the current
ca0110 parser passed the pin wrongly instead.

Reported-by: Wai Yew CHAY <wychay@ctl.creative.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_ca0110.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_ca0110.c
+++ b/sound/pci/hda/patch_ca0110.c
@@ -489,7 +489,7 @@ static void parse_digital(struct hda_cod
 	if (cfg->dig_outs &&
 	    snd_hda_get_connections(codec, cfg->dig_out_pins[0],
 				    &spec->dig_out, 1) == 1)
-		spec->multiout.dig_out_nid = cfg->dig_out_pins[0];
+		spec->multiout.dig_out_nid = spec->dig_out;
 }
 
 static int ca0110_parse_auto_config(struct hda_codec *codec)


