Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1H2DuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 23:50:14 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35432 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1H2Dtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 23:49:52 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 3/6] bounce: convert to __bio_endio() for bounced bio's
Date: Mon, 29 Aug 2011 12:47:37 +0900
Message-Id: <1314589660-2918-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
References: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use untraced __bio_endio() for nested bio handling path to
suppress duplicated trace event.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: linux-mm@kvack.org
---
 mm/bounce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/bounce.c b/mm/bounce.c
index 1481de68184b..c21289571d4d 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -142,7 +142,7 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
 		mempool_free(bvec->bv_page, pool);
 	}
 
-	bio_endio(bio_orig, err);
+	__bio_endio(bio_orig, err);
 	bio_put(bio);
 }
 
-- 
1.7.6

