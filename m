Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1C1Lbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:31:32 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57967 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab1C1Lbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:31:31 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] VFS: trivial: fix comment on s_maxbytes value warning check
Date: Mon, 28 Mar 2011 07:31:25 -0400
Message-Id: <1301311885-19259-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I originally intended to remove this warning in 2.6.34, but it's not in
a high performance codepath and might help us to catch bugs later. Let's
keep it, but fix the comment to allay confusion about its removal.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/super.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 7e9dd4c..92f38a3 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1013,8 +1013,7 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
 	 * but s_maxbytes was an unsigned long long for many releases. Throw
 	 * this warning for a little while to try and catch filesystems that
-	 * violate this rule. This warning should be either removed or
-	 * converted to a BUG() in 2.6.34.
+	 * violate this rule.
 	 */
 	WARN((mnt->mnt_sb->s_maxbytes < 0), "%s set sb->s_maxbytes to "
 		"negative value (%lld)\n", type->name, mnt->mnt_sb->s_maxbytes);
-- 
1.7.4

