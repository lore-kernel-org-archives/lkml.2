Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2GIOvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:51:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab2GIOvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:51:42 -0400
Message-ID: <4FFAEFCA.4030106@redhat.com>
Date: Mon, 09 Jul 2012 10:50:50 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 14/26] sched, numa: Numa balancer
References: <20120316144028.036474157@chello.nl>  <20120316144241.012558280@chello.nl> <4FF87F5F.30106@redhat.com>  <1341836629.3462.60.camel@twins> <1341837624.3462.68.camel@twins>
In-Reply-To: <1341837624.3462.68.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2012 08:40 AM, Peter Zijlstra wrote:
> On Mon, 2012-07-09 at 14:23 +0200, Peter Zijlstra wrote:
>>> It is not yet clear to me how and why your code converges.
>>
>> I don't think it does.. but since the scheduler interaction is fairly
>> weak it doesn't matter too much from that pov.

Fair enough. It is just that you asked this same question
about Andrea's code, and I was asking myself that question
while reading your code (and failing to figure it out).

> That is,.. it slowly moves along with the cpu usage, only if there's a
> lot of remote memory allocations (memory pressure) things get funny.
>
> It'll try and rotate all tasks around a bit trying, but there's no good
> solution for a memory hole on one node and a cpu hole on another, you're
> going to have to take the remote hits.

Agreed, I suspect both your code and Andrea's code will
end up behaving fairly similarly in that situation.

> Again.. what do we want it to do?

That is a good question.

We can have various situations to deal with:

1) tasks fit nicely inside NUMA nodes
2) some tasks have more memory than what fits
    in a NUMA node
3) some tasks have more threads than what fits
    in a NUMA node
4) a combination of the above

I guess what we want the NUMA code to do to increase
the number of local memory accesses for each thread,
and do so in a relatively light weight way.

-- 
All rights reversed
