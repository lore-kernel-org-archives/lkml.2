Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0JERBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:01:50 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53119 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab0JERBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:01:48 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/3] fs/9p: Use generic_file_open with lookup_instantiate_filp
Date: Tue,  5 Oct 2010 22:31:30 +0530
Message-Id: <1286298090-2422-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to do O_LARGEFILE check even in case of 9p. Use the
generic_file_open helper

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 1ac9229..44ce77d 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -560,13 +560,6 @@ static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 	return retval;
 }
 
-static int
-v9fs_open_created(struct inode *inode, struct file *file)
-{
-	return 0;
-}
-
-
 /**
  * v9fs_create - Create a file
  * @v9ses: session information
@@ -766,7 +759,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 
 	/* if we are opening a file, assign the open fid to the file */
 	if (nd && nd->flags & LOOKUP_OPEN) {
-		filp = lookup_instantiate_filp(nd, dentry, v9fs_open_created);
+		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
 		if (IS_ERR(filp)) {
 			p9_client_clunk(ofid);
 			return PTR_ERR(filp);
@@ -825,7 +818,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 
 	/* if we are opening a file, assign the open fid to the file */
 	if (nd && nd->flags & LOOKUP_OPEN) {
-		filp = lookup_instantiate_filp(nd, dentry, v9fs_open_created);
+		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
 		if (IS_ERR(filp)) {
 			err = PTR_ERR(filp);
 			goto error;
-- 
1.7.0.4

