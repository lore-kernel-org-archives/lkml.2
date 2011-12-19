Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1LSTvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:51:39 -0500
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:41210 "EHLO
	intmgw003.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752812Ab1LSTvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:51:37 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 0/2] Add a thread cpu time implementation to vDSO (v2)
Date: Mon, 19 Dec 2011 11:51:31 -0800
Message-Id: <1324324293-10390-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since last rev:

* Drop the direct vsyscall (hope clock_gettime_ns() addresses the gap)
* Add a compile time check for vvar page overflow
* Handle return value from the syscall
* Pack the VVAR page more tightly
* Handle NR_CPUS > 64

Arun Sharma (1):
  Extend VVAR support to multiple pages

Kumar Sundararajan (1):
  Add a thread cpu time implementation to vDSO

 Documentation/cgroups/timer_slack.txt |   81 ----------------
 drivers/Makefile                      |    3 -
 drivers/fb/Makefile                   |    1 -
 drivers/fb/tsc/Makefile               |    2 -
 drivers/fb/tsc/tsc.c                  |   29 ------
 fs/select.c                           |    7 +-
 include/linux/cgroup_subsys.h         |    7 --
 include/linux/prctl.h                 |    6 -
 include/linux/sched.h                 |   11 --
 include/linux/topology.h              |    2 -
 init/Kconfig                          |    8 --
 kernel/Makefile                       |    1 -
 kernel/cgroup_timer_slack.c           |  169 ---------------------------------
 kernel/fork.c                         |    4 -
 kernel/futex.c                        |    4 +-
 kernel/hrtimer.c                      |    2 +-
 kernel/sched_fair.c                   |   54 -----------
 kernel/sys.c                          |    3 -
 18 files changed, 8 insertions(+), 386 deletions(-)
 delete mode 100644 Documentation/cgroups/timer_slack.txt
 delete mode 100644 drivers/fb/Makefile
 delete mode 100644 drivers/fb/tsc/Makefile
 delete mode 100644 drivers/fb/tsc/tsc.c
 delete mode 100644 kernel/cgroup_timer_slack.c

-- 
1.7.4

