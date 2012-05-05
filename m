Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2EEHeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 03:34:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63869 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab2EEHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 03:34:22 -0400
Date: Sat, 5 May 2012 09:34:08 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 0/5] Rationalize time keeping
Message-ID: <20120505073408.GC1967@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <4FA2E334.7040601@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA2E334.7040601@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 12:57:40PM -0700, John Stultz wrote:
> On 04/27/2012 01:12 AM, Richard Cochran wrote:
> >
> >The basic idea is to keep the internal time using a continuous
> >timescale and to convert to UTC by testing the time value against the
> >current threshold and adding the appropriate offset. Since the UTC
> >time and the leap second status is provided on demand, this eliminates
> >the need to set a timer or to constantly monitor for leap seconds, as
> >was done up until now.
> 
> So as I mentioned in my earlier review of this patch set, I'm not as
> excited about the meta-layer you added in utc-tai.h.

It really isn't a layer. It is just a pair of static inline helper
functions. The code could just as well be internal to timekeeper.c,
but I put it in its own file so that I could include it into a unit
test program.

> http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/clktai
> 
> The untested patch set there basically pushes TAI time management
> into the timekeeping core, and then exports a CLOCK_TAI clockid.
> 
> This patch set *does not* address the tick-granularity delayed
> leap-second processing issue that your patch also addresses. But I
> feel like the basic handling of tai is a little simpler.

So, is this a "won't fix" issue, in your view?

(If so, I'll drop it.)
 
> Take a look at it and let me know what you think.

It looks okay to me, as far as it goes.

At least you offer a clock that doesn't jump around. With your patches
(and the TAI offset fix before), user space programs sensitive to the
leap second uglies would have a reasonable option. Data collection
programs can read and store TAI time stamps, and these can always be
converted into UTC using a table method.

But do you think it will be possible to implement the following in the
same way?

- clock_settime(CLOCK_TAI)
- clock_adjtime(CLOCK_TAI)
- timer_create(CLOCK_TAI)

Thanks,
Richard
