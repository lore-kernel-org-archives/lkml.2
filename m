Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab2ERPtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:49:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab2ERPtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:49:23 -0400
Message-ID: <4FB66F5D.4020803@redhat.com>
Date: Fri, 18 May 2012 11:48:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>  <4FB66756.2060302@redhat.com> <1337355341.573.68.camel@twins>
In-Reply-To: <1337355341.573.68.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 11:35 AM, Peter Zijlstra wrote:
> On Fri, 2012-05-18 at 11:14 -0400, Rik van Riel wrote:

>> While this may work well for programs written in languages
>> with pointers, and for virtual machines, I do not see how
>> eg. a JVM could provide useful hints to the kernel, because
>> the Java program running on top has no idea about the
>> memory addresses of its objects, and the Java language has
>> no way to hint which thread will be the predominant user
>> of an object.
>
> This is one of the many reasons why you'll never see me use Java or any
> other 'managed' language.

You are hardly a typical user, though :)

Whether we like it or not, managed runtimes are here,
and people are using them in droves.

I believe that the kernel should be able to handle
NUMA placement for such uses.

>> I like your code for handling smaller processes in NUMA
>> systems, but we do need to have a serious discussion on
>> how to handle processes that do not fit in one node.
>>
>> The more I think about it, the more Andrea's code looks
>> like it might be the more flexible way forward.
>
> I still have serious concerns about his approach; it very much assumes
> there's a temporal page<->thread relation to exploit. This might not at
> all be true for some programs (including JVM) that have hardly any data
> separation and just point chase their way around the entire object set.

Neither his approach or your approach will be able to
help these workloads. I do not see how that should be
counted against Andrea's approach, though, since it
does seem to be useful for sane workloads.

> I've also yet to see a coherent patch-set from Andrea with coherent
> changelogs and comments (this very much precludes PDFs of any kind).
>
> And you know I detest the way he cobbled his way around the scheduler
> instead of integrating it properly. And I'll very much not accept
> anything like the spaghetti code anywhere near the scheduler I have to
> maintain. (I recently looked at the THP code and if that's the standard
> I'm not having it).
>
> That said, I'll leave the door open and will consider something like his
> scanning stuff as an optional add on on-top of this.

No argument there. Your scheduler integration is nicer,
and Andrea's code could stand some documentation.

> I very much believe in doing the simple thing first, and this is that,

Leave out your syscalls (which might not be useful for
managed runtimes), and you actually have the simple
thing :)

I am all in favor of simplicity, and doing one thing
at a time.

-- 
All rights reversed
