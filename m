Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1LLXdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:33:02 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57161 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1LLXc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:32:59 -0500
Message-ID: <1323732772.4078.113.camel@work-vm>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
From: john stultz <johnstul@us.ibm.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Date: Mon, 12 Dec 2011 15:32:52 -0800
In-Reply-To: <4EE68C31.1030207@fb.com>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
	 <1323718578-1157-3-git-send-email-asharma@fb.com>
	 <1323731361.4078.102.camel@work-vm> <4EE68C31.1030207@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121223-9360-0000-0000-00000174C17F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 15:20 -0800, Arun Sharma wrote:
> On 12/12/11 3:09 PM, john stultz wrote:
> > On Mon, 2011-12-12 at 11:36 -0800, Arun Sharma wrote:
> >> From: Kumar Sundararajan<kumar@fb.com>
> >>
> >> This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..)
> >> via a new vsyscall. We also add a direct vsyscall that returns
> >> time in ns (RFC: the direct vsyscall doesn't have a corresponding
> >> regular syscall, although clock_gettime() is pretty close).
> >
> > I'm still not super psyched about providing a vdso-only API.
> >
> > If a nanosecond interface like thread_cpu_time() is actually a big win
> > over clock_gettime(CLOCK_THREAD_CPUTIME,...) it seems it should have its
> > own syscall as well, no?
> 
> The win is relatively small when we're dealing with syscalls. But with 
> vsyscalls, it starts showing up in micro benchmarks.
> 
> Happy to post patches for regular syscalls (assuming I can get them 
> allocated :).
> 
> >
> > Possibly something like clock_gettime_ns(), which would return the same
> > values as clock_gettime() but in nanoseconds rather then a timespec?
> >
> 
> If we're doing non-POSIXy things there, how about allocating one syscall 
> per clock instead of multiplexing them through a single syscall?
> 
> This would be a nice to have (clock_gettime_ns() should get us most of 
> the perf benefit).

Well, it makes it a little easier to extend if we get a new clockid,
rather then having to add a whole new syscall. Keeps parity between the
timespec and ns interfaces.

Is it just that you're concerned about the clockid switch costs being
too high?

thanks
-john


