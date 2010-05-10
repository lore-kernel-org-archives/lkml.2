Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab0EJXQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:16:25 -0400
Received: from kroah.org ([198.145.64.141]:51792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab0EJW6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:05 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:38 2010
Message-Id: <20100510223538.724493996@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Subject: [48/98] ALSA: hda: Use LPIB quirk for DG965OT board version AAD63733-203
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel T Chen <crimsun@ubuntu.com>

commit 0e0280dc2b0c7395a880d25544b47f3e3e3f79db upstream.

BugLink: https://launchpad.net/bugs/459083

The OR has verified with 2.6.32.11 and the latest alsa-driver stable
daily snapshot that position_fix=1 is necessary for the external mic
to work and for PulseAudio not to crash constantly.

This patch is necessary also for 2.6.32.11 and 2.6.33.2.

Reported-by: <imwithid@yahoo.com>
Tested-by: <imwithid@yahoo.com>
Signed-off-by: Daniel T Chen <crimsun@ubuntu.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2236,6 +2236,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1462, 0x1002, "MSI Wind U115", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1565, 0x820f, "Biostar Microtech", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1565, 0x8218, "Biostar Microtech", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x8086, 0x2503, "DG965OT AAD63733-203", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x8086, 0xd601, "eMachines T5212", POS_FIX_LPIB),
 	{}
 };


