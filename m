Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365Ab2EOWES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:04:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab2EOWEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:04:16 -0400
Date: Tue, 15 May 2012 15:04:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 01/29] slab: dup name string
In-Reply-To: <1336758272-24284-2-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205151502000.18595@chino.kir.corp.google.com>
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-2-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Glauber Costa wrote:

> diff --git a/mm/slab.c b/mm/slab.c
> index e901a36..91b9c13 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2118,6 +2118,7 @@ static void __kmem_cache_destroy(struct kmem_cache *cachep)
>  			kfree(l3);
>  		}
>  	}
> +	kfree(cachep->name);
>  	kmem_cache_free(&cache_cache, cachep);
>  }
>  
> @@ -2526,7 +2527,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>  		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
>  	}
>  	cachep->ctor = ctor;
> -	cachep->name = name;
> +	cachep->name = kstrdup(name, GFP_KERNEL);
>  
>  	if (setup_cpu_cache(cachep, gfp)) {
>  		__kmem_cache_destroy(cachep);

Couple problems:

 - allocating memory for a string of an unknown, unchecked size, and

 - could potentially return NULL which I suspect will cause problems 
   later.
