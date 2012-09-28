Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161059Ab2I1WHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:07:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36620 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030492Ab2I1WHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:07:51 -0400
Message-ID: <50661FA8.9090801@us.ibm.com>
Date: Fri, 28 Sep 2012 15:07:36 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, "Molnar, Ingo" <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Time/alarmtimer changes for 3.7
References: <50608EE1.3050401@linaro.org>
In-Reply-To: <50608EE1.3050401@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092822-2876-0000-0000-0000009455FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     I just updated my fortglx/3.7/time branch to include and resolve 
the collision with Arnd's LATCH fix. Just wanted to give you a heads up 
so you weren't surprised by the additional change.

Full pull request below.

thanks
-john

The following changes since commit ec145babe754f9ea1079034a108104b6001e001c:

   time: Fix timeekeping_get_ns overflow on 32bit systems (2012-09-13 17:39:14 +0200)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.7/time

for you to fetch changes up to 28f2b02bc581ffc835bc1691b18d03f62fcf0395:

   Merge branch 'arnds-jiffies-fix' into fortglx/3.7/time (2012-09-28 18:00:27 -0400)

----------------------------------------------------------------

Arnd Bergmann (1):
       time/jiffies: bring back unconditional LATCH definition

John Stultz (12):
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
       Merge branch 'arnds-jiffies-fix' into fortglx/3.7/time

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
  include/linux/jiffies.h             |   20 +-----
  include/linux/timekeeper_internal.h |  108 ++++++++++++++++++++++++++++++++
  kernel/time.c                       |    2 +-
  kernel/time/Kconfig                 |    4 ++
  kernel/time/alarmtimer.c            |  118 +++++++++++++----------------------
  kernel/time/jiffies.c               |   32 +++++++++-
  kernel/time/timekeeping.c           |  115 ++++++++++------------------------
  19 files changed, 282 insertions(+), 260 deletions(-)
  create mode 100644 include/linux/timekeeper_internal.h


