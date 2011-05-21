Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab1EUAEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:04:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683Ab1EUACx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: dpshah@google.com, namhyung@gmail.com, vgoyal@redhat.com
Subject: [PATCH 3/3] block: call elv_bio_merged() when merged
Date: Fri, 20 May 2011 20:02:47 -0400
Message-Id: <1305936167-8932-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
References: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 73c101011926 ("block: initial patch for on-stack per-task plugging")
removed calls to elv_bio_merged() when @bio merged with @req. Re-add them.

This in turn will update merged stats in associated group. That
should be safe as long as request has got reference to the blkio_group.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Divyesh Shah <dpshah@google.com>
---
 block/blk-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7369eee..c8303e9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1122,6 +1122,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
+	elv_bio_merged(q, req, bio);
 	return true;
 }
 
@@ -1155,6 +1156,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
+	elv_bio_merged(q, req, bio);
 	return true;
 }
 
-- 
1.7.4.4

