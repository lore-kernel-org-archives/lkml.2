Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0KSDM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 22:12:26 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60361 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab0KSDMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 22:12:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 0/5] Reworked RTC layer & Alarm timers
Date: Thu, 18 Nov 2010 19:12:04 -0800
Message-Id: <1290136329-18291-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this patchset has gotten minimal feedback, so I 
wanted to send it out again for another chance at feedback
and consideration for partial inclusion.

The first 4 patches rework the generic RTC code adding a abstracted
timerlist layer which allows the kernel to multiplex multiple
event on a single RTC device. These patches haven't changed much
since mid-october, so I'd like to start pushing for them to be
queued for testing to be included in 2.6.38.

Alessandro: Unless you object, I'll likely push these changes
upstream through Thomas. If you'd prefer to be the path, please
let me know. 

The last patch is the Android-inspired alarm timers infrastructure.
This is still in development, and I'd really like to get Arve's 
input as well as other android dev's input so we can try to make
sure the proposed interface will suffice for Android.

For now I've also dropped the dynamic clockid and direct RTC
posix clock interface patches, as Richard's dynamic clock device
code is still in-progress. I'll revisit the that interface later 
once Richard's code is more settled.

CC: Arve Hjønnevåg <arve@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Richard Cochran <richardcochran@gmail.com>

John Stultz (5):
  Introduce timerlist infrastructure.
  hrtimers: Convert hrtimers to use timerlist infrastructure
  RTC: Rework RTC code to use timerlist for events
  RTC: Remove UIE emulation
  [RFC] Introduce Alarm (hybrid) timers

 drivers/rtc/class.c          |   13 +
 drivers/rtc/interface.c      |  574 ++++++++++++++++++++++---------------
 drivers/rtc/rtc-dev.c        |  104 -------
 drivers/rtc/rtc-lib.c        |   26 ++
 include/linux/alarmtimer.h   |   30 ++
 include/linux/hrtimer.h      |   32 +--
 include/linux/posix-timers.h |    2 +
 include/linux/rtc.h          |   51 +++-
 include/linux/time.h         |    2 +
 include/linux/timerlist.h    |   37 +++
 kernel/hrtimer.c             |   86 ++----
 kernel/time/Makefile         |    2 +-
 kernel/time/alarmtimer.c     |  657 ++++++++++++++++++++++++++++++++++++++++++
 kernel/time/timer_list.c     |    8 +-
 lib/Makefile                 |    2 +-
 lib/timerlist.c              |  115 ++++++++
 16 files changed, 1318 insertions(+), 423 deletions(-)
 create mode 100644 include/linux/alarmtimer.h
 create mode 100644 include/linux/timerlist.h
 create mode 100644 kernel/time/alarmtimer.c
 create mode 100644 lib/timerlist.c

-- 
1.7.3.2.146.gca209

