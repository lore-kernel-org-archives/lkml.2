Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab0EMKtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:49:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:60622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758632Ab0EMKtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:49:17 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHSET sched/core] sched: prepare for cmwq
Date: Thu, 13 May 2010 12:48:21 +0200
Message-Id: <1273747705-7829-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 10:48:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo, Peter.

These four patches are the scheduler modifications necessary for cmwq
and contains the following four patches.

 0001-sched-consult-online-mask-instead-of-active-in-selec.patch
 0002-sched-implement-__set_cpus_allowed.patch
 0003-sched-refactor-try_to_wake_up.patch
 0004-sched-add-hooks-for-workqueue.patch

The first three have been posted multiple times as part of cmwq
patchset multiple times.  Other than description updates to explain
why they are needed, these three patches haven't changed from the last
posting[L].

The last patch adds two hardcoded workqueue hooks as suggested in in
the unify-tracers-in-sched thread[U].  These new hardcoded hooks are
much simpler and no scheduler behavior change is leaked outside of
sched.c.  Workqueue workers are marked with PF_WQ_WORKER and hooks are
called only for them.  Instead of exporting try_to_wake_up_local(),
the sleeping hook now returns a pointer to local task which is woken
up by scheduler.  The hooks are defined as noop for now and will be
filled later by cmwq implementation.

The change from sched_notifier to the hardcoded hooks doesn't make any
notable difference to cmwq implementation itself.

This patchset is available in the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git sched-wq

and contains the following changes.

 include/linux/sched.h    |   15 ++-
 kernel/fork.c            |    2 
 kernel/sched.c           |  191 +++++++++++++++++++++++++++++++++--------------
 kernel/workqueue_sched.h |   16 +++
 4 files changed, 163 insertions(+), 61 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/954759
[U] http://thread.gmane.org/gmane.linux.kernel/980857
