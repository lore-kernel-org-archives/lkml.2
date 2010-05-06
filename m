Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab0EFQxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:53:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:40678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341Ab0EFQxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:53:16 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: [GIT PULL sched/core] cpu_stop: implement and use cpu_stop, take#3
Date: Thu,  6 May 2010 18:52:47 +0200
Message-Id: <1273164772-19149-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 16:52:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Please pull from the following branch to receive cpu_stop patches.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cpu_stop

Adding mb()'s in synchronize_sched_expedited() is the only change
since the last take[2].  Both Peter and Paul have acked the patchset.
I'll post the patchset as replies to this message.

This patchset is on top of the current sched/core (99bd5e2f) and
contains the following changes.

Paul E. McKenney (1):
      scheduler: correctly place paranioa memory barriers in synchronize_sched_expedited()

Tejun Heo (4):
      cpu_stop: implement stop_cpu[s]()
      stop_machine: reimplement using cpu_stop
      scheduler: replace migration_thread with cpu_stop
      scheduler: kill paranoia check in synchronize_sched_expedited()

 Documentation/RCU/torture.txt |   10 -
 arch/s390/kernel/time.c       |    1 -
 drivers/xen/manage.c          |   14 +-
 include/linux/rcutiny.h       |    2 -
 include/linux/rcutree.h       |    1 -
 include/linux/stop_machine.h  |   59 +++--
 kernel/cpu.c                  |    8 -
 kernel/module.c               |   14 +-
 kernel/rcutorture.c           |    2 +-
 kernel/sched.c                |  284 +++++-----------------
 kernel/sched_fair.c           |   48 +++-
 kernel/stop_machine.c         |  530 +++++++++++++++++++++++++++++++----------
 12 files changed, 538 insertions(+), 435 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/980893
