Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab1LNSac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:30:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36020 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1LNSab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:30:31 -0500
Date: Wed, 14 Dec 2011 19:30:25 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20111214183025.GB2465@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
 <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
 <20111214074640.GB2180@netboy.at.omicron.at>
 <1323881310.6805.41.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323881310.6805.41.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 08:48:30AM -0800, john stultz wrote:
> On Wed, 2011-12-14 at 08:46 +0100, Richard Cochran wrote:
> > On Mon, Dec 12, 2011 at 11:09:29PM -0800, Andy Lutomirski wrote:
> > > On Mon, Dec 12, 2011 at 7:43 PM, john stultz <johnstul@us.ibm.com> wrote:
> > > >> - New name, to distance ourselves from POSIX (clock_ns_get?)
> > > 
> > > I will defer to the bikeshedding consensus :)
> > > 
> > > >> - Family of calls, with set/get
> > > 
> > > Setting the time is a big can of worms.  adjtimex is rather
> > > incomprehensible (without reading lots of source and/or the rfc) and
> > > IMO puts a lot of NTP magic into the kernel, where it doesn't belong.
> 
> Honestly, I don't really see how we jumped to adjtimex from setting the
> time, nor the complexity hinted at. First, the rational for getting
> clock_gettime_ns is to avoid the overhead of userland translating from
> timespec to ns.   I doubt there are similar performance needs for
> settimeofday().  Even if it was needed, it shouldn't be more complex
> then the unit conversion done in this abi patch. Am I missing something?

So, you agree on adding new syscalls as a performance tweek?

I am not against it, but I do think syscalls should try to satisfy a
large number of user cases.

> But again, the hard part with in-kernel TAI (possibly as the base of
> time)is that initialization of the TAI/UTC offset needs to be able to be
> phased in slowly, as we also have to preserve legacy interfaces and
> behavior. 

With brand new syscall, there are no legacy uses.

> Why do we need a new interface for TAI? clock_gettime(CLOCK_TAI,...)
> should be achievable. I do think it would be interesting, but I also
> think its separate from the goal of this proposal.

I mean to define an interface that always returns TAI values, no matter
what the clock device.

Richard
