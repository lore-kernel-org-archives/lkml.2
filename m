Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152Ab2FENMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:12:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49600 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934115Ab2FENLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:11:20 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 18/21] vfs: do_last(): clean up labels
Date: Tue,  5 Jun 2012 15:10:29 +0200
Message-Id: <1338901832-14049-19-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 55f5f27..e57cec2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2454,13 +2454,13 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 			error = -EISDIR;
 			goto exit;
 		}
-		goto ok;
+		goto finish_open;
 	case LAST_BIND:
 		error = complete_walk(nd);
 		if (error)
 			return ERR_PTR(error);
 		audit_inode(pathname, dir);
-		goto ok;
+		goto finish_open;
 	}
 
 	if (!(open_flag & O_CREAT)) {
@@ -2517,7 +2517,7 @@ retry_lookup:
 		will_truncate = 0;
 		acc_mode = MAY_OPEN;
 		path_to_nameidata(path, nd);
-		goto common;
+		goto finish_open_created;
 	}
 
 	/*
@@ -2589,7 +2589,7 @@ finish_lookup:
 	if ((nd->flags & LOOKUP_DIRECTORY) && !nd->inode->i_op->lookup)
 		goto exit;
 	audit_inode(pathname, nd->path.dentry);
-ok:
+finish_open:
 	if (!S_ISREG(nd->inode->i_mode))
 		will_truncate = 0;
 
@@ -2599,7 +2599,7 @@ ok:
 			goto exit;
 		want_write = 1;
 	}
-common:
+finish_open_created:
 	error = may_open(&nd->path, acc_mode, open_flag);
 	if (error)
 		goto exit;
-- 
1.7.7

