Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab0FPJbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:31:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0FPJbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:31:40 -0400
Message-ID: <4C1899C4.9050403@redhat.com>
Date: Wed, 16 Jun 2010 12:30:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>,
       "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
References: <1276441427-31514-1-git-send-email-avi@redhat.com> <4C187C22.2080505@redhat.com> <4C187DF1.9030007@zytor.com> <4C188527.9040305@redhat.com> <20100616083941.GA27151@elte.hu> <20100616091003.GU6138@laptop>
In-Reply-To: <20100616091003.GU6138@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 12:10 PM, Nick Piggin wrote:
>
>> This cannot be stated categorically without precise measurements of
>> known-good, known-bad, average FPU usage and average CPU usage scenarios. All
>> these workloads have different characteristics.
>>
>> I can imagine bad effects across all sorts of workloads: tcpbench, AIM7,
>> various lmbench components, X benchmarks, tiobench - you name it. Combined
>> with the fact that most micro-benchmarks wont be using the FPU, while in the
>> long run most processes will be using the FPU due to SIMM instructions. So
>> even a positive result might be skewed in practice. Has to be measured
>> carefully IMO - and i havent seen a _single_ performance measurement in the
>> submission mail. This is really essential.
>>      
> It can be nice to code an absolute worst-case microbenchmark too.
>    

Sure.

> Task migration can actually be very important to the point of being
> almost a fastpath in some workloads where threads are oversubscribed to
> CPUs and blocking on some contented resource (IO or mutex or whatever).
> I suspect the main issues in that case is the actual context switching
> and contention, but it would be nice to see just how much slower it
> could get.
>    

If it's just cpu oversubscription then the IPIs will be limited by the 
rebalance rate and the time slice, so as you say it has to involve 
contention and frequent wakeups as well as heavy cpu usage.  That won't 
be easy to code.  Can you suggest an existing benchmark to run?

-- 
error compiling committee.c: too many arguments to function

