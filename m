Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab1FFSCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:02:02 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47382 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab1FFSB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:01:58 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] fs/9p: remove rename work around in 9p
Date: Mon,  6 Jun 2011 23:31:47 +0530
Message-Id: <1307383308-5773-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307383308-5773-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1307383308-5773-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that VFS does the right thing remove the work around.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 651f577..ded6309 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -892,11 +892,6 @@ clunk_newdir:
 				clear_nlink(new_inode);
 			else
 				drop_nlink(new_inode);
-			/*
-			 * Work around vfs rename rehash bug with
-			 * FS_RENAME_DOES_D_MOVE
-			 */
-			v9fs_invalidate_inode_attr(new_inode);
 		}
 		if (S_ISDIR(old_inode->i_mode)) {
 			if (!new_inode)
-- 
1.7.4.1

