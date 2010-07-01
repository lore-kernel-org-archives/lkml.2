Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0GASyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:54:07 -0400
Received: from kroah.org ([198.145.64.141]:35348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757550Ab0GASWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:22:44 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:08 2010
Message-Id: <20100701173208.090187195@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:30:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 015/149] ALSA: hda: Fix model quirk for Dell M1730
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 66668b6fb6861fad7f6bfef6646ac84693474c9a upstream.

BugLink: https://launchpad.net/bugs/576160

Symptom: Currently (2.6.32.12) the Dell M1730 uses the 3stack model
quirk. Unfortunately this means that capture is not functional out-
of-the-box despite ensuring that capture settings are unmuted and
raised fully.

Test case: boot from Ubuntu 10.04 LTS live cd; capture does not
work.

Resolution: Correct the model quirk for Dell M1730 to rely on the
BIOS configuration.

This patch also trivially sorts the quirk into the correct section
based on the comments.

Reported-and-Tested-By: <picdragon99@msn.com>
Tested-By: Daren Hayward
Tested-By: Tobias Krais
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -2059,12 +2059,12 @@ static struct snd_pci_quirk stac927x_cfg
 	SND_PCI_QUIRK_MASK(PCI_VENDOR_ID_INTEL, 0xff00, 0x2000,
 			   "Intel D965", STAC_D965_3ST),
 	/* Dell 3 stack systems */
-	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x01f7, "Dell XPS M1730", STAC_DELL_3ST),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x01dd, "Dell Dimension E520", STAC_DELL_3ST),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x01ed, "Dell     ", STAC_DELL_3ST),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x01f4, "Dell     ", STAC_DELL_3ST),
 	/* Dell 3 stack systems with verb table in BIOS */
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x01f3, "Dell Inspiron 1420", STAC_DELL_BIOS),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x01f7, "Dell XPS M1730", STAC_DELL_BIOS),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x0227, "Dell Vostro 1400  ", STAC_DELL_BIOS),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x022e, "Dell     ", STAC_DELL_BIOS),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL,  0x022f, "Dell Inspiron 1525", STAC_DELL_BIOS),


