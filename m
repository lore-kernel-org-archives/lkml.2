Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab1CYMAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:00:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52846 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1CYMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:00:08 -0400
Date: Fri, 25 Mar 2011 12:00:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: John Stultz <john.stultz@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        kyungmin.park@samsung.com, MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH v2] RTC: Selectively enable PIE-Hrtimer
	emulation.
Message-ID: <20110325120002.GB22502@sirena.org.uk>
References: <1300781334-30308-1-git-send-email-myungjoo.ham@samsung.com> <1300823076.2731.123.camel@work-vm> <AANLkTinuwuosJ27BRjREEq8m2_Z+0=U0x6ujGMS-5rKm@mail.gmail.com> <1301001498.848.160.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301001498.848.160.camel@work-vm>
X-Cookie: To order, call toll-free.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 02:18:18PM -0700, John Stultz wrote:
> On Thu, 2011-03-24 at 14:28 +0900, MyungJoo Ham wrote:

> > b. there could be multiple rtc devices in a system and we may need to
> > setup them anyway without any s/w interrupt handlers. (RTC PIEs
> > directly signalling some other H/W pieces?)

> Maybe I'm misunderstanding, but this sounds like an abuse of the RTC
> interface. If you're using the RTC interface to enable some sort of
> inter-hardware signaling, where the kernel itself wouldn't be handling
> the irq, you probably really want to use a different driver
> all-together. But again, I might just not understand what you're
> meaning.

This sort of thing is fairly common for embedded RTCs.  Usually there's
no fixed connection, it's just that the RTC outputs a signal which can
be wired to anything the system integrator feels like.  It does seem to
make sense for the RTC driver to export this functionality to the rest
of the world.

> The benefit here is that since the kernel manages all of this, it will
> then work on any RTC hardware that supports alarms, and doesn't need
> some hardware-specific PIE mode support. Even better, since the kernel
> can allow for multiplexing of events, userland can still set AIE mode
> alarms using the legacy interface without affecting your periodic
> rtc_timer.

This only works if you're not generating a hardware signal from the RTC
- if it's a hardware signal you may not be able to do it from software
at all.  This may not be relevant for the particular application,
though.
