Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1BERtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:49:36 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:52976 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1BERrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:09 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 08/17] fs/9p: Clarify cached dentry delete operation
Date: Sat,  5 Feb 2011 23:16:36 +0530
Message-Id: <1296928005-9529-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the comment to indicate that we don't want to cache
negative dentries.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_dentry.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index 233b7d4..a4ae4be 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -63,20 +63,15 @@ static int v9fs_dentry_delete(const struct dentry *dentry)
  * v9fs_cached_dentry_delete - called when dentry refcount equals 0
  * @dentry:  dentry in question
  *
- * Only return 1 if our inode is invalid.  Only non-synthetic files
- * (ones without mtime == 0) should be calling this function.
- *
  */
-
 static int v9fs_cached_dentry_delete(const struct dentry *dentry)
 {
-	struct inode *inode = dentry->d_inode;
-	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_name.name,
-									dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n",
+		   dentry->d_name.name, dentry);
 
-	if(!inode)
+	/* Don't cache negative dentries */
+	if (!dentry->d_inode)
 		return 1;
-
 	return 0;
 }
 
-- 
1.7.1

