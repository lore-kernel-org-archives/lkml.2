Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab3AIQKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 11:10:40 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49744 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab3AIQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 11:10:39 -0500
Date: Wed, 9 Jan 2013 08:10:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: [GIT PULL] cfq blkcg hierarchy support
Message-ID: <20130109161034.GK3926@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Please consider pulling from the following branch to receive cfq blkcg
hierarchy support.  The branch is based on top of v3.8-rc2.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git blkcg-cfq-hierarchy

The patchset was reviewd in the following thread.

  http://thread.gmane.org/gmane.linux.kernel.cgroups/5571

Thanks.

----------------------------------------------------------------
Tejun Heo (19):
      blkcg: fix minor bug in blkg_alloc()
      blkcg: reorganize blkg_lookup_create() and friends
      blkcg: cosmetic updates to blkg_create()
      blkcg: make blkcg_gq's hierarchical
      cfq-iosched: add leaf_weight
      cfq-iosched: implement cfq_group->nr_active and ->children_weight
      cfq-iosched: implement hierarchy-ready cfq_group charge scaling
      cfq-iosched: convert cfq_group_slice() to use cfqg->vfraction
      cfq-iosched: enable full blkcg hierarchy support
      blkcg: add blkg_policy_data->plid
      blkcg: implement blkcg_policy->on/offline_pd_fn() and blkcg_gq->online
      blkcg: s/blkg_rwstat_sum()/blkg_rwstat_total()/
      blkcg: export __blkg_prfill_rwstat()
      blkcg: implement blkg_[rw]stat_recursive_sum() and blkg_[rw]stat_merge()
      block: RCU free request_queue
      blkcg: make blkcg_print_blkgs() grab q locks instead of blkcg lock
      cfq-iosched: separate out cfqg_stats_reset() from cfq_pd_reset_stats()
      cfq-iosched: collect stats from dead cfqgs
      cfq-iosched: add hierarchical cfq_group statistics

Vivek Goyal (6):
      cfq-iosched: Properly name all references to IO class
      cfq-iosched: More renaming to better represent wl_class and wl_type
      cfq-iosched: Rename "service_tree" to "st" at some places
      cfq-iosched: Rename few functions related to selecting workload
      cfq-iosched: Get rid of unnecessary local variable
      cfq-iosched: Print sync-noidle information in blktrace messages

 Documentation/block/cfq-iosched.txt        |  58 +++
 Documentation/cgroups/blkio-controller.txt |  35 +-
 block/blk-cgroup.c                         | 277 +++++++++++--
 block/blk-cgroup.h                         |  68 +++-
 block/blk-sysfs.c                          |   9 +-
 block/cfq-iosched.c                        | 627 +++++++++++++++++++++++------
 include/linux/blkdev.h                     |   2 +
 7 files changed, 902 insertions(+), 174 deletions(-)

-- 
tejun
