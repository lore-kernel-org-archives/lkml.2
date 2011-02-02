Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1BBBMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:12:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:4379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab1BBAnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622214"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: david.henningsson@canonical.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [4/139] ALSA: HDA: Quirk for Dell Vostro 320 to make microphone work
Message-Id: <20110202004317.E16823E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Henningsson <david.henningsson@canonical.com>

commit 8a96b1e02029aa512199b1b6d281dcede9ed81f1 upstream.

BugLink: http://launchpad.net/497546

Confirmed that the ideapad model works better than the current
quirk for Dell Vostro 320.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_conexant.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.35.y/sound/pci/hda/patch_conexant.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/patch_conexant.c
+++ linux-2.6.35.y/sound/pci/hda/patch_conexant.c
@@ -3026,8 +3026,7 @@ static const char *cxt5066_models[CXT506
 static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x14f1, 0x0101, "Conexant Reference board",
 		      CXT5066_LAPTOP),
-	SND_PCI_QUIRK(0x1028, 0x02f5, "Dell",
-		      CXT5066_DELL_LAPTOP),
+	SND_PCI_QUIRK(0x1028, 0x02f5, "Dell Vostro 320", CXT5066_IDEAPAD),
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
 	SND_PCI_QUIRK(0x1028, 0x02d8, "Dell Vostro", CXT5066_DELL_VOSTO),
 	SND_PCI_QUIRK(0x1028, 0x0402, "Dell Vostro", CXT5066_DELL_VOSTO),
