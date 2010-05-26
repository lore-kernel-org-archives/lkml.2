Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0EZNKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:10:15 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18007 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0EZNKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:10:12 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] writeback: fix non-integrity write-back
Date: Wed, 26 May 2010 16:08:40 +0300
Message-Id: <1274879320-11367-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
X-OriginalArrivalTime: 26 May 2010 13:10:04.0718 (UTC) FILETIME=[C1BDACE0:01CAFCD4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This is a fix for commit 7c8a3554. Note, I only compile-tested
this.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ea8592b..0242855 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -920,7 +920,7 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 		if (force_wait)
 			work->args.sync_mode = args.sync_mode = WB_SYNC_ALL;
 
-		post_clear = WB_SYNC_ALL || args.sb_pinned;
+		post_clear = args.sync_mode == WB_SYNC_ALL || args.sb_pinned;
 
 		/*
 		 * If this isn't a data integrity operation, just notify
-- 
1.6.6.1

