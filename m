Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab1FWSRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:17:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:34366 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab1FWRgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 100/247] NFS: fix the return value of nfs_file_fsync()
Date: Thu, 23 Jun 2011 13:32:48 -0400
Message-Id: <1308850515-15242-41-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. R. Okajima <hooanon05@yahoo.co.jp>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0702099bd86c33c2dcdbd3963433a61f3f503901 upstream.

By the commit af7fa16 2010-08-03 NFS: Fix up the fsync code
close(2) became returning the non-zero value even if it went well.
nfs_file_fsync() should return 0 when "status" is positive.

[PG: in 34, nfs_file_fsync is just a wrapper around nfs_do_fsync,
 so the related code and actual change lands in nfs_do_fsync here.]

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 7f7df1d..1c91289 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -219,7 +219,7 @@ static int nfs_do_fsync(struct nfs_open_context *ctx, struct inode *inode)
 	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	if (have_error)
 		ret = xchg(&ctx->error, 0);
-	if (!ret)
+	if (!ret && status < 0)
 		ret = status;
 	return ret;
 }
-- 
1.7.4.4

