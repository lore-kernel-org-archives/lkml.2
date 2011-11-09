Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936256Ab1KJEG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:06:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965495Ab1KJDpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:21 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:01 2011
Message-Id: <20111109213201.858336409@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [194/264] ALSA: hda - Fix a regression for DMA-position check with CA0110
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 69f9ba9b0cad67bc03f0a096f7f274de795ca844 upstream.

The regression-fix in 3.1 for the check of DMA-position validity caused
yet another regression for CA0110.  As usual, this hardware seems working
only with LPIB properly.  Adding the appropriate driver-caps bit to force
LPIB fixes the problem.

Reported-and-tested-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2912,12 +2912,12 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids)
 	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
 	  .class_mask = 0xffffff,
 	  .driver_data = AZX_DRIVER_CTX | AZX_DCAPS_CTX_WORKAROUND |
-	  AZX_DCAPS_RIRB_PRE_DELAY },
+	  AZX_DCAPS_RIRB_PRE_DELAY | AZX_DCAPS_POSFIX_LPIB },
 #else
 	/* this entry seems still valid -- i.e. without emu20kx chip */
 	{ PCI_DEVICE(0x1102, 0x0009),
 	  .driver_data = AZX_DRIVER_CTX | AZX_DCAPS_CTX_WORKAROUND |
-	  AZX_DCAPS_RIRB_PRE_DELAY },
+	  AZX_DCAPS_RIRB_PRE_DELAY | AZX_DCAPS_POSFIX_LPIB },
 #endif
 	/* Vortex86MX */
 	{ PCI_DEVICE(0x17f3, 0x3010), .driver_data = AZX_DRIVER_GENERIC },


