Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab1COMqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:46:40 -0400
Received: from mx2.netapp.com ([216.240.18.37]:35229 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab1COMqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:46:38 -0400
X-IronPort-AV: E=Sophos;i="4.62,322,1297065600"; 
   d="scan'208";a="530424824"
Subject: Re: linux-next: build failure after merge of the bkl-config tree
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Adamson <andros@netapp.com>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Dean Hildebrand <dhildeb@us.ibm.com>,
        Fred Isaman <iisaman@citi.umich.edu>, Mike Sager <sager@netapp.com>,
        Fred Isaman <iisaman@netapp.com>,
        Mingyang Guo <guomingyang@nrchpc.ac.cn>,
        Ricardo Labiaga <Ricardo.Labiaga@netapp.com>,
        Tao Guo <guotao@nrchpc.ac.cn>, Benny Halevy <bhalevy@panasas.com>
In-Reply-To: <20110315184845.1a411e67.sfr@canb.auug.org.au>
References: <20110315184845.1a411e67.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Tue, 15 Mar 2011 08:46:33 -0400
Message-ID: <1300193193.9321.1.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 15 Mar 2011 12:46:35.0798 (UTC) FILETIME=[04FE4B60:01CBE30F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 18:48 +1100, Stephen Rothwell wrote:
> Hi Arnd,
> 
> After merging the bkl-config tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/read.c:21:28: error: linux/smp_lock.h: No such file or directory
> 
> Caused by commit 64419a9b2093 ("NFSv4.1: generic read") from the nfs tree
> interacting with commit 4ba8216cd905 ("BKL: That's all, folks") from the
> bkl-config tree.
> 
> I couldn't see that this include file was needed, so I applied the patch
> below (which Trond could apply to his tree, I am pretty sure).  (I am not
> sure why module.h is included either.)
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 15 Mar 2011 18:37:09 +1100
> Subject: [PATCH] nfs: BKL is no longer needed, so remove the include
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/nfs/read.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/read.c b/fs/nfs/read.c
> index 4b764c6..7cded2b 100644
> --- a/fs/nfs/read.c
> +++ b/fs/nfs/read.c
> @@ -18,7 +18,6 @@
>  #include <linux/sunrpc/clnt.h>
>  #include <linux/nfs_fs.h>
>  #include <linux/nfs_page.h>
> -#include <linux/smp_lock.h>
>  #include <linux/module.h>
>  
>  #include <asm/system.h>
> -- 
> 1.7.4.1

Thanks Stephen! Applied to the nfs-for-2.6.39 tree.

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

