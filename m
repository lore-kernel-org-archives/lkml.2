Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1BVV3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:29:51 -0500
Received: from www.tglx.de ([62.245.132.106]:36909 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab1BVV3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:29:49 -0500
Date: Tue, 22 Feb 2011 22:27:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
In-Reply-To: <1298409673.9215.84.camel@work-vm>
Message-ID: <alpine.LFD.2.00.1102222225060.2701@localhost6.localdomain6>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>  <1298332538-31216-5-git-send-email-john.stultz@linaro.org>  <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm>  <1298362178.4222.57.camel@work-vm> 
 <20110222181647.GA25569@opensource.wolfsonmicro.com>  <1298404268.9215.39.camel@work-vm>  <20110222200046.GD31611@opensource.wolfsonmicro.com>  <1298406174.9215.71.camel@work-vm>  <20110222210522.GG31611@opensource.wolfsonmicro.com>
 <1298409673.9215.84.camel@work-vm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011, john stultz wrote:
> On Tue, 2011-02-22 at 21:05 +0000, Mark Brown wrote:
> > On Tue, Feb 22, 2011 at 12:22:54PM -0800, john stultz wrote:
> > 
> > > In some ways it does complicate things, but in others it greatly
> > > simplifies it. You don't have to have 80 drivers each implementing their
> > > own code to set a mode that isn't used. Everyone is using the common
> > > kernel code, so bugs are shared and thus found and fixed faster.
> > > Features can be more easily added, as the limitations of specific
> > > hardware have to be more formally expressed, rather then having to
> > > change 80 drivers that opaquely work around their specific hardware
> > > issues. Also, applications are easier to port, since there are less
> > > platform specific differences.
> > 
> > I agree that it's a win for things like UIE - the reason it worries me
> > for alarms (and the RTC time itself) is that full emulation requires us
> > to do things over reboots, including the support for having multiple
> > alarms scheduled which isn't available on most hardware at all.
> 
> Hmm. Maybe I'm missing what you mean again. If the RTC doesn't support
> alarms, we don't emulate them (or RTC time).
> 
> But if you just mean trying to keep multiple alarms scheduled across
> resets, I don't think that is something we can emulate (since the kernel
> doesn't have any other persistent storage). But due to the lack of
> consistency in RTC hardware, I don't think its a reasonable expectation
> for applications to have.
> 
> We can preserve what hardware state we can at boot, but applications
> should not expect alarms set multiple reboot cycles ago to be valid.
> After all, other applications might have jumped in and grabbed the rtc
> device and set it to something else before the application was able to.
> Or a user might change the value from something like a bios menu.

Ack. Anyhting which relies on such a feature is broken by
definition. A sane requirement is that the last set earliest alarm
survives, but anything else is just beyond the scope of a sane
interface.

Thanks,

	tglx
