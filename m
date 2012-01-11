Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab2AKU6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:58:00 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36548 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab2AKU56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:57:58 -0500
Message-ID: <1326315453.27249.242.camel@work-vm>
Subject: [GIT PULL] rtc/time work possibly for 3.3
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 12:57:33 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12011120-5806-0000-0000-0000114C5F63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	This is a little late in the merge window, so let me know and I'll
rework this queue for 3.4.

I've got two main items here:
1) Improved version of Neil's fix for the RTC queue getting jammed up if
RTC time was set forward. This resolves the issues that required it be
reverted right before 3.2

2) Timekeeping core cleanup. These are fairly straight forward reworking
of the timekeeping code, moving all the inter-connected variables into
the timekeeper structure, and splitting up the xtime_lock usage into a
separate timekeeper lock and ntp lock. This is in preparation for the
timekeeping lock hold time reduction changes I want to push out to 3.4.

These are against linus's HEAD right now, as tip/timers/core has all
been merged and is a bit behind. Let me know if you'd rather I rebase
these ontop of something else.

Anyway, they are available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.3/tip/timers/core

Shortlog is here:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/fortglx/3.3/tip/timers/core


John Stultz (11):
      rtc: Avoid setting alarm to a time in the past
      time: Move total_sleep_time into the timekeeper structure
      time: Move wall_to_monotonic into the timekeeper structure
      time: Move xtime into timekeeeper structure
      time: Move raw_time into timekeeper structure
      time: Cleanup global variables and move them to the top
      time: Add timekeeper lock
      ntp: Cleanup timex.h
      ntp: Access tick_length variable via ntp_tick_length()
      ntp: Add ntp_lock to replace xtime_locking
      time: Remove most of xtime_lock usage in timekeeping.c

NeilBrown (1):
      rtc: Expire alarms after the time is set. (v2)

Thomas Gleixner (2):
      time: Reorder so the hot data is together
      time: Move common updates to a function

 drivers/rtc/interface.c   |   15 ++-
 include/linux/timex.h     |   17 +--
 kernel/time/ntp.c         |   83 +++++++++---
 kernel/time/timekeeping.c |  338 ++++++++++++++++++++++++--------------------
 4 files changed, 262 insertions(+), 191 deletions(-)


