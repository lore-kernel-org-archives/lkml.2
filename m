Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1BVVdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:33:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58369 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751734Ab1BVVdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:33:20 -0500
Date: Tue, 22 Feb 2011 21:33:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: john stultz <johnstul@us.ibm.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
	rtc_class_ops->read_alarm()
Message-ID: <20110222213319.GI31611@opensource.wolfsonmicro.com>
References: <1298332538-31216-5-git-send-email-john.stultz@linaro.org> <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm> <1298362178.4222.57.camel@work-vm> <20110222181647.GA25569@opensource.wolfsonmicro.com> <1298404268.9215.39.camel@work-vm> <20110222200046.GD31611@opensource.wolfsonmicro.com> <1298406174.9215.71.camel@work-vm> <20110222210522.GG31611@opensource.wolfsonmicro.com> <1298409673.9215.84.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298409673.9215.84.camel@work-vm>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 01:21:13PM -0800, john stultz wrote:

> But if you just mean trying to keep multiple alarms scheduled across
> resets, I don't think that is something we can emulate (since the kernel
> doesn't have any other persistent storage). But due to the lack of
> consistency in RTC hardware, I don't think its a reasonable expectation
> for applications to have.

I'm saying that I've got concerns about providing that functionality at
all as it's going to be a pure software at runtime thing - the kernel
can't do anything here that userspace couldn't already do and there are
things that userspace can do that the kernel can't.  If the hardware
could do it then great but otherwise it feels like you'd be better off
with a program in userspace owning the hardware and dealing with the
resource contention.
