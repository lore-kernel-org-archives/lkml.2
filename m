Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2AEMSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:18:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab2AEMQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:16:23 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/16] GFS2: remove vestigial al_alloced
Date: Thu,  5 Jan 2012 11:51:54 +0000
Message-Id: <1325764322-10807-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
References: <1325764322-10807-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch removes the vestigial variable al_alloced from
the gfs2_alloc structure. This is another baby step toward
multi-block reservations.

My next planned step is to decouple the quota variables
from the gfs2_alloc structure so we can use a different
method for allocations.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 7389dfd..32f5bec 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -251,7 +251,6 @@ struct gfs2_alloc {
 	unsigned int al_qd_num;
 
 	u32 al_requested; /* Filled in by caller of gfs2_inplace_reserve() */
-	u32 al_alloced; /* Filled in by gfs2_alloc_*() */
 
 	/* Filled in by gfs2_inplace_reserve() */
 	struct gfs2_holder al_rgd_gh;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 995f4e6..855597a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1372,8 +1372,6 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
-	al->al_alloced += *n;
-
 	gfs2_statfs_change(sdp, 0, -(s64)*n, dinode ? 1 : 0);
 	if (dinode)
 		gfs2_trans_add_unrevoke(sdp, block, 1);
-- 
1.7.4

