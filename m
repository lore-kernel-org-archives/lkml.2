Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2IQOXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:23:48 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29453 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab2IQOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:23:46 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkCABEvV1BbdWObgWdsb2JhbABEvBUiAQEWJieCIAEBBSdSECAxPBsHEogEulqCQ49GA5ViiTWJVA
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="969870769"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 6/7] staging: sm7xxfb: rename pFramebufferPhysical to mmio_base
Date: Mon, 17 Sep 2012 16:12:52 +0200
Message-Id: <1347891173-13916-7-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
References: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch renames pFramebufferPhysical name to mmio_base.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 1358fc7..11fb9f5 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -775,7 +775,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 	struct smtcfb_info *sfb;
 	u_long smem_size = 0x00800000;	/* default 8MB */
 	int err;
-	unsigned long pFramebufferPhysical;
+	unsigned long mmio_base;
 
 	dev_info(&pdev->dev, "Silicon Motion display driver.");
 
@@ -815,21 +815,21 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		sfb->fb.var.bits_per_pixel = (smtc_scr_info.lfb_depth = 32);
 #endif
 	/* Map address and memory detection */
-	pFramebufferPhysical = pci_resource_start(pdev, 0);
+	mmio_base = pci_resource_start(pdev, 0);
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &sfb->chip_rev_id);
 
 	switch (sfb->chip_id) {
 	case 0x710:
 	case 0x712:
-		sfb->fb.fix.mmio_start = pFramebufferPhysical + 0x00400000;
+		sfb->fb.fix.mmio_start = mmio_base + 0x00400000;
 		sfb->fb.fix.mmio_len = 0x00400000;
 		smem_size = SM712_VIDEOMEMORYSIZE;
 #ifdef __BIG_ENDIAN
 		sfb->lfb = (smtc_VRAMBaseAddress =
-		    ioremap(pFramebufferPhysical, 0x00c00000));
+		    ioremap(mmio_base, 0x00c00000));
 #else
 		sfb->lfb = (smtc_VRAMBaseAddress =
-		    ioremap(pFramebufferPhysical, 0x00800000));
+		    ioremap(mmio_base, 0x00800000));
 #endif
 		sfb->mmio = (smtc_RegBaseAddress =
 		    smtc_VRAMBaseAddress + 0x00700000);
@@ -865,10 +865,10 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 #endif
 		break;
 	case 0x720:
-		sfb->fb.fix.mmio_start = pFramebufferPhysical;
+		sfb->fb.fix.mmio_start = mmio_base;
 		sfb->fb.fix.mmio_len = 0x00200000;
 		smem_size = SM722_VIDEOMEMORYSIZE;
-		sfb->dp_regs = ioremap(pFramebufferPhysical, 0x00a00000);
+		sfb->dp_regs = ioremap(mmio_base, 0x00a00000);
 		sfb->lfb = (smtc_VRAMBaseAddress =
 		    sfb->dp_regs + 0x00200000);
 		sfb->mmio = (smtc_RegBaseAddress =
-- 
1.7.10.4

