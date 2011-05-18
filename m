Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab1ERTNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:13:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933642Ab1ERTNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:13:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 09/14] blk-throttle: Use helper function to add root throtl group to lists
Date: Wed, 18 May 2011 15:13:21 -0400
Message-Id: <1305746006-5837-10-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
References: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use same helper function for root group as we use with dynamically
allocated groups to add it to various lists.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c2c2888..5543c82 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1176,10 +1176,8 @@ int blk_throtl_init(struct request_queue *q)
 	td->root_tg = tg;
 
 	rcu_read_lock();
-	blkiocg_add_blkio_group(&blkio_root_cgroup, &tg->blkg, (void *)td,
-					0, BLKIO_POLICY_THROTL);
+	throtl_init_add_tg_lists(td, tg, &blkio_root_cgroup);
 	rcu_read_unlock();
-	throtl_add_group_to_td_list(td, tg);
 
 	/* Attach throtl data to request queue */
 	q->td = td;
-- 
1.7.1

