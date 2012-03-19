Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030700Ab2CSKvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:51:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261Ab2CSKty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:49:54 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/12] GFS2: Flush pending glock work when evicting an inode
Date: Mon, 19 Mar 2012 10:25:25 +0000
Message-Id: <1332152728-4027-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures that we will not try to access the inode thats
being flushed via the glock after it has been freed.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f3faf72..6172fa7 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1557,6 +1557,7 @@ out:
 	end_writeback(inode);
 	gfs2_dir_hash_inval(ip);
 	ip->i_gl->gl_object = NULL;
+	flush_delayed_work_sync(&ip->i_gl->gl_work);
 	gfs2_glock_add_to_lru(ip->i_gl);
 	gfs2_glock_put(ip->i_gl);
 	ip->i_gl = NULL;
-- 
1.7.4

