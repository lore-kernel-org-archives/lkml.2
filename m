Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2HGMoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:44:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42649 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2HGMof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:44:35 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjones@redhat.com, steveamigauk@yahoo.co.uk, mszeredi@suse.cz
Subject: [PATCH 2/4] vfs: atomic_open(): fix create mode usage
Date: Tue,  7 Aug 2012 14:45:47 +0200
Message-Id: <1344343549-11887-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1344343549-11887-1-git-send-email-miklos@szeredi.hu>
References: <1344343549-11887-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Don't mask S_ISREG off the create mode before passing to ->atomic_open().  Other
methods (->create, ->mknod) also get the complete file mode and filesystems
expect it.

Reported-by: Steve <steveamigauk@yahoo.co.uk>
Reported-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1b46439..5bac1bb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2414,7 +2414,7 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 		goto out;
 	}
 
-	mode = op->mode & S_IALLUGO;
+	mode = op->mode;
 	if ((open_flag & O_CREAT) && !IS_POSIXACL(dir))
 		mode &= ~current_umask();
 
-- 
1.7.7

