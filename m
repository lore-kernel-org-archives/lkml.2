Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2E3M2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:28:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:52645 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab2E3M2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:28:52 -0400
Message-ID: <4FC611F4.7010202@parallels.com>
Date: Wed, 30 May 2012 16:26:28 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <devel@openvz.org>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge infrastructure
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-17-git-send-email-glommer@parallels.com> <20120530121706.GB25094@somewhere.redhat.com>
In-Reply-To: <20120530121706.GB25094@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 04:17 PM, Frederic Weisbecker wrote:
> On Fri, May 25, 2012 at 05:03:36PM +0400, Glauber Costa wrote:
>>   #endif /* CONFIG_CGROUP_MEM_RES_CTLR_KMEM */
>> +static __always_inline struct kmem_cache *
>> +mem_cgroup_get_kmem_cache(struct kmem_cache *cachep, gfp_t gfp)
>> +{
>> +	if (!mem_cgroup_kmem_on)
>> +		return cachep;
>> +	if (!current->mm)
>> +		return cachep;
>> +	if (in_interrupt())
>> +		return cachep;
>
> Does that mean interrupts are kept out of accounting?

Well, since interrupts have no process context, if you are in an 
interrupt I can't think of any sane thing to do than relay it to the 
root memcg. That's what happen when I return cachep: I return the 
original parent cache, and we allocate from that.

