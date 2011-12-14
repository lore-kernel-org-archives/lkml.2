Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1LNVgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:36:40 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49036 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab1LNVgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:36:38 -0500
Message-ID: <1323898490.6805.92.camel@work-vm>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
From: john stultz <johnstul@us.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Steve Allen <sla@ucolick.org>
Date: Wed, 14 Dec 2011 13:34:50 -0800
In-Reply-To: <CALCETrXwQXnRRAUZ+h=kR4wUVyfAQyGRd==W47W7LsW7Ci-KAw@mail.gmail.com>
References: <cover.1323739287.git.luto@amacapital.net>
	 <20111213032406.GA9604@netboy.at.omicron.at>
	 <1323747782.4078.144.camel@work-vm>
	 <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
	 <20111214074640.GB2180@netboy.at.omicron.at>
	 <1323881310.6805.41.camel@work-vm>
	 <20111214183025.GB2465@netboy.at.omicron.at>
	 <1323889666.6805.71.camel@work-vm>
	 <CALCETrXwQXnRRAUZ+h=kR4wUVyfAQyGRd==W47W7LsW7Ci-KAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121421-7408-0000-0000-0000014416D4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 11:20 -0800, Andy Lutomirski wrote:
> On Wed, Dec 14, 2011 at 11:07 AM, john stultz <johnstul@us.ibm.com> wrote:
> > I don't see a reason to limit clock_gettime_ns() to only CLOCK_TAI.
> > After all, while CLOCK_TAI doesn't have leapseconds, it still can be set
> > by userland if its wrong, so it doesn't provide the same functionality
> > as CLOCK_MONOTONIC. Additionally, the motivation for this new interface
> > is for a more efficient CLOCK_THREAD_CPUTIME vdso implementation, so an
> > exclusive CLOCK_TAI interface wouldn't serve that need.
> >
> > I agree adding CLOCK_TAI is an interesting feature, but that could done
> > properly with the existing clock_gettime() interface. So I think the
> > CLOCK_TAI discussion is really disconnected from the new ABI being
> > proposed.
> 
> Unless we want the future CLOCK_TAI to also return the UTC offset (or
> vice versa), in which case we can use 32 bits of the padding field for
> exactly that purpose.  (If TAI and UTC diverge by more than 2^32
> seconds, we probably have other things to worry about.  That being
> said, it might be useful to add a little more padding at the cost of a
> bit of performance.)

FYI: Interesting additional emails from Steve Allen below (forwarded
with permission) that put some caution around CLOCK_TAI. 

Also, The timescales web page looks like a great reference, which I'll
have to bookmark.

thanks
-john


-------- Forwarded Message --------
From: Steve Allen <sla@ucolick.org>
To: John Stultz <johnstul@us.ibm.com>
Subject: TAI in linux kernel
Date: Wed, 14 Dec 2011 11:44:23 -0800

Greetings John Stultz,

I note the linux kernel discussion mentioning the use of TAI.

It may be relevant to note the position of the CCTF and BIPM on
the use of TAI as expressed in Document CCTF/09-27

http://www.bipm.org/cc/CCTF/Allowed/18/CCTF_09-27_note_on_UTC-ITU-R.pdf

Their position is that they do not want TAI used as an operational
system time, and in their last paragraph they make it plain that
they would consider suppressing TAI in order to accomplish that.

Building TAI into the linux kernel could result in the use of
an nonexistent time standard.



-------- Forwarded Message --------
From: Steve Allen <sla@ucolick.org>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: TAI in linux kernel
Date: Wed, 14 Dec 2011 12:33:40 -0800

Greetings again John,

On Wed 2011-12-14T12:11:52 -0800, Steve Allen hath writ:
> Feel free.  It's a BIPM document, and somewhat confusing because BIPM
> documents from a few years earlier indicated different things, so it's
> hard to tell what to rely upon when designing operational systems.

I have been trying to track what's what for quite a while.

For a few links pointing at previous position statements about TAI see
http://www.ucolick.org/~sla/leapsecs/timescales.html#TAI
The 1999 statement is quite opposite to the 2007/2009 document.


