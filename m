Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab2EAPSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:18:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46423 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab2EAPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:18:00 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5/5] overlayfs: update touch_atime() usage
Date: Tue,  1 May 2012 16:17:55 +0100
Message-Id: <1335885475-11990-6-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335885475-11990-1-git-send-email-apw@canonical.com>
References: <1335885475-11990-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

touch_atime() now has new parametarisation, follow this in overlayfs.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index bc9178c..c63fd3f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -176,7 +176,7 @@ static int ovl_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 	if (!realinode->i_op->readlink)
 		return -EINVAL;
 
-	touch_atime(realpath.mnt, realpath.dentry);
+	touch_atime(&realpath);
 
 	return realinode->i_op->readlink(realpath.dentry, buf, bufsiz);
 }
-- 
1.7.9.5

