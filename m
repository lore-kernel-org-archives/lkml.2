Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0JAQUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:20:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab0JAQUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:20:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH 1/3] blkio-throttle: There is no need to convert jiffies to milli seconds
Date: Fri,  1 Oct 2010 12:20:27 -0400
Message-Id: <1285950029-30205-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
References: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Do not convert jiffies to mili seconds as it is not required. Just work
  with jiffies and HZ.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a467002..c1bc1b6 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -439,8 +439,7 @@ static bool tg_with_in_iops_limit(struct throtl_data *td, struct throtl_grp *tg,
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
 
-	io_allowed = (tg->iops[rw] * jiffies_to_msecs(jiffy_elapsed_rnd))
-				/ MSEC_PER_SEC;
+	io_allowed = (tg->iops[rw] * jiffy_elapsed_rnd) / HZ;
 
 	if (tg->io_disp[rw] + 1 <= io_allowed) {
 		if (wait)
@@ -476,8 +475,8 @@ static bool tg_with_in_bps_limit(struct throtl_data *td, struct throtl_grp *tg,
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
 
-	tmp = tg->bps[rw] * jiffies_to_msecs(jiffy_elapsed_rnd);
-	do_div(tmp, MSEC_PER_SEC);
+	tmp = tg->bps[rw] * jiffy_elapsed_rnd;
+	do_div(tmp, HZ);
 	bytes_allowed = tmp;
 
 	if (tg->bytes_disp[rw] + bio->bi_size <= bytes_allowed) {
-- 
1.7.2.3

