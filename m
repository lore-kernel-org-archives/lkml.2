Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab0FEMMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 08:12:16 -0400
Received: from smtp.nokia.com ([192.100.122.230]:29103 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab0FEMMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 08:12:15 -0400
From: imre.deak@nokia.com
To: LKML <linux-kernel@vger.kernel.org>
Cc: Imre Deak <imre.deak@nokia.com>, Andrew Morton <akpm@linux-foundation.org>,
       Zygo Blaxell <zygo.blaxell@xandros.com>, Tejun Heo <tj@kernel.org>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] genalloc: fix allocation from end of pool
Date: Sat,  5 Jun 2010 15:09:17 +0300
Message-Id: <bb57bd68cf450bc3430bc072269041355d798b7f.1275739617.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 05 Jun 2010 12:11:29.0923 (UTC) FILETIME=[3AE40530:01CB04A8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@nokia.com>

bitmap_find_next_zero_area requires the size of the bitmap, we instead
passed the last suitable position. This made it impossible to allocate
from the end of the pool.

Signed-off-by: Imre Deak <imre.deak@nokia.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Zygo Blaxell <zygo.blaxell@xandros.com>
CC: Tejun Heo <tj@kernel.org>
CC: Akinobu Mita <akinobu.mita@gmail.com>

---
 lib/genalloc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index 736c3b0..1923f14 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -128,7 +128,6 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 
 		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
-		end_bit -= nbits + 1;
 
 		spin_lock_irqsave(&chunk->lock, flags);
 		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit, 0,
-- 
1.7.1

