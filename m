Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1BVDxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:53:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab1BVDxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:53:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: neilb@suse.de, sergey.senozhatsky@gmail.com, tj@kernel.org,
        jmoyer@redhat.com, snitzer@redhat.com
Subject: [PATCH 2/3] loop: No need to initialize ->queue_lock explicitly before calling blk_cleanup_queue()
Date: Mon, 21 Feb 2011 22:53:36 -0500
Message-Id: <1298346817-26144-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
References: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Now we initialize ->queue_lock at queue allocation time so driver does
  not have to worry about initializing it before calling blk_cleanup_queue().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/loop.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 49e6a54..44e18c0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1641,9 +1641,6 @@ out:
 
 static void loop_free(struct loop_device *lo)
 {
-	if (!lo->lo_queue->queue_lock)
-		lo->lo_queue->queue_lock = &lo->lo_queue->__queue_lock;
-
 	blk_cleanup_queue(lo->lo_queue);
 	put_disk(lo->lo_disk);
 	list_del(&lo->lo_list);
-- 
1.7.1

