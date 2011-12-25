Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1LYNSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 08:18:05 -0500
Received: from mx2.netapp.com ([216.240.18.37]:50332 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab1LYNSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 08:18:03 -0500
X-IronPort-AV: E=Sophos;i="4.71,408,1320652800"; 
   d="scan'208";a="610710935"
Message-ID: <1324819077.5195.5.camel@lade.trondhjem.org>
Subject: Re: [PATCH 4/6] SUNPRC: cleanup RPC PipeFS pipes upcall interface
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: linux-nfs@vger.kernel.org, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, bfields@fieldses.org, davem@davemloft.net,
        devel@openvz.org
Date: Sun, 25 Dec 2011 14:17:57 +0100
In-Reply-To: <20111122144159.479.68045.stgit@localhost6.localdomain6>
References: <20111122134514.479.9848.stgit@localhost6.localdomain6>
	 <20111122144159.479.68045.stgit@localhost6.localdomain6>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Dec 2011 13:17:58.0173 (UTC) FILETIME=[9EB4ACD0:01CCC307]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 18:41 +0300, Stanislav Kinsbursky wrote: 
> RPC pipe upcall doesn't requires only private pipe data. Thus RPC inode
> references in this code can be removed.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> ---
>  fs/nfs/blocklayout/blocklayoutdev.c |    2 +-
>  fs/nfs/blocklayout/blocklayoutdm.c  |    2 +-
>  fs/nfs/idmap.c                      |    4 ++--
>  include/linux/sunrpc/rpc_pipe_fs.h  |    2 +-
>  net/sunrpc/auth_gss/auth_gss.c      |    3 +--
>  net/sunrpc/rpc_pipe.c               |    3 +--
>  6 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/nfs/blocklayout/blocklayoutdev.c b/fs/nfs/blocklayout/blocklayoutdev.c
> index a83b393..44dc348 100644
> --- a/fs/nfs/blocklayout/blocklayoutdev.c
> +++ b/fs/nfs/blocklayout/blocklayoutdev.c
> @@ -168,7 +168,7 @@ nfs4_blk_decode_device(struct nfs_server *server,
>  
>  	dprintk("%s CALLING USERSPACE DAEMON\n", __func__);
>  	add_wait_queue(&bl_wq, &wq);
> -	if (rpc_queue_upcall(bl_device_pipe->d_inode, &msg) < 0) {
> +	if (rpc_queue_upcall(RPC_I(bl_device_pipe->d_inode)->pipe, &msg) < 0) {

Needs a rebase: the above doesn't apply...

> 		remove_wait_queue(&bl_wq, &wq);
>  		goto out;
>  	}


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

