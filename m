Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1BVUAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:00:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39702 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755358Ab1BVUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:00:47 -0500
Date: Tue, 22 Feb 2011 20:00:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: john stultz <johnstul@us.ibm.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
	rtc_class_ops->read_alarm()
Message-ID: <20110222200046.GD31611@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org> <1298332538-31216-5-git-send-email-john.stultz@linaro.org> <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm> <1298362178.4222.57.camel@work-vm> <20110222181647.GA25569@opensource.wolfsonmicro.com> <1298404268.9215.39.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298404268.9215.39.camel@work-vm>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:51:08AM -0800, john stultz wrote:
> On Tue, 2011-02-22 at 10:16 -0800, Mark Brown wrote:

> > The WM83xx RTCs can do this (the alarm can be used to initiate a boot)
> > and I'd expect many embedded RTC controllers can do similar.  The
> > application would manage this by owning the RTC in the system, usually
> > with a configuration saying something like "boot every day at 7am" or
> > something.

> So since the RTC_ALM_SET doesn't support wildcards, the application
> would be checking the hardware at least once a day and making sure the
> alarm was properly set for 7am?

Probably, yes.  Though some RTCs just ignore the day anyway.

> Does the approach I mentioned in my last mail to Marcelo sound like a
> reasonable solution?

> Basically: The kernel will try to init the value returned from
> RTC_ALM_READ to whatever the hardware has stored, but since many (very
> common) rtc devices don't support persistent values after reset,
> applications shouldn't trust that alarms will persist across resets.

That'll probably work, yes.

> > Having thought about this a bit I'm thinking that this sort of alarm
> > handling is probably something I'd expect to see handled in userspace.
> > I can see us providing a virtual RTC driver that can generate alarms
> > when there's no actual RTC hardware but adding additional functionality
> > on top of the hardware feels like an application issue.

> If you're suggesting that the multiplexing of RTC events doesn't belong
> in the kernel, and instead should be handled through userland
> coordination, then I disagree. The kernel's job is explicitly to
> abstract the hardware so that resources can be shared safely. So
> abstracting the RTC alarms doesn't seem to be overreaching. But maybe
> I'm misunderstanding what your saying?

I'm saying that for something like this it doesn't seem like the kernel
should be adding support for features that the hardware doesn't actually
have, it feels like it's going to be more complicated and error prone to
implement in kernel space.
