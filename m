Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2AJS2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:28:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab2AJS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:28:40 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dhsharp@google.com
Cc: linux-kernel@vger.kernel.org, winget@google.com, namhyung@gmail.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/9] block: block_bio_complete tracepoint was missing
Date: Tue, 10 Jan 2012 10:28:19 -0800
Message-Id: <1326220106-5765-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1326220106-5765-1-git-send-email-tj@kernel.org>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block_bio_complete tracepoint was defined but not invoked anywhere.
Fix it.

-tj: This will generate duplicate BLK_TA_COMPLETEs.  Namhyung is
     working on proper solution.

DO_NOT_APPLY
Cc: Namhyung Kim <namhyung@gmail.com>
---
 fs/bio.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b1fe82c..96548da 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1447,6 +1447,9 @@ void bio_endio(struct bio *bio, int error)
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	if (bio->bi_bdev)
+		trace_block_bio_complete(bdev_get_queue(bio->bi_bdev),
+					 bio, error);
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
-- 
1.7.3.1

