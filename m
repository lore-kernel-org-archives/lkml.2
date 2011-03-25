Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893Ab1CZAXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:23:46 -0400
Received: from kroah.org ([198.145.64.141]:41603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab1CYXwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:48:41 2011
Message-Id: <20110325234841.129537716@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:47:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [21/55] ALSA: HDA: Fix internal mic on Dell E5420/E5520
In-Reply-To: <20110325234853.GA21145@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

This is a fixup for the 2.6.38 kernel, as the issue is being resolved
by upstream commits 699d899560cd7e72da39231e584412e7ac8114a4 and
094a42452abd5564429045e210281c6d22e67fca - which are too invasive
to reach 2.6.38. Instead make pin fixes as a workaround.

BugLink: http://bugs.launchpad.net/bugs/740055
Tested-by: Kent Baxley <kent.baxley@canonical.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Acked-by: Takashi Iwai <tiwai@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -94,6 +94,7 @@ enum {
 	STAC_92HD83XXX_REF,
 	STAC_92HD83XXX_PWR_REF,
 	STAC_DELL_S14,
+	STAC_DELL_E5520M,
 	STAC_92HD83XXX_HP,
 	STAC_HP_DV7_4000,
 	STAC_92HD83XXX_MODELS
@@ -1649,6 +1650,13 @@ static unsigned int dell_s14_pin_configs
 	0x40f000f0, 0x40f000f0,
 };
 
+/* Switch int mic from 0x20 to 0x11 */
+static unsigned int dell_e5520m_pin_configs[10] = {
+	0x04a11020, 0x0421101f, 0x400000f0, 0x90170110,
+	0x23011050, 0x23a1102e, 0x400000f3, 0xd5a30130,
+	0x400000f0, 0x40f000f0,
+};
+
 static unsigned int hp_dv7_4000_pin_configs[10] = {
 	0x03a12050, 0x0321201f, 0x40f000f0, 0x90170110,
 	0x40f000f0, 0x40f000f0, 0x90170110, 0xd5a30140,
@@ -1659,6 +1667,7 @@ static unsigned int *stac92hd83xxx_brd_t
 	[STAC_92HD83XXX_REF] = ref92hd83xxx_pin_configs,
 	[STAC_92HD83XXX_PWR_REF] = ref92hd83xxx_pin_configs,
 	[STAC_DELL_S14] = dell_s14_pin_configs,
+	[STAC_DELL_E5520M] = dell_e5520m_pin_configs,
 	[STAC_HP_DV7_4000] = hp_dv7_4000_pin_configs,
 };
 
@@ -1667,6 +1676,7 @@ static const char *stac92hd83xxx_models[
 	[STAC_92HD83XXX_REF] = "ref",
 	[STAC_92HD83XXX_PWR_REF] = "mic-ref",
 	[STAC_DELL_S14] = "dell-s14",
+	[STAC_DELL_E5520M] = "dell-e5520m",
 	[STAC_92HD83XXX_HP] = "hp",
 	[STAC_HP_DV7_4000] = "hp-dv7-4000",
 };
@@ -1679,6 +1689,14 @@ static struct snd_pci_quirk stac92hd83xx
 		      "DFI LanParty", STAC_92HD83XXX_REF),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02ba,
 		      "unknown Dell", STAC_DELL_S14),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x049a,
+		      "Dell E5520", STAC_DELL_E5520M),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x049b,
+		      "Dell E5420", STAC_DELL_E5520M),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x04eb,
+		      "Dell E5420m", STAC_DELL_E5520M),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x04ec,
+		      "Dell E5520m", STAC_DELL_E5520M),
 	SND_PCI_QUIRK_MASK(PCI_VENDOR_ID_HP, 0xff00, 0x3600,
 		      "HP", STAC_92HD83XXX_HP),
 	{} /* terminator */


