Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab2ILXn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:43:57 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317Ab2ILXnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:43:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Yuanming Chen <hikvision_linux@163.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 15/46] NFSv3: Ensure that do_proc_get_root() reports errors correctly
Date: Wed, 12 Sep 2012 16:39:05 -0700
Message-Id: <20120912233819.258768792@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/nfs/nfs3proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -68,7 +68,7 @@ do_proc_get_root(struct rpc_clnt *client
 	nfs_fattr_init(info->fattr);
 	status = rpc_call_sync(client, &msg, 0);
 	dprintk("%s: reply fsinfo: %d\n", __func__, status);
-	if (!(info->fattr->valid & NFS_ATTR_FATTR)) {
+	if (status == 0 && !(info->fattr->valid & NFS_ATTR_FATTR)) {
 		msg.rpc_proc = &nfs3_procedures[NFS3PROC_GETATTR];
 		msg.rpc_resp = info->fattr;
 		status = rpc_call_sync(client, &msg, 0);


