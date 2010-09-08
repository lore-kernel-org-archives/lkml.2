Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0IHOzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 10:55:42 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:49253 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613Ab0IHOzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 10:55:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: San Mehat <san@android.com>, Jens Axboe <axboe@kernel.dk>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] block: block_dump: Add number of sectors to debug output
Date: Wed, 8 Sep 2010 16:55:12 +0200
Message-ID: <1283957712-772-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: San Mehat <san@android.com>

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: San Mehat <san@android.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Found this in the Android tree, apparently it has never been
upstreamed so doing that now.
---
 block/blk-core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 29fd2cc..9b3d98e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1612,11 +1612,12 @@ void submit_bio(int rw, struct bio *bio)
 
 		if (unlikely(block_dump)) {
 			char b[BDEVNAME_SIZE];
-			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s\n",
+			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
 			current->comm, task_pid_nr(current),
 				(rw & WRITE) ? "WRITE" : "READ",
 				(unsigned long long)bio->bi_sector,
-				bdevname(bio->bi_bdev, b));
+				bdevname(bio->bi_bdev, b),
+				count);
 		}
 	}
 
-- 
1.6.3.3

