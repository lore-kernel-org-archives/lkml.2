Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab2IKWOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:14:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab2IKWOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:14:15 -0400
From: raghu.prabhu13@gmail.com
To: xfs@oss.sgi.com
Cc: david@fromorbit.com, Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM),
        Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] XFS: Print error when xfs_ialloc_ag_select fails to find continuous free space.
Date: Wed, 12 Sep 2012 03:43:23 +0530
Message-Id: <b4227a4a67fb7b50bcf83fa369ba8999d3409d64.1347396641.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

When xfs_ialloc_ag_select fails to find any AG with continuous free blocks
required for inode allocation, printk the error in ratelimited manner.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_ialloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5aceb3f..e75a39d 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -539,8 +539,11 @@ nextag:
 		if (agno >= agcount)
 			agno = 0;
 		if (agno == pagno) {
-			if (flags == 0)
+			if (flags == 0) {
+				xfs_err_ratelimited(mp,
+					"Out of continuous free blocks for inode allocation");
 				return NULLAGNUMBER;
+			}
 			flags = 0;
 		}
 	}
-- 
1.7.12

