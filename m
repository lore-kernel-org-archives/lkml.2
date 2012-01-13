Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2AMPx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:53:56 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43115 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab2AMPxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:53:50 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 4/7] mtd: use for_each_clear_bit
Date: Sat, 14 Jan 2012 00:53:21 +0900
Message-Id: <1326470004-10096-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
References: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/chips/cfi_cmdset_0001.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index e1e122f..9bcd1f4 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -2526,12 +2526,10 @@ static void cfi_intelext_restore_locks(struct mtd_info *mtd)
 		if (!region->lockmap)
 			continue;
 
-		for (block = 0; block < region->numblocks; block++) {
+		for_each_clear_bit(block, region->lockmap, region->numblocks) {
 			len = region->erasesize;
 			adr = region->offset + block * len;
-
-			if (!test_bit(block, region->lockmap))
-				cfi_intelext_unlock(mtd, adr, len);
+			cfi_intelext_unlock(mtd, adr, len);
 		}
 	}
 }
-- 
1.7.4.4

