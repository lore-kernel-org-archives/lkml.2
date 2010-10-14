Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0JNEsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:48:37 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:50418 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762Ab0JNEsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:48:36 -0400
Date: Thu, 14 Oct 2010 15:48:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: xfs-masters@oss.sgi.com, lkml <linux-kernel@vger.kernel.org>,
        Alex Elder <aelder@sgi.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] xfs: eliminate kconfig dependency warning
Message-ID: <20101014044808.GB4681@dastard>
References: <20101013210142.9d524535.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013210142.9d524535.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:01:42PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig dependency warning to satisfy dependencies:
> 
> warning: (XFS_FS && BLOCK || NFSD && NETWORK_FILESYSTEMS && INET && FILE_LOCKING && BKL) selects EXPORTFS which has unmet direct dependencies (NETWORK_FILESYSTEMS)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  fs/xfs/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20101013.orig/fs/xfs/Kconfig
> +++ linux-next-20101013/fs/xfs/Kconfig
> @@ -1,6 +1,6 @@
>  config XFS_FS
>  	tristate "XFS filesystem support"
> -	depends on BLOCK
> +	depends on BLOCK && NETWORK_FILESYSTEMS
>  	select EXPORTFS
>  	help
>  	  XFS is a high performance journaling filesystem which originated

This looks wrong to me.  IIUC, this means if you turn of network
filesystem support (e.g no NFS, CIFS, etc), you can't select XFS
even though it is a local filesystem.

EXPORTFS functionality actually has use for local filesystems - the
open-by-handle interfaces in XFS are what uses it, and there are patches
about that make this generic for most filesystems. Hence it seems to
me that the correct thing to do is separate EXPORTFS from
NETWORK_FILESYSTEMS, not make local filesystems depend on a user
selecting network filesystem support....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
