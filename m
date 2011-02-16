Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab1BPEUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:20:30 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56422 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab1BPEUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:20:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=C3=83=C2=B8nnev=C3=83=C2=A5g?= 
	<arve@android.com>
Subject: [PATCH 0/5] Introduce CLOCK_BOOTTIME
Date: Tue, 15 Feb 2011 20:20:02 -0800
Message-Id: <1297830007-426-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set (applies against tip/timers/core) extends the
hrtimer, timekeeping, and posix-timer code to support a new 
clockid: CLOCK_BOOTTIME.

CLOCK_BOOTTIME is identical to CLOCK_MONOTONIC, except it also
includes any time spent in suspend (as currently measured by
read_persistent_clock()). This allows applications to get a
suspend aware monotonic clock.

Thomas, I've included your suggestions from the last round.
Does this look like something you could queue for 2.6.39?

thanks
-john


CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve HjÃ¸nnevÃ¥g <arve@android.com>

John Stultz (5):
  hrtimers: extend hrtimer base code to handle more then 2 clockids
  time: Introduce get_monotonic_boottime and ktime_get_boottime
  time: Extend get_xtime_and_monotonic_offset() to also return sleep
  timers: Add CLOCK_BOOTTIME hrtimer base
  timers: Export CLOCK_BOOTTIME via the posix timers interface

 include/linux/hrtimer.h   |    8 +++++-
 include/linux/time.h      |    5 +++-
 kernel/hrtimer.c          |   63 ++++++++++++++++++++++++++++++--------------
 kernel/posix-timers.c     |   21 ++++++++++++++-
 kernel/time/timekeeping.c |   56 ++++++++++++++++++++++++++++++++++++++-
 5 files changed, 128 insertions(+), 25 deletions(-)

-- 
1.7.3.2.146.gca209

