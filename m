Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0LPP3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:29:51 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:52581 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab0LPP3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:29:49 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: Fix the return error on default acl removal
Date: Thu, 16 Dec 2010 20:59:43 +0530
Message-Id: <1292513383-18629-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't have default ACL, then trying to remove
default acl on a file should return 0.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/acl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index 12d6023..c9c3376 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -362,7 +362,7 @@ static int v9fs_xattr_set_acl(struct dentry *dentry, const char *name,
 	case ACL_TYPE_DEFAULT:
 		name = POSIX_ACL_XATTR_DEFAULT;
 		if (!S_ISDIR(inode->i_mode)) {
-			retval = -EINVAL;
+			retval = acl ? -EINVAL : 0;
 			goto err_out;
 		}
 		break;
-- 
1.7.1

