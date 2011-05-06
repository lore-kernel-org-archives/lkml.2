Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1EFANR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:13:17 -0400
Received: from kroah.org ([198.145.64.141]:32787 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1EFANN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:07 2011
Message-Id: <20110506001207.759379119@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [patch 05/38] ALSA: HDA: Fix automute for Gateway NV79
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 94024cd1aefa0f8bcc9dfe46c05bd7ce3f471a1c upstream.

The PCI SSID is 1025:031c and the codec SSID is 1025:031d,
so the driver mistakes this for a SKU value, but looking at
the numbers, this is obviously wrong.

BugLink: http://bugs.launchpad.net/bugs/761861
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -19556,6 +19556,7 @@ enum {
 	ALC272_FIXUP_MARIO,
 	ALC662_FIXUP_CZC_P10T,
 	ALC662_FIXUP_GIGABYTE,
+	ALC662_FIXUP_SKU_IGNORE,
 };
 
 static const struct alc_fixup alc662_fixups[] = {
@@ -19591,10 +19592,15 @@ static const struct alc_fixup alc662_fix
 			{ }
 		}
 	},
+	[ALC662_FIXUP_SKU_IGNORE] = {
+		.type = ALC_FIXUP_SKU,
+		.v.sku = ALC_FIXUP_SKU_IGNORE,
+	},
 };
 
 static struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x0308, "Acer Aspire 8942G", ALC662_FIXUP_ASPIRE),
+	SND_PCI_QUIRK(0x1025, 0x031c, "Gateway NV79", ALC662_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte", ALC662_FIXUP_GIGABYTE),


