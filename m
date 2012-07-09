Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2GIJFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:05:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56181 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2GIJFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:05:02 -0400
Date: Mon, 9 Jul 2012 12:04:52 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Julia Lawall <Julia.Lawall@lip6.fr>
cc: Christoph Lameter <cl@linux-foundation.org>,
        kernel-janitors@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] mm/slub.c: remove invalid reference to list iterator
 variable
In-Reply-To: <1341747464-1772-4-git-send-email-Julia.Lawall@lip6.fr>
Message-ID: <alpine.LFD.2.02.1207091204450.3050@tux.localdomain>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr> <1341747464-1772-4-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2012, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> If list_for_each_entry, etc complete a traversal of the list, the iterator
> variable ends up pointing to an address at an offset from the list head,
> and not a meaningful structure.  Thus this value should not be used after
> the end of the iterator.  The patch replaces s->name by al->name, which is
> referenced nearby.
> 
> This problem was found using Coccinelle (http://coccinelle.lip6.fr/).
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  mm/slub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index cc4ed03..ef9bf01 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5395,7 +5395,7 @@ static int __init slab_sysfs_init(void)
>  		err = sysfs_slab_alias(al->s, al->name);
>  		if (err)
>  			printk(KERN_ERR "SLUB: Unable to add boot slab alias"
> -					" %s to sysfs\n", s->name);
> +					" %s to sysfs\n", al->name);
>  		kfree(al);
>  	}

Applied, thanks!
