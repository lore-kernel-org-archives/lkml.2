Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab1AEXM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:12:56 -0500
Received: from kroah.org ([198.145.64.141]:50689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1AEXGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:15 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:23 2011
Message-Id: <20110105230323.863925823@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [05/49] ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 77c4d5cdb81d25a45fbdfb84dd3348121219a072 upstream.

BugLink: https://launchpad.net/bugs/595482

The original reporter states that audible playback from the internal
speaker is inaudible despite the hardware being properly detected.  To
work around this symptom, he uses the model=lg quirk to properly enable
both playback, capture, and jack sense.  Another user corroborates this
workaround on separate hardware.  Add this PCI SSID to the quirk table
to enable it for further LG P1 Expresses.

Reported-and-tested-by: Philip Peitsch <philip.peitsch@gmail.com>
Tested-by: nikhov
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3975,6 +3975,7 @@ static struct snd_pci_quirk alc880_cfg_t
 	SND_PCI_QUIRK(0x1734, 0x10b0, "Fujitsu", ALC880_FUJITSU),
 	SND_PCI_QUIRK(0x1854, 0x0018, "LG LW20", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x1854, 0x003b, "LG", ALC880_LG),
+	SND_PCI_QUIRK(0x1854, 0x005f, "LG P1 Express", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0068, "LG w1", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0077, "LG LW25", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x19db, 0x4188, "TCL S700", ALC880_TCL_S700),


