Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1FCVHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:07:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161Ab1FCVHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:07:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk
Cc: vgoyal@redhat.com, arighi@develer.com, fengguang.wu@intel.com,
        jack@suse.cz, akpm@linux-foundation.org
Subject: [PATCH 5/8] blk-throttle: Get rid of extend slice trace message
Date: Fri,  3 Jun 2011 17:06:46 -0400
Message-Id: <1307135209-30539-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1307135209-30539-1-git-send-email-vgoyal@redhat.com>
References: <1307135209-30539-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am about to introduce more tracing messages for task throttling. There
seem to be too many messages and I thought that this extend slice one
is not that useful. so kill it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 81df3ea..e52f630 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -515,9 +515,6 @@ static inline void throtl_extend_slice(struct throtl_data *td,
 		struct throtl_grp *tg, bool rw, unsigned long jiffy_end)
 {
 	tg->slice_end[rw] = roundup(jiffy_end, throtl_slice);
-	throtl_log_tg(td, tg, "[%c] extend slice start=%lu end=%lu jiffies=%lu",
-			rw == READ ? 'R' : 'W', tg->slice_start[rw],
-			tg->slice_end[rw], jiffies);
 }
 
 /* Determine if previously allocated or extended slice is complete or not */
-- 
1.7.4.4

