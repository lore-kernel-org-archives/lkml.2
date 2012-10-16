Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2JPArp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:47:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36259 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2JPArn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:47:43 -0400
Date: Mon, 15 Oct 2012 17:47:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v4] slab: Ignore internal flags in cache creation
In-Reply-To: <alpine.DEB.2.00.1210081424340.22552@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1210151747290.31712@chino.kir.corp.google.com>
References: <1349434154-8000-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210081424340.22552@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012, David Rientjes wrote:

> > diff --git a/mm/slab.h b/mm/slab.h
> > index 7deeb44..4c35c17 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -45,6 +45,31 @@ static inline struct kmem_cache *__kmem_cache_alias(const char *name, size_t siz
> >  #endif
> >  
> >  
> > +/* Legal flag mask for kmem_cache_create(), for various configurations */
> > +#define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | SLAB_PANIC | \
> > +			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS )
> > +
> > +#if defined(CONFIG_DEBUG_SLAB)
> > +#define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
> > +#elif defined(CONFIG_SLUB_DEBUG)
> > +#define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
> > +			  SLAB_TRACE | SLAB_DEBUG_FREE)
> > +#else
> > +#define SLAB_DEBUG_FLAGS (0)
> > +#endif
> > +
> > +#if defined(CONFIG_SLAB)
> > +#define SLAB_CACHE_FLAGS (SLAB_MEMSPREAD | SLAB_NOLEAKTRACE | \
> 
> s/SLAB_MEMSPREAD/SLAB_MEM_SPREAD/
> 

Did you have a v5 of this patch with the above fix?
