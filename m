Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2JVPLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:11:46 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51730 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2JVPLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:11:43 -0400
Message-ID: <5085621C.3040904@parallels.com>
Date: Mon, 22 Oct 2012 19:11:24 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, David Rientjes <rientjes@google.com>,
        "Pekka Enberg" <penberg@kernel.org>, <devel@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 15/18] Aggregate memcg cache values in slabinfo
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-16-git-send-email-glommer@parallels.com> <0000013a7a93cb72-588b2a69-ebb0-4b5f-9040-102800d3bef4-000000@email.amazonses.com>
In-Reply-To: <0000013a7a93cb72-588b2a69-ebb0-4b5f-9040-102800d3bef4-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 11:50 PM, Christoph Lameter wrote:
> On Fri, 19 Oct 2012, Glauber Costa wrote:
> 
>> +
>> +/*
>> + * We use suffixes to the name in memcg because we can't have caches
>> + * created in the system with the same name. But when we print them
>> + * locally, better refer to them with the base name
>> + */
>> +static inline const char *cache_name(struct kmem_cache *s)
>> +{
>> +	if (!is_root_cache(s))
>> +		return s->memcg_params->root_cache->name;
>> +	return s->name;
>> +}
> 
> Could we avoid this uglyness? You can ID a slab cache by combining a memcg
> pointer and a slabname.
> 
But that is not what I want.

What I want is to show the cache by its root name in memcg-specific
slabinfo.


