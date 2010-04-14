Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0DNCQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 22:16:05 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:44383 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab0DNCQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 22:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GJl9kU2MHz06XW+rfdqC5qLaACZRYqiD3fT9N8cl+3Ezn/3SwLEaqQXhIVzAiXFwvd
         MNTcTp2xTu2xX6fGQzxQTilUCwoz0kyrRFQz5Tcxoq37Tq3slvbjBNvdypi+aK6O5Ndx
         49JxUSyy3QSBWVP4OfNKzqIjyD918vu+H3JOk=
From: Huang Shijie <shijie8@gmail.com>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Huang Shijie <shijie8@gmail.com>
Subject: [PATCH][resend] namei.c : update mnt when it needed
Date: Wed, 14 Apr 2010 10:16:09 +0800
Message-Id: <1271211369-27419-1-git-send-email-shijie8@gmail.com>
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

