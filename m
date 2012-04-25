Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab2DYMoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:44:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60469 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab2DYMoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:44:14 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 07/16] vfs: do_last(): check LOOKUP_DIRECTORY
Date: Wed, 25 Apr 2012 14:44:08 +0200
Message-Id: <1335357857-16416-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
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
index d9b0eba..597e52d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2387,6 +2387,9 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
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

