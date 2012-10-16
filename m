Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab2JPIw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:52:58 -0400
Received: from mx2.parallels.com ([64.131.90.16]:33810 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2JPIw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:52:56 -0400
Message-ID: <507D2061.3030101@parallels.com>
Date: Tue, 16 Oct 2012 12:52:49 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v4] slab: Ignore internal flags in cache creation
References: <1349434154-8000-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1210081424340.22552@chino.kir.corp.google.com> <alpine.DEB.2.00.1210151747290.31712@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210151747290.31712@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 04:47 AM, David Rientjes wrote:
> On Mon, 8 Oct 2012, David Rientjes wrote:
> 
>>> diff --git a/mm/slab.h b/mm/slab.h
>>> index 7deeb44..4c35c17 100644
>>> --- a/mm/slab.h
>>> +++ b/mm/slab.h
>>> @@ -45,6 +45,31 @@ static inline struct kmem_cache *__kmem_cache_alias(const char *name, size_t siz
>>>  #endif
>>>  
>>>  
>>> +/* Legal flag mask for kmem_cache_create(), for various configurations */
>>> +#define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | SLAB_PANIC | \
>>> +			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS )
>>> +
>>> +#if defined(CONFIG_DEBUG_SLAB)
>>> +#define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
>>> +#elif defined(CONFIG_SLUB_DEBUG)
>>> +#define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
>>> +			  SLAB_TRACE | SLAB_DEBUG_FREE)
>>> +#else
>>> +#define SLAB_DEBUG_FLAGS (0)
>>> +#endif
>>> +
>>> +#if defined(CONFIG_SLAB)
>>> +#define SLAB_CACHE_FLAGS (SLAB_MEMSPREAD | SLAB_NOLEAKTRACE | \
>>
>> s/SLAB_MEMSPREAD/SLAB_MEM_SPREAD/
>>
> 
> Did you have a v5 of this patch with the above fix?
> 
Yes, I sent it bundled in my kmemcg-slab series.

I can send it separately as well, no problem. (Or we can merge the
series!!! =p )

