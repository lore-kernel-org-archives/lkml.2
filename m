Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab2DCFi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:38:28 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63720 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab2DCFi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:38:26 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mike Miller <mike.miller@hp.com>,
        iss_storagedev@hp.com
Subject: [PATCH] cciss: use check_signature
Date: Tue,  3 Apr 2012 14:38:52 +0900
Message-Id: <1333431534-4595-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1333431534-4595-1-git-send-email-akinobu.mita@gmail.com>
References: <1333431534-4595-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use check_signature to find a signature in the mmio address.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
---
 drivers/block/cciss.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index bda6d12..e04c63e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -42,8 +42,8 @@
 #include <linux/compat.h>
 #include <linux/mutex.h>
 #include <linux/bitmap.h>
+#include <linux/io.h>
 #include <asm/uaccess.h>
-#include <asm/io.h>
 
 #include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
@@ -4267,10 +4267,7 @@ static void __devinit cciss_find_board_params(ctlr_info_t *h)
 
 static inline bool CISS_signature_present(ctlr_info_t *h)
 {
-	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
-	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
-	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
-	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
+	if (!check_signature(h->cfgtable->Signature, "CISS", 4)) {
 		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
 		return false;
 	}
-- 
1.7.4.4

