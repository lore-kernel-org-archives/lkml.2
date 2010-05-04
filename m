Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054Ab0EDNsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:48:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:39160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760027Ab0EDNsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:48:35 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET sched/core] cpu_stop: implement and use cpu_stop, take#2
Date: Tue,  4 May 2010 15:47:40 +0200
Message-Id: <1272980864-27235-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 13:47:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the second take of cpu_stop.  There have been only two minor
changes from the last take[L].

* work_buf initialization in stop_one_cpu_nowait() simplified.

* Comment to clarify active_balance_work synchronization added.

Peter, if you ack the series, I'll add refresh the patches w/ your ACK
and request pull into sched/core to Ingo.

This patchset contains the following four patches.

 0001-cpu_stop-implement-stop_cpu-s.patch
 0002-stop_machine-reimplement-using-cpu_stop.patch
 0003-scheduler-replace-migration_thread-with-cpu_stop.patch
 0004-scheduler-kill-paranoia-check-in-synchronize_sched_e.patch

The patches are against the current linux-2.6-tip/sched/core
(99bd5e2f245d8cd17d040c82d40becdb3efd9b69) and are available in the
following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cpu_stop

diffstat follows.

 Documentation/RCU/torture.txt |   10 
 arch/s390/kernel/time.c       |    1 
 drivers/xen/manage.c          |   14 -
 include/linux/rcutiny.h       |    2 
 include/linux/rcutree.h       |    1 
 include/linux/stop_machine.h  |   59 ++--
 kernel/cpu.c                  |    8 
 kernel/module.c               |   14 -
 kernel/rcutorture.c           |    2 
 kernel/sched.c                |  271 +++------------------
 kernel/sched_fair.c           |   48 ++-
 kernel/stop_machine.c         |  530 ++++++++++++++++++++++++++++++++----------
 12 files changed, 525 insertions(+), 435 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/976691
