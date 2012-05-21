Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2EUPad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:30:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65374 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2EUPa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:28 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 07/16] vfs: do_last(): check LOOKUP_DIRECTORY
Date: Mon, 21 May 2012 17:30:11 +0200
Message-Id: <1337614220-6174-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Check for ENOTDIR before finishing open.  This allows this code to be shared
between O_CREAT and plain opens.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3f4b286..d17a4e4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2388,6 +2388,9 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	error = -EISDIR;
 	if (S_ISDIR(nd->inode->i_mode))
 		goto exit;
+	error = -ENOTDIR;
+	if ((nd->flags & LOOKUP_DIRECTORY) && !nd->inode->i_op->lookup)
+		goto exit;
 ok:
 	if (!S_ISREG(nd->inode->i_mode))
 		will_truncate = 0;
-- 
1.7.7

