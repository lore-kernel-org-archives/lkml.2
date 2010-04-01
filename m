Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0DACLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:11:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55894 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0DACLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:11:08 -0400
Message-ID: <4BB400AA.7090408@us.ibm.com>
Date: Wed, 31 Mar 2010 19:10:50 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com>
In-Reply-To: <4BB3D90C.3030108@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing the right Chris this time.

Darren Hart wrote:
> I'm looking at some adaptive spinning with futexes as a way to help 
> reduce the dependence on sched_yield() to implement userspace spinlocks. 
> Chris, I included you in the CC after reading your comments regarding 
> sched_yield() at kernel summit and I thought you might be interested.
> 
> I have an experimental patchset that implements FUTEX_LOCK and 
> FUTEX_LOCK_ADAPTIVE in the kernel and use something akin to 
> mutex_spin_on_owner() for the first waiter to spin. What I'm finding is 
> that adaptive spinning actually hurts my particular test case, so I was 
> hoping to poll people for context regarding the existing adaptive 
> spinning implementations in the kernel as to where we see benefit. Under 
> which conditions does adaptive spinning help?
> 
> I presume locks with a short average hold time stand to gain the most as 
> the longer the lock is held the more likely the spinner will expire its 
> timeslice or that the scheduling gain becomes noise in the acquisition 
> time. My test case simple calls "lock();unlock()" for a fixed number of 
> iterations and reports the iterations per second at the end of the run. 
> It can run with an arbitrary number of threads as well. I typically run 
> with 256 threads for 10M iterations.
> 
>          futex_lock: Result: 635 Kiter/s
> futex_lock_adaptive: Result: 542 Kiter/s
> 
> I've limited the number of spinners to 1 but feel that perhaps this 
> should be configurable as locks with very short hold times could benefit 
> from up to NR_CPUS-1 spinners.
> 
> I'd really appreciate any data, just general insight, you may have 
> acquired while implementing adaptive spinning for rt-mutexes and 
> mutexes. Open questions for me regarding conditions where adaptive 
> spinning helps are:
> 
> o What type of lock hold times do we expect to benefit?
> o How much contention is a good match for adaptive spinning?
>   - this is related to the number of threads to run in the test
> o How many spinners should be allowed?
> 
> I can share the kernel patches if people are interested, but they are 
> really early, and I'm not sure they are of much value until I better 
> understand the conditions where this is expected to be useful.
> 
> Thanks,
> 


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
