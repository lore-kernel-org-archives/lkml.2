Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2K1Jfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:35:54 -0500
Received: from mx2.parallels.com ([64.131.90.16]:36251 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab2K1Jfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:35:53 -0500
Message-ID: <50B5DAEE.6060009@parallels.com>
Date: Wed, 28 Nov 2012 13:35:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        "Ying Han" <yinghan@google.com>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [patch v2 3/6] memcg: rework mem_cgroup_iter to use cgroup iterators
References: <1353955671-14385-1-git-send-email-mhocko@suse.cz> <1353955671-14385-4-git-send-email-mhocko@suse.cz> <50B5CFBF.2090100@jp.fujitsu.com> <20121128091745.GC12309@dhcp22.suse.cz> <50B5D82D.6010109@parallels.com> <20121128093336.GD12309@dhcp22.suse.cz>
In-Reply-To: <20121128093336.GD12309@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 01:33 PM, Michal Hocko wrote:
> On Wed 28-11-12 13:23:57, Glauber Costa wrote:
>> On 11/28/2012 01:17 PM, Michal Hocko wrote:
>>> On Wed 28-11-12 17:47:59, KAMEZAWA Hiroyuki wrote:
>>>> (2012/11/27 3:47), Michal Hocko wrote:
>>> [...]
>>>>> +		/*
>>>>> +		 * Even if we found a group we have to make sure it is alive.
>>>>> +		 * css && !memcg means that the groups should be skipped and
>>>>> +		 * we should continue the tree walk.
>>>>> +		 * last_visited css is safe to use because it is protected by
>>>>> +		 * css_get and the tree walk is rcu safe.
>>>>> +		 */
>>>>> +		if (css == &root->css || (css && css_tryget(css)))
>>>>> +			memcg = mem_cgroup_from_css(css);
>>>>
>>>> Could you note that this iterator will never visit dangling(removed)
>>>> memcg, somewhere ?
>>>
>>> OK, I can add it to the function comment but the behavior hasn't changed
>>> so I wouldn't like to confuse anybody.
>>>
>>>> Hmm, I'm not sure but it may be trouble at shrkinking dangling
>>>> kmem_cache(slab).
>>>
>>> We do not shrink slab at all. 
>>
>> yet. However...
>>
>>> Those objects that are in a dead memcg
>>> wait for their owner tho release them which will make the dangling group
>>> eventually go away
>>>
>>>>
>>>> Costa, how do you think ?
>>>>
>>
>> In general, I particularly believe it is a good idea to skip dead memcgs
>> in the iterator. I don't anticipate any problems with shrinking at all.
> 
> We even cannot iterate dead ones because their cgroups are gone and so
> you do not have any way to iterate. So either make them alive by css_get
> or we cannot iterate them.
> 

We are in full agreement.


