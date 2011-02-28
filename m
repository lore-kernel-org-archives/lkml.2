Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1B1TZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:25:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580Ab1B1TZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:25:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com, neilb@suse.de
Subject: [PATCH 2/3] loop: No need to initialize ->queue_lock explicitly before calling blk_cleanup_queue()
Date: Mon, 28 Feb 2011 14:25:29 -0500
Message-Id: <1298921130-17533-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1298921130-17533-1-git-send-email-vgoyal@redhat.com>
References: <1298921130-17533-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Now we initialize ->queue_lock at queue allocation time so driver does
  not have to worry about initializing it before calling blk_cleanup_queue().
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
1.7.2.3

