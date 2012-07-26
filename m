Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2GZLzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:55:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53878 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2GZLzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:55:35 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v4 05/17] vfs: remove user_path_at_empty
Date: Thu, 26 Jul 2012 07:55:08 -0400
Message-Id: <1343303720-11199-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1343303720-11199-1-git-send-email-jlayton@redhat.com>
References: <1343303720-11199-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...there are no more callers.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c            | 12 +++---------
 include/linux/namei.h |  1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1ab4400..244ee8b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1988,10 +1988,10 @@ int kern_path_at(int dfd, const char *name, unsigned flags, struct path *path)
 	return err;
 }
 
-int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
-		 struct path *path, int *empty)
+int user_path_at(int dfd, const char __user *name, unsigned flags,
+		 struct path *path)
 {
-	char *tmp = getname_flags(name, flags, empty);
+	char *tmp = getname_flags(name, flags, NULL);
 	int err;
 
 	if (IS_ERR(tmp)) {
@@ -2003,12 +2003,6 @@ int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
 	return err;
 }
 
-int user_path_at(int dfd, const char __user *name, unsigned flags,
-		 struct path *path)
-{
-	return user_path_at_empty(dfd, name, flags, path, NULL);
-}
-
 static int user_path_parent(int dfd, const char __user *path,
 			struct nameidata *nd, char **name)
 {
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 002dc55..dc2a306 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -57,7 +57,6 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 
 extern int kern_path_at(int, const char *, unsigned, struct path *);
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
-extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
 
 #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
 #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)
-- 
1.7.11.2

