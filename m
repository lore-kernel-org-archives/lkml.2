Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab0DVUMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:12:34 -0400
Received: from kroah.org ([198.145.64.141]:59971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090Ab0DVUB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:29 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:16 2010
Message-Id: <20100422195416.074680243@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Piel <Eric.Piel@tremplin-utc.net>, Takashi Iwai <tiwai@suse.de>,
       maximilian attems <max@stro.at>
Subject: [106/139] ALSA: hda - Add position_fix quirk for Biostar mobo
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8815cd030fdd73932a791d1f06194c8db807cde7 upstream.

The Biostar mobo seems to give a wrong DMA position, resulting in
stuttering or skipping sounds on 2.6.34.  Since the commit
7b3a177b0d4f92b3431b8dca777313a07533a710, "ALSA: pcm_lib: fix "something
must be really wrong" condition", makes the position check more strictly,
the DMA position problem is revealed more clearly now.

The fix is to use only LPIB for obtaining the position, i.e. passing
position_fix=1.  This patch adds a static quirk to achieve it as default.

Reported-by: Frank Griffin <ftg@roadrunner.com>
Cc: Eric Piel <Eric.Piel@tremplin-utc.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2272,6 +2272,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1458, 0xa022, "ga-ma770-ud3", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1462, 0x1002, "MSI Wind U115", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1565, 0x820f, "Biostar Microtech", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1565, 0x8218, "Biostar Microtech", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x8086, 0xd601, "eMachines T5212", POS_FIX_LPIB),
 	{}
 };


