Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab1F1Phy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758658Ab1F1PfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:35:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Cc: andrea@betterlinux.com, vgoyal@redhat.com
Subject: [PATCH 5/8] blk-throttle: get rid of extend slice trace message
Date: Tue, 28 Jun 2011 11:35:06 -0400
Message-Id: <1309275309-12889-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
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
index 506f4ec..ec41f6d 100644
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

