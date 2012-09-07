Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567Ab2IGLYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:24:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46519 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760416Ab2IGLX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:23:56 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: [PATCH v6 01/10] audit: remove unnecessary NULL ptr checks from do_path_lookup
Date: Fri,  7 Sep 2012 07:23:38 -0400
Message-Id: <1347017027-17167-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
References: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
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

