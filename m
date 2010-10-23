Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0JWOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 10:09:27 -0400
Received: from mx2.netapp.com ([216.240.18.37]:23215 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab0JWOJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 10:09:25 -0400
X-IronPort-AV: E=Sophos;i="4.58,227,1286175600"; 
   d="scan'208";a="471944547"
Subject: Re: [PATCH -next] nfs: include ratelimit.h, fix nfs4state build
 error
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org
In-Reply-To: <20101022161852.2ef2638c.randy.dunlap@oracle.com>
References: <20101022152350.fc79e2b9.sfr@canb.auug.org.au>
	 <20101022161852.2ef2638c.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Sat, 23 Oct 2010 10:09:06 -0400
Message-ID: <1287842947.3022.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 23 Oct 2010 14:09:08.0545 (UTC) FILETIME=[DBFD4310:01CB72BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 16:18 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> nfs4state.c uses interfaces from ratelimit.h.  It needs to include
> that header file to fix build errors:
> 
> fs/nfs/nfs4state.c:1195: warning: type defaults to 'int' in declaration of 'DEFINE_RATELIMIT_STATE'
> fs/nfs/nfs4state.c:1195: warning: parameter names (without types) in function declaration
> fs/nfs/nfs4state.c:1195: error: invalid storage class for function 'DEFINE_RATELIMIT_STATE'
> fs/nfs/nfs4state.c:1195: error: implicit declaration of function '__ratelimit'
> fs/nfs/nfs4state.c:1195: error: '_rs' undeclared (first use in this function)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc:	linux-nfs@vger.kernel.org
> ---
>  fs/nfs/nfs4state.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20101022.orig/fs/nfs/nfs4state.c
> +++ linux-next-20101022/fs/nfs/nfs4state.c
> @@ -46,6 +46,7 @@
>  #include <linux/kthread.h>
>  #include <linux/module.h>
>  #include <linux/random.h>
> +#include <linux/ratelimit.h>
>  #include <linux/workqueue.h>
>  #include <linux/bitops.h>
>  

That one is my fault. Sorry, and thanks Randy! I've applied the fix to
the linux-next branch...

Cheers
  Trond
