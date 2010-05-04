Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab0EDXQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:16:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:57982 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934609Ab0EDXQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:16:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=PJI0znwNKQZfvup7KZiT/cVFO2T4tneMoAMtTBgkHj8aZBxzwgnGr4HVWL+D39J/S
	4D907MAAqLF86NZFFS+eA==
MIME-Version: 1.0
In-Reply-To: <18849d97-2fee-43a0-a3ea-9132f8163609@default>
References: <18849d97-2fee-43a0-a3ea-9132f8163609@default>
Date: Tue, 4 May 2010 16:16:46 -0700
Message-ID: <m2z3055132f1005041616r2d6a9747i32b8187912049182@mail.gmail.com>
Subject: Re: [RFC] Exposing TSC "reliability" to userland
From: Venkatesh Pallipadi <venki@google.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 1:21 PM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
>
> In a patch posted late last year by Venki:
>
> http://lkml.org/lkml/2009/12/17/360
>
> it was noted that some systems that specify the "Invariant TSC"
> bit in CPUID (on recent processors) are sadly not guaranteed to
> have synchronized TSCs.  As a result, Ingo's check_tsc_warp() is
> executed; if the warp test passes, the kernel uses TSC
> as clocksource and, if it doesn't pass, the kernel marks
> the TSC as unstable and chooses a different clocksource.
>
> Whether the kernel deems TSC to be reliable or not is a very
> useful piece of information to userland, e.g. to certain
> enterprise apps such the Oracle DB, some JVM's, etc.  If
> TSC IS reliable, rdtsc can be used by many of these
> enterprise applications in many situations in place of a
> gettimeofday call.  Rdtsc can be much faster even than
> a vsyscall and it is certainly much much faster when,
> for one reason or another, vsyscall is not enabled.
> This can make a huge performance difference in real
> benchmarks when timestamps are frequently taken (10%
> benchmark performance improvement was measured using
> rdtsc vs gettimeofday syscall).
>
> Running a warp test in userland is not nearly as accurate
> as the warp test run by the kernel.  So it makes sense to expose
> the results of the kernel warp test to userland, maybe
> through /sys/devices/system/clocksource/tsc_reliable
>
> Comments?

[ Sorry if this is a duplicate. I had messed up my mail client format setting ]

One option is to remove tsc from
/sys/devices/system/clocksource/clocksource*/available_clocksource
when it is detected as unstable.

That should already be happening with NOHZ or HIGHRES selected. But,
should be simple to add some code to do this always.

Would that work?

Thanks,
Venki
