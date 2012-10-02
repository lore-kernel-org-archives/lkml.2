Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab2JBDQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 23:16:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56589 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2JBDQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 23:16:58 -0400
Date: Mon, 1 Oct 2012 20:16:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2] slab: Ignore internal flags in cache creation
In-Reply-To: <1349088458-3940-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1210012015190.30896@chino.kir.corp.google.com>
References: <1349088458-3940-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012, Glauber Costa wrote:

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 9c21725..f2682ee 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -107,6 +107,15 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align
>  	if (!kmem_cache_sanity_check(name, size) == 0)
>  		goto out_locked;
>  
> +	/*
> +	 * Some allocators will constraint the set of valid flags to a subset
> +	 * of all flags. We expect them to define CACHE_CREATE_MASK in this
> +	 * case, and we'll just provide them with a sanitized version of the
> +	 * passed flags.
> +	 */
> +#ifdef CACHE_CREATE_MASK
> +	flags &= ~CACHE_CREATE_MASK;
> +#endif
>  
>  	s = __kmem_cache_alias(name, size, align, flags, ctor);
>  	if (s)

flags &= CACHE_CREATE_MASK

After that's done:

	Acked-by: David Rientjes <rientjes@google.com>

Thanks for working through this.
