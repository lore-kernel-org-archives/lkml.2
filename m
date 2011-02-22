Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1BVT61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:58:27 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48931 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1BVT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:58:25 -0500
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
From: john stultz <johnstul@us.ibm.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <20110222195143.GC31611@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
	 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
	 <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm>
	 <1298362178.4222.57.camel@work-vm>
	 <AANLkTinMPnJj+ca+=ujU=5rhK3Nh0qrFGe955zZWjYaf@mail.gmail.com>
	 <1298403310.9215.26.camel@work-vm>
	 <20110222195143.GC31611@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Feb 2011 11:58:16 -0800
Message-ID: <1298404696.9215.47.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 19:51 +0000, Mark Brown wrote:
> On Tue, Feb 22, 2011 at 11:35:10AM -0800, john stultz wrote:
> 
> > Yea. The way I thought about it originally was that you can set an alarm
> > and that alarm will fire if the machine is on, suspended or even in some
> > cases off.  Then, when the machine is booted (system reset), the state
> > of the RTC's alarm should not be trusted.
> 
> > Your description of the AIE/UIE having random values aligns with that
> > intuition.
> 
> This seems rather worrying - it sounds like it might mean that the
> device might come up firing spuriously which doesn't seem terribly
> clever.

Well, in those known cases the driver should initalize the irq modes to
be off. 

> > However, if the expectation is that once set, the alarm should persist
> > across any number of reboots, this makes it a bit more complicated.
> 
> For an embedded device I'd expect that either nothing about the RTC
> would persist (including the time) or everything would.

But that isn't the reality of the hardware. On reboot the kernel can't
trust hardware to be in a valid state.

Even so, we can try to preserve what we can, but I think the expectation
from an application's point of view shouldn't be that rtc device's alarm
state will be valid upon reset.

thanks
-john


