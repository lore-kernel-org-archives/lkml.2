Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab1FTUKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:10:12 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41337 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab1FTUJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:09:58 -0400
Date: Mon, 20 Jun 2011 23:09:56 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: John Stultz <john.stultz@linaro.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] alarmtimers: Handle late rtc module loading
In-Reply-To: <1308335616.3606.4.camel@work-vm>
Message-ID: <alpine.SOC.1.00.1106202308050.29718@math.ut.ee>
References: <1308274479-25259-1-git-send-email-john.stultz@linaro.org>  <alpine.SOC.1.00.1106171112460.29700@math.ut.ee> <1308335616.3606.4.camel@work-vm>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > One the PC, I get the following about RTC in dmesg:
> > 
> > [    0.319145] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> > [    3.614132] rtc_cmos 00:03: RTC can wake from S4
> > [    3.614480] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> > [    3.614582] rtc0: alarms up to one year, y3k, 114 bytes nvram
> 
> I'll double check, but I suspect that "unable to open rtc device"
> message isn't new. The issue is that the rtc_cmos driver is built as a
> module, and the hctosys functionality is running before the module is
> loaded.

Yes. But I consider this a configuration error - to load modular rtc 
driver and expect boottime clock setting from it works. It was by 
mistake - the boottime options came later in time. Changed it to 
statically compiled in PC CMOS RTC and it works fine.

> Hmmm. This maybe points to the need for some sort of callback system for
> when RTC devices are registered. Since most existing code is just hoping
> its available by late_init.

Is it really necessary?

-- 
Meelis Roos (mroos@linux.ee)
