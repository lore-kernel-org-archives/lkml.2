Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab1CWOYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:24:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:43478 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab1CWOYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:24:11 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] fs/9p: Fix revalidate to return correct value
Date: Wed, 23 Mar 2011 19:54:03 +0530
Message-Id: <1300890243-14712-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

revalidate should return > 0 on success.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_dentry.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index b6a3b9f..59c5ddc 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -126,7 +126,7 @@ static int v9fs_lookup_revalidate(struct dentry *dentry, struct nameidata *nd)
 			retval = v9fs_refresh_inode_dotl(fid, inode);
 		else
 			retval = v9fs_refresh_inode(fid, inode);
-		if (retval <= 0)
+		if (retval < 0)
 			return retval;
 	}
 out_valid:
-- 
1.7.1

