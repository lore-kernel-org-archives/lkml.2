Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab0C3X73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:59:29 -0400
Received: from kroah.org ([198.145.64.141]:45486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab0C3XS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:56 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:06 2010
Message-Id: <20100330225706.172984111@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [100/116] ALSA: hda: Use ALC260_WILL quirk for another Acer model (0x1025007f)
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 950200e2ff11daae1c5d9426703bdd494603f38b upstream.

BugLink: https://bugs.launchpad.net/bugs/418627

The original reporter states that this quirk is necessary to obtain
reasonable gain for playback.  Without it, sound is inaudible.  Tested
with playback (spkr and hp) and capture.

Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6252,6 +6252,7 @@ static const char *alc260_models[ALC260_
 
 static struct snd_pci_quirk alc260_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x007b, "Acer C20x", ALC260_ACER),
+	SND_PCI_QUIRK(0x1025, 0x007f, "Acer", ALC260_WILL),
 	SND_PCI_QUIRK(0x1025, 0x008f, "Acer", ALC260_ACER),
 	SND_PCI_QUIRK(0x1509, 0x4540, "Favorit 100XS", ALC260_FAVORIT100),
 	SND_PCI_QUIRK(0x103c, 0x2808, "HP d5700", ALC260_HP_3013),


