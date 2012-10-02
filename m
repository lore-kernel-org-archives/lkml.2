Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2JBTyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:54:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63106 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2JBTyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:54:20 -0400
Date: Tue, 2 Oct 2012 12:54:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3] slab: Ignore internal flags in cache creation
In-Reply-To: <1349171968-19243-1-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1210021251330.7383@chino.kir.corp.google.com>
References: <1349171968-19243-1-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Glauber Costa wrote:

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 9c21725..79be32e 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -107,6 +107,13 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size, size_t align
>  	if (!kmem_cache_sanity_check(name, size) == 0)
>  		goto out_locked;
>  
> +	/*
> +	 * Some allocators will constraint the set of valid flags to a subset
> +	 * of all flags. We expect them to define CACHE_CREATE_MASK in this

s/CACHE_CREATE_MASK/SLAB_AVAILABLE_FLAGS/

I don't think SLAB_AVAILABLE_FLAGS is the best name we can come up with, I 
think it should be at least something like CACHE_ALLOWED_FLAGS, but I'm 
fine with whatever it turns out to be.

> +	 * case, and we'll just provide them with a sanitized version of the
> +	 * passed flags.
> +	 */
> +	flags &= SLAB_AVAILABLE_FLAGS;
>  
>  	s = __kmem_cache_alias(name, size, align, flags, ctor);
>  	if (s)
