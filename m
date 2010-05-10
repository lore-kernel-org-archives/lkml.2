Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab0EJXAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:00:24 -0400
Received: from kroah.org ([198.145.64.141]:51704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757399Ab0EJW5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:51 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:37 2010
Message-Id: <20100510223537.301713673@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [32/98] NFS: rsize and wsize settings ignored on v4 mounts
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 356e76b855bdbfd8d1c5e75bcf0c6bf0dfe83496 upstream.

NFSv4 mounts ignore the rsize and wsize mount options, and always use
the default transfer size for both.  This seems to be because all
NFSv4 mounts are now cloned, and the cloning logic doesn't copy the
rsize and wsize settings from the parent nfs_server.

I tested Fedora's 2.6.32.11-99 and it seems to have this problem as
well, so I'm guessing that .33, .32, and perhaps older kernels have
this issue as well.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -965,6 +965,8 @@ out_error:
 static void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_server *source)
 {
 	target->flags = source->flags;
+	target->rsize = source->rsize;
+	target->wsize = source->wsize;
 	target->acregmin = source->acregmin;
 	target->acregmax = source->acregmax;
 	target->acdirmin = source->acdirmin;


