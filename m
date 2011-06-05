Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1FELMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 07:12:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36561 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1FELMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 07:12:33 -0400
Date: Sun, 5 Jun 2011 12:12:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix ->mknod() return value on xfs_get_acl() failure
Message-ID: <20110605111231.GD11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	->mknod() should return negative on errors and PTR_ERR() gives
already negative value...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index dd21784..d44d92c 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -182,7 +182,7 @@ xfs_vn_mknod(
 	if (IS_POSIXACL(dir)) {
 		default_acl = xfs_get_acl(dir, ACL_TYPE_DEFAULT);
 		if (IS_ERR(default_acl))
-			return -PTR_ERR(default_acl);
+			return PTR_ERR(default_acl);
 
 		if (!default_acl)
 			mode &= ~current_umask();
