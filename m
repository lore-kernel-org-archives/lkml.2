Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0H3Kx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:53:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53548 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab0H3KxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VNJ59KxDvdULZ6I9dH7LSU7WOjgTiJ5Dv/0Bfw16Vkhbqj0zDUpLyPDxIvRaTSLhdi
         OwY6FEf6gRDfeidhkKGQtfqC9/uvweKhIvVDY+0ijtpcwHlsZkguvMff9iF20yasL05F
         m3cBCTSl4aJZbVGkwUDA7BB8wYB6GCw/hrMJs=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 2/2] mtd: sm_ftl: cosmetic, use bool when possible
Date: Mon, 30 Aug 2010 13:53:09 +0300
Message-Id: <1283165589-10334-3-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283165589-10334-1-git-send-email-maximlevitsky@gmail.com>
References: <1283165589-10334-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't know that kernel allows use of that typedef.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/sm_ftl.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/sm_ftl.h b/drivers/mtd/sm_ftl.h
index e30e48e..43bb730 100644
--- a/drivers/mtd/sm_ftl.h
+++ b/drivers/mtd/sm_ftl.h
@@ -20,7 +20,7 @@
 
 
 struct ftl_zone {
-	int initialized;
+	bool initialized;
 	int16_t *lba_to_phys_table;		/* LBA to physical table */
 	struct kfifo free_sectors;	/* queue of free sectors */
 };
@@ -37,8 +37,8 @@ struct sm_ftl {
 	int zone_count;			/* number of zones */
 	int max_lba;			/* maximum lba in a zone */
 	int smallpagenand;		/* 256 bytes/page nand */
-	int readonly;			/* is FS readonly */
-	int unstable;
+	bool readonly;			/* is FS readonly */
+	bool unstable;
 	int cis_block;			/* CIS block location */
 	int cis_boffset;		/* CIS offset in the block */
 	int cis_page_offset;		/* CIS offset in the page */
@@ -49,7 +49,7 @@ struct sm_ftl {
 	int cache_zone;			/* zone of cached block */
 	unsigned char *cache_data;	/* cached block data */
 	long unsigned int cache_data_invalid_bitmap;
-	int cache_clean;
+	bool cache_clean;
 	struct work_struct flush_work;
 	struct timer_list timer;
 
-- 
1.7.0.4

