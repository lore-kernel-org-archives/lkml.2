Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab0DBJeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 05:34:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:6307 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab0DBJeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 05:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GbrFEvMyZcmwYXK6UiXWrqepKFO3+Do7V4cAGgYnZ1hd9Ct6tj13jiKqSf91bGaF/d
         cT6N3Hrhcq7vRWdNxQau9elnFNdhklITR2FNTBEpZk2UBAWBtDBcy3lUhMPLCmkrUuyx
         mh0wNdWDVfDnHGr6HPrIbZ6tneThtT4cgofqg=
From: Huang Shijie <shijie8@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Huang Shijie <shijie8@gmail.com>
Subject: [PATCH] namei.c : update mnt when it needed
Date: Fri,  2 Apr 2010 17:37:13 +0800
Message-Id: <1270201033-14894-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update the mnt of the path when it is not equal to the new one.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 fs/namei.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a7dce91..9c3a040 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -523,9 +523,10 @@ static void path_put_conditional(struct path *path, struct nameidata *nd)
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 {
 	dput(nd->path.dentry);
-	if (nd->path.mnt != path->mnt)
+	if (nd->path.mnt != path->mnt) {
 		mntput(nd->path.mnt);
-	nd->path.mnt = path->mnt;
+		nd->path.mnt = path->mnt;
+	}
 	nd->path.dentry = path->dentry;
 }
 
-- 
1.6.6

