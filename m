Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab2AEMS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:18:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab2AEMQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:28 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/16] GFS2: Fix up "off by one" in the previous patch
Date: Thu,  5 Jan 2012 11:51:57 +0000
Message-Id: <1325764322-10807-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace point should take extlen and not *ndata as the
extent length.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b8935af..f1d1960 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1378,7 +1378,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *ndata,
 				  ip->i_inode.i_gid);
 
 	rgd->rd_free_clone -= extlen;
-	trace_gfs2_block_alloc(ip, block, *ndata,
+	trace_gfs2_block_alloc(ip, block, extlen,
 			       dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	*bn = block;
 	return 0;
-- 
1.7.4

