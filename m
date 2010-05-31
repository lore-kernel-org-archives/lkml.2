Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0EaHAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:00:54 -0400
Received: from sh.osrg.net ([192.16.179.4]:38177 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab0EaHAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:00:48 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: jens.axboe@oracle.com, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -mm 2/3] block: kill ISA_DMA_THRESHOLD usage
Date: Mon, 31 May 2010 15:59:03 +0900
Message-Id: <1275289144-28782-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1275289144-28782-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 31 May 2010 16:00:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block uses ISA_DMA_THRESHOLD for BLK_BOUNCE_ISA. Only SCSI uses
ISA_DMA_THRESHOLD for ancient drivers with non-zero
unchecked_isa_dma. Nowadays drivers (and subsystems) use dma_mask
properly instead of ISA_DMA_THRESHOLD.

Documentation/scsi/scsi_mid_low_api.txt says:

unchecked_isa_dma - 1=>only use bottom 16 MB of ram (ISA DMA addressing
                   restriction), 0=>can use full 32 bit (or better) DMA
                   address space

So block simply uses DMA_BIT_MASK(24) for BLK_BOUNCE_ISA for SCSI.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/blkdev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8b7f5e0..f95bdd1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -709,7 +709,7 @@ extern unsigned long blk_max_low_pfn, blk_max_pfn;
 #define BLK_BOUNCE_HIGH		-1ULL
 #endif
 #define BLK_BOUNCE_ANY		(-1ULL)
-#define BLK_BOUNCE_ISA		(ISA_DMA_THRESHOLD)
+#define BLK_BOUNCE_ISA		(DMA_BIT_MASK(24))
 
 /*
  * default timeout for SG_IO if none specified
-- 
1.6.5

