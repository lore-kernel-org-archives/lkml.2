Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1DTSa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:30:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:43148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1DTSa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 14:30:56 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] vfs: Pass setxattr(2) flags properly
Date: Wed, 20 Apr 2011 20:30:40 +0200
Message-Id: <1303324240-26672-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason generic_setxattr() did not pass flags (XATTR_CREATE,
XATTR_REPLACE) to the filesystem specific helper. This caused that
setxattr(2) syscall just ignored these flags.

Fix the bug by passing flags correctly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 Who's handling VFS changes when Al is away? Andrew?

diff --git a/fs/xattr.c b/fs/xattr.c
index a19acdb..f1ef949 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -666,7 +666,7 @@ generic_setxattr(struct dentry *dentry, const char *name, const void *value, siz
 	handler = xattr_resolve_name(dentry->d_sb->s_xattr, &name);
 	if (!handler)
 		return -EOPNOTSUPP;
-	return handler->set(dentry, name, value, size, 0, handler->flags);
+	return handler->set(dentry, name, value, size, flags, handler->flags);
 }
 
 /*
-- 
1.7.1

