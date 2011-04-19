Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1DSX66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:58:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33373 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab1DSX64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:58:56 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 0/4] Posix Alarm Timers
Date: Tue, 19 Apr 2011 16:58:26 -0700
Message-Id: <1303257510-15054-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just wanted to send out my current Posix Alarm Timers queue for 
comment and review in the hopes of getting it into shape for
2.6.40.

Some background on the patches can be found here:
	https://lwn.net/Articles/429925/

New in this series:
* Added timekeeping_inject_sleeptime, which corrects CLOCK_BOOTTIME
  for arches that don't support read_persistent_clock().
* I've added a CAP_WAKE_ALARM capability to limit random applications
  from setting alarms in the last patch. This probably needs some
  careful review as it allows clock_nanosleep and timer_create to
  return -EPERM, which is new behavior.

thanks
-john

CC: Arve Hjønnevåg <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>

John Stultz (4):
  time: Add timekeeping_inject_sleeptime
  timers: Add rb_init_node() to allow for stack allocated rb nodes
  timers: Introduce in-kernel alarm-timer interface
  timers: posix interface for alarm-timers

 drivers/rtc/class.c          |   23 +-
 include/linux/alarmtimer.h   |   30 ++
 include/linux/capability.h   |    7 +-
 include/linux/posix-timers.h |    2 +
 include/linux/rbtree.h       |    8 +
 include/linux/time.h         |    3 +
 include/linux/timerqueue.h   |    2 +-
 kernel/time/Makefile         |    2 +-
 kernel/time/alarmtimer.c     |  705 ++++++++++++++++++++++++++++++++++++++++++
 kernel/time/timekeeping.c    |   56 ++++-
 10 files changed, 818 insertions(+), 20 deletions(-)
 create mode 100644 include/linux/alarmtimer.h
 create mode 100644 kernel/time/alarmtimer.c

-- 
1.7.3.2.146.gca209

