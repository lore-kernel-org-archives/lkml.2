Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1AUKX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:23:26 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:40190 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1AUKXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:23:24 -0500
X-Auth-Info: 7GCPMvuR5kzAnsbU/UGhZN+VxwwFbuscDmLI3SNtPMM=
From: Andreas Schwab <schwab@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 3/5] RTC: Rework RTC code to use timerlist for events
References: <1290136329-18291-1-git-send-email-john.stultz@linaro.org>
	<1290136329-18291-4-git-send-email-john.stultz@linaro.org>
	<m2hbd378jt.fsf@igel.home> <1295550774.2998.58.camel@work-vm>
X-Yow: Today, THREE WINOS from DETROIT sold me a framed photo of
 TAB HUNTER before his MAKEOVER!
Date: Fri, 21 Jan 2011 11:23:22 +0100
In-Reply-To: <1295550774.2998.58.camel@work-vm> (John Stultz's message of
	"Thu, 20 Jan 2011 11:12:54 -0800")
Message-ID: <m262tizhb9.fsf@whitebox.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> On Thu, 2011-01-20 at 19:07 +0100, Andreas Schwab wrote:
>> John Stultz <john.stultz@linaro.org> writes:
>> 
>> > This patch reworks a large portion of the generic RTC code
>> > to in-effect virtualize the rtc interrupt code.
>> 
>> That breaks RTC on powermac which uses rtc-generic.
>> 
>> # hwclock 
>> select() to /dev/rtc0 to wait for clock tick timed out
>
> Actually, can you also send strace output?

ioctl(4, RTC_UIE_ON, 0)                 = 0
select(5, [4], NULL, NULL, {5, 0})      = 0 (Timeout)
write(2, "select() to /dev/rtc0 to wait fo"..., 55) = 55
ioctl(4, RTC_UIE_OFF, 0)                = 0

CONFIG_RTC_INTF_DEV_UIE_EMUL was never enabled, and RTC_UIE_ON returned
EINVAL before, which caused hwclock to fall back to polling.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
