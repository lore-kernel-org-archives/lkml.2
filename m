Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1BFXpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:45:20 -0500
Received: from 1wt.eu ([62.212.114.60]:60258 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab1BFXpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:45:17 -0500
Message-Id: <20110206232252.576122815@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:22:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 01/23] ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

Index: longterm-2.6.27/sound/pci/hda/patch_realtek.c
===================================================================
--- longterm-2.6.27.orig/sound/pci/hda/patch_realtek.c	2011-01-29 11:19:14.761063991 +0100
+++ longterm-2.6.27/sound/pci/hda/patch_realtek.c	2011-01-29 11:26:53.367191052 +0100
@@ -3154,6 +3154,7 @@
 	SND_PCI_QUIRK(0x1734, 0x10b0, "Fujitsu", ALC880_FUJITSU),
 	SND_PCI_QUIRK(0x1854, 0x0018, "LG LW20", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x1854, 0x003b, "LG", ALC880_LG),
+	SND_PCI_QUIRK(0x1854, 0x005f, "LG P1 Express", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0068, "LG w1", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0077, "LG LW25", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x19db, 0x4188, "TCL S700", ALC880_TCL_S700),


