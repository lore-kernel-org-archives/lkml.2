Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0LLXrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:00 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36230 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0LLXq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:58 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: crimsun@ubuntu.com, david.henningsson@canonical.com, tiwai@suse.de,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [116/223] ALSA: hda: Add speaker pin to automute Acer Aspire 8943G
Message-Id: <20101212234657.63DB6B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit 2df03514de41f3bbb5623f2e7f2bf594e49cb2ec upstream.

BugLink: https://bugs.launchpad.net/bugs/656625

Add clause for handling Acer Aspire 8943G's subwoofer as additional
speaker pin for automuting.

Reported-by: RussianNeuroMancer
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/sound/pci/hda/patch_realtek.c
===================================================================
--- linux.orig/sound/pci/hda/patch_realtek.c
+++ linux/sound/pci/hda/patch_realtek.c
@@ -18680,10 +18680,17 @@ static void alc662_auto_init(struct hda_
 }
 
 enum {
+	ALC662_FIXUP_ASPIRE,
 	ALC662_FIXUP_IDEAPAD,
 };
 
 static const struct alc_fixup alc662_fixups[] = {
+	[ALC662_FIXUP_ASPIRE] = {
+		.pins = (const struct alc_pincfg[]) {
+			{ 0x15, 0x99130112 }, /* subwoofer */
+			{ }
+		}
+	},
 	[ALC662_FIXUP_IDEAPAD] = {
 		.pins = (const struct alc_pincfg[]) {
 			{ 0x17, 0x99130112 }, /* subwoofer */
@@ -18693,6 +18700,7 @@ static const struct alc_fixup alc662_fix
 };
 
 static struct snd_pci_quirk alc662_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	{}
