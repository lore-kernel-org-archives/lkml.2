Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab1LNShh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:37:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40560 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab1LNShf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:37:35 -0500
Date: Wed, 14 Dec 2011 19:37:30 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
Message-ID: <20111214183729.GC2465@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net>
 <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm>
 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
 <20111214074640.GB2180@netboy.at.omicron.at>
 <1323881310.6805.41.camel@work-vm>
 <CALCETrW+g6_VSUJJz4NSVwjKhMo+U_3uQDe9W6uEXdjTuaXVhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW+g6_VSUJJz4NSVwjKhMo+U_3uQDe9W6uEXdjTuaXVhA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 09:15:29AM -0800, Andy Lutomirski wrote:
> On Wed, Dec 14, 2011 at 8:48 AM, john stultz <johnstul@us.ibm.com> wrote:

> > On Wed, 2011-12-14 at 08:46 +0100, Richard Cochran wrote:
> >> Believe it or not, people (from the Test and Measurement field) have
> >> already been asking me about having subnanosecond time values from the
> >> kernel.
> 
> I'm curious how that works.  My personal record is synchronizing time
> across a bunch of computers to within maybe half a nanosecond, but it
> wasn't the *system* clock that I synchronized -- I just calibrated a
> bunch of oscillator phase differences on ADC clocks that I was using.
> I only relied on the system clock being correct to a few tens of
> microseconds, which is easily done with PTP.

On example to take a look at is the White Rabbit project.

It is possible to time stamp events and apply clock corrections at a
very fine resolution, for example with synchronized Ethernet and PTP.

> What about:
> 
> struct sys_timeval {
>     u64 nanoseconds;  /* unsigned.  the current time will always be
> after 1970, and those extra 290 years might be nice. */
>     u64 padding;  /* for later.  currently always zero. */
> 
> That way, once there's both an implementation and a use case, we can
> implement it.  In the mean time, the overhead is probably immeasurably
> low -- it's a single assignment.

Agreed.

> Note that rdtsc isn't good to a nanosecond, let alone sub-nanosecond
> intervals, on any hardware I've ever seen.

But the hardware is coming, sooner or later.

Richard
