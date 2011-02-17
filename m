Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab1BQSCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:02:47 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36083 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab1BQSCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:41 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 13/14] fs/9p: Workaround vfs rename rehash bug
Date: Thu, 17 Feb 2011 23:32:04 +0530
Message-Id: <1297965725-25603-14-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is similar to what ceph, ocfs2 and nfs does
http://kerneltrap.org/mailarchive/linux-fsdevel/2008/4/18/1498534

May be we should get vfs fixed

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index eaa089c..52dacbb 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -895,6 +895,11 @@ clunk_newdir:
 				clear_nlink(new_inode);
 			else
 				drop_nlink(new_inode);
+			/*
+			 * Work around vfs rename rehash bug with
+			 * FS_RENAME_DOES_D_MOVE
+			 */
+			v9fs_invalidate_inode_attr(new_inode);
 		}
 		if (S_ISDIR(old_inode->i_mode)) {
 			if (!new_inode)
-- 
1.7.1

