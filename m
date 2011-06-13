Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1FMPyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:54:51 -0400
Received: from mail.perches.com ([173.55.12.10]:2829 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1FMPyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:54:50 -0400
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] blk-throttle: Make total_nr_queued unsigned
Date: Mon, 13 Jun 2011 08:54:48 -0700
Message-Id: <f5e32f63cf03e8fb6f6b9c8e66a6ac0c4d5c3d45.1307980331.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: Vivek Goyal <vgoyal@redhat.com>

The total of two unsigned values should also be unsigned.

Update throtl_log output to unsigned.
Update total_nr_queued test to non-zero to be the
same as the other total_nr_queued tests.

Signed-off-by: Joe Perches <joe@perches.com>
---
 block/blk-throttle.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3689f83..f6a7941 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -142,9 +142,9 @@ static inline struct throtl_grp *tg_of_blkg(struct blkio_group *blkg)
 	return NULL;
 }
 
-static inline int total_nr_queued(struct throtl_data *td)
+static inline unsigned int total_nr_queued(struct throtl_data *td)
 {
-	return (td->nr_queued[0] + td->nr_queued[1]);
+	return td->nr_queued[0] + td->nr_queued[1];
 }
 
 static inline struct throtl_grp *throtl_ref_get_tg(struct throtl_grp *tg)
@@ -927,7 +927,7 @@ static int throtl_dispatch(struct request_queue *q)
 
 	bio_list_init(&bio_list_on_stack);
 
-	throtl_log(td, "dispatch nr_queued=%d read=%u write=%u",
+	throtl_log(td, "dispatch nr_queued=%u read=%u write=%u",
 			total_nr_queued(td), td->nr_queued[READ],
 			td->nr_queued[WRITE]);
 
@@ -970,7 +970,7 @@ throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 	struct delayed_work *dwork = &td->throtl_work;
 
 	/* schedule work if limits changed even if no bio is queued */
-	if (total_nr_queued(td) > 0 || td->limits_changed) {
+	if (total_nr_queued(td) || td->limits_changed) {
 		/*
 		 * We might have a work scheduled to be executed in future.
 		 * Cancel that and schedule a new one.
-- 
1.7.6.rc1

