Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1EKQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:16:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38331 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab1EKQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:16:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hy44ty+SyCUM2Q0YNoa9y69Mlp03BWdyYBgooCC21yIwl3P4MroZ/4JIt3zempt/MZ
         0gbLzri2uBRidMBFj5KhznppIM9IXUHAr4muafKAgXrNG6UoGzehkwTUrDUXRL6kfSLy
         n2d/LB4THe3GpVZ1keu/0CSsFTAuUp9v58jao=
From: Namhyung Kim <namhyung@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] blk-throttle: fix typos on struct throtl_grp init code
Date: Wed, 11 May 2011 22:20:45 +0900
Message-Id: <1305120045-5111-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <20110511130732.GB31633@redhat.com>
References: <20110511130732.GB31633@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/td/tg/

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0475a22a420d..d1e317e0fc34 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -201,7 +201,7 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 	RB_CLEAR_NODE(&tg->rb_node);
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
-	td->limits_changed = false;
+	tg->limits_changed = false;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1072,7 +1072,7 @@ int blk_throtl_init(struct request_queue *q)
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
 	tg->iops[0] = tg->iops[1] = -1;
-	td->limits_changed = false;
+	tg->limits_changed = false;
 
 	/*
 	 * Set root group reference to 2. One reference will be dropped when
-- 
1.7.5

