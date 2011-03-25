Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab1CYLbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:31:48 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39758 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1CYLbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:31:11 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/5] fs/9p: Fix error reported by coccicheck
Date: Fri, 25 Mar 2011 17:00:50 +0530
Message-Id: <1301052651-21440-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_inode_dotl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index ffbb113..82a7c38 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -811,7 +811,7 @@ v9fs_vfs_follow_link_dotl(struct dentry *dentry, struct nameidata *nd)
 	fid = v9fs_fid_lookup(dentry);
 	if (IS_ERR(fid)) {
 		__putname(link);
-		link = ERR_PTR(PTR_ERR(fid));
+		link = ERR_CAST(fid);
 		goto ndset;
 	}
 	retval = p9_client_readlink(fid, &target);
-- 
1.7.1

