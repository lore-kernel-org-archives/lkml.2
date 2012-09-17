Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab2IQOYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:24:19 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29453 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab2IQOXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:23:41 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkCABEvV1BbdWObgWdsb2JhbABEvBUiAQEWJieCIAEBBSdSECAxPBsHEogEulqLK4ZeA5ViiTWJVA
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="969870766"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 5/7] staging: sm7xxfb: rename some smtcfb_info fields
Date: Mon, 17 Sep 2012 16:12:51 +0200
Message-Id: <1347891173-13916-6-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
References: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch improves naming style and comments on smtcfb_info fields.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |   52 ++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 3fa55a8..1358fc7 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -43,11 +43,11 @@ struct smtcfb_info {
 	u16 chip_id;
 	u8  chip_rev_id;
 
-	void __iomem *m_pMMIO;
-	void __iomem *m_pLFB;
-	void __iomem *m_pDPR;
-	void __iomem *m_pVPR;
-	void __iomem *m_pCPR;
+	void __iomem *lfb;	/* linear frame buffer */
+	void __iomem *dp_regs;	/* drawing processor control regs */
+	void __iomem *vp_regs;	/* video processor control regs */
+	void __iomem *cp_regs;	/* capture processor control regs */
+	void __iomem *mmio;	/* memory map IO port */
 
 	u_int width;
 	u_int height;
@@ -551,28 +551,28 @@ static void sm7xx_set_timing(struct smtcfb_info *sfb)
 	smtc_mmiowb(0x67, 0x3c2);
 
 	/* set VPR registers */
-	writel(0x0, sfb->m_pVPR + 0x0C);
-	writel(0x0, sfb->m_pVPR + 0x40);
+	writel(0x0, sfb->vp_regs + 0x0C);
+	writel(0x0, sfb->vp_regs + 0x40);
 
 	/* set data width */
 	m_nScreenStride =
 		(sfb->width * sfb->fb.var.bits_per_pixel) / 64;
 	switch (sfb->fb.var.bits_per_pixel) {
 	case 8:
-		writel(0x0, sfb->m_pVPR + 0x0);
+		writel(0x0, sfb->vp_regs + 0x0);
 		break;
 	case 16:
-		writel(0x00020000, sfb->m_pVPR + 0x0);
+		writel(0x00020000, sfb->vp_regs + 0x0);
 		break;
 	case 24:
-		writel(0x00040000, sfb->m_pVPR + 0x0);
+		writel(0x00040000, sfb->vp_regs + 0x0);
 		break;
 	case 32:
-		writel(0x00030000, sfb->m_pVPR + 0x0);
+		writel(0x00030000, sfb->vp_regs + 0x0);
 		break;
 	}
 	writel((u32) (((m_nScreenStride + 2) << 16) | m_nScreenStride),
-	       sfb->m_pVPR + 0x10);
+	       sfb->vp_regs + 0x10);
 
 }
 
@@ -825,23 +825,23 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		sfb->fb.fix.mmio_len = 0x00400000;
 		smem_size = SM712_VIDEOMEMORYSIZE;
 #ifdef __BIG_ENDIAN
-		sfb->m_pLFB = (smtc_VRAMBaseAddress =
+		sfb->lfb = (smtc_VRAMBaseAddress =
 		    ioremap(pFramebufferPhysical, 0x00c00000));
 #else
-		sfb->m_pLFB = (smtc_VRAMBaseAddress =
+		sfb->lfb = (smtc_VRAMBaseAddress =
 		    ioremap(pFramebufferPhysical, 0x00800000));
 #endif
-		sfb->m_pMMIO = (smtc_RegBaseAddress =
+		sfb->mmio = (smtc_RegBaseAddress =
 		    smtc_VRAMBaseAddress + 0x00700000);
-		sfb->m_pDPR = smtc_VRAMBaseAddress + 0x00408000;
-		sfb->m_pVPR = sfb->m_pLFB + 0x0040c000;
+		sfb->dp_regs = smtc_VRAMBaseAddress + 0x00408000;
+		sfb->vp_regs = sfb->lfb + 0x0040c000;
 #ifdef __BIG_ENDIAN
 		if (sfb->fb.var.bits_per_pixel == 32) {
 			smtc_VRAMBaseAddress += 0x800000;
-			sfb->m_pLFB += 0x800000;
+			sfb->lfb += 0x800000;
 			dev_info(&pdev->dev,
-				 "smtc_VRAMBaseAddress=%p sfb->m_pLFB=%p",
-				  smtc_VRAMBaseAddress, sfb->m_pLFB);
+				 "smtc_VRAMBaseAddress=%p sfb->lfb=%p",
+				  smtc_VRAMBaseAddress, sfb->lfb);
 		}
 #endif
 		if (!smtc_RegBaseAddress) {
@@ -868,12 +868,12 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *pdev,
 		sfb->fb.fix.mmio_start = pFramebufferPhysical;
 		sfb->fb.fix.mmio_len = 0x00200000;
 		smem_size = SM722_VIDEOMEMORYSIZE;
-		sfb->m_pDPR = ioremap(pFramebufferPhysical, 0x00a00000);
-		sfb->m_pLFB = (smtc_VRAMBaseAddress =
-		    sfb->m_pDPR + 0x00200000);
-		sfb->m_pMMIO = (smtc_RegBaseAddress =
-		    sfb->m_pDPR + 0x000c0000);
-		sfb->m_pVPR = sfb->m_pDPR + 0x800;
+		sfb->dp_regs = ioremap(pFramebufferPhysical, 0x00a00000);
+		sfb->lfb = (smtc_VRAMBaseAddress =
+		    sfb->dp_regs + 0x00200000);
+		sfb->mmio = (smtc_RegBaseAddress =
+		    sfb->dp_regs + 0x000c0000);
+		sfb->vp_regs = sfb->dp_regs + 0x800;
 
 		smtc_seqw(0x62, 0xff);
 		smtc_seqw(0x6a, 0x0d);
-- 
1.7.10.4

