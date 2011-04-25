Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab1DYU66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:58:58 -0400
Received: from 1wt.eu ([62.212.114.60]:33802 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab1DYUXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:43 -0400
Message-Id: <20110425200234.772191028@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 041/173] NFS: fix the return value of nfs_file_fsync()
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. R. Okajima <hooanon05@yahoo.co.jp>

commit 0702099bd86c33c2dcdbd3963433a61f3f503901 upstream.

By the commit af7fa16 2010-08-03 NFS: Fix up the fsync code
close(2) became returning the non-zero value even if it went well.
nfs_file_fsync() should return 0 when "status" is positive.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -220,7 +220,7 @@ static int nfs_do_fsync(struct nfs_open_
 	have_error |= test_bit(NFS_CONTEXT_ERROR_WRITE, &ctx->flags);
 	if (have_error)
 		ret = xchg(&ctx->error, 0);
-	if (!ret)
+	if (!ret && status < 0)
 		ret = status;
 	return ret;
 }


