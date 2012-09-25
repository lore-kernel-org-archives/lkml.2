Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab2IYOBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:01:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51005 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab2IYOBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:01:18 -0400
Message-ID: <5061B852.7070902@parallels.com>
Date: Tue, 25 Sep 2012 17:57:38 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        <linux-mm@kvack.org>, Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 06/16] memcg: infrastructure to match an allocation
 to the right cache
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-7-git-send-email-glommer@parallels.com> <20120921183217.GH7264@google.com> <50601DEB.10705@parallels.com> <20120924175619.GD7694@google.com>
In-Reply-To: <20120924175619.GD7694@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 09:56 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Mon, Sep 24, 2012 at 12:46:35PM +0400, Glauber Costa wrote:
>>>> +#ifdef CONFIG_MEMCG_KMEM
>>>> +	/* Slab accounting */
>>>> +	struct kmem_cache *slabs[MAX_KMEM_CACHE_TYPES];
>>>> +#endif
>>>
>>> Bah, 400 entry array in struct mem_cgroup.  Can't we do something a
>>> bit more flexible?
>>>
>>
>> I guess. I still would like it to be an array, so we can easily access
>> its fields. There are two ways around this:
>>
>> 1) Do like the events mechanism and allocate this in a separate
>> structure. Add a pointer chase in the access, and I don't think it helps
>> much because it gets allocated anyway. But we could at least
>> defer it to the time when we limit the cache.
> 
> Start at some reasonable size and then double it as usage grows?  How
> many kmem_caches do we typically end up using?
> 

So my Fedora box here, recently booted on a Fedora kernel, will have 111
caches. How would 150 sound to you?
