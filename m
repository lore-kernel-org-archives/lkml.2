Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2EPGOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:14:12 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38227 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab2EPGOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:14:10 -0400
Message-ID: <4FB34534.3070306@parallels.com>
Date: Wed, 16 May 2012 10:12:04 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 01/29] slab: dup name string
References: <1336758272-24284-1-git-send-email-glommer@parallels.com> <1336758272-24284-2-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205151502000.18595@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205151502000.18595@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 02:04 AM, David Rientjes wrote:
> On Fri, 11 May 2012, Glauber Costa wrote:
>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index e901a36..91b9c13 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -2118,6 +2118,7 @@ static void __kmem_cache_destroy(struct kmem_cache *cachep)
>>   			kfree(l3);
>>   		}
>>   	}
>> +	kfree(cachep->name);
>>   	kmem_cache_free(&cache_cache, cachep);
>>   }
>>
>> @@ -2526,7 +2527,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
>>   		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
>>   	}
>>   	cachep->ctor = ctor;
>> -	cachep->name = name;
>> +	cachep->name = kstrdup(name, GFP_KERNEL);
>>
>>   	if (setup_cpu_cache(cachep, gfp)) {
>>   		__kmem_cache_destroy(cachep);
>
> Couple problems:
>
>   - allocating memory for a string of an unknown, unchecked size, and
>
>   - could potentially return NULL which I suspect will cause problems
>     later.

Well, this is what slub does.

I sent already two patches for it: One removing this from the slub, one 
adding this to the slab.

Right now I am comfortable with this one, because it makes it slightly 
easier in the latest patches of my series.

But note the word: slightest.

I am comfortable with any, provided slub and slab start behaving the same.

So whatever you guys decide between yourselves is fine, provided there 
is a decision.

Thanks for your review, David!
