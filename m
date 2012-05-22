Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810Ab2EVRQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:16:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55044 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab2EVRQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:16:37 -0400
Date: Tue, 22 May 2012 10:16:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue changes for 3.5-rc1
Message-ID: <20120522171631.GE14339@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive workqueue changes for
3.5-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.5

Nothing exciting.  Most are updates to debug stuff and related fixes.
Two not-too-critical bugs are fixed - WARN_ON() triggering spurious
during cpu offlining and unlikely lockdep related oops.

Thanks.

Dan Carpenter (1):
      workqueue: change BUG_ON() to WARN_ON()

Peter Zijlstra (1):
      lockdep: fix oops in processing workqueue

Stephen Boyd (2):
      trace: Remove unused workqueue tracer
      workqueue: Catch more locking problems with flush_work()

Tejun Heo (1):
      workqueue: skip nr_running sanity check in worker_enter_idle() if trustee is active

 include/linux/lockdep.h        |   18 +++
 kernel/timer.c                 |    4 +-
 kernel/trace/Makefile          |    1 -
 kernel/trace/trace_workqueue.c |  300 ----------------------------------------
 kernel/workqueue.c             |   21 +++-
 5 files changed, 38 insertions(+), 306 deletions(-)
 delete mode 100644 kernel/trace/trace_workqueue.c

--
tejun
