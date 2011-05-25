Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab1EYUpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:45:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37880 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab1EYUpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=f1FC1s+f7EJPSFx94y5eM08zeNdSWo+KylRXsZsEMr/wEmhMYSyYTpLL2YyQAOwqt4
         oCx4mhsh4YoZPA0ZHMvWLYv5pxmyPTnk4YYZQQ/jK6npU2U0ttxRdG8+LGHpRCGETC2B
         NYK7Wi35HNrkKUrOhfIN7wA173BZbDbobZndk=
Date: Wed, 25 May 2011 22:45:06 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] bio_attempt_front_merge: remove unused variable.
Message-ID: <20110525204506.GA24207@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sector is never read inside the function.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---
 block/blk-core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3fe00a1..1439bac 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1139,7 +1139,6 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 				    struct request *req, struct bio *bio)
 {
 	const int ff = bio->bi_rw & REQ_FAILFAST_MASK;
-	sector_t sector;
 
 	/*
 	 * Debug stuff, kill later
@@ -1157,8 +1156,6 @@ static bool bio_attempt_front_merge(struct request_queue *q,
 	if ((req->cmd_flags & REQ_FAILFAST_MASK) != ff)
 		blk_rq_set_mixed_merge(req);
 
-	sector = bio->bi_sector;
-
 	bio->bi_next = req->bio;
 	req->bio = bio;
 
-- 
1.7.5.1
