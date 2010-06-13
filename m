Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab0FMHrk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:47:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab0FMHrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:47:39 -0400
Date: Sun, 13 Jun 2010 00:47:20 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Michael Ellerman <michael@ellerman.id.au>
cc: linuxppc-dev@ozlabs.org, monstr@monstr.eu,
       microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] device-tree: Drop properties with "/" in their name
In-Reply-To: <0958c243b32f5f77028a794a9ce0d55f9a12121e.1274272289.git.michael@ellerman.id.au>
Message-ID: <alpine.DEB.2.01.1006130045230.3964@bogon.housecafe.de>
References: <0958c243b32f5f77028a794a9ce0d55f9a12121e.1274272289.git.michael@ellerman.id.au>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+O13xEdrTb9jSxoHCVhsyvHGbTP7cF4LZ8lzC
 GiZBMKfmPY8f+byoz7DSpLHCmcNG5EM4Ev2apBnfYUMjuub5Js
 Rp1y6Dpei7MvqhvEOHIUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 at 22:32, Michael Ellerman wrote:
> Some bogus firmwares include properties with "/" in their name. This
> causes problems when creating the /proc/device-tree file system,
> because the slash is taken to indicate a directory.
> 
> We don't care about those properties, and we don't want to encourage
> them, so just throw them away when creating /proc/device-tree.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
> 
> Hi Christian, if you could test this new patch that'd be great, thanks!

I've tested the patch, the Badness is gone and the system is stable as 
ever. Will this be pushed to 2.6.35?

Thanks,
Christian.

>  fs/proc/proc_devtree.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
> index ce94801..d9396a4 100644
> --- a/fs/proc/proc_devtree.c
> +++ b/fs/proc/proc_devtree.c
> @@ -209,6 +209,9 @@ void proc_device_tree_add_node(struct device_node *np,
>  	for (pp = np->properties; pp != NULL; pp = pp->next) {
>  		p = pp->name;
>  
> +		if (strchr(p, '/'))
> +			continue;
> +
>  		if (duplicate_name(de, p))
>  			p = fixup_name(np, de, p);
>  
> -- 
> 1.7.0.4
> 
> 
> 

-- 
BOFH excuse #334:

50% of the manual is in .pdf readme files
