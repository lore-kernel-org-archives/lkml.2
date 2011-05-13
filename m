Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab1EMVXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:23:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35193 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab1EMVXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:23:08 -0400
From: Julia Lawall <julia@diku.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/freevxfs/vxfs_fshead.c: Convert kfree to kmem_cache_free
Date: Fri, 13 May 2011 23:23:02 +0200
Message-Id: <1305321782-30566-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

vxfs_blkiget allocates its return value using kmem_cache_alloc, so that
value should be freed using kmem_cache_free.  The cache is already made
available via vxfs_extern.h.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/freevxfs/vxfs_fshead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/freevxfs/vxfs_fshead.c b/fs/freevxfs/vxfs_fshead.c
index c9a6a94..86b59e7 100644
--- a/fs/freevxfs/vxfs_fshead.c
+++ b/fs/freevxfs/vxfs_fshead.c
@@ -198,6 +198,6 @@ vxfs_read_fshead(struct super_block *sbp)
 	iput(infp->vsi_fship);
 	return -EINVAL;
  out_free_fship:
- 	kfree(vip);
+	kmem_cache_free(vxfs_inode_cachep, vip);
 	return -EINVAL;
 }

