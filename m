Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2GNQWC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 12:22:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2GNQV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 12:21:57 -0400
Message-ID: <50019C5E.8020508@redhat.com>
Date: Sat, 14 Jul 2012 12:20:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Don Morris <don.morris@hp.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <20120316144028.036474157@chello.nl> <20120316144241.012558280@chello.nl> <4FFF4987.4050205@redhat.com> <5000347E.1050301@hp.com>
In-Reply-To: <5000347E.1050301@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 10:45 AM, Don Morris wrote:

>> IIRC the test consisted of a 16GB NUMA system with two 8GB nodes.
>> It was running 3 KVM guests, two guests of 3GB memory each, and
>> one guest of 6GB each.
>
> How many cpus per guest (host threads) and how many physical/logical
> cpus per node on the host? Any comparisons with a situation where
> the memory would fit within nodes but the scheduling load would
> be too high?

IIRC this particular test was constructed to have guests
A and B fit in one NUMA node, with guest C in the other
NUMA node.

With schednuma, guest A ended up on one NUMA node, guest
B on the other, and guest C was spread between both nodes.

Only migrating when there is plenty of free space available
means you can end up not doing the right thing when running
a few large workloads on the system.

-- 
All rights reversed
