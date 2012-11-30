Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2K3KSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:18:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab2K3KSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:40 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/16] GFS2: add error check while allocating new inodes
Date: Fri, 30 Nov 2012 09:52:20 +0000
Message-Id: <1354269141-3311-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch adds a return code check after attempting to allocate
a new inode during dinode creation.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e321333..2405695 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -674,6 +674,10 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock;
 
 	inode = new_inode(sdp->sd_vfs);
+	if (!inode) {
+		gfs2_glock_dq_uninit(ghs);
+		return -ENOMEM;
+	}
 	ip = GFS2_I(inode);
 	error = gfs2_rs_alloc(ip);
 	if (error)
-- 
1.7.4

