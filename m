Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab0FYU0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:26:09 -0400
Received: from www.tglx.de ([62.245.132.106]:34004 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab0FYU0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:26:07 -0400
Date: Fri, 25 Jun 2010 22:25:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ulrich Drepper <drepper@redhat.com>
cc: Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: Q: sys_futex() && timespec_valid()
In-Reply-To: <235959492.961541277496281970.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Message-ID: <alpine.LFD.2.00.1006252212420.18683@localhost.localdomain>
References: <235959492.961541277496281970.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, Ulrich Drepper wrote:

> ----- "Thomas Gleixner" <tglx@linutronix.de> wrote:
> > tv->sec < 0 is definitely an invalid value for both CLOCK_REALTIME
> > and CLOCK_MONOTONIC.

> CLOCK_MONOTONIC is different but it's wrong for CLOCK_REALTIME.

Why is CLOCK_MONOTONIC any different ? According to you argumentation
it's just _BEFORE_ we started the system.

> Why would it be invalid?  Because times before Epoch will not be
> used?  By that logic you would have to declare all values before
> Linus' first running kernel as invalid.  None of this makes sense.

That's utter bullshit and you know that. Every system which does not
have an RTC starts with the EPOCH and the range check is correct in
the terms of the specification:

    Outside the valid range of the clock_id.

The kernel treats the range valid which it can theoretically hand back
to user space:

   EPOCH <= CLOCK_REALTIME <= Y2038_or_far_away

   0 <= CLOCK_MONOTONIC <= far_away

> The tv_sec in timespec is of type time_t and for absolute time
> values the same semantics as for naked time_t values applies.  The
> absolute time is
>   epoch + tv_sec + tv_nsec / 1000000000
> 
> If tv_sec is negative these are values before epoch.
> 
> If there are other interfaces with absolute timeouts they certainly
>  should be changed as well.

If we'd change that, then we'd need to allow negative relative
timeouts as well and not restrict it to CLOCK_REALTIME. 

If we'd change the notion of "valid" then we do it in a consistent
way for everything not just for a corner case of some glibc wreckage.

Thanks,

	tglx
