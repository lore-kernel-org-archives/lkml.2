Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab0DVTjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:39:55 -0400
Received: from kroah.org ([198.145.64.141]:41400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab0DVT3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:34 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:21 2010
Message-Id: <20100422190921.235116706@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Christian Pulvermacher <pulvermacher@gmx.de>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [155/197] ecryptfs: fix error code for missing xattrs in lower fs
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Pulvermacher <pulvermacher@gmx.de>

commit cfce08c6bdfb20ade979284e55001ca1f100ed51 upstream.

If the lower file system driver has extended attributes disabled,
ecryptfs' own access functions return -ENOSYS instead of -EOPNOTSUPP.
This breaks execution of programs in the ecryptfs mount, since the
kernel expects the latter error when checking for security
capabilities in xattrs.

Signed-off-by: Christian Pulvermacher <pulvermacher@gmx.de>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -998,7 +998,7 @@ ecryptfs_setxattr(struct dentry *dentry,
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	if (!lower_dentry->d_inode->i_op->setxattr) {
-		rc = -ENOSYS;
+		rc = -EOPNOTSUPP;
 		goto out;
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
@@ -1016,7 +1016,7 @@ ecryptfs_getxattr_lower(struct dentry *l
 	int rc = 0;
 
 	if (!lower_dentry->d_inode->i_op->getxattr) {
-		rc = -ENOSYS;
+		rc = -EOPNOTSUPP;
 		goto out;
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
@@ -1043,7 +1043,7 @@ ecryptfs_listxattr(struct dentry *dentry
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	if (!lower_dentry->d_inode->i_op->listxattr) {
-		rc = -ENOSYS;
+		rc = -EOPNOTSUPP;
 		goto out;
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
@@ -1060,7 +1060,7 @@ static int ecryptfs_removexattr(struct d
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	if (!lower_dentry->d_inode->i_op->removexattr) {
-		rc = -ENOSYS;
+		rc = -EOPNOTSUPP;
 		goto out;
 	}
 	mutex_lock(&lower_dentry->d_inode->i_mutex);


