Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1G0Vs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:36327 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab1G0Vsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258278"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: crimsun@ubuntu.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [52/99] ALSA: hda: Fix quirk for Dell Inspiron 910
Message-Id: <20110727214851.423CB2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit 0a1896b27b030529ec770aefd790544a1bdb7d5a upstream.

BugLink: https://launchpad.net/bugs/792712

The original reporter states that sound from the internal speakers is
inaudible until using the model=auto quirk. This symptom is due to an
existing quirk mask for 0x102802b* that uses the model=dell quirk. To
limit the possible regressions, leave the existing quirk mask but add
a higher priority specific mask for the reporter's PCI SSID.

Reported-and-tested-by: rodni hipp
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/sound/pci/hda/patch_realtek.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/patch_realtek.c
+++ linux-2.6.35.y/sound/pci/hda/patch_realtek.c
@@ -13296,6 +13296,7 @@ static struct snd_pci_quirk alc268_cfg_t
 	SND_PCI_QUIRK(0x1025, 0x015b, "Acer Aspire One",
 						ALC268_ACER_ASPIRE_ONE),
 	SND_PCI_QUIRK(0x1028, 0x0253, "Dell OEM", ALC268_DELL),
+	SND_PCI_QUIRK(0x1028, 0x02b0, "Dell Inspiron 910", ALC268_AUTO),
 	SND_PCI_QUIRK_MASK(0x1028, 0xfff0, 0x02b0,
 			"Dell Inspiron Mini9/Vostro A90", ALC268_DELL),
 	/* almost compatible with toshiba but with optional digital outs;
