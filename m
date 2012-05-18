Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab2ERPpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab2ERPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:45:52 -0400
Message-ID: <4FB66756.2060302@redhat.com>
Date: Fri, 18 May 2012 11:14:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
In-Reply-To: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 06:42 AM, tip-bot for Peter Zijlstra wrote:

> Now that we have a NUMA process scheduler, provide a syscall
> interface for finer granularity NUMA balancing. In particular
> this allows setting up NUMA groups of threads and vmas within
> a process.
>
> For this we introduce two new syscalls:
>
>   sys_numa_tbind(int tig, int ng_id, unsigned long flags);
>
> Bind a thread to a numa group, query its binding or create a new group:
>
>   sys_numa_tbind(tid, -1, 0);	 // create new group, return new ng_id
>   sys_numa_tbind(tid, -2, 0);	 // returns existing ng_id
>   sys_numa_tbind(tid, ng_id, 0);  // set ng_id

I am not convinced this is the right way forward.

While this may work well for programs written in languages
with pointers, and for virtual machines, I do not see how
eg. a JVM could provide useful hints to the kernel, because
the Java program running on top has no idea about the
memory addresses of its objects, and the Java language has
no way to hint which thread will be the predominant user
of an object.

I like your code for handling smaller processes in NUMA
systems, but we do need to have a serious discussion on
how to handle processes that do not fit in one node.

The more I think about it, the more Andrea's code looks
like it might be the more flexible way forward.

Another topic to discuss is whether we want lazy
migrate-on-fault, or if we want to keep the program
spend its time running, using another (idle) core to
do the migration in the background.

-- 
All rights reversed
