Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab2CLAuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:50:39 -0400
Received: from 1wt.eu ([62.212.114.60]:63105 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab2CLAsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:52 -0400
Message-Id: <20120312004411.644235573@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:19 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 08/13] eCryptfs: Remove extra d_delete in ecryptfs_rmdir
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 35ffa948b2f7bdf79e488cd496232935d095087a upstream.

vfs_rmdir() already calls d_delete() on the lower dentry. That was being
duplicated in ecryptfs_rmdir() and caused a NULL pointer dereference
when NFSv3 was the lower filesystem.

BugLink: http://bugs.launchpad.net/bugs/723518
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Colin King <colin.king@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/inode.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 7ce5471..79ae6a7 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -575,8 +575,6 @@ static int ecryptfs_rmdir(struct inode *dir, struct dentry *dentry)
 	dget(lower_dentry);
 	rc = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
 	dput(lower_dentry);
-	if (!rc)
-		d_delete(lower_dentry);
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
 	unlock_dir(lower_dir_dentry);
-- 
1.7.2.1.45.g54fbc



