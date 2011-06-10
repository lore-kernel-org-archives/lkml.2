Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab1FJN3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab1FJN3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:29:07 -0400
From: Jerome Marchand <jmarchan@redhat.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 1/4] Staging: zram: Remove useless offset calculation in handle_uncompressed_page()
Date: Fri, 10 Jun 2011 15:28:46 +0200
Message-Id: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The offset of uncompressed page is always zero: handle_uncompressed_page()
doesn't have to care about it.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 drivers/staging/zram/zram_drv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index aab4ec4..3305e1a 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -194,8 +194,7 @@ static void handle_uncompressed_page(struct zram *zram,
 	unsigned char *user_mem, *cmem;
 
 	user_mem = kmap_atomic(page, KM_USER0);
-	cmem = kmap_atomic(zram->table[index].page, KM_USER1) +
-			zram->table[index].offset;
+	cmem = kmap_atomic(zram->table[index].page, KM_USER1);
 
 	memcpy(user_mem, cmem, PAGE_SIZE);
 	kunmap_atomic(user_mem, KM_USER0);
-- 
1.6.2.5

