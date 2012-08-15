Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2HOSD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:03:56 -0400
Received: from mx2.parallels.com ([64.131.90.16]:35828 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab2HOSDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:03:55 -0400
Message-ID: <502BE3CB.2070306@parallels.com>
Date: Wed, 15 Aug 2012 22:00:43 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ying Han <yinghan@google.com>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>, <devel@openvz.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        "David Rientjes" <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v2 04/11] kmem accounting basic infrastructure
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-5-git-send-email-glommer@parallels.com> <20120814162144.GC6905@dhcp22.suse.cz> <502B6D03.1080804@parallels.com> <20120815123931.GF23985@dhcp22.suse.cz> <CALWz4ixYXN9FGJ1E9CZ9viJ=s3k63Pm8t3nakQvi+1T5qtyFYw@mail.gmail.com>
In-Reply-To: <CALWz4ixYXN9FGJ1E9CZ9viJ=s3k63Pm8t3nakQvi+1T5qtyFYw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.1.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:01 PM, Ying Han wrote:
> On Wed, Aug 15, 2012 at 5:39 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> On Wed 15-08-12 13:33:55, Glauber Costa wrote:
>> [...]
>>>> This can
>>>> be quite confusing.  I am still not sure whether we should mix the two
>>>> things together. If somebody wants to limit the kernel memory he has to
>>>> touch the other limit anyway.  Do you have a strong reason to mix the
>>>> user and kernel counters?
>>>
>>> This is funny, because the first opposition I found to this work was
>>> "Why would anyone want to limit it separately?" =p
>>>
>>> It seems that a quite common use case is to have a container with a
>>> unified view of "memory" that it can use the way he likes, be it with
>>> kernel memory, or user memory. I believe those people would be happy to
>>> just silently account kernel memory to user memory, or at the most have
>>> a switch to enable it.
>>>
>>> What gets clear from this back and forth, is that there are people
>>> interested in both use cases.
>>
>> I am still not 100% sure myself. It is just clear that the reclaim would
>> need some work in order to do accounting like this.
>>
>>>> My impression was that kernel allocation should simply fail while user
>>>> allocations might reclaim as well. Why should we reclaim just because of
>>>> the kernel allocation (which is unreclaimable from hard limit reclaim
>>>> point of view)?
>>>
>>> That is not what the kernel does, in general. We assume that if he wants
>>> that memory and we can serve it, we should. Also, not all kernel memory
>>> is unreclaimable. We can shrink the slabs, for instance. Ying Han
>>> claims she has patches for that already...
>>
>> Are those patches somewhere around?
> 
> Yes, I am working on it to post it sometime *this week*. My last
> rebase is based on v3.3 and now I am trying to get it rebased to
> github-memcg. The patch itself has a functional dependency on kernel
> slab accounting, and I am trying to get that rebased on Glauber's tree
> but has some difficulty now. What I am planning to do is post the RFC
> w/ only complied version by far.

That would be great, so we can start looking at its design, at least.

> The patch handles dentry cache shrinker only at this moment. That is
> what we discussed last time as well, where dentry contributes most of
> the reclaimable objects. (it pins inode, so we leave inode behind)
> 

This will mark the inodes as reclaimable, but will leave them in memory.
If we are assuming memory pressure, it would be good to shrink them too.


