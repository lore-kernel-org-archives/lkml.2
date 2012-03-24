Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2CXAiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 20:38:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38557 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2CXAiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 20:38:02 -0400
Message-ID: <4F6D1760.7080604@us.ibm.com>
Date: Fri, 23 Mar 2012 17:37:52 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: "Gleixner, Thomas" <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Time stragglers for 3.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032400-3352-0000-0000-000003892E97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Here's the last of my items for 3.4.  Let me know if you have any 
objections or if you'd rather me push any changes off to 3.5.

thanks
-john

The changes can be found here, on top of tip/timers/core:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.4/time

Andy Lutomirski (2):

       x86-64: Simplify and optimize vdso clock_gettime monotonic variants

       x86-64: Inline vdso clock_gettime helpers

Cesar Eduardo Barros (1):

       time: remove no_sync_cmos_clock

Jim Cromie (1):

       kernel-time: fix s/then/than/ spelling errors

John Stultz (3):

       ntp: Fix leap-second hrtimer livelock

       alarmtimer: Make sure we initialize the rtctimer

       time: Avoid scary backtraces when warning of>  11% adj

  arch/x86/include/asm/vgtod.h   |   15 +++--

  arch/x86/kernel/vsyscall_64.c  |   10 +++-

  arch/x86/vdso/vclock_gettime.c |   47 ++++----------

  include/linux/time.h           |    1 -

  include/linux/timex.h          |    2 +-

  kernel/time/alarmtimer.c       |    5 +-

  kernel/time/clocksource.c      |    2 +-

  kernel/time/ntp.c              |  134 +++++++++++++---------------------------

  kernel/time/timekeeping.c      |   44 ++++++--------

  9 files changed, 98 insertions(+), 162 deletions(-)


