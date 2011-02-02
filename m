Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab1BBBMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:12:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:59383 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1BBAnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960285"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: crimsun@ubuntu.com, nikhov@linux.intel.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [6/139] ALSA: hda: Use model=lg quirk for LG P1 Express to enable playback and capture
Message-Id: <20110202004320.0461C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit 77c4d5cdb81d25a45fbdfb84dd3348121219a072 upstream.

BugLink: https://launchpad.net/bugs/595482

The original reporter states that audible playback from the internal
speaker is inaudible despite the hardware being properly detected.  To
work around this symptom, he uses the model=lg quirk to properly enable
both playback, capture, and jack sense.  Another user corroborates this
workaround on separate hardware.  Add this PCI SSID to the quirk table
to enable it for further LG P1 Expresses.

Reported-and-tested-by: Philip Peitsch <philip.peitsch@gmail.com>
Tested-by: nikhov
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
@@ -4240,6 +4240,7 @@ static struct snd_pci_quirk alc880_cfg_t
 	SND_PCI_QUIRK(0x1734, 0x10b0, "Fujitsu", ALC880_FUJITSU),
 	SND_PCI_QUIRK(0x1854, 0x0018, "LG LW20", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x1854, 0x003b, "LG", ALC880_LG),
+	SND_PCI_QUIRK(0x1854, 0x005f, "LG P1 Express", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0068, "LG w1", ALC880_LG),
 	SND_PCI_QUIRK(0x1854, 0x0077, "LG LW25", ALC880_LG_LW),
 	SND_PCI_QUIRK(0x19db, 0x4188, "TCL S700", ALC880_TCL_S700),
