Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab2DYMrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:47:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab2DYMoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:44:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 08/16] vfs: do_last(): only return EISDIR for O_CREAT
Date: Wed, 25 Apr 2012 14:44:09 +0200
Message-Id: <1335357857-16416-9-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This allows this code to be shared between O_CREAT and plain opens.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 597e52d..4fd802c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2385,7 +2385,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (error)
 		return ERR_PTR(error);
 	error = -EISDIR;
-	if (S_ISDIR(nd->inode->i_mode))
+	if ((open_flag & O_CREAT) && S_ISDIR(nd->inode->i_mode))
 		goto exit;
 	error = -ENOTDIR;
 	if ((nd->flags & LOOKUP_DIRECTORY) && !nd->inode->i_op->lookup)
-- 
1.7.7

