Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab1LLV56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:57:58 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:62212 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab1LLV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:57:56 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] xfs: fix acl count validation in xfs_acl_from_disk()
Date: Mon, 12 Dec 2011 16:55:52 -0500
Message-Id: <1323726952-22963-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fa8b18ed didn't prevent the integer overflow and possible
memory corruption.  "count" can go negative and bypass the check.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 fs/xfs/xfs_acl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 76e4266..ac702a6 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -39,7 +39,7 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	struct posix_acl_entry *acl_e;
 	struct posix_acl *acl;
 	struct xfs_acl_entry *ace;
-	int count, i;
+	unsigned int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
 	if (count > XFS_ACL_MAX_ENTRIES)
-- 
1.7.5.4

