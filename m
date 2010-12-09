Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab0LIUGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:06:30 -0500
Received: from mail.perches.com ([173.55.12.10]:2426 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080Ab0LIUEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:15 -0500
From: Joe Perches <joe@perches.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] nfs: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:04:06 -0800
Message-Id: <f96c04f4ede30eb824087668a8d8f8de475d8f68.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/nfs/mount_clnt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/mount_clnt.c b/fs/nfs/mount_clnt.c
index eceafe7..3f2a6be 100644
--- a/fs/nfs/mount_clnt.c
+++ b/fs/nfs/mount_clnt.c
@@ -248,7 +248,7 @@ void nfs_umount(const struct nfs_mount_request *info)
 		args.flags |= RPC_CLNT_CREATE_NONPRIVPORT;
 
 	clnt = rpc_create(&args);
-	if (unlikely(IS_ERR(clnt)))
+	if (IS_ERR(clnt))
 		goto out_clnt_err;
 
 	dprintk("NFS: sending UMNT request for %s:%s\n",
-- 
1.7.3.3.464.gf80b6

