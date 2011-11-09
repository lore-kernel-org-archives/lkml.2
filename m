Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1KJE0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:26:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964925Ab1KJDjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:39:25 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:51 2011
Message-Id: <20111109213150.957468275@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peng Tao <peng_tao@emc.com>,
        Jim Rees <rees@umich.edu>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [088/264] pnfsblock: add missing rpc_put_mount and path_put
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit 760383f1ee4d14b0e0bdf0cddee648d9b8633429 upstream.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Jim Rees <rees@umich.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/blocklayout/blocklayout.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -993,17 +993,20 @@ static int __init nfs4blocklayout_init(v
 			      mnt,
 			      NFS_PIPE_DIRNAME, 0, &path);
 	if (ret)
-		goto out_remove;
+		goto out_putrpc;
 
 	bl_device_pipe = rpc_mkpipe(path.dentry, "blocklayout", NULL,
 				    &bl_upcall_ops, 0);
+	path_put(&path);
 	if (IS_ERR(bl_device_pipe)) {
 		ret = PTR_ERR(bl_device_pipe);
-		goto out_remove;
+		goto out_putrpc;
 	}
 out:
 	return ret;
 
+out_putrpc:
+	rpc_put_mount();
 out_remove:
 	pnfs_unregister_layoutdriver(&blocklayout_type);
 	return ret;
@@ -1016,6 +1019,7 @@ static void __exit nfs4blocklayout_exit(
 
 	pnfs_unregister_layoutdriver(&blocklayout_type);
 	rpc_unlink(bl_device_pipe);
+	rpc_put_mount();
 }
 
 MODULE_ALIAS("nfs-layouttype4-3");


