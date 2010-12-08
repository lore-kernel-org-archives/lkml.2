Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab0LHBf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:35:27 -0500
Received: from kroah.org ([198.145.64.141]:49001 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216Ab0LHBBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:25 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:34 2010
Message-Id: <20101208005734.769146064@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [134/289] ALSA: hda: Use BIOS auto-parsing instead of existing model quirk for MEDION MD2
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit ac70eb1305d5a81efd1e32327d7e79be15a63a5a upstream.

BugLink: https://launchpad.net/bugs/682199

A 2.6.35 (Ubuntu Maverick) user, burningphantom1, reported a regression
in audio: playback was inaudible through both speakers and headphones.
In commit 272a527c04 of sound-2.6.git, a new model was added with this
machine's PCI SSID.  Fortunately, it is now sufficient to use the auto
model for BIOS auto-parsing instead of the existing quirk.

Playback, capture, and jack sense were verified working for both
2.6.35 and the alsa-driver snapshot from 2010-11-27 when model=auto is
used.

Reported-and-tested-by: burningphantom1
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9664,7 +9664,6 @@ static struct snd_pci_quirk alc882_cfg_t
 	SND_PCI_QUIRK(0x17aa, 0x3bfc, "Lenovo NB0763", ALC883_LENOVO_NB0763),
 	SND_PCI_QUIRK(0x17aa, 0x3bfd, "Lenovo NB0763", ALC883_LENOVO_NB0763),
 	SND_PCI_QUIRK(0x17aa, 0x101d, "Lenovo Sky", ALC888_LENOVO_SKY),
-	SND_PCI_QUIRK(0x17c0, 0x4071, "MEDION MD2", ALC883_MEDION_MD2),
 	SND_PCI_QUIRK(0x17c0, 0x4085, "MEDION MD96630", ALC888_LENOVO_MS7195_DIG),
 	SND_PCI_QUIRK(0x17f2, 0x5000, "Albatron KI690-AM2", ALC883_6ST_DIG),
 	SND_PCI_QUIRK(0x1991, 0x5625, "Haier W66", ALC883_HAIER_W66),


