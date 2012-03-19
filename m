Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031098Ab2CSM1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:27:42 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:32982 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758334Ab2CSM1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:27:41 -0400
Message-ID: <4F672629.60606@linux.vnet.ibm.com>
Date: Mon, 19 Mar 2012 17:57:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 15/26] sched, numa: Implement hotplug hooks
References: <20120316144028.036474157@chello.nl> <20120316144241.074193109@chello.nl> <4F672384.7030500@linux.vnet.ibm.com> <1332159598.18960.320.camel@twins>
In-Reply-To: <1332159598.18960.320.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031902-1396-0000-0000-000000D5FE7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 05:49 PM, Peter Zijlstra wrote:

> On Mon, 2012-03-19 at 17:46 +0530, Srivatsa S. Bhat wrote:
>>> +     get_online_cpus();
>>> +     cpu_notifier(numa_hotplug, 0);
>>
>>
>> ABBA deadlock!
>>
> Yeah, I know.. luckily it can't actually happen since early_initcalls
> are pre-smp. I could just leave out the get_online_cpus() thing.
> 


Oh numa_init() is an early_initcall? Ok, I didn't observe.
In that case, its fine either way, with or without get_online_cpus()
stuff.

Regards,
Srivatsa S. Bhat

