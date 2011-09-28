Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1I1FV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:21:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63952 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab1I1FV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:21:56 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: mark block device queue as non-rotational
Date: Wed, 28 Sep 2011 00:21:42 -0500
Message-Id: <1317187302-13380-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to what the nbd driver does, among others.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index ca38569..ed8b5e7 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -426,6 +426,8 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	new->rq->queuedata = new;
 	blk_queue_logical_block_size(new->rq, tr->blksize);
 
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, new->rq);
+
 	if (tr->discard) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, new->rq);
 		new->rq->limits.max_discard_sectors = UINT_MAX;
-- 
1.7.6.4

