Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0LMAUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:20:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44889 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0LLXp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:56 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: crimsun@ubuntu.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [58/223] ALSA: hda: Use hp-laptop quirk to enable headphones automute for Asus A52J
Message-Id: <20101212234556.07603B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit 673f7a8984c3a9e2cb1108ce221da1ebbd9e5d09 upstream.

BugLink: https://launchpad.net/bugs/677652

The original reporter states that, in 2.6.35, headphones do not appear
to work, nor does inserting them mute the A52J's onboard speakers.  Upon
inspecting the codec dump, it appears that the newly committed hp-laptop
quirk will suffice to enable this basic functionality.  Testing was done
with an alsa-driver build from 2010-11-21.

Reported-and-tested-by: Joan Creus
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/sound/pci/hda/patch_conexant.c
===================================================================
--- linux.orig/sound/pci/hda/patch_conexant.c
+++ linux/sound/pci/hda/patch_conexant.c
@@ -3033,6 +3033,7 @@ static struct snd_pci_quirk cxt5066_cfg_
 	SND_PCI_QUIRK(0x1028, 0x0402, "Dell Vostro", CXT5066_DELL_VOSTO),
 	SND_PCI_QUIRK(0x1028, 0x0408, "Dell Inspiron One 19T", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x103c, 0x360b, "HP G60", CXT5066_HP_LAPTOP),
+	SND_PCI_QUIRK(0x1043, 0x13f3, "Asus A52J", CXT5066_HP_LAPTOP),
 	SND_PCI_QUIRK(0x1179, 0xff50, "Toshiba Satellite P500-PSPGSC-01800T", CXT5066_OLPC_XO_1_5),
 	SND_PCI_QUIRK(0x1179, 0xffe0, "Toshiba Satellite Pro T130-15F", CXT5066_OLPC_XO_1_5),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400s", CXT5066_THINKPAD),
