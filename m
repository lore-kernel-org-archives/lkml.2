Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1ATVQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:16:43 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40414 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1ATVQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:16:42 -0500
Subject: Re: RTC seems broken on 2.6.38-rc1 for RTCs lacking alarms.
From: John Stultz <john.stultz@linaro.org>
To: David Daney <ddaney@caviumnetworks.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4D38A051.2010301@caviumnetworks.com>
References: <4D38A051.2010301@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 13:16:36 -0800
Message-ID: <1295558196.2998.85.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 12:51 -0800, David Daney wrote:
> open("/dev/rtc0", O_RDONLY|O_LARGEFILE) = 3
> ioctl(3, PRESTO_GETMOUNT or RTC_UIE_ON, 0) = 0
> _newselect(4, [3], NULL, NULL, {5, 0})  = 0 (Timeout)
> write(2, "select() to /dev/rtc0 to wait for"..., 55select() to /dev/rtc0 
> to wait for clock tick timed out
> ) = 55
> ioctl(3, PRESTO_SETPID or RTC_UIE_OFF, 0) = 0
> close(3)                                = 0
> exit_group(1)                           = ?
> 
> 
> The hwclock program is asking to put the clock in UIE mode and then
> does a select() on it.  Since the alarm doesn't work, the select times out.
> 
> Previously the ioctl(RTC_UIE_ON) would return EINVAL:

Ah. Good diagnosis! Let me try to get a patch for you and Andreas to
test.

thanks
-john


