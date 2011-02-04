Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab1BDIdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 03:33:24 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:44275 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1BDIdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 03:33:23 -0500
From: Simon Horman <horms@verge.net.au>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ian Molton <ian@mnementh.co.uk>, Chris Ball <cjb@laptop.org>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH] tmio_mmc: Improve readability of the output of pr_debug_status()
Date: Fri,  4 Feb 2011 17:33:07 +0900
Message-Id: <1296808387-21935-1-git-send-email-horms@verge.net.au>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Simon Horman <horms@verge.net.au>
---
 drivers/mmc/host/tmio_mmc.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 6f724de..811427d 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -237,12 +237,16 @@ static inline void tmio_mmc_kunmap_atomic(void *virt,
 
 #define STATUS_TO_TEXT(a) \
 	do { \
-		if (status & TMIO_STAT_##a) \
+		if (status & TMIO_STAT_##a) { \
+			if (i++) \
+				printk("|"); \
 			printk(#a); \
+		} \
 	} while (0)
 
 void pr_debug_status(u32 status)
 {
+	int i = 0;
 	printk(KERN_DEBUG "status: %08x = ", status);
 	STATUS_TO_TEXT(CARD_REMOVE);
 	STATUS_TO_TEXT(CARD_INSERT);
-- 
1.7.2.3

