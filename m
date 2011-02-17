Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1BQSEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:04:41 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50830 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab1BQSCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:30 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 07/14] fs/9p: Initialize root inode number for dotl
Date: Thu, 17 Feb 2011 23:31:58 +0530
Message-Id: <1297965725-25603-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 0dc9e4b..6e04cf3 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -168,7 +168,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 			retval = PTR_ERR(st);
 			goto release_sb;
 		}
-
+		root->d_inode->i_ino = v9fs_qid2ino(&st->qid);
 		v9fs_stat2inode_dotl(st, root->d_inode);
 		kfree(st);
 	} else {
-- 
1.7.1

