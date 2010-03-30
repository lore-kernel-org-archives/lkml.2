Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0C3Xs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:48:26 -0400
Received: from kroah.org ([198.145.64.141]:45909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482Ab0C3XTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:49 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:46 2010
Message-Id: <20100330224745.531111746@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [039/156] ALSA: hda: Use LPIB and 6stack-dig for eMachines T5212
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 572c0e3c73341755f3e7dfaaef6b26df12bd709c upstream.

BugLink: https://bugs.launchpad.net/bugs/538895

The OR has verified that both position_fix=1 and model=6stack-dig are
necessary to have capture function properly. (The existing 3stack-6ch
model quirk seems to be incorrect.)

Reported-by: Reuben Bailey <reuben.e.bailey@gmail.com>
Tested-by: Reuben Bailey <reuben.e.bailey@gmail.com>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c     |    1 +
 sound/pci/hda/patch_realtek.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2267,6 +2267,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1462, 0x1002, "MSI Wind U115", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1565, 0x820f, "Biostar Microtech", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x8086, 0xd601, "eMachines T5212", POS_FIX_LPIB),
 	{}
 };
 
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9101,7 +9101,7 @@ static struct snd_pci_quirk alc882_cfg_t
 	SND_PCI_QUIRK(0x8086, 0x0022, "DX58SO", ALC889_INTEL),
 	SND_PCI_QUIRK(0x8086, 0x0021, "Intel IbexPeak", ALC889A_INTEL),
 	SND_PCI_QUIRK(0x8086, 0x3b56, "Intel IbexPeak", ALC889A_INTEL),
-	SND_PCI_QUIRK(0x8086, 0xd601, "D102GGC", ALC883_3ST_6ch),
+	SND_PCI_QUIRK(0x8086, 0xd601, "D102GGC", ALC882_6ST_DIG),
 
 	{}
 };


