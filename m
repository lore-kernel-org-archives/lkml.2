Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1CAW0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:26:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1CAW0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:26:43 -0500
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
In-Reply-To: <4D6D22A7.6000000@cisco.com>
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
	 <1298865151-23656-4-git-send-email-daahern@cisco.com>
	 <1298989751.5226.863.camel@laptop>  <4D6D0438.2090901@cisco.com>
	 <1298993714.5226.871.camel@laptop>  <4D6D13C6.5020807@cisco.com>
	 <1298995250.5226.882.camel@laptop>  <4D6D1A4C.1090009@cisco.com>
	 <1298997435.5226.890.camel@laptop>  <4D6D22A7.6000000@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 23:28:09 +0100
Message-ID: <1299018489.5226.940.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 09:45 -0700, David Ahern wrote:

> One example would be a system watchdog that decided for some reason or
> another to force an event sample because of some event it detected.

That would be a design error, there already is an event, use that.

> > 
> > I'd much rather expose the whole
> > local_clock()/perf_clock()/trace_clock() (should all be the same anyway)
> > as a posix clock using CLOCK_TRACING or whatever would be an appropriate
> > name.
> > 
> > [ Since the whole thing is NMI safe it should be well possible to make a
> > VDSO version as well. ]
> > 
> > Anyway, once its visible as a posix clock you can sync up from
> > userspace. And this clock is indeed wanted for other things too, like
> > user-space tracing etc.
> > 
> 
> And for some silly reason I sense a time trap here (pun intended) .....
> 
> So your pushback is:
> 1. throw out the realtime-clock event patch,

Well, no, you need continues samples to keep in sync, so having this is
required [*].

> 2. add a new CLOCK_TRACING type to clock_gettime with VDSO hook,

Right, that is something we need anyway at some point in time.

> 3. and use a synthesized event from userspace for snapshotting
> perf_clock to time-of-day -- similar to what I have now, but one that
> will guarantee a time-of-day to perf_clock correlation (versus the
> current one which hopes that perf_clock is the monotonic clock).

I guess you could do that if we have full userspace tracing support, but
it wouldn't need synthesized events, it would need a pure userspace
event stream.

Thing is, I really dislike the ioctl() trigger



