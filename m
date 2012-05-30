Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2E3Mv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:51:27 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:38672 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab2E3MvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:51:25 -0400
X-ASG-Debug-ID: 1338382284-03d6a5030e1cd30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FC61799.9030309@fusionio.com>
Date: Wed, 30 May 2012 14:50:33 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block/IO core bits for 3.5
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Block/IO core bits for 3.5
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1338382284
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.27
X-Barracuda-Spam-Status: No, SCORE=-1.27 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE_7580G
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.98436
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.75 BSF_RULE_7580G         Custom Rule 7580G
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the main 3.5 block/IO core pull request for 3.5. This is
a bit bigger on the core side than usual, but that is purely because
we decided to hold off on parts of Tejun's submission on 3.4 to give
it a bit more time to simmer. As a consequence, it's seen a long
cycle in for-next.

It contains:

- Bug fix from Dan, wrong locking type.
- Relax splice gifting restriction from Eric.
- A ton of updates from Tejun, primarily for blkcg. This improves
  the code a lot, making the API nicer and cleaner, and also includes
  fixes for how we handle and tie policies and re-activate on switches.
  The changes also include generic bug fixes.
- A simple fix from Vivek, along with a fix for doing proper delayed
  allocation of the blkcg stats.

Please pull.

  git://git.kernel.dk/linux-block.git for-3.5/core

