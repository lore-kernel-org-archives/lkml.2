Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab1BQSCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:02:35 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53037 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1BQSC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:28 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 06/14] fs/9p: Update link count correctly on mkdir
Date: Thu, 17 Feb 2011 23:31:57 +0530
Message-Id: <1297965725-25603-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need update parent directory link count on success full
mkdir

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c      |    3 ++-
 fs/9p/vfs_inode_dotl.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 8a895bb..d72cabe 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -717,7 +717,8 @@ static int v9fs_vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	if (IS_ERR(fid)) {
 		err = PTR_ERR(fid);
 		fid = NULL;
-	}
+	} else
+		inc_nlink(dir);
 
 	if (fid)
 		p9_client_clunk(fid);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index aebe532..b0fa56a 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -382,7 +382,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 	}
 	/* Now set the ACL based on the default value */
 	v9fs_set_create_acl(dentry, dacl, pacl);
-
+	inc_nlink(dir);
 error:
 	if (fid)
 		p9_client_clunk(fid);
-- 
1.7.1

