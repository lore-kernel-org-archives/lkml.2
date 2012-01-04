Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2ADHST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:18:19 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:59372 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2ADHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:18:15 -0500
Date: Wed, 4 Jan 2012 10:18:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] fsnotify: remove unused parameter from send_to_group()
Message-ID: <20120104071800.GA30978@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F03FD30.002A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't use "mnt" anymore in send_to_group() after 1968f5eed5
"fanotify: use both marks when possible" was applied.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index ccb14d3..b39c5c1 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -123,7 +123,7 @@ int __fsnotify_parent(struct path *path, struct dentry *dentry, __u32 mask)
 }
 EXPORT_SYMBOL_GPL(__fsnotify_parent);
 
-static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
+static int send_to_group(struct inode *to_tell,
 			 struct fsnotify_mark *inode_mark,
 			 struct fsnotify_mark *vfsmount_mark,
 			 __u32 mask, void *data,
@@ -168,10 +168,10 @@ static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
 			vfsmount_test_mask &= ~inode_mark->ignored_mask;
 	}
 
-	pr_debug("%s: group=%p to_tell=%p mnt=%p mask=%x inode_mark=%p"
+	pr_debug("%s: group=%p to_tell=%p mask=%x inode_mark=%p"
 		 " inode_test_mask=%x vfsmount_mark=%p vfsmount_test_mask=%x"
 		 " data=%p data_is=%d cookie=%d event=%p\n",
-		 __func__, group, to_tell, mnt, mask, inode_mark,
+		 __func__, group, to_tell, mask, inode_mark,
 		 inode_test_mask, vfsmount_mark, vfsmount_test_mask, data,
 		 data_is, cookie, *event);
 
@@ -258,16 +258,16 @@ int fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,
 
 		if (inode_group > vfsmount_group) {
 			/* handle inode */
-			ret = send_to_group(to_tell, NULL, inode_mark, NULL, mask, data,
+			ret = send_to_group(to_tell, inode_mark, NULL, mask, data,
 					    data_is, cookie, file_name, &event);
 			/* we didn't use the vfsmount_mark */
 			vfsmount_group = NULL;
 		} else if (vfsmount_group > inode_group) {
-			ret = send_to_group(to_tell, &mnt->mnt, NULL, vfsmount_mark, mask, data,
+			ret = send_to_group(to_tell, NULL, vfsmount_mark, mask, data,
 					    data_is, cookie, file_name, &event);
 			inode_group = NULL;
 		} else {
-			ret = send_to_group(to_tell, &mnt->mnt, inode_mark, vfsmount_mark,
+			ret = send_to_group(to_tell, inode_mark, vfsmount_mark,
 					    mask, data, data_is, cookie, file_name,
 					    &event);
 		}
