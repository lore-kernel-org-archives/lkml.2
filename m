Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2EUPcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:32:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60065 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2EUPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:40 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 12/16] vfs: do_dentry_open(): don't put filp
Date: Mon, 21 May 2012 17:30:16 +0200
Message-Id: <1337614220-6174-13-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
References: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Move put_filp() out to __dentry_open(), the only caller now.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/open.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 971b474..e1448cd 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -737,7 +737,6 @@ cleanup_all:
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
 cleanup_file:
-	put_filp(f);
 	dput(dentry);
 	mntput(mnt);
 	return ERR_PTR(error);
@@ -755,6 +754,8 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 			fput(res);
 			res = ERR_PTR(error);
 		}
+	} else {
+		put_filp(f);
 	}
 	return res;
 }
-- 
1.7.7

