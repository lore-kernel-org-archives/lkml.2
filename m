Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0DVTk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:40:59 -0400
Received: from kroah.org ([198.145.64.141]:41383 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab0DVT3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:30 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:20 2010
Message-Id: <20100422190920.735988034@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Piel <Eric.Piel@tremplin-utc.net>, Takashi Iwai <tiwai@suse.de>,
       maximilian attems <max@stro.at>
Subject: [150/197] ALSA: hda - Add position_fix quirk for Biostar mobo
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2235,6 +2235,7 @@ static struct snd_pci_quirk position_fix
 	SND_PCI_QUIRK(0x1458, 0xa022, "ga-ma770-ud3", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1462, 0x1002, "MSI Wind U115", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x1565, 0x820f, "Biostar Microtech", POS_FIX_LPIB),
+	SND_PCI_QUIRK(0x1565, 0x8218, "Biostar Microtech", POS_FIX_LPIB),
 	SND_PCI_QUIRK(0x8086, 0xd601, "eMachines T5212", POS_FIX_LPIB),
 	{}
 };


