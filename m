Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761758Ab2EQMse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761468Ab2EQMsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/24] GFS2: make function gfs2_page_add_databufs static
Date: Thu, 17 May 2012 13:23:11 +0100
Message-Id: <1337257411-3173-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch makes function gfs2_page_add_databufs static.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 9b2ff0e..56dc1f0 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -36,8 +36,8 @@
 #include "glops.h"
 
 
-void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
-			    unsigned int from, unsigned int to)
+static void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
+				   unsigned int from, unsigned int to)
 {
 	struct buffer_head *head = page_buffers(page);
 	unsigned int bsize = head->b_size;
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 276e7b5..5d345b4 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -19,8 +19,6 @@ extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
 extern int gfs2_internal_read(struct gfs2_inode *ip,
 			      struct file_ra_state *ra_state,
 			      char *buf, loff_t *pos, unsigned size);
-extern void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
-				   unsigned int from, unsigned int to);
 extern void gfs2_set_aops(struct inode *inode);
 
 static inline int gfs2_is_stuffed(const struct gfs2_inode *ip)
-- 
1.7.4

