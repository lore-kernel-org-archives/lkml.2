Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab2HHNXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:23:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61298 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab2HHNWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:22:09 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v5 15/19] vfs: remove user_path_parent
Date: Wed,  8 Aug 2012 09:21:38 -0400
Message-Id: <1344432102-22312-16-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344432102-22312-1-git-send-email-jlayton@redhat.com>
References: <1344432102-22312-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...there are no more callers.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 936591f..ca1496a 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2121,24 +2121,6 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
 	return err;
 }
 
-static int user_path_parent(int dfd, const char __user *path,
-			struct nameidata *nd, char **name)
-{
-	char *s = getname(path);
-	int error;
-
-	if (IS_ERR(s))
-		return PTR_ERR(s);
-
-	error = do_path_lookup(dfd, s, LOOKUP_PARENT, nd);
-	if (error)
-		putname(s);
-	else
-		*name = s;
-
-	return error;
-}
-
 /*
  * It's inline, so penalty for filesystems that don't use sticky bit is
  * minimal.
-- 
1.7.11.2

