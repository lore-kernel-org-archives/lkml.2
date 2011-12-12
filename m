Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1LLXJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:09:29 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35780 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1LLXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:09:28 -0500
Message-ID: <1323731361.4078.102.camel@work-vm>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
From: john stultz <johnstul@us.ibm.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Date: Mon, 12 Dec 2011 15:09:21 -0800
In-Reply-To: <1323718578-1157-3-git-send-email-asharma@fb.com>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
	 <1323718578-1157-3-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121223-4242-0000-0000-000000519955
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 11:36 -0800, Arun Sharma wrote:
> From: Kumar Sundararajan <kumar@fb.com>
> 
> This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..)
> via a new vsyscall. We also add a direct vsyscall that returns
> time in ns (RFC: the direct vsyscall doesn't have a corresponding
> regular syscall, although clock_gettime() is pretty close).

I'm still not super psyched about providing a vdso-only API.

If a nanosecond interface like thread_cpu_time() is actually a big win
over clock_gettime(CLOCK_THREAD_CPUTIME,...) it seems it should have its
own syscall as well, no? 

Possibly something like clock_gettime_ns(), which would return the same
values as clock_gettime() but in nanoseconds rather then a timespec?

thanks
-john


