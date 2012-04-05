Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab2DEO7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:59:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49884 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab2DEO6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:50 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 08/34] vfs: do_last(): only return EISDIR for O_CREAT
Date: Thu,  5 Apr 2012 16:58:34 +0200
Message-Id: <1333637940-31884-9-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
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
index 06ff96f..a405260 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2414,7 +2414,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
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

