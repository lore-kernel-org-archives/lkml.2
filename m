Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab2KEIPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:15:04 -0500
Received: from mx2.parallels.com ([64.131.90.16]:44550 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2KEIPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:15:02 -0500
Message-ID: <50977570.2010001@parallels.com>
Date: Mon, 5 Nov 2012 09:14:40 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: JoonSoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v6 00/29] kmem controller for memcg.
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <20121101170454.b7713bce.akpm@linux-foundation.org> <50937918.7080302@parallels.com> <CAAmzW4O74e3J9M3Q86Y0wXX6Pfp8GDpv6jAB5ebJPHfAxAeL0Q@mail.gmail.com> <20121102230638.GE27843@mtj.dyndns.org>
In-Reply-To: <20121102230638.GE27843@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.2.49.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 12:06 AM, Tejun Heo wrote:
> Hey, Joonsoo.
> 
> On Sat, Nov 03, 2012 at 04:25:59AM +0900, JoonSoo Kim wrote:
>> I am worrying about data cache footprint which is possibly caused by
>> this patchset, especially slab implementation.
>> If there are several memcg cgroups, each cgroup has it's own kmem_caches.
>> When each group do slab-intensive job hard, data cache may be overflowed easily,
>> and cache miss rate will be high, therefore this would decrease system
>> performance highly.
> 
> It would be nice to be able to remove such overhead too, but the
> baselines for cgroup implementations (well, at least the ones that I
> think important) in somewhat decreasing priority are...
> 
> 1. Don't over-complicate the target subsystem.
> 
> 2. Overhead when cgroup is not used should be minimal.  Prefereably to
>    the level of being unnoticeable.
> 
> 3. Overhead while cgroup is being actively used should be reasonable.
> 
> If you wanna split your system into N groups and maintain memory
> resource segregation among them, I don't think it's unreasonable to
> ask for paying data cache footprint overhead.
> 
> So, while improvements would be nice, I wouldn't consider overheads of
> this type as a blocker.
> 
> Thanks.
> 
There is another thing I should add.

We are essentially replicating all the allocator meta-data, so if you
look at it, this is exactly the same thing as workloads that allocate
from different allocators (i.e.: a lot of network structures, and a lot
of dentries).

In this sense, it really basically depends what is your comparison
point. Full containers - the main (but not exclusive) reason for this,
are more or less an alternative for virtual machines. In those, you
would be allocating from a different cache because you would be getting
those through a bunch of memory address translations. From this, we do a
lot better, since we only change the cache you allocate from, keeping
all the rest unchanged.


