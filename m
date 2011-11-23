Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1KWJzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:55:35 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50768 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab1KWJzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:55:33 -0500
Date: Wed, 23 Nov 2011 15:24:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (uprobes tree related)
Message-ID: <20111123095443.GA22971@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111123152854.98c60a7c859f28c2efa30717@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111123152854.98c60a7c859f28c2efa30717@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112309-5112-0000-0000-0000025122BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hey Stephen, 

> After merging the uprobes tree, today's linux-next build (sparc64
> defconfig) failed like this:
> 
> In file included from include/linux/mm_types.h:15:0,
>                  from include/linux/kmemcheck.h:4,
>                  from include/linux/skbuff.h:18,
>                  from net/8021q/vlan_core.c:1:
> include/linux/uprobes.h: In function 'register_uprobe':
> include/linux/uprobes.h:148:10: error: 'ENOSYS' undeclared (first use in this function)
> 

Oh sorry for missing this.

> And several more.
> 
> Caused by commit fb16338b69cd ("register_unregister_uprobe" - "Uprobes:
> register/unregister probes").
> 
> I have added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 23 Nov 2011 15:11:20 +1100
> Subject: [PATCH] uprobes: using ENOSYS requires errno.h
> 
> Fixes this build problem:
> 
> In file included from include/linux/mm_types.h:15:0,
>                  from include/linux/kmemcheck.h:4,
>                  from include/linux/skbuff.h:18,
>                  from net/8021q/vlan_core.c:1:
> include/linux/uprobes.h: In function 'register_uprobe':
> include/linux/uprobes.h:148:10: error: 'ENOSYS' undeclared (first use in this function)
> 
> when CONFIG_UPROBES is not defined.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/uprobes.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index 091dfb8..e2e0674 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -23,6 +23,7 @@
>   *	Jim Keniston
>   */
>  
> +#include <linux/errno.h>
>  #include <linux/rbtree.h>
>  
>  struct vm_area_struct;

Yes, this is the right fix. So I will fold this into my patch.

-- 
Thanks and Regards
Srikar

