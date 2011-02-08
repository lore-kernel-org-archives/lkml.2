Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1BHWZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:25:33 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50839 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1BHWZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:25:31 -0500
From: Simon Horman <horms@verge.net.au>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Chris Ball <cjb@laptop.org>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH] [patch v4] tmio_mmc: Improve readability of the output of pr_debug_status()
Date: Wed,  9 Feb 2011 07:25:22 +0900
Message-Id: <1297203922-25669-1-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Simon Horman <horms@verge.net.au>

---

v2: As suggested by Guennadi Liakhovetski
* Pass status and i as parameters to STATUS_TO_TEXT
* Pad "|" with spaces to further improve readability

v3: Actually include the v2 changes
* My git-foo bites again

v4: Rebase against 2.6.38-rc4
---
 drivers/mmc/host/tmio_mmc.c |   50 +++++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index e3c6ef2..a33f718 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -228,36 +228,40 @@ static void tmio_mmc_kunmap_atomic(void *virt, unsigned long *flags)
 
 #ifdef CONFIG_MMC_DEBUG
 
-#define STATUS_TO_TEXT(a) \
+#define STATUS_TO_TEXT(a, status, i) \
 	do { \
-		if (status & TMIO_STAT_##a) \
+		if (status & TMIO_STAT_##a) { \
+			if (i++) \
+				printk(" | "); \
 			printk(#a); \
+		} \
 	} while (0)
 
 void pr_debug_status(u32 status)
 {
+	int i = 0;
 	printk(KERN_DEBUG "status: %08x = ", status);
-	STATUS_TO_TEXT(CARD_REMOVE);
-	STATUS_TO_TEXT(CARD_INSERT);
-	STATUS_TO_TEXT(SIGSTATE);
-	STATUS_TO_TEXT(WRPROTECT);
-	STATUS_TO_TEXT(CARD_REMOVE_A);
-	STATUS_TO_TEXT(CARD_INSERT_A);
-	STATUS_TO_TEXT(SIGSTATE_A);
-	STATUS_TO_TEXT(CMD_IDX_ERR);
-	STATUS_TO_TEXT(STOPBIT_ERR);
-	STATUS_TO_TEXT(ILL_FUNC);
-	STATUS_TO_TEXT(CMD_BUSY);
-	STATUS_TO_TEXT(CMDRESPEND);
-	STATUS_TO_TEXT(DATAEND);
-	STATUS_TO_TEXT(CRCFAIL);
-	STATUS_TO_TEXT(DATATIMEOUT);
-	STATUS_TO_TEXT(CMDTIMEOUT);
-	STATUS_TO_TEXT(RXOVERFLOW);
-	STATUS_TO_TEXT(TXUNDERRUN);
-	STATUS_TO_TEXT(RXRDY);
-	STATUS_TO_TEXT(TXRQ);
-	STATUS_TO_TEXT(ILL_ACCESS);
+	STATUS_TO_TEXT(CARD_REMOVE, status, i);
+	STATUS_TO_TEXT(CARD_INSERT, status, i);
+	STATUS_TO_TEXT(SIGSTATE, status, i);
+	STATUS_TO_TEXT(WRPROTECT, status, i);
+	STATUS_TO_TEXT(CARD_REMOVE_A, status, i);
+	STATUS_TO_TEXT(CARD_INSERT_A, status, i);
+	STATUS_TO_TEXT(SIGSTATE_A, status, i);
+	STATUS_TO_TEXT(CMD_IDX_ERR, status, i);
+	STATUS_TO_TEXT(STOPBIT_ERR, status, i);
+	STATUS_TO_TEXT(ILL_FUNC, status, i);
+	STATUS_TO_TEXT(CMD_BUSY, status, i);
+	STATUS_TO_TEXT(CMDRESPEND, status, i);
+	STATUS_TO_TEXT(DATAEND, status, i);
+	STATUS_TO_TEXT(CRCFAIL, status, i);
+	STATUS_TO_TEXT(DATATIMEOUT, status, i);
+	STATUS_TO_TEXT(CMDTIMEOUT, status, i);
+	STATUS_TO_TEXT(RXOVERFLOW, status, i);
+	STATUS_TO_TEXT(TXUNDERRUN, status, i);
+	STATUS_TO_TEXT(RXRDY, status, i);
+	STATUS_TO_TEXT(TXRQ, status, i);
+	STATUS_TO_TEXT(ILL_ACCESS, status, i);
 	printk("\n");
 }
 
-- 
1.7.2.3

