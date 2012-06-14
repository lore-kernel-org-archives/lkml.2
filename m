Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2FOAE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:04:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2FOAAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:11 -0400
Message-Id: <20120614235626.203530407@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 26/42] ALSA: HDA: Pin fixup for Zotac Z68 motherboard
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit edfe3bfc1b779ddda9bcff523eb022dda37b93c8 upstream.

Pin 0x1b was connected to the front panel connector, which according to
the HDA standard should contain a mic and a headphone. In this case,
the headphone was listed as "line out" by BIOS.

BugLink: https://bugs.launchpad.net/bugs/993162
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6606,6 +6606,7 @@ enum {
 	ALC662_FIXUP_ASUS_MODE7,
 	ALC662_FIXUP_ASUS_MODE8,
 	ALC662_FIXUP_NO_JACK_DETECT,
+	ALC662_FIXUP_ZOTAC_Z68,
 };
 
 static const struct alc_fixup alc662_fixups[] = {
@@ -6755,6 +6756,13 @@ static const struct alc_fixup alc662_fix
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc_fixup_no_jack_detect,
 	},
+	[ALC662_FIXUP_ZOTAC_Z68] = {
+		.type = ALC_FIXUP_PINS,
+		.v.pins = (const struct alc_pincfg[]) {
+			{ 0x1b, 0x02214020 }, /* Front HP */
+			{ }
+		}
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -6768,6 +6776,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
+	SND_PCI_QUIRK(0x19da, 0xa130, "Zotac Z68", ALC662_FIXUP_ZOTAC_Z68),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
 
 #if 0


