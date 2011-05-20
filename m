Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935332Ab1ETF3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:29:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38329 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934850Ab1ETF3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:29:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dzmBZYcucb/fF+groy/1Ih9JmSHWqfbvCuk0gRULrxwkdBf0OhYriTzxYum0Gv4bWP
         CglNpvvSbXkUyu6wdvIaXoUbZWw7RApqrxaBZ4qTjjvorb7StK8YAe3V+rvtd40Z5NCC
         6Zoyr08u4zyfbbb6zF9ov4eDOpjy0v3sudEhs=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Divyesh Shah <dpshah@google.com>
Subject: [PATCH] block: call elv_bio_merged() when merged
Date: Fri, 20 May 2011 14:28:57 +0900
Message-Id: <1305869337-4375-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 73c101011926 ("block: initial patch for on-stack per-task plugging")
removed calls to elv_bio_merged() when @bio merged with @req. Re-add them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Divyesh Shah <dpshah@google.com>
---
 block/blk-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3fe00a14822a..4dc02ef5fc82 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1132,6 +1132,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
+	elv_bio_merged(q, req, bio);
 	return true;
 }
 
@@ -1173,6 +1174,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 	req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
 
 	drive_stat_acct(req, 0);
+	elv_bio_merged(q, req, bio);
 	return true;
 }
 
-- 
1.7.5

