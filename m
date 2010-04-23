Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab0DWQOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890Ab0DWQOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:14:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 0/8] lockup detector changes
Date: Fri, 23 Apr 2010 12:13:28 -0400
Message-Id: <1272039216-8890-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series covers mostly the changes necessary for combining the
nmi_watchdog and softlockup code.  Also added are the cleanups associated
with the change, like removing the old files.

The changelogs in each patch are more specific to what the changes are.

Don Zickus (8):
  [watchdog] combine nmi_watchdog and softlockup
  [watchdog] convert touch_softlockup_watchdog to touch_watchdog
  [watchdog] remove old softlockup code
  [watchdog] remove nmi_watchdog.c file
  [x86] watchdog: move trigger_all_cpu_backtrace to its own die_notifier
  [x86] watchdog: cleanup hw_nmi.c cruft
  [watchdog] resolve softlockup.c conflicts
  [watchdog] separate touch_nmi_watchdog code path from touch_watchdog

 Documentation/kernel-parameters.txt |    2 +
 arch/ia64/kernel/time.c             |    2 +-
 arch/ia64/kernel/uncached.c         |    2 +-
 arch/ia64/xen/time.c                |    2 +-
 arch/mn10300/kernel/gdb-stub.c      |    2 +-
 arch/powerpc/kernel/swsusp_64.c     |    2 +-
 arch/sparc/kernel/nmi.c             |    2 +-
 arch/x86/include/asm/nmi.h          |    2 +-
 arch/x86/kernel/apic/Makefile       |    4 +-
 arch/x86/kernel/apic/hw_nmi.c       |  119 +++-----
 arch/x86/kernel/apic/nmi.c          |    2 +-
 arch/x86/kernel/traps.c             |    4 +-
 arch/x86/xen/smp.c                  |    2 +-
 drivers/ide/ide-iops.c              |    2 +-
 drivers/ide/ide-taskfile.c          |    2 +-
 drivers/mtd/nand/nand_base.c        |    4 +-
 drivers/video/nvidia/nv_accel.c     |    2 +-
 include/linux/nmi.h                 |   13 +-
 include/linux/sched.h               |   20 +-
 init/Kconfig                        |    5 +-
 kernel/Makefile                     |    3 +-
 kernel/kgdb.c                       |    6 +-
 kernel/nmi_watchdog.c               |  259 ----------------
 kernel/panic.c                      |    2 +-
 kernel/power/hibernate.c            |    2 +-
 kernel/sched.c                      |    2 +-
 kernel/sched_clock.c                |    2 +-
 kernel/softlockup.c                 |  278 -----------------
 kernel/sysctl.c                     |   52 ++--
 kernel/time/tick-sched.c            |    8 +-
 kernel/time/timekeeping.c           |    2 +-
 kernel/timer.c                      |    1 -
 kernel/watchdog.c                   |  568 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |   30 ++-
 34 files changed, 713 insertions(+), 697 deletions(-)
 delete mode 100644 kernel/nmi_watchdog.c
 delete mode 100644 kernel/softlockup.c
 create mode 100644 kernel/watchdog.c

