Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795Ab1FNJYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:24:37 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:58514 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab1FNJYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:24:36 -0400
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 05:24:36 EDT
Date: Tue, 14 Jun 2011 12:06:49 +0300 (EEST)
From: Meelis Roos <mroos@ut.ee>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: 3.0-rc3: No RTC device found
In-Reply-To: <alpine.SOC.1.00.1106081454240.8911@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1106141203350.11764@math.ut.ee>
References: <alpine.SOC.1.00.1106081454240.8911@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was my earlier report that I tought was sparc64 specific:

> Dmesg finds both OF RTC and PC RTC but later complains
> "No RTC device found, ALARM timers will not wake from suspend"

But today I noticed this while testing 3.0-rc3 on a PC:

[    0.313944] No RTC device found, ALARM timers will not wake from suspend
[    0.314275] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

Later it detects PC RTC:

[    3.610210] rtc_cmos 00:03: RTC can wake from S4
[    3.611554] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.611669] rtc0: alarms up to one year, y3k, 114 bytes nvram

Bisecting it on sparc64 got me nowhere. Have not tried bisecting it on 
PC yet.

-- 
Meelis Roos (mroos@linux.ee)
