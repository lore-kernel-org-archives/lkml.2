Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab0GSLfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 07:35:38 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:49217 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760572Ab0GSLfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 07:35:22 -0400
X-IronPort-AV: E=Sophos;i="4.55,226,1278280800"; 
   d="scan'208";a="55778617"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Subject: [PATCH 0/4] Wall time clocks + change in access rules
Date: Mon, 19 Jul 2010 13:34:45 +0200
Message-Id: <1279539289-27628-1-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During our work we encountered a problem of obtaining
a reliable and fine-grained measurements of CPU time/wall time 
of a process/thread. The existing methods (taskstats, procfs,
POSIX CPU clocks) have either unfriendly interface (taskstats)
or give unsatisfactory precision (procfs). However, even
the most precise and clean interface, POSIX CPU clocks, 
is limited only to threads in the same thread group.

The following patches introduce three changes:
  * new per process/thread wall time clocks --
    CLOCK_PROCESS_WALLTIME_ID and CLOCK_THREAD_WALLTIME_ID;
    one can also access wall time of a process/thread
    using clocks constructed from macros in posix-timers.h
  * less restricted access to CPU and wall clocks --
    user can access them for all their threads
  * minor refactoring/renaming to reflect the changes.

Tomasz Buchert (4):
  posix-timers: Refactoring of CPUCLOCK* macros
  posix-cpu-timers: Introduction of wall clocks
  posix-cpu-timers: Wider access to the thread clocks
  posix-cpu-timers: posix-cpu-timers.c renamed to posix-task-timers.c

 include/linux/posix-timers.h |   51 +-
 include/linux/sched.h        |    2 +-
 include/linux/time.h         |    2 +
 kernel/Makefile              |    2 +-
 kernel/itimer.c              |   14 +-
 kernel/posix-cpu-timers.c    | 1642 -------------------------------------
 kernel/posix-task-timers.c   | 1852 ++++++++++++++++++++++++++++++++++++++++++
 kernel/posix-timers.c        |   25 +-
 8 files changed, 1923 insertions(+), 1667 deletions(-)
 delete mode 100644 kernel/posix-cpu-timers.c
 create mode 100644 kernel/posix-task-timers.c

