Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1IWUec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:34:32 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:43129 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1IWUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:34:30 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1316810059!39606940!20
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ecryptfs/inode.c: local functions should be static
Date: Fri, 23 Sep 2011 13:33:57 -0700
User-Agent: KMail/1.9.9
CC: <ecryptfs@vger.kernel.org>, <tyhicks@linux.vnet.ibm.com>,
        <kirkland@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231333.58042.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets the following sparse noise:

warning: symbol 'ecryptfs_getattr_link' was not declared. Should it be static?
warning: symbol 'ecryptfs_getattr' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>

---

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 11f8582..6837d8d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1017,7 +1017,7 @@ out:
 	return rc;
 }
 
-int ecryptfs_getattr_link(struct vfsmount *mnt, struct dentry *dentry,
+static int ecryptfs_getattr_link(struct vfsmount *mnt, struct dentry *dentry,
 			  struct kstat *stat)
 {
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
@@ -1039,7 +1039,7 @@ int ecryptfs_getattr_link(struct vfsmount *mnt, struct dentry *dentry,
 	return rc;
 }
 
-int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
+static int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		     struct kstat *stat)
 {
 	struct kstat lower_stat;
