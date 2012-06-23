Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2FWGKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 02:10:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39832 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2FWGKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 02:10:46 -0400
From: Chad Williamson <chad@dahc.us>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH] Block: blk-cgroup: fixed compiler warning about unused local variable
Date: Sat, 23 Jun 2012 01:09:56 -0500
Message-Id: <1340431796-8581-1-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed an unnecessary local variable in blkg_destroy() which was
causing a compiler warning.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 block/blk-cgroup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 02cf633..14bd85c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -245,10 +245,9 @@ EXPORT_SYMBOL_GPL(blkg_lookup_create);
 
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
-	struct request_queue *q = blkg->q;
 	struct blkcg *blkcg = blkg->blkcg;
 
-	lockdep_assert_held(q->queue_lock);
+	lockdep_assert_held(blkg->q->queue_lock);
 	lockdep_assert_held(&blkcg->lock);
 
 	/* Something wrong if we are trying to remove same group twice */
-- 
1.7.7

