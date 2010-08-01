Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab0HAOnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 10:43:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38694 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab0HAOnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 10:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UIFcHZR9padj4Ff7Uct7S/zxnB9hTfyH7XGNjA/kbHnw1ezbi3zwU0cKXJXn3xKE08
         rO/TkUtdQjqCKia7tqMVaP9TXgGTb9ZfLVch310JNChFDgQUZSCW+7y4gYyjASSx1zCa
         yfUpW6xAdqQwx2fRyVCjGizkTl0/qgy4Ri0so=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] writeback: remove wb in get_next_work_item
Date: Sun,  1 Aug 2010 23:42:54 +0900
Message-Id: <1280673774-8072-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

83ba7b07 cleans up the writeback.
So we don't use wb any more in get_next_work_item.
Let's remove unnecessary argument.

CC: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 fs/fs-writeback.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a178828..9a55257 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -712,7 +712,7 @@ static long wb_writeback(struct bdi_writeback *wb,
  * Return the next wb_writeback_work struct that hasn't been processed yet.
  */
 static struct wb_writeback_work *
-get_next_work_item(struct backing_dev_info *bdi, struct bdi_writeback *wb)
+get_next_work_item(struct backing_dev_info *bdi)
 {
 	struct wb_writeback_work *work = NULL;
 
@@ -770,7 +770,7 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 	struct wb_writeback_work *work;
 	long wrote = 0;
 
-	while ((work = get_next_work_item(bdi, wb)) != NULL) {
+	while ((work = get_next_work_item(bdi)) != NULL) {
 		/*
 		 * Override sync mode, in case we must wait for completion
 		 * because this thread is exiting now.
-- 
1.7.0.5

