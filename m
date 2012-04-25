Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab2DYMpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:45:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab2DYMoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:44:23 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 12/16] vfs: do_dentry_open(): don't put filp
Date: Wed, 25 Apr 2012 14:44:13 +0200
Message-Id: <1335357857-16416-13-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
References: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
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

