Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab2JBARf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:17:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37115 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2JBARH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:07 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 01/49] audit: remove unnecessary NULL ptr checks from do_path_lookup
Date: Mon,  1 Oct 2012 20:16:10 -0400
Message-Id: <1349137018-21948-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As best I can tell, whenever retval == 0, nd->path.dentry and nd->inode
are also non-NULL. Eliminate those checks and the superfluous
audit_context check.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index dd1ed1b..e3661762 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1976,12 +1976,8 @@ static int do_path_lookup(int dfd, const char *name,
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
1.7.11.4

