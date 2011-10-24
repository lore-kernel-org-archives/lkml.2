Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1JXMrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392Ab1JXMro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/24] GFS2: Remove obsolete assert
Date: Mon, 24 Oct 2011 13:48:27 +0100
Message-Id: <1319460518-9046-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that a resource group has been locked, there is no reason why
we should not be able to allocate as many blocks as are free. The
al_requested parameter should really be considered as a minimum
number of blocks to be available. Should this limit be overshot,
there are other mechanisms which will prevent over allocation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5bfb970..08b3a80 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1077,15 +1077,8 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip,
 
 void gfs2_inplace_release(struct gfs2_inode *ip)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = ip->i_alloc;
 
-	if (gfs2_assert_warn(sdp, al->al_alloced <= al->al_requested) == -1)
-		fs_warn(sdp, "al_alloced = %u, al_requested = %u "
-			     "al_file = %s, al_line = %u\n",
-		             al->al_alloced, al->al_requested, al->al_file,
-			     al->al_line);
-
 	if (al->al_rgd_gh.gh_gl)
 		gfs2_glock_dq_uninit(&al->al_rgd_gh);
 }
-- 
1.7.4.4

