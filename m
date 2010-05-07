Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab0EGVMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:12:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab0EGVMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:12:09 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 0/8] lockup detector changes
Date: Fri,  7 May 2010 17:11:43 -0400
Message-Id: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series covers mostly the changes necessary for combining the
nmi_watchdog and softlockup code.  Also added are the cleanups associated
with the change, like removing the old files.

The changelogs in each patch are more specific to what the changes are.

V2:
reworked patch 2 to not change the touch_softlockup_watchdog api but instead
do some cleanups here and there.  This caused patches 7 and 8 to be changed a
bit to handle the new differences.

Don Zickus (8):
  [watchdog] combine nmi_watchdog and softlockup
  [nmi watchdog] touch_softlockup cleanups and softlockup_tick removal
  [watchdog] remove old softlockup code
  [watchdog] remove nmi_watchdog.c file
  [x86] watchdog: move trigger_all_cpu_backtrace to its own die_notifier
  [x86] watchdog: cleanup hw_nmi.c cruft
  [watchdog] resolve softlockup.c conflicts
  [watchdog] separate touch_nmi_watchdog code path from touch_watchdog

 Documentation/kernel-parameters.txt |    2 +
 arch/x86/include/asm/nmi.h          |    2 +-
 arch/x86/kernel/apic/Makefile       |    4 +-
 arch/x86/kernel/apic/hw_nmi.c       |  119 +++-----
 arch/x86/kernel/traps.c             |    4 +-
 include/linux/nmi.h                 |    8 +-
 include/linux/sched.h               |   14 +-
 init/Kconfig                        |    5 +-
 kernel/Makefile                     |    3 +-
 kernel/kgdb.c                       |    6 +-
 kernel/nmi_watchdog.c               |  259 ----------------
 kernel/softlockup.c                 |  278 -----------------
 kernel/sysctl.c                     |   52 ++--
 kernel/timer.c                      |    1 -
 kernel/watchdog.c                   |  564 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |   30 ++-
 16 files changed, 684 insertions(+), 667 deletions(-)
 delete mode 100644 kernel/nmi_watchdog.c
 delete mode 100644 kernel/softlockup.c
 create mode 100644 kernel/watchdog.c

