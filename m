Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1H2DuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 23:50:18 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35432 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1H2Dty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 23:49:54 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/6] bio-integrity: convert to __bio_endio()
Date: Mon, 29 Aug 2011 12:47:38 +0900
Message-Id: <1314589660-2918-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
References: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use untraced __bio_endio() for nested bio handling path to
suppress duplicated trace event.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 9c5e6b2cd11a..85bebe1b77b5 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -541,7 +541,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 
 	/* Restore original bio completion handler */
 	bio->bi_end_io = bip->bip_end_io;
-	bio_endio(bio, error);
+	__bio_endio(bio, error);
 }
 
 /**
@@ -568,7 +568,7 @@ void bio_integrity_endio(struct bio *bio, int error)
 	 */
 	if (error) {
 		bio->bi_end_io = bip->bip_end_io;
-		bio_endio(bio, error);
+		__bio_endio(bio, error);
 
 		return;
 	}
-- 
1.7.6

