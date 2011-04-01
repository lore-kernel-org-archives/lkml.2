Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1DACjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 22:39:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44002 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab1DACjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 22:39:06 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, patches@linaro.org,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 0/3] Posix Alarm Timers patchqueue
Date: Thu, 31 Mar 2011 19:38:36 -0700
Message-Id: <1301625519-10164-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that most of the prerequisite code has been merged,
I wanted to send out the Posix Alarm Timers patchset for
some review in hopes that the details can be worked out
so that it can be merged in 2.6.40 or shortly there after.

Issues I'd like to get feedback on:

1) Does the in-kernel alarm timer interface seem sufficient
for the Android Alarm Timers to adapt to using?

2) For the Posix Alarm Timers, what capabilities should be
required in order to allow an application to set an alarm?

3) For in-kernel alarm timers, should there be some override
or explicit switch in sysfs that allows alarm timers to be
enabled or disabled to allow a user to make sure their system
is not woken up by an alarm timer, if they desire. What should
that switch look like?

Remaining issues/Future work:
1) Currently CLOCK_BOOTTIME is updated from read_persistant_clock(),
however some systems do not support that call, instead using the RTC 
to set the time on resume. I'm working on a hook on resume that allows
the RTC hook to increment the timekeeping sleep time as well.

2) I'd like to try to hook up _ALARM clockids to the timerfd
infrastructure to see if that interface might more closely map
to the Android Alarm Timers interface.

thanks
-john

CC: patches@linaro.org
CC: Arve Hjønnevåg <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>


John Stultz (3):
  timers: Add rb_init_node() to allow for stack allocated rb nodes
  timers: Introduce in-kernel alarm-timer interface
  timers: posix interface for alarm-timers

 include/linux/alarmtimer.h   |   30 ++
 include/linux/posix-timers.h |    2 +
 include/linux/rbtree.h       |    8 +
 include/linux/time.h         |    2 +
 include/linux/timerqueue.h   |    2 +-
 kernel/time/Makefile         |    2 +-
 kernel/time/alarmtimer.c     |  701 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 745 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/alarmtimer.h
 create mode 100644 kernel/time/alarmtimer.c

-- 
1.7.3.2.146.gca209

