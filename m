Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab2DTTdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:33:18 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50132 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2DTTdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:33:07 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 0/4] Android Alarm Driver Cleanups (for staging-next/3.5)
Date: Fri, 20 Apr 2012 12:31:43 -0700
Message-Id: <1334950307-403-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042019-7408-0000-0000-00000461CD7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set moves the Android alarm driver in staging to use
the upstreamed CLOCK_BOOTTIME and alarmtimer interfaces, allowing
us to greatly shrink the alarm driver.

The Google Android team has been using these patches in its AOSP tree
for a little while without any reported issues.

The only gotcha is that I needed to make one alarmtimer interface
non-static in order to support the android alarm driver. This sort
of is a grey area for the staging tree, but I'm the author of the
upstreamed alarmtimer code, and Thomas (cc'ed) had no objection
to this patch going in via the staging tree, instead of -tip so 
this should be ok (and much simpler then dealing with
cross-maintainer dependencies).

Greg: Would you mind applying this set to staging-next for 3.5?

thanks
-john

CC: Colin Cross <ccross@android.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>

John Stultz (4):
  android-alarm: Convert ALARM_ELAPSED_REALTIME to use CLOCK_BOOTTIME
  alarmtimer: Provide accessor to alarmtimer rtc device
  android-alarm: Rework alarm-dev.c to use upstreamed alarmtimers
  android-alarm: Remove unused android alarm in-kernel interfaces

 drivers/staging/android/Kconfig         |   21 +-
 drivers/staging/android/Makefile        |    1 -
 drivers/staging/android/alarm-dev.c     |  111 +++++-
 drivers/staging/android/alarm.c         |  601 -------------------------------
 drivers/staging/android/android_alarm.h |   59 ---
 include/linux/alarmtimer.h              |    3 +
 kernel/time/alarmtimer.c                |    4 +-
 7 files changed, 106 insertions(+), 694 deletions(-)
 delete mode 100644 drivers/staging/android/alarm.c

-- 
1.7.3.2.146.gca209

