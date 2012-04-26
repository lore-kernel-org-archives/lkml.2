Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2DZVNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 17:13:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52789 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab2DZVNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:13:37 -0400
From: Emil Goode <emilgoode@gmail.com>
To: swhiteho@redhat.com, cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] GFS2: Return -ENOMEM only if kmalloc fails
Date: Thu, 26 Apr 2012 23:12:58 +0200
Message-Id: <1335474778-6252-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error variable should be assigned the value of -ENOMEM
after the NULL check and not before.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 fs/gfs2/acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 230eb0f..90f6328 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -174,8 +174,8 @@ int gfs2_acl_chmod(struct gfs2_inode *ip, struct iattr *attr)
 
 	len = posix_acl_to_xattr(acl, NULL, 0);
 	data = kmalloc(len, GFP_NOFS);
-	error = -ENOMEM;
 	if (data == NULL)
+		error = -ENOMEM;
 		goto out;
 	posix_acl_to_xattr(acl, data, len);
 	error = gfs2_xattr_acl_chmod(ip, attr, data);
-- 
1.7.10

