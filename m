Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab2GKNuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:50:52 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:7961 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932603Ab2GKNuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAQEFJ1IQIDE8GwcSiBG9V5EuA5U6iSaGYIJh
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808137"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 8/9] staging: sm7xxfb: move pseudo palette into smtcfb_info
Date: Wed, 11 Jul 2012 15:49:40 +0200
Message-Id: <1342014581-2979-9-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
References: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch moves pseudo palette into smtcfb_info struct.

Tested with SM712.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 9dd2ef7..baee015 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -52,13 +52,13 @@ struct smtcfb_info {
 	u_int width;
 	u_int height;
 	u_int hz;
+
+	u32 colreg[17];
 };
 
 char __iomem *smtc_RegBaseAddress;	/* Memory Map IO starting address */
 char __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
 
-static u32 colreg[17];
-
 static struct fb_var_screeninfo smtcfb_var = {
 	.xres           = 1024,
 	.yres           = 600,
@@ -709,9 +709,9 @@ static struct smtcfb_info *smtc_alloc_fb_info(struct pci_dev *pdev, char *name)
 	sfb->fb.var.accel_flags = FB_ACCELF_TEXT;
 	sfb->fb.var.vmode = FB_VMODE_NONINTERLACED;
 
-	sfb->fb.par = sfb;
+	sfb->fb.pseudo_palette = sfb->colreg;
 
-	sfb->fb.pseudo_palette = colreg;
+	sfb->fb.par = sfb;
 
 	return sfb;
 }
-- 
1.7.10

