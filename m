Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2IZI63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:58:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab2IZIvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Michel Lespinasse <walken@google.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/27] GFS2: Use RB_CLEAR_NODE() rather than rb_init_node()
Date: Wed, 26 Sep 2012 09:25:28 +0100
Message-Id: <1348647948-3219-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Lespinasse <walken@google.com>

gfs2 calls RB_EMPTY_NODE() to check if nodes are not on an rbtree.
The corresponding initialization function is RB_CLEAR_NODE().
rb_init_node() was never clearly defined and is going away.

Signed-off-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 06476b3..7ce22d8 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -453,7 +453,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	if (!res)
 		error = -ENOMEM;
 
-	rb_init_node(&res->rs_node);
+	RB_CLEAR_NODE(&res->rs_node);
 
 	down_write(&ip->i_rw_mutex);
 	if (ip->i_res)
@@ -486,7 +486,7 @@ static void __rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
 	rgd = rs->rs_rbm.rgd;
 	trace_gfs2_rs(ip, rs, TRACE_RS_TREEDEL);
 	rb_erase(&rs->rs_node, &rgd->rd_rstree);
-	rb_init_node(&rs->rs_node);
+	RB_CLEAR_NODE(&rs->rs_node);
 	BUG_ON(!rgd->rd_rs_cnt);
 	rgd->rd_rs_cnt--;
 
-- 
1.7.4

