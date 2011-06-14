Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1FNSme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:42:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40266 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1FNSmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:42:33 -0400
Subject: Re: 3.0-rc3: No RTC device found
From: John Stultz <john.stultz@linaro.org>
To: Meelis Roos <mroos@ut.ee>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.SOC.1.00.1106141203350.11764@math.ut.ee>
References: <alpine.SOC.1.00.1106081454240.8911@math.ut.ee>
	 <alpine.SOC.1.00.1106141203350.11764@math.ut.ee>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 10:54:39 -0700
Message-ID: <1308074079.7261.1.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 12:06 +0300, Meelis Roos wrote:
> This was my earlier report that I tought was sparc64 specific:
> 
> > Dmesg finds both OF RTC and PC RTC but later complains
> > "No RTC device found, ALARM timers will not wake from suspend"
> 
> But today I noticed this while testing 3.0-rc3 on a PC:
> 
> [    0.313944] No RTC device found, ALARM timers will not wake from suspend
> [    0.314275] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> 
> Later it detects PC RTC:
> 
> [    3.610210] rtc_cmos 00:03: RTC can wake from S4
> [    3.611554] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> [    3.611669] rtc0: alarms up to one year, y3k, 114 bytes nvram
> 
> Bisecting it on sparc64 got me nowhere. Have not tried bisecting it on 
> PC yet.

Hmm. I'm guessing this is due to the RTC cmos module loading later then
expected. Don't bother bisecting, I'll see what I can do about it.

Thanks for the testing and feedback!
-john


