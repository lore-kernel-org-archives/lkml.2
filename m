Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0H3QEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:04:46 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45413 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715Ab0H3QEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:04:40 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: Use the correct dentry operations
Date: Mon, 30 Aug 2010 21:34:35 +0530
Message-Id: <1283184275-23650-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use the cached dentry operation only if caching mode is enabled

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index d5c4867..5acee50 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -730,7 +730,10 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int mode,
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
 		goto error;
 	}
-	dentry->d_op = &v9fs_cached_dentry_operations;
+	if (v9ses->cache)
+		dentry->d_op = &v9fs_cached_dentry_operations;
+	else
+		dentry->d_op = &v9fs_dentry_operations;
 	d_instantiate(dentry, inode);
 	err = v9fs_fid_add(dentry, fid);
 	if (err < 0)
-- 
1.7.0.4

