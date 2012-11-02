Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2KBT0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:26:07 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38818 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab2KBT0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:26:00 -0400
MIME-Version: 1.0
In-Reply-To: <50937918.7080302@parallels.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
	<20121101170454.b7713bce.akpm@linux-foundation.org>
	<50937918.7080302@parallels.com>
Date: Sat, 3 Nov 2012 04:25:59 +0900
Message-ID: <CAAmzW4O74e3J9M3Q86Y0wXX6Pfp8GDpv6jAB5ebJPHfAxAeL0Q@mail.gmail.com>
Subject: Re: [PATCH v6 00/29] kmem controller for memcg.
From: JoonSoo Kim <js1304@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

2012/11/2 Glauber Costa <glommer@parallels.com>:
> On 11/02/2012 04:04 AM, Andrew Morton wrote:
>> On Thu,  1 Nov 2012 16:07:16 +0400
>> Glauber Costa <glommer@parallels.com> wrote:
>>
>>> Hi,
>>>
>>> This work introduces the kernel memory controller for memcg. Unlike previous
>>> submissions, this includes the whole controller, comprised of slab and stack
>>> memory.
>>
>> I'm in the middle of (re)reading all this.  Meanwhile I'll push it all
>> out to http://ozlabs.org/~akpm/mmots/ for the crazier testers.
>>
>> One thing:
>>
>>> Numbers can be found at https://lkml.org/lkml/2012/9/13/239
>>
>> You claim in the above that the fork worload is 'slab intensive".  Or
>> at least, you seem to - it's a bit fuzzy.
>>
>> But how slab intensive is it, really?
>>
>> What is extremely slab intensive is networking.  The networking guys
>> are very sensitive to slab performance.  If this hasn't already been
>> done, could you please determine what impact this has upon networking?
>> I expect Eric Dumazet, Dave Miller and Tom Herbert could suggest
>> testing approaches.
>>
>
> I can test it, but unfortunately I am unlikely to get to prepare a good
> environment before Barcelona.
>
> I know, however, that Greg Thelen was testing netperf in his setup.
> Greg, do you have any publishable numbers you could share?

Below is my humble opinion.
I am worrying about data cache footprint which is possibly caused by
this patchset, especially slab implementation.
If there are several memcg cgroups, each cgroup has it's own kmem_caches.
When each group do slab-intensive job hard, data cache may be overflowed easily,
and cache miss rate will be high, therefore this would decrease system
performance highly.
Is there any result about this?

Thanks.
