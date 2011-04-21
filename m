Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab1DUSUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:20:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49356 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab1DUSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:20:12 -0400
Subject: Re: [PATCH 4/4] timers: posix interface for alarm-timers
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <20110420063426.GB20952@riccoc20.at.omicron.at>
References: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
	 <1303257510-15054-5-git-send-email-john.stultz@linaro.org>
	 <20110420063426.GB20952@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 21 Apr 2011 11:19:45 -0700
Message-ID: <1303409985.1876.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 08:34 +0200, Richard Cochran wrote:
> On Tue, Apr 19, 2011 at 04:58:30PM -0700, John Stultz wrote:
> > This patch exposes alarm-timers to userland via the posix clock
> > and timers interface, using two new clockids: CLOCK_REALTIME_ALARM
> > and CLOCK_BOOTTIME_ALARM. Both clockids behave identically to
> > CLOCK_REALTIME and CLOCK_BOOTTIME, respectively, but timers
> > set against the _ALARM suffixed clockids will wake the system if
> > it is suspended.
> 
> So, is there reason these cannot or should not be using the dynamic
> posix clock interface?

So in this case, since the clockids are not directly linked to specific
dynamic hardware, I'm not sure if that's the best route.

> > The semantics of the Android alarm driver are different from what
> > this posix interface provides.
> ...
> > One potential way to implement similar semantics may be via
> > the timerfd infrastructure, but this needs more research.
> > 
> > There may also need to be some sort of sysfs system level policy
> > hooks that allow alarm timers to be disabled to keep them
> > from firing at inappropriate times (ie: laptop in a well insulated
> > bag, mid-flight).
> 
> I have not put hardly any thought into these issues, but the dynamic
> interface gives you a character device at no extra charge.

True, but I'd like to first try to extend the existing interface
(timerfd) before we look at adding new ones.

thanks
-john


