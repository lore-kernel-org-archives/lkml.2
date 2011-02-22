Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1BVTvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:51:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42188 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754824Ab1BVTvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:51:45 -0500
Date: Tue, 22 Feb 2011 19:51:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
	rtc_class_ops->read_alarm()
Message-ID: <20110222195143.GC31611@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org> <1298332538-31216-5-git-send-email-john.stultz@linaro.org> <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm> <1298362178.4222.57.camel@work-vm> <AANLkTinMPnJj+ca+=ujU=5rhK3Nh0qrFGe955zZWjYaf@mail.gmail.com> <1298403310.9215.26.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298403310.9215.26.camel@work-vm>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:35:10AM -0800, john stultz wrote:

> Yea. The way I thought about it originally was that you can set an alarm
> and that alarm will fire if the machine is on, suspended or even in some
> cases off.  Then, when the machine is booted (system reset), the state
> of the RTC's alarm should not be trusted.

> Your description of the AIE/UIE having random values aligns with that
> intuition.

This seems rather worrying - it sounds like it might mean that the
device might come up firing spuriously which doesn't seem terribly
clever.

> However, if the expectation is that once set, the alarm should persist
> across any number of reboots, this makes it a bit more complicated.

For an embedded device I'd expect that either nothing about the RTC
would persist (including the time) or everything would.
