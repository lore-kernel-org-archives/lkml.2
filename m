Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0DTPZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab0DTPYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:24:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 0/6] lockup detector changes
Date: Tue, 20 Apr 2010 11:23:57 -0400
Message-Id: <1271777043-3807-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series covers mostly the changes necessary for combining the
nmi_watchdog and softlockup code.  Also added are the cleanups associated
with the change, like removing the old files.

The changelogs in each patch are more specific to what the changes are.

Don Zickus (5):
  [watchdog] combine nmi_watchdog and softlockup
  [watchdog] convert touch_softlockup_watchdog to touch_watchdog
  [watchdog] remove old softlockup code
  [watchdog] remove nmi_watchdog.c file
  [x86] watchdog: move trigger_all_cpu_backtrace to its own die_notifier
  [x86] watchdog: cleanup hw_nmi.c cruft

 Documentation/kernel-parameters.txt |    2 +
 arch/ia64/kernel/time.c             |    2 +-
 arch/ia64/kernel/uncached.c         |    2 +-
 arch/ia64/xen/time.c                |    2 +-
 arch/mn10300/kernel/gdb-stub.c      |    2 +-
 arch/powerpc/kernel/swsusp_64.c     |    2 +-
 arch/sparc/kernel/nmi.c             |    2 +-
 arch/x86/include/asm/nmi.h          |    2 +-
 arch/x86/kernel/apic/Makefile       |    4 +-
 arch/x86/kernel/apic/hw_nmi.c       |  113 +++-----
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
 kernel/softlockup.c                 |  278 ------------------
 kernel/sysctl.c                     |   52 ++--
 kernel/time/tick-sched.c            |    8 +-
 kernel/time/timekeeping.c           |    2 +-
 kernel/timer.c                      |    1 -
 kernel/watchdog.c                   |  552 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |   30 ++-
 34 files changed, 692 insertions(+), 696 deletions(-)
 delete mode 100644 kernel/nmi_watchdog.c
 delete mode 100644 kernel/softlockup.c
 create mode 100644 kernel/watchdog.c

