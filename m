Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2BBDEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:04:04 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:45117 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2BBDEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:04:01 -0500
Message-ID: <1328151764.2342.118.camel@work-vm>
Subject: [GIT PULL] Timekeeping changes for 3.4
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Wed, 01 Feb 2012 19:02:44 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020203-7408-0000-0000-00000255D99A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Here's the first chunk of my big timekeeping change queue, for 3.4.
Most of it should be fairly straight forward cleanups, moving values
into the timekeeper structure and changing the locking away from
xtime_lock.

Again, since tip/timers/core hasn't been updated since 3.3 was out,
these are against Linus' head (actually, from a week or so ago). Let me
know if you'd like me to base them off of something else.

Also, the more aggressive changes that will allow for reduced lock hold
times, which I'm holding off for 3.5 or later, can be found here if you
want to take a look at them, or possibly merge them earlier into a
3.4-rt tree for extra testing:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/dev/xtime-breakup

thanks
-john

The patches are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.4/time

John Stultz (10):
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

Thomas Gleixner (2):
      time: Reorder so the hot data is together
      time: Move common updates to a function

 include/linux/timex.h     |   17 +--
 kernel/time/ntp.c         |   83 +++++++++---
 kernel/time/timekeeping.c |  338 ++++++++++++++++++++++++--------------------
 3 files changed, 248 insertions(+), 190 deletions(-)

