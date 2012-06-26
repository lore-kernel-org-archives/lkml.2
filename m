Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2FZMuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 08:50:55 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58910 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab2FZMux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 08:50:53 -0400
Message-ID: <4FE9AF88.5070803@parallels.com>
Date: Tue, 26 Jun 2012 16:48:08 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Frederic Weisbecker <fweisbec@redhat.com>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-12-git-send-email-glommer@parallels.com> <4FE89807.50708@redhat.com> <20120625183818.GH3869@google.com>
In-Reply-To: <20120625183818.GH3869@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 10:38 PM, Tejun Heo wrote:
> On Mon, Jun 25, 2012 at 06:55:35PM +0200, Frederic Weisbecker wrote:
>> On 06/25/2012 04:15 PM, Glauber Costa wrote:
>>
>>> Because those architectures will draw their stacks directly from
>>> the page allocator, rather than the slab cache, we can directly
>>> pass __GFP_KMEMCG flag, and issue the corresponding free_pages.
>>>
>>> This code path is taken when the architecture doesn't define
>>> CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
>>> THREAD_SIZE >= PAGE_SIZE. Luckily, most - if not all - of the
>>> remaining architectures fall in this category.
>>>
>>> This will guarantee that every stack page is accounted to the memcg
>>> the process currently lives on, and will have the allocations to fail
>>> if they go over limit.
>>>
>>> For the time being, I am defining a new variant of THREADINFO_GFP, not
>>> to mess with the other path. Once the slab is also tracked by memcg,
>>> we can get rid of that flag.
>>>
>>> Tested to successfully protect against :(){ :|:& };:
>>>
>>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>>> CC: Christoph Lameter <cl@linux.com>
>>> CC: Pekka Enberg <penberg@cs.helsinki.fi>
>>> CC: Michal Hocko <mhocko@suse.cz>
>>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> CC: Johannes Weiner <hannes@cmpxchg.org>
>>> CC: Suleiman Souhlal <suleiman@google.com>
>>
>>
>> Acked-by: Frederic Weisbecker <fweisbec@redhat.com>
>
> Frederic, does this (with proper slab accounting added later) achieve
> what you wanted with the task counter?
>

A note: Frederic may confirm, but I think he doesn't even need
the slab accounting to follow to achieve that goal.



