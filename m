Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2HON7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:59:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44595 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab2HON64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:58:56 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjones@redhat.com, steveamigauk@yahoo.co.uk, mszeredi@suse.cz
Subject: [PATCH 4/4] fuse: check create mode in atomic open
Date: Wed, 15 Aug 2012 15:59:59 +0200
Message-Id: <1345039199-5904-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345039199-5904-1-git-send-email-miklos@szeredi.hu>
References: <1345039199-5904-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Verify that the VFS is passing us a complete create mode with the S_IFREG to
atomic open.

Reported-by: Steve <steveamigauk@yahoo.co.uk>
Reported-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Richard W.M. Jones <rjones@redhat.com>
---
 fs/fuse/dir.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8964cf3..324bc08 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -383,6 +383,9 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	struct fuse_entry_out outentry;
 	struct fuse_file *ff;
 
+	/* Userspace expects S_IFREG in create mode */
+	BUG_ON((mode & S_IFMT) != S_IFREG);
+
 	forget = fuse_alloc_forget();
 	err = -ENOMEM;
 	if (!forget)
-- 
1.7.7

