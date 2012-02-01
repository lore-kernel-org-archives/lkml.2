Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2BAVxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:53:40 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48105 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757043Ab2BAVIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:09 -0500
X-Sasl-enc: W4MAnbptg5/F/cLXfn8abhkuHTzqw07J+DxUB/w75lav 1328130488
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:37 2012
Message-Id: <20120201205737.748277938@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:55:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tim Gardner <tim.gardner@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tyler Hicks <tyhicks@canonical.com>
Subject: [03/65] ecryptfs: Improve metadata read failure logging
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1618,7 +1618,8 @@ int ecryptfs_read_metadata(struct dentry
 		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file header region or xattr region\n");
+			       "file header region or xattr region, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 			goto out;
 		}
@@ -1627,7 +1628,8 @@ int ecryptfs_read_metadata(struct dentry
 						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file xattr region either\n");
+			       "file xattr region either, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
 		if (crypt_stat->mount_crypt_stat->flags
@@ -1638,7 +1640,8 @@ int ecryptfs_read_metadata(struct dentry
 			       "crypto metadata only in the extended attribute "
 			       "region, but eCryptfs was mounted without "
 			       "xattr support enabled. eCryptfs will not treat "
-			       "this like an encrypted file.\n");
+			       "this like an encrypted file, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
 	}


