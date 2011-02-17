Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab1BQSDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:03:30 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53052 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab1BQSCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:40 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 12/14] fs/9p: mark inode attribute invalid on rename and unlink
Date: Thu, 17 Feb 2011 23:32:03 +0530
Message-Id: <1297965725-25603-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both rename and unlink result in update of inode attribute.
So mark the cached copy invalid

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 27045d9..eaa089c 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -520,7 +520,9 @@ static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 			drop_nlink(dir);
 		} else
 			drop_nlink(file_inode);
+
 		v9fs_invalidate_inode_attr(dir);
+		v9fs_invalidate_inode_attr(file_inode);
 	}
 	return retval;
 }
@@ -901,6 +903,7 @@ clunk_newdir:
 		}
 		v9fs_invalidate_inode_attr(old_dir);
 		v9fs_invalidate_inode_attr(new_dir);
+		v9fs_invalidate_inode_attr(old_inode);
 		/* successful rename */
 		d_move(old_dentry, new_dentry);
 	}
-- 
1.7.1

