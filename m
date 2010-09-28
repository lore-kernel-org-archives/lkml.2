Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab0I1TkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 15:40:10 -0400
Received: from cobra.newdream.net ([66.33.216.30]:40911 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab0I1TkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 15:40:07 -0400
Date: Tue, 28 Sep 2010 12:42:10 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH -next] ceph: fix debugfs warnings
In-Reply-To: <20100928095310.2983a888.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.1009281241450.16237@cobra.newdream.net>
References: <20100928141823.8c61000e.sfr@canb.auug.org.au>
 <20100928095310.2983a888.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Randy.  This is in my for-next branch now!

sage


On Tue, 28 Sep 2010, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Include "super.h" outside of CONFIG_DEBUG_FS to eliminate a compiler warning:
> 
> fs/ceph/debugfs.c:266: warning: 'struct ceph_fs_client' declared inside parameter list
> fs/ceph/debugfs.c:266: warning: its scope is only this definition or declaration, which is probably not what you want
> fs/ceph/debugfs.c:271: warning: 'struct ceph_fs_client' declared inside parameter list
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  fs/ceph/debugfs.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-next-20100927.orig/fs/ceph/debugfs.c
> +++ linux-next-20100927/fs/ceph/debugfs.c
> @@ -12,9 +12,10 @@
>  #include <linux/ceph/auth.h>
>  #include <linux/ceph/debugfs.h>
>  
> +#include "super.h"
> +
>  #ifdef CONFIG_DEBUG_FS
>  
> -#include "super.h"
>  #include "mds_client.h"
>  
>  static int mdsmap_show(struct seq_file *s, void *p)
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
