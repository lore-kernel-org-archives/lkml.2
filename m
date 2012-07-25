Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2GYAGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:06:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50105 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2GYAFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:05:43 -0400
Date: Tue, 24 Jul 2012 17:05:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue changes for v3.6-rc1
Message-ID: <20120725000538.GE5776@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive workqueue changes for
v3.6-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.6

There are three major changes.

* WQ_HIGHPRI has been reimplemented so that high priority work items
  are served by worker threads with -20 nice value from dedicated
  highpri worker pools.

* CPU hotplug support has been reimplemented such that idle workers
  are kept across CPU hotplug events.  This makes CPU hotplug cheaper
  (for PM) and makes the code simpler.

* flush_kthread_work() has been reimplemented so that a work item can
  be freed while executing.  This removes an annoying behavior
  difference between kthread_worker and workqueue.

Thanks.

Tejun Heo (18):
      workqueue: don't use WQ_HIGHPRI for unbound workqueues
      workqueue: factor out worker_pool from global_cwq
      workqueue: use @pool instead of @gcwq or @cpu where applicable
      workqueue: separate out worker_pool flags
      workqueue: introduce NR_WORKER_POOLS and for_each_worker_pool()
      workqueue: reimplement WQ_HIGHPRI using a separate worker_pool
      workqueue: perform cpu down operations from low priority cpu_notifier()
      workqueue: drop CPU_DYING notifier operation
      workqueue: ROGUE workers are UNBOUND workers
      workqueue: use mutex for global_cwq manager exclusion
      workqueue: drop @bind from create_worker()
      workqueue: reimplement CPU online rebinding to handle idle workers
      workqueue: don't butcher idle workers on an offline CPU
      workqueue: remove CPU offline trustee
      workqueue: simplify CPU hotplug code
      kthread_worker: reorganize to prepare for flush_kthread_work() reimplementation
      kthread_worker: reimplement flush_kthread_work() to allow freeing the work item being executed
      workqueue: fix spurious CPU locality WARN from process_one_work()

 Documentation/workqueue.txt      |  103 ++---
 include/linux/cpu.h              |    5 +-
 include/linux/kthread.h          |    8 +-
 include/trace/events/workqueue.h |    2 +-
 kernel/kthread.c                 |   88 ++--
 kernel/workqueue.c               | 1144 ++++++++++++++++++--------------------
 6 files changed, 628 insertions(+), 722 deletions(-)

--
tejun
