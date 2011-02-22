Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1BVTvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:51:21 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33462 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab1BVTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:51:20 -0500
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
From: john stultz <johnstul@us.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
In-Reply-To: <20110222181647.GA25569@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
	 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
	 <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm>
	 <1298362178.4222.57.camel@work-vm>
	 <20110222181647.GA25569@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 11:51:08 -0800
Message-ID: <1298404268.9215.39.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 10:16 -0800, Mark Brown wrote:
> On Tue, Feb 22, 2011 at 12:09:38AM -0800, john stultz wrote:
> 
> > Just so I can better get a grip of the cases your considering, could you
> > maybe give me some more detailed examples of where you'd like to see the
> > alarm timer be set and then persist across multiple power cycles before
> > firing? And how is that persistent value managed by the application
> > setting it?
> 
> The WM83xx RTCs can do this (the alarm can be used to initiate a boot)
> and I'd expect many embedded RTC controllers can do similar.  The
> application would manage this by owning the RTC in the system, usually
> with a configuration saying something like "boot every day at 7am" or
> something.

So since the RTC_ALM_SET doesn't support wildcards, the application
would be checking the hardware at least once a day and making sure the
alarm was properly set for 7am?

Does the approach I mentioned in my last mail to Marcelo sound like a
reasonable solution?

Basically: The kernel will try to init the value returned from
RTC_ALM_READ to whatever the hardware has stored, but since many (very
common) rtc devices don't support persistent values after reset,
applications shouldn't trust that alarms will persist across resets.


> Having thought about this a bit I'm thinking that this sort of alarm
> handling is probably something I'd expect to see handled in userspace.
> I can see us providing a virtual RTC driver that can generate alarms
> when there's no actual RTC hardware but adding additional functionality
> on top of the hardware feels like an application issue.

If you're suggesting that the multiplexing of RTC events doesn't belong
in the kernel, and instead should be handled through userland
coordination, then I disagree. The kernel's job is explicitly to
abstract the hardware so that resources can be shared safely. So
abstracting the RTC alarms doesn't seem to be overreaching. But maybe
I'm misunderstanding what your saying?

thanks
john

