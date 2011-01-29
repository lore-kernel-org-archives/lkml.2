Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1A2T0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:26:47 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50621 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab1A2T0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:26:42 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V1 3/7] fs/9p: increment inode->i_count in cached mode.
Date: Sun, 30 Jan 2011 00:56:22 +0530
Message-Id: <1296329186-23807-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to ihold even in cached mode

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode_dotl.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index fbe9572..265f583 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -636,13 +636,8 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		v9fs_stat2inode_dotl(st, old_dentry->d_inode);
 
 		kfree(st);
-	} else {
-		/* Caching disabled. No need to get upto date stat info.
-		 * This dentry will be released immediately. So, just hold the
-		 * inode
-		 */
-		ihold(old_dentry->d_inode);
 	}
+	ihold(old_dentry->d_inode);
 	d_instantiate(dentry, old_dentry->d_inode);
 
 	return err;
-- 
1.7.1

