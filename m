Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab2JAXUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:20:50 -0400
Received: from 1wt.eu ([62.212.114.60]:35388 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932956Ab2JAXBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:34 -0400
Message-Id: <20121001225203.079788589@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 129/180] NFSv3: Ensure that do_proc_get_root() reports errors correctly
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 086600430493e04b802bee6e5b3ce0458e4eb77f upstream.

If the rpc call to NFS3PROC_FSINFO fails, then we need to report that
error so that the mount fails. Otherwise we can end up with a
superblock with completely unusable values for block sizes, maxfilesize,
etc.

Reported-by: Yuanming Chen <hikvision_linux@163.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/nfs/nfs3proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 3f8881d..59d9304 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -66,7 +66,7 @@ do_proc_get_root(struct rpc_clnt *client, struct nfs_fh *fhandle,
 	nfs_fattr_init(info->fattr);
 	status = rpc_call_sync(client, &msg, 0);
 	dprintk("%s: reply fsinfo: %d\n", __func__, status);
-	if (!(info->fattr->valid & NFS_ATTR_FATTR)) {
+	if (status == 0 && !(info->fattr->valid & NFS_ATTR_FATTR)) {
 		msg.rpc_proc = &nfs3_procedures[NFS3PROC_GETATTR];
 		msg.rpc_resp = info->fattr;
 		status = rpc_call_sync(client, &msg, 0);
-- 
1.7.2.1.45.g54fbc



