Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1BQSC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:02:56 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49252 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab1BQSCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:44 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 14/14] fs/9p: Prevent multiple inclusion of same header
Date: Thu, 17 Feb 2011 23:32:05 +0530
Message-Id: <1297965725-25603-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary #ifndef #endif blocks to avoid mulitple inclusion of same headers

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/fid.h      |    4 +++-
 fs/9p/v9fs.h     |    4 ++++
 fs/9p/v9fs_vfs.h |    6 ++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index c3bbd6a..f610510 100644
--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -19,7 +19,8 @@
  *  Boston, MA  02111-1301  USA
  *
  */
-
+#ifndef FS_9P_FID_H
+#define FS_9P_FID_H
 #include <linux/list.h>
 
 /**
@@ -45,3 +46,4 @@ struct v9fs_dentry {
 struct p9_fid *v9fs_fid_lookup(struct dentry *dentry);
 struct p9_fid *v9fs_fid_clone(struct dentry *dentry);
 int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid);
+#endif
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 64acf72..92fb61b 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -20,6 +20,9 @@
  *  Boston, MA  02111-1301  USA
  *
  */
+#ifndef FS_9P_V9FS_H
+#define FS_9P_V9FS_H
+
 #include <linux/backing-dev.h>
 
 /**
@@ -193,3 +196,4 @@ v9fs_get_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	else
 		return v9fs_inode_from_fid(v9ses, fid, sb);
 }
+#endif
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index 3ac13b4..e719282 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -20,6 +20,8 @@
  *  Boston, MA  02111-1301  USA
  *
  */
+#ifndef FS_9P_V9FS_VFS_H
+#define FS_9P_V9FS_VFS_H
 
 /* plan9 semantics are that created files are implicitly opened.
  * But linux semantics are that you call create, then open.
@@ -36,6 +38,7 @@
  * unlink calls remove, which is an implicit clunk. So we have to track
  * that kind of thing so that we don't try to clunk a dead fid.
  */
+#define P9_LOCK_TIMEOUT (30*HZ)
 
 extern struct file_system_type v9fs_fs_type;
 extern const struct address_space_operations v9fs_addr_operations;
@@ -79,5 +82,4 @@ static inline void v9fs_invalidate_inode_attr(struct inode *inode)
 	v9inode->cache_validity |= V9FS_INO_INVALID_ATTR;
 	return;
 }
-
-#define P9_LOCK_TIMEOUT (30*HZ)
+#endif
-- 
1.7.1

