Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2CKKye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 06:54:34 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53779 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab2CKKya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 06:54:30 -0400
Message-ID: <4F5C8414.5090800@parallels.com>
Date: Sun, 11 Mar 2012 14:53:08 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Suleiman Souhlal <ssouhlal@FreeBSD.org>
CC: <cgroups@vger.kernel.org>, <suleiman@google.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <penberg@kernel.org>, <cl@linux.com>,
        <yinghan@google.com>, <hughd@google.com>, <gthelen@google.com>,
        <peterz@infradead.org>, <dan.magenheimer@oracle.com>,
        <hannes@cmpxchg.org>, <mgorman@suse.de>,
        <James.Bottomley@HansenPartnership.com>, <linux-mm@kvack.org>,
        <devel@openvz.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 06/13] slab: Add kmem_cache_gfp_flags() helper function.
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org> <1331325556-16447-7-git-send-email-ssouhlal@FreeBSD.org>
In-Reply-To: <1331325556-16447-7-git-send-email-ssouhlal@FreeBSD.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2012 12:39 AM, Suleiman Souhlal wrote:
> This function returns the gfp flags that are always applied to
> allocations of a kmem_cache.
>
> Signed-off-by: Suleiman Souhlal<suleiman@google.com>
> ---
>   include/linux/slab_def.h |    6 ++++++
>   include/linux/slob_def.h |    6 ++++++
>   include/linux/slub_def.h |    6 ++++++
>   3 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> index fbd1117..25f9a6a 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -159,6 +159,12 @@ found:
>   	return __kmalloc(size, flags);
>   }
>
> +static inline gfp_t
> +kmem_cache_gfp_flags(struct kmem_cache *cachep)
> +{
> +	return cachep->gfpflags;
> +}
> +
>   #ifdef CONFIG_NUMA
>   extern void *__kmalloc_node(size_t size, gfp_t flags, int node);
>   extern void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
> diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
> index 0ec00b3..3fa527d 100644
> --- a/include/linux/slob_def.h
> +++ b/include/linux/slob_def.h
> @@ -34,4 +34,10 @@ static __always_inline void *__kmalloc(size_t size, gfp_t flags)
>   	return kmalloc(size, flags);
>   }
>
> +static inline gfp_t
> +kmem_cache_gfp_flags(struct kmem_cache *cachep)
> +{
> +	return 0;
> +}
> +
>   #endif /* __LINUX_SLOB_DEF_H */
> diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> index a32bcfd..5911d81 100644
> --- a/include/linux/slub_def.h
> +++ b/include/linux/slub_def.h
> @@ -313,4 +313,10 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
>   }
>   #endif
>
> +static inline gfp_t
> +kmem_cache_gfp_flags(struct kmem_cache *cachep)
> +{
> +	return cachep->allocflags;
> +}
> +

Why is this needed? Can't the caller just call 
mem_cgroup_get_kmem_cache(cachep, flags | cachep->allocflags) ?

>   #endif /* _LINUX_SLUB_DEF_H */

