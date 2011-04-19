Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1DSURA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:00 -0400
Received: from kroah.org ([198.145.64.141]:47580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1DSUQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:16:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:44 2011
Message-Id: <20110419201044.248256921@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [10/70] ALSA: hda - Fix pin-config of Gigabyte mobo
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c6b358748e19ce7e230b0926ac42696bc485a562 upstream.

Use pin-fix instead of the static quirk for Gigabyte mobos 1458:a002.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=677256
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9932,7 +9932,6 @@ static struct snd_pci_quirk alc882_cfg_t
 	SND_PCI_QUIRK(0x1071, 0x8258, "Evesham Voyaeger", ALC883_LAPTOP_EAPD),
 	SND_PCI_QUIRK(0x10f1, 0x2350, "TYAN-S2350", ALC888_6ST_DELL),
 	SND_PCI_QUIRK(0x108e, 0x534d, NULL, ALC883_3ST_6ch),
-	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte P35 DS3R", ALC882_6ST_DIG),
 
 	SND_PCI_QUIRK(0x1462, 0x0349, "MSI", ALC883_TARGA_2ch_DIG),
 	SND_PCI_QUIRK(0x1462, 0x040d, "MSI", ALC883_TARGA_2ch_DIG),
@@ -10769,6 +10768,7 @@ enum {
 	PINFIX_LENOVO_Y530,
 	PINFIX_PB_M5210,
 	PINFIX_ACER_ASPIRE_7736,
+	PINFIX_GIGABYTE_880GM,
 };
 
 static const struct alc_fixup alc882_fixups[] = {
@@ -10800,6 +10800,13 @@ static const struct alc_fixup alc882_fix
 		.type = ALC_FIXUP_SKU,
 		.v.sku = ALC_FIXUP_SKU_IGNORE,
 	},
+	[PINFIX_GIGABYTE_880GM] = {
+		.type = ALC_FIXUP_PINS,
+		.v.pins = (const struct alc_pincfg[]) {
+			{ 0x14, 0x1114410 }, /* set as speaker */
+			{ }
+		}
+	},
 };
 
 static struct snd_pci_quirk alc882_fixup_tbl[] = {
@@ -10807,6 +10814,7 @@ static struct snd_pci_quirk alc882_fixup
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Y530", PINFIX_LENOVO_Y530),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", PINFIX_ABIT_AW9D_MAX),
 	SND_PCI_QUIRK(0x1025, 0x0296, "Acer Aspire 7736z", PINFIX_ACER_ASPIRE_7736),
+	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte", PINFIX_GIGABYTE_880GM),
 	{}
 };
 
@@ -18851,8 +18859,6 @@ static struct snd_pci_quirk alc662_cfg_t
 		      ALC662_3ST_6ch_DIG),
 	SND_PCI_QUIRK(0x1179, 0xff6e, "Toshiba NB20x", ALC662_AUTO),
 	SND_PCI_QUIRK(0x144d, 0xca00, "Samsung NC10", ALC272_SAMSUNG_NC10),
-	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte 945GCM-S2L",
-		      ALC662_3ST_6ch_DIG),
 	SND_PCI_QUIRK(0x152d, 0x2304, "Quanta WH1", ALC663_ASUS_H13),
 	SND_PCI_QUIRK(0x1565, 0x820f, "Biostar TA780G M2+", ALC662_3ST_6ch_DIG),
 	SND_PCI_QUIRK(0x1631, 0xc10c, "PB RS65", ALC663_ASUS_M51VA),
@@ -19526,6 +19532,7 @@ enum {
 	ALC662_FIXUP_IDEAPAD,
 	ALC272_FIXUP_MARIO,
 	ALC662_FIXUP_CZC_P10T,
+	ALC662_FIXUP_GIGABYTE,
 };
 
 static const struct alc_fixup alc662_fixups[] = {
@@ -19554,12 +19561,20 @@ static const struct alc_fixup alc662_fix
 			{}
 		}
 	},
+	[ALC662_FIXUP_GIGABYTE] = {
+		.type = ALC_FIXUP_PINS,
+		.v.pins = (const struct alc_pincfg[]) {
+			{ 0x14, 0x1114410 }, /* set as speaker */
+			{ }
+		}
+	},
 };
 
 static struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x0308, "Acer Aspire 8942G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
+	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte", ALC662_FIXUP_GIGABYTE),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),


