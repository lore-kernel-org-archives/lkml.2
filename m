Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0LHBCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:13 -0500
Received: from kroah.org ([198.145.64.141]:49144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369Ab0LHBCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:08 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:37 2010
Message-Id: <20101208005737.839882305@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
        Takashi Iwai <tiwai@suse.de>
Subject: [164/289] ALSA: hda - Fix ALC660-VD/ALC861-VD capture/playback mixers
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -16557,7 +16557,7 @@ static struct alc_config_preset alc861vd
 static int alc861vd_auto_create_input_ctls(struct hda_codec *codec,
 						const struct auto_pin_cfg *cfg)
 {
-	return alc_auto_create_input_ctls(codec, cfg, 0x15, 0x09, 0);
+	return alc_auto_create_input_ctls(codec, cfg, 0x0b, 0x22, 0);
 }
 
 


