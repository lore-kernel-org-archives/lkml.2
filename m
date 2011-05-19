Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565Ab1ESTkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:40:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934494Ab1ESTig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 08/13] blk-throttle: Use helper function to add root throtl group to lists
Date: Thu, 19 May 2011 15:38:26 -0400
Message-Id: <1305833911-7717-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
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
index 97ea7f8..b9412d1 100644
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
1.7.4.4

