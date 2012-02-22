Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2BVBrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:47:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2BVBrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:47:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.129.105 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: [PATCHSET] blkcg: accumulated blkcg updates
Date: Tue, 21 Feb 2012 17:46:27 -0800
Message-Id: <1329875223-5102-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

This is accumulation of the following three patchsets on top of
block/for-linus - 621032ad6e "block: exit_io_context() should call
elevator_exit_icq_fn()".

[1] blkcg: kill policy node and blkg->dev, take#4
[2] blkcg: unify blkgs for different policies
[3] blkcg: update locking and fix stacking

This patchset collects all three patchset into single series with all
the updated versions of patches included.  There are also some minor
changes for build fixes and typos.  Please refer to patch descriptions
of each patchset for further details.

This patchset contains the following 36 patches.

  0001-block-blk-throttle-should-be-drained-regardless-of-q.patch
  0002-blkcg-make-CONFIG_BLK_CGROUP-bool.patch
  0003-cfq-don-t-register-propio-policy-if-CONFIG_CFQ_GROUP.patch
  0004-elevator-clear-auxiliary-data-earlier-during-elevato.patch
  0005-elevator-make-elevator_init_fn-return-0-errno.patch
  0006-block-implement-blk_queue_bypass_start-end.patch
  0007-block-extend-queue-bypassing-to-cover-blkcg-policies.patch
  0008-blkcg-shoot-down-blkio_groups-on-elevator-switch.patch
  0009-blkcg-move-rcu_read_lock-outside-of-blkio_group-get-.patch
  0010-blkcg-update-blkg-get-functions-take-blkio_cgroup-as.patch
  0011-blkcg-use-q-and-plid-instead-of-opaque-void-for-blki.patch
  0012-blkcg-add-blkio_policy-array-and-allow-one-policy-pe.patch
  0013-blkcg-use-the-usual-get-blkg-path-for-root-blkio_gro.patch
  0014-blkcg-factor-out-blkio_group-creation.patch
  0015-blkcg-don-t-allow-or-retain-configuration-of-missing.patch
  0016-blkcg-kill-blkio_policy_node.patch
  0017-blkcg-kill-the-mind-bending-blkg-dev.patch

  0018-blkcg-let-blkio_group-point-to-blkio_cgroup-directly.patch
  0019-blkcg-add-blkcg_-init-drain-exit-_queue.patch
  0020-blkcg-clear-all-request_queues-on-blkcg-policy-un-re.patch
  0021-blkcg-let-blkcg-core-handle-policy-private-data-allo.patch
  0022-blkcg-move-refcnt-to-blkcg-core.patch
  0023-blkcg-make-blkg-pd-an-array-and-move-configuration-a.patch
  0024-blkcg-don-t-use-blkg-plid-in-stat-related-functions.patch
  0025-blkcg-move-per-queue-blkg-list-heads-and-counters-to.patch
  0026-blkcg-let-blkcg-core-manage-per-queue-blkg-list-and-.patch
  0027-blkcg-unify-blkg-s-for-blkcg-policies.patch
  0028-blkcg-use-double-locking-instead-of-RCU-for-blkg-syn.patch
  0029-blkcg-drop-unnecessary-RCU-locking.patch

  0030-block-restructure-get_request.patch
  0031-block-interface-update-for-ioc-icq-creation-function.patch
  0032-block-ioc_task_link-can-t-fail.patch
  0033-block-add-io_context-active_ref.patch
  0034-block-implement-bio_associate_current.patch
  0035-block-make-block-cgroup-policies-follow-bio-task-ass.patch
  0036-block-make-blk-throttle-preserve-the-issuing-task-on.patch

0001-0017 kill policy node and blkg->dev and also available in the
following git branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-kill-pn

0018-0029 unify blkgs for different policies and update locking.  Note
that 0028 and 0029 belonged to the third patchset in the original
posting.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-unified-blkg

0030-0036 fix stacking of blkcg policies.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git blkcg-stacking

Thank you.

diffstat follows.

 block/Kconfig.iosched     |    4 
 block/blk-cgroup.c        | 1258 ++++++++++++++++++++++++----------------------
 block/blk-cgroup.h        |  286 ++++++----
 block/blk-core.c          |  179 ++++--
 block/blk-ioc.c           |   58 +-
 block/blk-sysfs.c         |    6 
 block/blk-throttle.c      |  450 +++-------------
 block/blk.h               |   32 -
 block/cfq-iosched.c       |  509 +++++-------------
 block/cfq.h               |  113 ++--
 block/deadline-iosched.c  |    8 
 block/elevator.c          |  123 +---
 block/noop-iosched.c      |    8 
 fs/bio.c                  |   61 ++
 include/linux/bio.h       |    8 
 include/linux/blk_types.h |   10 
 include/linux/blkdev.h    |   12 
 include/linux/elevator.h  |    8 
 include/linux/iocontext.h |   32 -
 init/Kconfig              |    2 
 kernel/fork.c             |    5 
 21 files changed, 1521 insertions(+), 1651 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1247152
[2] http://thread.gmane.org/gmane.linux.kernel/1247287
[3] http://thread.gmane.org/gmane.linux.kernel/1254428
