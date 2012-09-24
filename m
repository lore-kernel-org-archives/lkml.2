Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2IXIVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:21:10 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55440 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab2IXIVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:21:08 -0400
Message-ID: <50601721.6040805@parallels.com>
Date: Mon, 24 Sep 2012 12:17:37 +0400
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
Subject: Re: [PATCH v3 06/16] memcg: infrastructure to match an allocation
 to the right cache
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-7-git-send-email-glommer@parallels.com> <20120921205236.GT7264@google.com>
In-Reply-To: <20120921205236.GT7264@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 12:52 AM, Tejun Heo wrote:
> Missed some stuff.
> 
> On Tue, Sep 18, 2012 at 06:12:00PM +0400, Glauber Costa wrote:
>> +static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>> +						  struct kmem_cache *cachep)
>> +{
> ...
>> +	memcg->slabs[idx] = new_cachep;
> ...
>> +struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep,
>> +					  gfp_t gfp)
>> +{
> ...
>> +	return memcg->slabs[idx];
> 
> I think you need memory barriers for the above pair.
> 
> Thanks.
> 

Why is that?

We'll either see a value, or NULL. If we see NULL, we assume the cache
is not yet created. Not a big deal.

