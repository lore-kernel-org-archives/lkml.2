Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab2FZQft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:35:49 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:62636 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2FZQfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:35:45 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/9] audit: remove unnecessary NULL ptr checks from do_path_lookup
Date: Tue, 26 Jun 2012 12:35:29 -0400
Message-Id: <1340728537-25599-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
References: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As best I can tell, whenever retval == 0, nd->path.dentry and nd->inode
are also non-NULL. Eliminate those checks and the superfluous
audit_context check.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7d69419..5f6a34d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1812,12 +1812,8 @@ static int do_path_lookup(int dfd, const char *name,
 	if (unlikely(retval == -ESTALE))
 		retval = path_lookupat(dfd, name, flags | LOOKUP_REVAL, nd);
 
-	if (likely(!retval)) {
-		if (unlikely(!audit_dummy_context())) {
-			if (nd->path.dentry && nd->inode)
-				audit_inode(name, nd->path.dentry);
-		}
-	}
+	if (likely(!retval))
+		audit_inode(name, nd->path.dentry);
 	return retval;
 }
 
-- 
1.7.7.6

