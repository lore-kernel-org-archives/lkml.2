Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1HEJEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:04:32 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45886 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab1HEJEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:04:30 -0400
Subject: Re: [stable] [patch 3/3] rtc: Limit frequency
From: John Stultz <john.stultz@linaro.org>
To: Joshua Kinard <kumba@gentoo.org>
Cc: Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Greear <greearb@candelatech.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
In-Reply-To: <4E3B660E.3020108@gentoo.org>
References: <20110722091011.717194327@linutronix.de>
	 <20110722091045.537404938@linutronix.de>
	 <20110722150550.1878f069.akpm@linux-foundation.org>
	 <20110722223915.GA22405@1wt.eu>  <4E3B660E.3020108@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Aug 2011 02:04:19 -0700
Message-ID: <1312535060.2764.12.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 23:39 -0400, Joshua Kinard wrote:
> On 07/22/2011 18:39, Willy Tarreau wrote:
> > On Fri, Jul 22, 2011 at 03:05:50PM -0700, Andrew Morton wrote:
> >> On Fri, 22 Jul 2011 09:12:51 -0000
> >> Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >>> The RTC hrtimer is self rearming. We really need to limit the
> >>> frequency to something sensible.
> >>
> >>> Cc: stable@kernel.org
> >>
> >> Why?  What failures does the current code cause?  What effect do these
> >> failures have upon users?
> > 
> > I would add that if we go that route, we should at least accept values
> > that were documented as possible till now. Man rtc says 2 Hz to 8192 Hz,
> > but Thomas' proposed patch limits it to 5000 Hz, so some breakage is to
> > be expected.
> > 
> > Regards,
> > Willy
> 
> To me, it would make sense to lock it at 8192Hz.  I re-wrote a driver for the DS1685 family of Dallas chips that I need
> to cleanup and re-submit, but in researching that specific RTC, I really could not find an RTC out there that went above
> 8192.
> 
> Arguably, 32768Hz might also work.  The DS1685 runs at this mode normally, but it disables PIE when it does.
> 
> My vote is 8192Hz.

Yea, I submitted a slightly different version of Thomas' patch which set
it to 8192Hz via the tip tree, but the original one went upstream first.
I'm away from home right now, so I'll be re-submitting just that change
probably next week.

> Also, can we get a wrapper of some kind in the RTC core to allow an
> RTC driver to override the hrtimer /PIE emulation if
> needed?  I have in the DS1685 driver full support for its PIE mode and
> really do not want to gut it as part of the
> cleanup.  Some kind of override API would be nice in case anyone ever
> runs into this chip (or its family members).

I'm torn here. It would be good to have the functionality listed in some
way so it is documented. However as we abstract the RTC to be more of an
internal tool for the kernel, rather then hardware directly addressed
from userland, the PIE mode is really not as useful (and quite messier
to multiplex).  I'd much rather try to extend the alarm interfaces to
allow for higher resolution, so it could be used as a alarmed highres
oneshot timer if the hardware supports it.

thanks
-john


