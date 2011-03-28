Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1C1Bzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 21:55:48 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:64386 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753251Ab1C1Bzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 21:55:46 -0400
From: Ryan Mallon <ryan@bluewatersys.com>
To: viro@zeniv.linux.org.uk, dchinner@redhat.com, Trond.Myklebust@netapp.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, Ryan Mallon <ryan@bluewatersys.com>
Subject: [RFC PATCH 2/2] Use __igrab instead of igrab in nfs_inode_add_request
Date: Mon, 28 Mar 2011 14:56:01 +1300
Message-Id: <1301277361-9453-3-git-send-email-ryan@bluewatersys.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1301277361-9453-1-git-send-email-ryan@bluewatersys.com>
References: <1301277361-9453-1-git-send-email-ryan@bluewatersys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfs_inode_add_request already holds inode->i_lock, so call the unlocked
__igrab instead of igrab.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
---
 fs/nfs/write.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 85d7525..b161642 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -390,7 +390,7 @@ static int nfs_inode_add_request(struct inode *inode, struct nfs_page *req)
 	error = radix_tree_insert(&nfsi->nfs_page_tree, req->wb_index, req);
 	BUG_ON(error);
 	if (!nfsi->npages) {
-		igrab(inode);
+		__igrab(inode);
 		if (nfs_have_delegation(inode, FMODE_WRITE))
 			nfsi->change_attr++;
 	}
-- 
1.7.0.4

