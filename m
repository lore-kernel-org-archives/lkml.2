Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab0FECxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 22:53:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48331 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab0FECx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 22:53:29 -0400
From: John Stultz <johnstul@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeff Dike <jdike@addtoit.com>
Subject: [RFC][PATCH 0/6] xtime/wall_to_monotonic cleanups
Date: Fri,  4 Jun 2010 19:53:20 -0700
Message-Id: <1275706406-8111-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up all the direct accesses to xtime
and wall_to_monotonic, allowing them to be made static
so we can do further cleanup and rework of the timekeeping
core.

This is 2.6.36 (or later) material. But I wanted to get 
the ball rolling.

Any feedback/testing would be greatly appreciated!

thanks
-john


John Stultz (6):
  powerpc: Simplify update_vsyscall
  powerpc: Cleanup xtime usage
  Fix update_vsyscall to provide wall_to_monotonic offset
  Convert um to use read_persistent_clock
  Cleanup hrtimer.c's direct access to wall_to_monotonic
  Make xtime and wall_to_monotonic static

CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Anton Blanchard <anton@samba.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Tony Luck <tony.luck@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Jeff Dike <jdike@addtoit.com>

 Documentation/feature-removal-schedule.txt |   10 -----
 arch/ia64/kernel/time.c                    |    7 ++-
 arch/powerpc/kernel/time.c                 |   61 +++++++++++++---------------
 arch/s390/kernel/time.c                    |    8 ++--
 arch/um/kernel/time.c                      |   13 +++---
 arch/x86/kernel/vsyscall_64.c              |    6 +-
 include/linux/clocksource.h                |    6 ++-
 include/linux/time.h                       |    5 +-
 kernel/hrtimer.c                           |    9 ++--
 kernel/time/timekeeping.c                  |   18 ++++++--
 10 files changed, 69 insertions(+), 74 deletions(-)