for you to fetch changes up to ff26eaadf4d914e397872b99885d45756104e9ae:

  blkcg: tg_stats_alloc_lock is an irq lock (2012-05-23 12:16:21 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      blkcg: change a spin_lock() to spin_lock_irq()

Eric Dumazet (1):
      vmsplice: relax alignement requirements for SPLICE_F_GIFT

Jens Axboe (1):
      Merge tag 'v3.4-rc5' into for-3.5/core

Tejun Heo (89):
      block: blk-throttle should be drained regardless of q->elevator
      blkcg: make CONFIG_BLK_CGROUP bool
      cfq: don't register propio policy if !CONFIG_CFQ_GROUP_IOSCHED
      elevator: clear auxiliary data earlier during elevator switch
      elevator: make elevator_init_fn() return 0/-errno
      block: implement blk_queue_bypass_start/end()
      block: extend queue bypassing to cover blkcg policies
      blkcg: shoot down blkio_groups on elevator switch
      blkcg: move rcu_read_lock() outside of blkio_group get functions
      blkcg: update blkg get functions take blkio_cgroup as parameter
      blkcg: use q and plid instead of opaque void * for blkio_group association
      blkcg: add blkio_policy[] array and allow one policy per policy ID
      blkcg: use the usual get blkg path for root blkio_group
      blkcg: factor out blkio_group creation
      blkcg: don't allow or retain configuration of missing devices
      blkcg: kill blkio_policy_node
      blkcg: kill the mind-bending blkg->dev
      blkcg: let blkio_group point to blkio_cgroup directly
      blkcg: add blkcg_{init|drain|exit}_queue()
      blkcg: clear all request_queues on blkcg policy [un]registrations
      blkcg: let blkcg core handle policy private data allocation
      blkcg: move refcnt to blkcg core
      blkcg: make blkg->pd an array and move configuration and stats into it
      blkcg: don't use blkg->plid in stat related functions
      blkcg: move per-queue blkg list heads and counters to queue and blkg
      blkcg: let blkcg core manage per-queue blkg list and counter
      blkcg: unify blkg's for blkcg policies
      blkcg: use double locking instead of RCU for blkg synchronization
      blkcg: drop unnecessary RCU locking
      block: restructure get_request()
      block: interface update for ioc/icq creation functions
      block: ioc_task_link() can't fail
      block: add io_context->active_ref
      block: implement bio_associate_current()
      block: make block cgroup policies follow bio task association
      block: make blk-throttle preserve the issuing task on delayed bios
      blkcg: don't use percpu for merged stats
      blkcg: simplify stat reset
      blkcg: restructure blkio_get_stat()
      blkcg: remove blkio_group->stats_lock
      blkcg: add blkcg->id
      cfq: pass around cfq_io_cq instead of io_context
      cfq: don't use icq_get_changed()
      block: remove ioc_*_changed()
      cfq: fix cfqg ref handling when BLK_CGROUP && !CFQ_GROUP_IOSCHED
      Merge branch 'for-3.5' of ../cgroup into block/for-3.5/core-merged
      blkcg: remove unused @pol and @plid parameters
      blkcg: BLKIO_STAT_CPU_SECTORS doesn't have subcounters
      blkcg: introduce blkg_stat and blkg_rwstat
      blkcg: restructure statistics printing
      blkcg: drop blkiocg_file_write_u64()
      blkcg: restructure configuration printing
      blkcg: restructure blkio_group configruation setting
      blkcg: simplify blkg_conf_prep()
      blkcg: export conf/stat helpers to prepare for reorganization
      blkcg: implement blkio_policy_type->cftypes
      blkcg: move conf/stat file handling code to policies
      cfq: collapse cfq.h into cfq-iosched.c
      blkcg: move statistics update code to policies
      blkcg: cfq doesn't need per-cpu dispatch stats
      blkcg: add blkio_policy_ops operations for exit and stat reset
      blkcg: move blkio_group_stats to cfq-iosched.c
      blkcg: move blkio_group_stats_cpu and friends to blk-throttle.c
      blkcg: move blkio_group_conf->weight to cfq
      blkcg: move blkio_group_conf->iops and ->bps to blk-throttle
      blkcg: pass around pd->pdata instead of pd itself in prfill functions
      blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros
      cfq: fix build breakage & warnings
      blkcg: kill blkio_list and replace blkio_list_lock with a mutex
      blkcg: use @pol instead of @plid in update_root_blkg_pd() and blkcg_print_blkgs()
      blkcg: remove static policy ID enums
      blkcg: make blkg_conf_prep() take @pol and return with queue lock held
      blkcg: make sure blkg_lookup() returns %NULL if @q is bypassing
      blkcg: make request_queue bypassing on allocation
      blkcg: add request_queue->root_blkg
      blkcg: implement per-queue policy activation
      blkcg: drop stuff unused after per-queue policy activation update
      blkcg: shoot down blkgs if all policies are deactivated
      blkcg: blkg_rwstat_read() was missing inline
      blkcg: remove blkio_group->path[]
      blkcg: style cleanups for blk-cgroup.h
      blkcg: mass rename of blkcg API
      blkcg: embed struct blkg_policy_data in policy specific data
      blkcg: collapse blkcg_policy_ops into blkcg_policy
      block: collapse blk_alloc_request() into get_request()
      block: fix elvpriv allocation failure handling
      blkcg: fix blkcg->css ref leak in __blkg_lookup_create()
      blkcg: use radix tree to index blkgs from blkcg
      blkcg: tg_stats_alloc_lock is an irq lock

Vivek Goyal (2):
      blkcg: skip blkg printing if q isn't associated with disk
      blkcg: alloc per cpu stats from worker thread in a delayed manner

 Documentation/feature-removal-schedule.txt |    9 +
 block/Kconfig.iosched                      |    4 -
 block/blk-cgroup.c                         | 2109 +++++++++-------------------
 block/blk-cgroup.h                         |  647 ++++-----
 block/blk-core.c                           |  281 ++--
 block/blk-ioc.c                            |  126 +-
 block/blk-sysfs.c                          |    6 +-
 block/blk-throttle.c                       |  697 +++++----
 block/blk.h                                |   32 +-
 block/cfq-iosched.c                        | 1072 +++++++++-----
 block/cfq.h                                |  115 --
 block/deadline-iosched.c                   |    8 +-
 block/elevator.c                           |  121 +-
 block/noop-iosched.c                       |    8 +-
 fs/bio.c                                   |   61 +
 fs/ioprio.c                                |    2 +-
 fs/splice.c                                |    4 +-
 include/linux/bio.h                        |    8 +
 include/linux/blk_types.h                  |   10 +
 include/linux/blkdev.h                     |   20 +-
 include/linux/cgroup.h                     |   80 +-
 include/linux/elevator.h                   |    8 +-
 include/linux/iocontext.h                  |   39 +-
 include/linux/ioprio.h                     |   22 +-
 init/Kconfig                               |    2 +-
 kernel/cgroup.c                            |  550 ++++++--
 kernel/cgroup_freezer.c                    |   11 +-
 kernel/cpuset.c                            |   31 +-
 kernel/fork.c                              |    5 +-
 kernel/sched/core.c                        |   16 +-
 mm/memcontrol.c                            |   78 +-
 net/core/netprio_cgroup.c                  |   30 +-
 net/ipv4/tcp_memcontrol.c                  |   71 +-
 net/sched/cls_cgroup.c                     |   31 +-
 security/device_cgroup.c                   |   10 +-
 35 files changed, 3033 insertions(+), 3291 deletions(-)
 delete mode 100644 block/cfq.h

-- 
Jens Axboe

