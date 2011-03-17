Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1CQOMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:12:54 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48775 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1CQOMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:12:49 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] VFS: remove warning about invalid s_maxbytes values
Date: Thu, 17 Mar 2011 10:12:43 -0400
Message-Id: <1300371163-23923-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning should have been removed in 2.6.34. We missed that by a
few releases, so we should be OK to remove this now.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/super.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 7e9dd4c..2ed4a88 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1009,16 +1009,6 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	if (error)
 		goto out_sb;
 
-	/*
-	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
-	 * but s_maxbytes was an unsigned long long for many releases. Throw
-	 * this warning for a little while to try and catch filesystems that
-	 * violate this rule. This warning should be either removed or
-	 * converted to a BUG() in 2.6.34.
-	 */
-	WARN((mnt->mnt_sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
-		"negative value (%lld)\n", type->name, mnt->mnt_sb->s_maxbytes);
-
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
 	up_write(&mnt->mnt_sb->s_umount);
-- 
1.7.4

