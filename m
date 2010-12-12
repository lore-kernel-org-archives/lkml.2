Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0LLXqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36042 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab0LLXqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:33 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: crimsun@ubuntu.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [92/223] ALSA: hda: Use BIOS auto-parsing instead of existing model quirk for MEDION MD2
Message-Id: <20101212234632.0E54AB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/sound/pci/hda/patch_realtek.c
===================================================================
--- linux.orig/sound/pci/hda/patch_realtek.c
+++ linux/sound/pci/hda/patch_realtek.c
@@ -9472,7 +9472,6 @@ static struct snd_pci_quirk alc882_cfg_t
 	SND_PCI_QUIRK(0x17aa, 0x3bfc, "Lenovo NB0763", ALC883_LENOVO_NB0763),
 	SND_PCI_QUIRK(0x17aa, 0x3bfd, "Lenovo NB0763", ALC883_LENOVO_NB0763),
 	SND_PCI_QUIRK(0x17aa, 0x101d, "Lenovo Sky", ALC888_LENOVO_SKY),
-	SND_PCI_QUIRK(0x17c0, 0x4071, "MEDION MD2", ALC883_MEDION_MD2),
 	SND_PCI_QUIRK(0x17c0, 0x4085, "MEDION MD96630", ALC888_LENOVO_MS7195_DIG),
 	SND_PCI_QUIRK(0x17f2, 0x5000, "Albatron KI690-AM2", ALC883_6ST_DIG),
 	SND_PCI_QUIRK(0x1991, 0x5625, "Haier W66", ALC883_HAIER_W66),
