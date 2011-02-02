Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1BBAnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:35748 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1BBAnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883417909"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: crimsun@ubuntu.com, tiwai@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [5/139] ALSA: hda: Use position_fix=1 for Acer Aspire 5538 to enable capture on internal mic
Message-Id: <20110202004318.EDFD33E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel T Chen <crimsun@ubuntu.com>

commit dd5a089edfa51a74692604b4b427953d8e16bc35 upstream.

BugLink: https://launchpad.net/bugs/685161

The reporter of the bug states that he must use position_fix=1 to enable
capture for the internal microphone, so set it for his machine's PCI
SSID.  Verified using 2.6.35 and the 2010-12-04 alsa-driver build.

Reported-and-tested-by: Ralph Wabel <rwabel@gmx.net>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/sound/pci/hda/hda_intel.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/hda_intel.c
+++ linux-2.6.35.y/sound/pci/hda/hda_intel.c
@@ -2291,6 +2291,7 @@ static int azx_dev_free(struct snd_devic
  */
 static struct snd_pci_quirk position_fix_list[] __devinitdata = {
 	SND_PCI_QUIRK(0x1025, 0x009f, "Acer Aspire 5110", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1025, 0x026f, "Acer Aspire 5538", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1028, 0x01f6, "Dell Latitude 131L", POS_FIX_LPIB),
