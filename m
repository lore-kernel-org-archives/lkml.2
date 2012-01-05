Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202Ab2AEXnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:43:37 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57396 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932869Ab2AEXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:43:19 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/11] block: block_bio_complete tracepoint was missing
Date: Thu,  5 Jan 2012 15:42:46 -0800
Message-Id: <1325806974-23486-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325806974-23486-1-git-send-email-tj@kernel.org>
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block_bio_complete tracepoint was defined but not invoked anywhere.
Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
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

