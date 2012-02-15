Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2BOQKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:10:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:42711 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2BOQKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:10:31 -0500
Date: Wed, 15 Feb 2012 11:07:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>, James Morris <jmorris@namei.org>
Subject: Re: linux-next: build failure after merge of the tmem tree
Message-ID: <20120215160707.GB4093@phenom.dumpdata.com>
References: <20120215144131.e1c3b7bbe9c30f6b622872c2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215144131.e1c3b7bbe9c30f6b622872c2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F3BD8E6.0023,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 02:41:31PM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> After merging the tmem tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> mm/frontswap.c: In function 'frontswap_shrink':
> mm/frontswap.c:217:3: error: implicit declaration of function 'security_vm_enough_memory_kern' [-Werror=implicit-function-declaration]
> 
> Caused by commit 8174e70a6bde ("mm: frontswap: core frontswap
> functionality") interacting with commit 191c542442fd ("mm: collapse
> security_vm_enough_memory() variants into a single function") from the
> security tree.
> 
> I applied the following merge fix:
> 

Sweeet. Thanks!

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 15 Feb 2012 14:35:31 +1100
> Subject: [PATCH] mm: frontswap: update for security_vm_enough_memory API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/frontswap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/frontswap.c b/mm/frontswap.c
> index d7c91e3..2b80c5a 100644
> --- a/mm/frontswap.c
> +++ b/mm/frontswap.c
> @@ -214,7 +214,7 @@ void frontswap_shrink(unsigned long target_pages)
>  			pages_to_unuse = 0; /* unuse all */
>  		}
>  		/* ensure there is enough RAM to fetch pages from frontswap */
> -		if (security_vm_enough_memory_kern(pages))
> +		if (security_vm_enough_memory_mm(current->mm, pages))
>  			continue;
>  		vm_unacct_memory(pages);
>  		break;
> -- 
> 1.7.9
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


