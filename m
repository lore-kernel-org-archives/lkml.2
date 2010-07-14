Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0GNA4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:56:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59008 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0GNA4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:56:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/11] -tip Timekeeping changes for 2.6.36
Date: Tue, 13 Jul 2010 17:56:17 -0700
Message-Id: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

	I just wanted to send you my pending queue of timekeeping
change for 2.6.36. It would be nice to get these into the -tip 
tree for testing prior to the merge window.

thanks
-john

CC: Thomas Gleixner <tglx@linutronix.de>

John Stultz (11):
  x86: Fix vtime/file timestamp inconsistencies
  Implement timespec_add
  time: Kill off CONFIG_GENERIC_TIME
  powerpc: Simplify update_vsyscall
  powerpc: Cleanup xtime usage
  Fix update_vsyscall to provide wall_to_monotonic offset
  Convert um to use read_persistent_clock
  Cleanup hrtimer.c's direct access to wall_to_monotonic
  Make xtime and wall_to_monotonic static
  Convert common x86 clocksources to use clocksource_register_hz/khz
  Add __clocksource_updatefreq_hz/khz methods

 Documentation/feature-removal-schedule.txt |   10 ----
 Documentation/kernel-parameters.txt        |    3 +-
 arch/alpha/Kconfig                         |    4 --
 arch/arm/Kconfig                           |    4 --
 arch/avr32/Kconfig                         |    3 -
 arch/blackfin/Kconfig                      |    3 -
 arch/cris/Kconfig                          |    3 -
 arch/frv/Kconfig                           |    4 --
 arch/h8300/Kconfig                         |    4 --
 arch/ia64/Kconfig                          |    4 --
 arch/ia64/kernel/time.c                    |    7 ++-
 arch/m32r/Kconfig                          |    3 -
 arch/m68k/Kconfig                          |    3 -
 arch/m68knommu/Kconfig                     |    4 --
 arch/microblaze/Kconfig                    |    3 -
 arch/mips/Kconfig                          |    4 --
 arch/mn10300/Kconfig                       |    3 -
 arch/parisc/Kconfig                        |    4 --
 arch/powerpc/Kconfig                       |    3 -
 arch/powerpc/kernel/time.c                 |   61 ++++++++++------------
 arch/s390/Kconfig                          |    3 -
 arch/s390/kernel/time.c                    |    8 ++--
 arch/score/Kconfig                         |    3 -
 arch/sh/Kconfig                            |    3 -
 arch/sparc/Kconfig                         |    3 -
 arch/um/Kconfig.common                     |    4 --
 arch/um/kernel/time.c                      |   13 +++--
 arch/x86/Kconfig                           |    5 +--
 arch/x86/kernel/hpet.c                     |   13 +++--
 arch/x86/kernel/tsc.c                      |    6 +--
 arch/x86/kernel/vsyscall_64.c              |   17 ++++--
 arch/xtensa/Kconfig                        |    3 -
 drivers/Makefile                           |    4 +-
 drivers/acpi/acpi_pad.c                    |    2 +-
 drivers/acpi/processor_idle.c              |    2 +-
 drivers/clocksource/acpi_pm.c              |    9 +---
 drivers/misc/Kconfig                       |    4 +-
 include/linux/clocksource.h                |   17 +++++-
 include/linux/time.h                       |   21 ++++++-
 kernel/hrtimer.c                           |    9 ++--
 kernel/time.c                              |   16 ------
 kernel/time/Kconfig                        |    4 +-
 kernel/time/clocksource.c                  |   33 +++++++++---
 kernel/time/timekeeping.c                  |   79 +++++++---------------------
 kernel/trace/Kconfig                       |    4 +-
 45 files changed, 163 insertions(+), 259 deletions(-)

