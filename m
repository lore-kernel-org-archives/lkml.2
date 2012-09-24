Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2IXIPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:15:52 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45215 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab2IXIPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:15:50 -0400
Message-ID: <506015E7.8030900@parallels.com>
Date: Mon, 24 Sep 2012 12:12:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        <linux-mm@kvack.org>, Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in kmem_create_cache
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-6-git-send-email-glommer@parallels.com> <20120921181458.GG7264@google.com>
In-Reply-To: <20120921181458.GG7264@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 10:14 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Tue, Sep 18, 2012 at 06:11:59PM +0400, Glauber Costa wrote:
>> +void memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *cachep)
>> +{
>> +	int id = -1;
>> +
>> +	if (!memcg)
>> +		id = ida_simple_get(&cache_types, 0, MAX_KMEM_CACHE_TYPES,
>> +				    GFP_KERNEL);
>> +	cachep->memcg_params.id = id;
>> +}
> 
> I'm a bit confused.  Why is id allocated only when memcg is NULL?
> 

I think you figured that out already from your answer in another patch,
right? But I'll add a comment here since it seems to be a a natural
search point for people, explaining the mechanism.

> Also, how would the per-memcg slab/slubs appear in slabinfo?  If they
> appear separately it might be better to give them readable cgroup
> names.
>

The new caches will appear under /proc/slabinfo with the rest, with a
string appended that identifies the group.

> Thanks.
> 

