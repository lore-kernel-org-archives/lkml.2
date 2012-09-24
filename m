Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab2IXQtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:49:01 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40720 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab2IXQtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:49:00 -0400
Message-ID: <50608EE1.3050401@linaro.org>
Date: Mon, 24 Sep 2012 09:48:33 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, "Molnar, Ingo" <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Time/alarmtimer changes for 3.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12092416-9360-0000-0000-00000AFB3C95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,
	Here's my queue for 3.7 for tip/timers/core. Unfortunately
tip/timers/core is still 3.5 based, and this depends on items that
landed in 3.6 (and that are waiting in tip/timers/urgent), so its based
off of tip/timers/urgent, but merges cleanly with tip/timers/core.

Let me know if you have any thoughts or requests for changes here.

thanks
-john

PS: Just a reminder that there is still a pending change in
tip/timers/urgent that I'd hope to get into 3.6.


The following changes since commit ec145babe754f9ea1079034a108104b6001e001c:

   time: Fix timeekeping_get_ns overflow on 32bit systems (2012-09-13 17:39:14 +0200)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.7/time

for you to fetch changes up to 650ea02475106e8d6bdf561896d2ffe0d1c0ebb4:

   time: Convert x86_64 to using new update_vsyscall (2012-09-24 12:38:09 -0400)

----------------------------------------------------------------
John Stultz (11):
       alarmtimer: Use hrtimer per-alarm instead of per-base
       alarmtimer: Remove unused helpers & defines
       alarmtimer: Rename alarmtimer_remove to alarmtimer_dequeue
       jiffies: Kill unused TICK_USEC_TO_NSEC
       jiffies: Remove compile time assumptions about CLOCK_TICK_RATE
       time: Move timekeeper structure to timekeeper_internal.h for vsyscall changes
       time: Move update_vsyscall definitions to timekeeper_internal.h
       time: Convert CONFIG_GENERIC_TIME_VSYSCALL to CONFIG_GENERIC_TIME_VSYSCALL_OLD
       time: Introduce new GENERIC_TIME_VSYSCALL
       time: Only do nanosecond rounding on GENERIC_TIME_VSYSCALL_OLD systems
       time: Convert x86_64 to using new update_vsyscall

Todd Poynor (1):
       alarmtimer: Implement minimum alarm interval for allowing suspend

  arch/ia64/Kconfig                   |    2 +-
  arch/ia64/kernel/time.c             |    4 +-
  arch/powerpc/Kconfig                |    2 +-
  arch/powerpc/kernel/time.c          |    4 +-
  arch/s390/Kconfig                   |    2 +-
  arch/s390/kernel/time.c             |    4 +-
  arch/x86/include/asm/vgtod.h        |    4 +-
  arch/x86/kernel/setup.c             |    3 +
  arch/x86/kernel/vsyscall_64.c       |   49 +++++++++------
  arch/x86/vdso/vclock_gettime.c      |   22 ++++---
  include/linux/alarmtimer.h          |   31 +--------
  include/linux/clocksource.h         |   16 -----
  include/linux/jiffies.h             |   21 +------
  include/linux/timekeeper_internal.h |  108 ++++++++++++++++++++++++++++++++
  kernel/time.c                       |    2 +-
  kernel/time/Kconfig                 |    4 ++
  kernel/time/alarmtimer.c            |  118 +++++++++++++----------------------
  kernel/time/jiffies.c               |   32 +++++++++-
  kernel/time/timekeeping.c           |  115 ++++++++++------------------------
  19 files changed, 281 insertions(+), 262 deletions(-)
  create mode 100644 include/linux/timekeeper_internal.h

