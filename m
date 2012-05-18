Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031228Ab2EROKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 10:10:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49542 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab2EROKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 10:10:10 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH RFC V2 0/6] Fix leap seconds and add tai clock
Date: Fri, 18 May 2012 16:09:52 +0200
Message-Id: <cover.1337348892.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In honor of this summer's new leap second, this patch series aim to
fix the incorrect time values reported during a leap second. This
second version of the patch series does not change the core time
keeping code, but rather affects only the adjtimex interface.

Of course, the POSIX UTC system is broken by design, and the Linux
kernel cannot fix that. However, what we can do is correctly execute
leap seconds and report the time variables (UTC time, TAI offset, and
leap second status) with consistency.

Since commit 6b43ae8a, the leap second is applied on the first timer
tick after the actual deadline, resulting in incorrect time values
from gettimeofday and friends.  In contrast to V1, this series does
not address that issue but rather adds extra checks into the adjtimex
code path, with the effect of always providing correct UTC time
values, even during a leap second.

The first two patches merely clean up some cruft I noticed along the
way while working on this series.


John Stultz (1):
  time: Add CLOCK_TAI clockid

Richard Cochran (5):
  time: remove obsolete declaration
  ntp: remove useless parameter
  time: keep track of the pending utc/tai threshold
  time: introduce leap second functional interface
  time: move leap second management into time keeping core

 include/linux/time.h       |    9 +-
 kernel/posix-timers.c      |   10 ++
 kernel/time/leap-seconds.h |   21 ++++
 kernel/time/ntp.c          |   90 ++++++------------
 kernel/time/timekeeping.c  |  228 ++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 283 insertions(+), 75 deletions(-)
 create mode 100644 kernel/time/leap-seconds.h

-- 
1.7.2.5

