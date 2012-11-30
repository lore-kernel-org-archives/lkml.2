Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab2K3LoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:44:17 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56810 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642Ab2K3LoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:44:13 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v4 1/3] davinci: vpss: dm365: enable ISP registers
Date: Fri, 30 Nov 2012 17:13:39 +0530
Message-Id: <1354275821-25235-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354275821-25235-1-git-send-email-prabhakar.lad@ti.com>
References: <1354275821-25235-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

enable the clocks required for VPFE to work in PCCR register,
and enbale ISIF out on BCR to get the correct operation from ISIF.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/platform/davinci/vpss.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 146e4b0..1c96ce8 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -51,7 +51,18 @@ MODULE_AUTHOR("Texas Instruments");
 /* VENCINT - vpss_int8 */
 #define DM355_VPSSBL_EVTSEL_DEFAULT	0x4
 
-#define DM365_ISP5_PCCR 		0x04
+#define DM365_ISP5_PCCR				0x04
+#define DM365_ISP5_PCCR_BL_CLK_ENABLE		BIT(0)
+#define DM365_ISP5_PCCR_ISIF_CLK_ENABLE		BIT(1)
+#define DM365_ISP5_PCCR_H3A_CLK_ENABLE		BIT(2)
+#define DM365_ISP5_PCCR_RSZ_CLK_ENABLE		BIT(3)
+#define DM365_ISP5_PCCR_IPIPE_CLK_ENABLE	BIT(4)
+#define DM365_ISP5_PCCR_IPIPEIF_CLK_ENABLE	BIT(5)
+#define DM365_ISP5_PCCR_RSV			BIT(6)
+
+#define DM365_ISP5_BCR			0x08
+#define DM365_ISP5_BCR_ISIF_OUT_ENABLE	BIT(1)
+
 #define DM365_ISP5_INTSEL1		0x10
 #define DM365_ISP5_INTSEL2		0x14
 #define DM365_ISP5_INTSEL3		0x18
@@ -426,6 +437,16 @@ static int __devinit vpss_probe(struct platform_device *pdev)
 		oper_cfg.hw_ops.enable_clock = dm365_enable_clock;
 		oper_cfg.hw_ops.select_ccdc_source = dm365_select_ccdc_source;
 		/* Setup vpss interrupts */
+		isp5_write((isp5_read(DM365_ISP5_PCCR) |
+				      DM365_ISP5_PCCR_BL_CLK_ENABLE |
+				      DM365_ISP5_PCCR_ISIF_CLK_ENABLE |
+				      DM365_ISP5_PCCR_H3A_CLK_ENABLE |
+				      DM365_ISP5_PCCR_RSZ_CLK_ENABLE |
+				      DM365_ISP5_PCCR_IPIPE_CLK_ENABLE |
+				      DM365_ISP5_PCCR_IPIPEIF_CLK_ENABLE |
+				      DM365_ISP5_PCCR_RSV), DM365_ISP5_PCCR);
+		isp5_write((isp5_read(DM365_ISP5_BCR) |
+			    DM365_ISP5_BCR_ISIF_OUT_ENABLE), DM365_ISP5_BCR);
 		isp5_write(DM365_ISP5_INTSEL1_DEFAULT, DM365_ISP5_INTSEL1);
 		isp5_write(DM365_ISP5_INTSEL2_DEFAULT, DM365_ISP5_INTSEL2);
 		isp5_write(DM365_ISP5_INTSEL3_DEFAULT, DM365_ISP5_INTSEL3);
-- 
1.7.4.1

