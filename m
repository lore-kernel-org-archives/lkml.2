Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab0EYSTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:19:20 -0400
Received: from kroah.org ([198.145.64.141]:44399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933441Ab0EYSRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:33 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:13 2010
Message-Id: <20100525181213.750215295@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [17/25] NFS: rsize and wsize settings ignored on v4 mounts
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -826,6 +826,8 @@ out_error:
 static void nfs_server_copy_userdata(struct nfs_server *target, struct nfs_server *source)
 {
 	target->flags = source->flags;
+	target->rsize = source->rsize;
+	target->wsize = source->wsize;
 	target->acregmin = source->acregmin;
 	target->acregmax = source->acregmax;
 	target->acdirmin = source->acdirmin;


