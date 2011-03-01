Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1CARJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:09:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34338 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab1CARJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=JG2pVWx0vwsNVuRKbUmKOgt5E34GixA1EuZ/im9CgvpDSesQDITBzfVj5TFN0bC3ui
         rjvH/U2ZmmZdyPm/d6JxgtlflkKeOU/+Sh9p/LyGqGMJ0d9YK4Nh+ldgCVGMjC7whboM
         Lu03NaKkkMwGX+rJCRyebi1SkV7tzlsOijFmg=
Date: Tue, 1 Mar 2011 14:09:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf record: add time-of-day option
Message-ID: <20110301170941.GF26068@ghostprotocols.net>
References: <1298865151-23656-4-git-send-email-daahern@cisco.com>
 <1298989751.5226.863.camel@laptop>
 <4D6D0438.2090901@cisco.com>
 <1298993714.5226.871.camel@laptop>
 <4D6D13C6.5020807@cisco.com>
 <1298995250.5226.882.camel@laptop>
 <4D6D1A4C.1090009@cisco.com>
 <1298997435.5226.890.camel@laptop>
 <4D6D22A7.6000000@cisco.com>
 <20110301170750.GE26068@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301170750.GE26068@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 01, 2011 at 02:07:50PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Mar 01, 2011 at 09:45:27AM -0700, David Ahern escreveu:
> > On 03/01/2011 09:37 AM, Peter Zijlstra wrote:
> > > On Tue, 2011-03-01 at 09:09 -0700, David Ahern wrote:
> > >>
> > >> I did not code it create samples of a realtime-clock event; I coded it
> > >> to add an event to the stream on demand -- whatever event the fd is
> > >> tied to.
> > >>
> > >>
> > > Well yes, but aside from you and the realtime clock stuff, who'd ever
> > > want to do this particular thing?
> > 
> > One example would be a system watchdog that decided for some reason or
> > another to force an event sample because of some event it detected.
> > 
> > > 
> > > I'd much rather expose the whole
> > > local_clock()/perf_clock()/trace_clock() (should all be the same anyway)
> > > as a posix clock using CLOCK_TRACING or whatever would be an appropriate
> > > name.
> > > 
> > > [ Since the whole thing is NMI safe it should be well possible to make a
> > > VDSO version as well. ]
> > > 
> > > Anyway, once its visible as a posix clock you can sync up from
> > > userspace. And this clock is indeed wanted for other things too, like
> > > user-space tracing etc.
> > > 
> > 
> > And for some silly reason I sense a time trap here (pun intended) .....
> > 
> > So your pushback is:
> > 1. throw out the realtime-clock event patch,
> 
> Nope
>  
> > 2. add a new CLOCK_TRACING type to clock_gettime with VDSO hook,
> 
> Yes
>  
> > 3. and use a synthesized event from userspace for snapshotting
> > perf_clock to time-of-day -- similar to what I have now, but one that
> > will guarantee a time-of-day to perf_clock correlation (versus the
> > current one which hopes that perf_clock is the monotonic clock).
> 
> Nope.

I see, yeah, the very first CLOCK_REALTIME sample would be synthesized
from the return of clock_gettime(CLOCK_TRACING), all the others would
come in the event stream.
 
> My understanding was that for the initial gettime you use
> clock_gettime(), and then you get CLOCK_REALTIME events in the stream
> for resynch, etc.
> 
> Peter?
> 
> - Arnaldo
