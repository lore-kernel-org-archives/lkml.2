Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3AIACQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:02:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:63415 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab3AHXhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 08/77] ALSA: hda - Reduce pci id list for Intel with class id
Date: Tue, 8 Jan 2013 18:34:47 -0500
Message-ID: <1357688156-25387-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b686453543fd56332e8730a2abd7bf5bca756149 upstream.

Most of Intel controllers work as generic HD-audio without quirks,
and it'll be hopefully so in future.  Let's mark pci id with the
PCI_CLASS_MULTIMEDIA_HD_AUDIO for Intel so that the driver will work
with any new control chips in future.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/pci/hda/hda_intel.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a1a1e82..144d41d 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2716,25 +2716,17 @@ static void __devexit azx_remove(struct pci_dev *pci)
 
 /* PCI IDs */
 static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
-	/* ICH 6..10 */
-	{ PCI_DEVICE(0x8086, 0x2668), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x27d8), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x269a), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x284b), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x2911), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x293e), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x293f), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x3a3e), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x3a6e), .driver_data = AZX_DRIVER_ICH },
-	/* PCH */
-	{ PCI_DEVICE(0x8086, 0x3b56), .driver_data = AZX_DRIVER_ICH },
-	{ PCI_DEVICE(0x8086, 0x3b57), .driver_data = AZX_DRIVER_ICH },
 	/* CPT */
 	{ PCI_DEVICE(0x8086, 0x1c20), .driver_data = AZX_DRIVER_PCH },
 	/* PBG */
 	{ PCI_DEVICE(0x8086, 0x1d20), .driver_data = AZX_DRIVER_PCH },
 	/* SCH */
 	{ PCI_DEVICE(0x8086, 0x811b), .driver_data = AZX_DRIVER_SCH },
+	/* Generic Intel */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_ANY_ID),
+	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
+	  .class_mask = 0xffffff,
+	  .driver_data = AZX_DRIVER_ICH },
 	/* ATI SB 450/600 */
 	{ PCI_DEVICE(0x1002, 0x437b), .driver_data = AZX_DRIVER_ATI },
 	{ PCI_DEVICE(0x1002, 0x4383), .driver_data = AZX_DRIVER_ATI },
-- 
1.7.12.1

