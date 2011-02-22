Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1BVVF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:05:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42067 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751495Ab1BVVFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:05:24 -0500
Date: Tue, 22 Feb 2011 21:05:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: john stultz <johnstul@us.ibm.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
	rtc_class_ops->read_alarm()
Message-ID: <20110222210522.GG31611@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org> <1298332538-31216-5-git-send-email-john.stultz@linaro.org> <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm> <1298362178.4222.57.camel@work-vm> <20110222181647.GA25569@opensource.wolfsonmicro.com> <1298404268.9215.39.camel@work-vm> <20110222200046.GD31611@opensource.wolfsonmicro.com> <1298406174.9215.71.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298406174.9215.71.camel@work-vm>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:22:54PM -0800, john stultz wrote:

> In some ways it does complicate things, but in others it greatly
> simplifies it. You don't have to have 80 drivers each implementing their
> own code to set a mode that isn't used. Everyone is using the common
> kernel code, so bugs are shared and thus found and fixed faster.
> Features can be more easily added, as the limitations of specific
> hardware have to be more formally expressed, rather then having to
> change 80 drivers that opaquely work around their specific hardware
> issues. Also, applications are easier to port, since there are less
> platform specific differences.

I agree that it's a win for things like UIE - the reason it worries me
for alarms (and the RTC time itself) is that full emulation requires us
to do things over reboots, including the support for having multiple
alarms scheduled which isn't available on most hardware at all.
