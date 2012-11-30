Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2K3KSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab2K3KSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:39 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/16] GFS2: don't reference inode's glock during block allocation trace
Date: Fri, 30 Nov 2012 09:52:19 +0000
Message-Id: <1354269141-3311-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes the block allocation trace so that it references
the rgd's glock rather than the inode's glock. Now that the order
of inode creation is switched, this prevents a reference to the
glock which may not be set yet.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index bbdc78a..2ee13e8 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -486,7 +486,7 @@ TRACE_EVENT(gfs2_block_alloc,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= ip->i_gl->gl_sbd->sd_vfs->s_dev;
+		__entry->dev		= rgd->rd_gl->gl_sbd->sd_vfs->s_dev;
 		__entry->start		= block;
 		__entry->inum		= ip->i_no_addr;
 		__entry->len		= len;
-- 
1.7.4

