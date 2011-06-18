Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab1FRANw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 20:13:52 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38125 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1FRANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 20:13:49 -0400
Subject: Re: [RFC][PATCH] alarmtimers: Handle late rtc module loading
From: john stultz <johnstul@us.ibm.com>
To: Meelis Roos <mroos@ut.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1308335616.3606.4.camel@work-vm>
References: <1308274479-25259-1-git-send-email-john.stultz@linaro.org>
	 <alpine.SOC.1.00.1106171112460.29700@math.ut.ee>
	 <1308335616.3606.4.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 17:13:43 -0700
Message-ID: <1308356023.3606.19.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 11:33 -0700, John Stultz wrote:
> On Fri, 2011-06-17 at 12:43 +0300, Meelis Roos wrote:
> > > Meelis: Could you give this patch a shot to make sure it resolves
> > > the issues you've seen on x86 and sparc?
> > 
> > Worked on sparc64 (Netra X1) on all 3 boots, on top of 
> > 3.0.0-rc3-00202-geb96c92.
> > 
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

Yep. You're likely to see the same message with 2.6.37 or earlier if the
rtc drvier is a module and you have the hwtosys option enabled. Building
the driver statically will resolve this issue.

Clearly this is not ideal, but at least its not a regression.

thanks
-john



