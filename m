Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1JXMth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:49:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab1JXMru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:50 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/24] GFS2: Correctly set goal block after allocation
Date: Mon, 24 Oct 2011 13:48:31 +0100
Message-Id: <1319460518-9046-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new goal block should be set to the end of the newly
allocated extent, not the start of it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3088fb2..8ec4174 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1346,7 +1346,7 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 
 	rgd->rd_last_alloc = blk;
 	block = rgd->rd_data0 + blk;
-	ip->i_goal = block;
+	ip->i_goal = block + *n - 1;
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (error == 0) {
 		struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
-- 
1.7.4.4

