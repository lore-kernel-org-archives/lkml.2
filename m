Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1AFCQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 21:16:50 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56252 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1AFCQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:16:16 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 00/12] Posix Alarm Timers full patchset
Date: Wed,  5 Jan 2011 18:15:47 -0800
Message-Id: <1294280159-2513-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 8 of these patches are already in -tip for inclusion
in 2.6.38, but I wanted to send them all out again so folks could
try them out and I could hopefully get some feedback on the remaining 
patches in this set.

Specifically, I'm really hoping to get some feedback from any Android
folks on the introduction of CLOCK_BOOTTIME (generic posix version of
ANDROID_ALARM_ELAPSED_REALTIME) which provides CLOCK_MONOTONIC + suspend
time, as well as the posix alarm timers (CLOCK_REALTIME_ALARM and
CLOCK_BOOTTIME_ALARM), which try to provide equivalent functionality
as the Android Alarm Timers.

There are still a few remaining TODOs here, but getting some feedback
as to any limitations this interface has compared to the Android
/dev/alarm interface would be great.

The full set applies ontop of v2.6.37.

thanks
-john

CC: Arve Hjønnevåg <arve@android.com>
CC: Brian Swetland <swetland@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>

John Stultz (11):
  timers: Introduce timerlist infrastructure.
  timers: Rename timerlist infrastructure to timerqueue
  timers: Fixup allmodconfig build issue
  hrtimers: Convert hrtimers to use timerlist infrastructure
  hrtimer: fix timerqueue conversion flub
  RTC: Rework RTC code to use timerqueue for events
  RTC: Remove UIE emulation
  [RFC] hrtimers: extend hrtimer base code to handle more then 2
    clockids
  [RFC] hrtimers: Add CLOCK_BOOTTIME clockid, hrtimerbase and posix
    interface
  timers: Add rb_init_node() to allow for stack allocated rb nodes
  [RFC] Introduce Alarm (hybrid) timers

Thomas Gleixner (1):
  rtc: Namespace fixup

 drivers/rtc/class.c          |   13 +
 drivers/rtc/interface.c      |  574 +++++++++++++++++++++--------------
 drivers/rtc/rtc-dev.c        |  104 -------
 drivers/rtc/rtc-lib.c        |   28 ++
 include/linux/alarmtimer.h   |   30 ++
 include/linux/hrtimer.h      |   40 ++-
 include/linux/posix-timers.h |    2 +
 include/linux/rbtree.h       |    8 +
 include/linux/rtc.h          |   51 +++-
 include/linux/time.h         |    6 +
 include/linux/timerqueue.h   |   37 +++
 kernel/hrtimer.c             |  146 +++++-----
 kernel/posix-timers.c        |   16 +-
 kernel/time/Makefile         |    2 +-
 kernel/time/alarmtimer.c     |  699 ++++++++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c    |   79 +++++-
 kernel/time/timer_list.c     |    8 +-
 lib/Makefile                 |    2 +-
 lib/timerqueue.c             |  121 ++++++++
 19 files changed, 1525 insertions(+), 441 deletions(-)
 create mode 100644 include/linux/alarmtimer.h
 create mode 100644 include/linux/timerqueue.h
 create mode 100644 kernel/time/alarmtimer.c
 create mode 100644 lib/timerqueue.c

-- 
1.7.3.2.146.gca209

