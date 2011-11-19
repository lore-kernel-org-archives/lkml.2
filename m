Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1KSAKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:10:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab1KSAKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:10:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:28 2011
Message-Id: <20111119000327.955788633@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Julian Wollrath <jwollrath@web.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [01/26] ALSA: hda - fix internal mic on Dell Vostro 3500 laptop
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Wollrath <jwollrath@web.de>

commit f7f9bdfadfda07afb904a9767468e38c2d1a6033 upstream.

Fix the not working internal mic on Dell Vostro 3500 laptop by introducing the
new model dell-vostro-3500.

Signed-off-by: Julian Wollrath <jwollrath@web.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 sound/pci/hda/patch_sigmatel.c               |   11 +++++++++++
 2 files changed, 12 insertions(+)

--- a/Documentation/sound/alsa/HD-Audio-Models.txt
+++ b/Documentation/sound/alsa/HD-Audio-Models.txt
@@ -408,6 +408,7 @@ STAC92HD83*
   ref		Reference board
   mic-ref	Reference board with power management for ports
   dell-s14	Dell laptop
+  dell-vostro-3500	Dell Vostro 3500 laptop
   hp		HP laptops with (inverted) mute-LED
   hp-dv7-4000	HP dv-7 4000
   auto		BIOS setup (default)
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -94,6 +94,7 @@ enum {
 	STAC_92HD83XXX_REF,
 	STAC_92HD83XXX_PWR_REF,
 	STAC_DELL_S14,
+	STAC_DELL_VOSTRO_3500,
 	STAC_92HD83XXX_HP,
 	STAC_92HD83XXX_HP_cNB11_INTQUAD,
 	STAC_HP_DV7_4000,
@@ -1658,6 +1659,12 @@ static const unsigned int dell_s14_pin_c
 	0x40f000f0, 0x40f000f0,
 };
 
+static const unsigned int dell_vostro_3500_pin_configs[10] = {
+	0x02a11020, 0x0221101f, 0x400000f0, 0x90170110,
+	0x400000f1, 0x400000f2, 0x400000f3, 0x90a60160,
+	0x400000f4, 0x400000f5,
+};
+
 static const unsigned int hp_dv7_4000_pin_configs[10] = {
 	0x03a12050, 0x0321201f, 0x40f000f0, 0x90170110,
 	0x40f000f0, 0x40f000f0, 0x90170110, 0xd5a30140,
@@ -1674,6 +1681,7 @@ static const unsigned int *stac92hd83xxx
 	[STAC_92HD83XXX_REF] = ref92hd83xxx_pin_configs,
 	[STAC_92HD83XXX_PWR_REF] = ref92hd83xxx_pin_configs,
 	[STAC_DELL_S14] = dell_s14_pin_configs,
+	[STAC_DELL_VOSTRO_3500] = dell_vostro_3500_pin_configs,
 	[STAC_92HD83XXX_HP_cNB11_INTQUAD] = hp_cNB11_intquad_pin_configs,
 	[STAC_HP_DV7_4000] = hp_dv7_4000_pin_configs,
 };
@@ -1683,6 +1691,7 @@ static const char * const stac92hd83xxx_
 	[STAC_92HD83XXX_REF] = "ref",
 	[STAC_92HD83XXX_PWR_REF] = "mic-ref",
 	[STAC_DELL_S14] = "dell-s14",
+	[STAC_DELL_VOSTRO_3500] = "dell-vostro-3500",
 	[STAC_92HD83XXX_HP] = "hp",
 	[STAC_92HD83XXX_HP_cNB11_INTQUAD] = "hp_cNB11_intquad",
 	[STAC_HP_DV7_4000] = "hp-dv7-4000",
@@ -1696,6 +1705,8 @@ static const struct snd_pci_quirk stac92
 		      "DFI LanParty", STAC_92HD83XXX_REF),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02ba,
 		      "unknown Dell", STAC_DELL_S14),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x1028,
+		      "Dell Vostro 3500", STAC_DELL_VOSTRO_3500),
 	SND_PCI_QUIRK_MASK(PCI_VENDOR_ID_HP, 0xff00, 0x3600,
 			  "HP", STAC_92HD83XXX_HP),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x1656,


