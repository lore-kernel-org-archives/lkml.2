Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0LLXrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36262 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab0LLXrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:05 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: crimsun@ubuntu.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [122/223] ALSA: hda: Use "alienware" model quirk for another SSID
Message-Id: <20101212234703.B7651B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit 0defe09ca70daccdc83abd9c3c24cd89ae6a1141 upstream.

BugLink: https://launchpad.net/bugs/683695

The original reporter states that headphone jacks do not appear to
work.  Upon inspecting his codec dump, and upon further testing, it is
confirmed that the "alienware" model quirk is correct.

Reported-and-tested-by: Cody Thierauf
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/sound/pci/hda/patch_sigmatel.c
===================================================================
--- linux.orig/sound/pci/hda/patch_sigmatel.c
+++ linux/sound/pci/hda/patch_sigmatel.c
@@ -1625,6 +1625,8 @@ static struct snd_pci_quirk stac92hd73xx
 static struct snd_pci_quirk stac92hd73xx_codec_id_cfg_tbl[] = {
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02a1,
 		      "Alienware M17x", STAC_ALIENWARE_M17X),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x043a,
+		      "Alienware M17x", STAC_ALIENWARE_M17X),
 	{} /* terminator */
 };
 
