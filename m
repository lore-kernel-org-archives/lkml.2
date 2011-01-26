Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab1AZR3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:29:31 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56504 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab1AZR3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:29:30 -0500
Date: Wed, 26 Jan 2011 11:26:05 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] zram/xvmalloc: wrap debug code in #ifdef DEBUG
Message-ID: <20110126172605.GG8446@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110126172148.GB8446@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126172148.GB8446@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wraps the code, noted by comments as being debug code, with
#ifdef DEBUG so that it is removed from running in non-debug kernels.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/xvmalloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index b3622f1..172514e 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -219,7 +219,6 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
 static void remove_block_head(struct xv_pool *pool,
 			struct block_header *block, u32 slindex)
 {
-	struct block_header *tmpblock;
 	u32 flindex = slindex / BITS_PER_LONG;
 
 	pool->freelist[slindex].page = block->link.next_page;
@@ -232,6 +231,8 @@ static void remove_block_head(struct xv_pool *pool,
 		if (!pool->slbitmap[flindex])
 			__clear_bit(flindex, &pool->flbitmap);
 	} else {
+#ifdef DEBUG
+		struct block_header *tmpblock;
 		/*
 		 * DEBUG ONLY: We need not reinitialize freelist head previous
 		 * pointer to 0 - we never depend on its value. But just for
@@ -242,6 +243,7 @@ static void remove_block_head(struct xv_pool *pool,
 		tmpblock->link.prev_page = 0;
 		tmpblock->link.prev_offset = 0;
 		put_ptr_atomic(tmpblock, KM_USER1);
+#endif
 	}
 }
 
-- 
1.6.0.2

