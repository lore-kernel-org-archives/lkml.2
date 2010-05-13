Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab0EMBVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:21:18 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51999 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0EMBVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=wnSCT/MJe04oxr6mvbBLYRWsC11i0RS0YWYnFbN7pHzp3/LTHIs64scX0n6s5vGjSr
         wkQSr6yTeRohBoZKmbJnAOtyodDOogj06zIj+eSK81cc1yYWzPRDttzdH1WTYicP6sp9
         JZpYNqhhrkj/kXPTbtDkZEJNpmAjtDv2pA78Q=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [GIT PULL] Unified lockup detector
Date: Thu, 13 May 2010 03:21:05 +0200
Message-Id: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/nmi branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/nmi

There is also a merge of v2.6.34-rc7 to catch up with latest
softlockup changes and prevent from conflicts.

Thanks,
	Frederic
---

Don Zickus (7):
      lockup_detector: Combine nmi_watchdog and softlockup detector
      lockup_detector: Touch_softlockup cleanups and softlockup_tick removal
      lockup_detector: Remove old softlockup code
      lockup_detector: Remove nmi_watchdog.c file
      x86: Move trigger_all_cpu_backtrace to its own die_notifier
      x86: Cleanup hw_nmi.c cruft
      lockup_detector: Separate touch_nmi_watchdog code path from touch_watchdog

Frederic Weisbecker (2):
      lockup_detector: Make BOOTPARAM_SOFTLOCKUP_PANIC depend on LOCKUP_DETECTOR
      lockup_detector: Fix forgotten config conversion


 Documentation/kernel-parameters.txt |    2 +
 arch/x86/include/asm/nmi.h          |    2 +-
 arch/x86/kernel/apic/Makefile       |    4 +-
 arch/x86/kernel/apic/hw_nmi.c       |  119 +++-----
 arch/x86/kernel/traps.c             |    4 +-
 include/linux/nmi.h                 |    8 +-
 include/linux/sched.h               |   12 +-
 init/Kconfig                        |    5 +-
 kernel/Makefile                     |    3 +-
 kernel/nmi_watchdog.c               |  259 ----------------
 kernel/softlockup.c                 |  293 ------------------
 kernel/sysctl.c                     |   52 ++--
 kernel/timer.c                      |    1 -
 kernel/watchdog.c                   |  564 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug                   |   32 ++-
 15 files changed, 679 insertions(+), 681 deletions(-)
