Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2BAVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:09:57 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40202 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757283Ab2BAVJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:53 -0500
X-Sasl-enc: SwGIJNrO+VvEM4xcCYi/aX6PnGmeu1M8L/isQVfk1VOH 1328130592
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:44 2012
Message-Id: <20120201210044.241176216@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tim Gardner <tim.gardner@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>
Subject: [04/89] ecryptfs: Improve metadata read failure logging
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Gardner <tim.gardner@canonical.com>

commit 30373dc0c87ffef68d5628e77d56ffb1fa22e1ee upstream.

Print inode on metadata read failure. The only real
way of dealing with metadata read failures is to delete
the underlying file system file. Having the inode
allows one to 'find . -inum INODE`.

[tyhicks@canonical.com: Removed some minor not-for-stable parts]
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/crypto.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1620,7 +1620,8 @@ int ecryptfs_read_metadata(struct dentry
 		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file header region or xattr region\n");
+			       "file header region or xattr region, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 			goto out;
 		}
@@ -1629,7 +1630,8 @@ int ecryptfs_read_metadata(struct dentry
 						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file xattr region either\n");
+			       "file xattr region either, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
 		if (crypt_stat->mount_crypt_stat->flags
@@ -1640,7 +1642,8 @@ int ecryptfs_read_metadata(struct dentry
 			       "crypto metadata only in the extended attribute "
 			       "region, but eCryptfs was mounted without "
 			       "xattr support enabled. eCryptfs will not treat "
-			       "this like an encrypted file.\n");
+			       "this like an encrypted file, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
 	}


