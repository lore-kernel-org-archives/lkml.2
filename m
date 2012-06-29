Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab2F2QMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab2F2QMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:12:30 -0400
Message-ID: <4FEDD3BB.2020600@redhat.com>
Date: Fri, 29 Jun 2012 12:11:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Hillf Danton <dhillf@gmail.com>,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 09/40] autonuma: introduce kthread_bind_node()
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>  <1340888180-15355-10-git-send-email-aarcange@redhat.com>  <4FEDCB7A.1060007@redhat.com> <1340985857.28750.100.camel@twins>
In-Reply-To: <1340985857.28750.100.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2012 12:04 PM, Peter Zijlstra wrote:
> On Fri, 2012-06-29 at 11:36 -0400, Rik van Riel wrote:
>> On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
>>
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -1792,7 +1792,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
>>>    #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
>>>    #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
>>>    #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
>>> -#define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
>>> +#define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpus */
>>>    #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
>>>    #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
>>>    #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
>>
>> Changing the semantics of PF_THREAD_BOUND without so much as
>> a comment in your changelog or buy-in from the scheduler
>> maintainers is a big no-no.
>
> In fact I've already said a number of times this patch isn't going
> anywhere.

Which is probably fine, because I see no reason why Andrea's
numa threads would need PF_THREAD_BOUND in the first place.

Andrea?

-- 
All rights reversed
