Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab1BPAU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:20:58 -0500
Received: from kroah.org ([198.145.64.141]:39178 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab1BPAUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:20:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:35 2011
Message-Id: <20110216001435.388228653@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [103/272] ALSA: hda - Fix missing CA initialization for HDMI/DP
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 11839aed21881d7edd65dd79f22a8eb18426f672 upstream.

The commit 53d7d69d8ffdfa60c5b66cc2e9ee0774aaaef5c0
    ALSA: hdmi - support infoframe for DisplayPort
dropped the initialization of CA field accidentally.
This resulted in only two-channel LPCM mode on Nvidia machines.

Reference: kernel bug 28592
	https://bugzilla.kernel.org/show_bug.cgi?id=28592

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_hdmi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -642,6 +642,7 @@ static void hdmi_setup_audio_infoframe(s
 			hdmi_ai->ver		= 0x01;
 			hdmi_ai->len		= 0x0a;
 			hdmi_ai->CC02_CT47	= channels - 1;
+			hdmi_ai->CA		= ca;
 			hdmi_checksum_audio_infoframe(hdmi_ai);
 		} else if (spec->sink_eld[i].conn_type == 1) { /* DisplayPort */
 			struct dp_audio_infoframe *dp_ai;
@@ -651,6 +652,7 @@ static void hdmi_setup_audio_infoframe(s
 			dp_ai->len		= 0x1b;
 			dp_ai->ver		= 0x11 << 2;
 			dp_ai->CC02_CT47	= channels - 1;
+			dp_ai->CA		= ca;
 		} else {
 			snd_printd("HDMI: unknown connection type at pin %d\n",
 				   pin_nid);


