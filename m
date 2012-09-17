Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2IQOY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:24:57 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:29453 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465Ab2IQOXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:23:36 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2012 10:23:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhkCABEvV1BbdWObgWdsb2JhbABEvBUiAQEWJieCIAEBBXkQIDE8GwcSiAS6WpIJA5Vikwk
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="969870763"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 4/7] staging: sm7xxfb: annotate iomem pointers
Date: Mon, 17 Sep 2012 16:12:50 +0200
Message-Id: <1347891173-13916-5-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
References: <1347891173-13916-1-git-send-email-jmunhoz@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patch annotates iomem pointers.

Signed-off-by: Javier M. Mellid <jmunhoz@igalia.com>
---
 drivers/staging/sm7xxfb/sm7xx.h   |    2 +-
 drivers/staging/sm7xxfb/sm7xxfb.c |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/sm7xxfb/sm7xx.h b/drivers/staging/sm7xxfb/sm7xx.h
index 333f33c..8599861 100644
--- a/drivers/staging/sm7xxfb/sm7xx.h
+++ b/drivers/staging/sm7xxfb/sm7xx.h
@@ -29,7 +29,7 @@
 #define dac_reg	(0x3c8)
 #define dac_val	(0x3c9)
 
-extern char __iomem *smtc_RegBaseAddress;
+extern void __iomem *smtc_RegBaseAddress;
 #define smtc_mmiowb(dat, reg)	writeb(dat, smtc_RegBaseAddress + reg)
 #define smtc_mmioww(dat, reg)	writew(dat, smtc_RegBaseAddress + reg)
 #define smtc_mmiowl(dat, reg)	writel(dat, smtc_RegBaseAddress + reg)
diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index 5ad52b9..3fa55a8 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -43,11 +43,11 @@ struct smtcfb_info {
 	u16 chip_id;
 	u8  chip_rev_id;
 
-	unsigned char __iomem *m_pMMIO;
-	char __iomem *m_pLFB;
-	char *m_pDPR;
-	char *m_pVPR;
-	char *m_pCPR;
+	void __iomem *m_pMMIO;
+	void __iomem *m_pLFB;
+	void __iomem *m_pDPR;
+	void __iomem *m_pVPR;
+	void __iomem *m_pCPR;
 
 	u_int width;
 	u_int height;
@@ -56,8 +56,8 @@ struct smtcfb_info {
 	u32 colreg[17];
 };
 
-char __iomem *smtc_RegBaseAddress;	/* Memory Map IO starting address */
-char __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
+void __iomem *smtc_RegBaseAddress;	/* Memory Map IO starting address */
+void __iomem *smtc_VRAMBaseAddress;	/* video memory starting address */
 
 static struct fb_var_screeninfo smtcfb_var = {
 	.xres           = 1024,
-- 
1.7.10.4

