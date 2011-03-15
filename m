Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab1COKS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 06:18:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44268 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab1COKSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 06:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=miHrbEf7+AHgmlRi+DOj1D3Ks3PcB2rzbqdX4PT8H7ObWt6fbeqtcmpbpOZ3OQasBG
         lUiQ3PrmkU12KDZOkyXo4ZVpJ7l2wwrGt/EIZa9wTHPtJ6SOfw9O50FXZ0Olf/V2SRPG
         QQrP03UT4wbZqTYrXcSm6UmVzQ1ll+JeYzwsw=
Date: Tue, 15 Mar 2011 11:18:47 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue: changes for 2.6.39-rc1
Message-ID: <20110315101847.GG8635@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following git branch to receive workqueue changes
for 2.6.39-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-2.6.39

Nothing too important.  Other than addition of system_freezable_wq and
some cosmetic changes, there's no change to workqueue code itself.
All other changes are updates to the various workqueue users so that
they better utilize the new features and move away from the old APIs.

Most of flush_scheduled_work() and create_workqueue() users have been
converted and I'm planning on deprecating and/or removing them in the
opening devel cycle.  create_singlethread_workqueue() is the next but
that's gonna take some more time.

Thanks.

Tejun Heo (21):
      workqueue: use WQ_MEM_RECLAIM instead of WQ_RESCUER
      arm/omap: use system_wq in mailbox
      wireless/ipw2x00: use system_wq instead of dedicated workqueues
      cpufreq: use system_wq instead of dedicated workqueues
      input/tps6507x-ts: use system_wq instead of dedicated workqueue
      fs/aio: aio_wq isn't used in memory reclaim path
      acpi: kacpi*_wq don't need WQ_MEM_RECLAIM
      i2o: use alloc_workqueue() instead of create_workqueue()
      misc/iwmc3200top: use system_wq instead of dedicated workqueues
      scsi/be2iscsi,qla2xxx: convert to alloc_workqueue()
      scsi/scsi_tgt_lib: scsi_tgtd isn't used in memory reclaim path
      ext4: convert to alloc_workqueue()
      ocfs2: use system_wq instead of ocfs2_quota_wq
      reiserfs: make commit_wq use the default concurrency level
      xfs: convert to alloc_workqueue()
      net/9p: use system_wq instead of p9_mux_wq
      net/9p: replace p9_poll_task with a work
      rds/ib: use system_wq instead of rds_ib_fmr_wq
      workqueue: add system_freezeable_wq
      Merge branch 'master' into for-2.6.39
      workqueue: fix build failure introduced by s/freezeable/freezable/

 arch/arm/plat-omap/mailbox.c            |   10 +--
 drivers/acpi/osl.c                      |    6 +-
 drivers/cpufreq/cpufreq_conservative.c  |   22 +---
 drivers/cpufreq/cpufreq_ondemand.c      |   20 +---
 drivers/input/touchscreen/tps6507x-ts.c |   12 +--
 drivers/md/md.c                         |    2 +-
 drivers/message/i2o/driver.c            |    3 +-
 drivers/misc/iwmc3200top/iwmc3200top.h  |    4 +-
 drivers/misc/iwmc3200top/main.c         |   14 +--
 drivers/net/wireless/ipw2x00/ipw2100.c  |   70 +++++-------
 drivers/net/wireless/ipw2x00/ipw2100.h  |    1 -
 drivers/net/wireless/ipw2x00/ipw2200.c  |  196 ++++++++++++++-----------------
 drivers/net/wireless/ipw2x00/ipw2200.h  |    2 -
 drivers/scsi/be2iscsi/be_main.c         |    2 +-
 drivers/scsi/qla2xxx/qla_os.c           |    2 +-
 drivers/scsi/scsi_tgt_lib.c             |    2 +-
 fs/aio.c                                |    4 +-
 fs/ext4/super.c                         |    7 +-
 fs/nfs/inode.c                          |    2 +-
 fs/ocfs2/quota.h                        |    3 -
 fs/ocfs2/quota_global.c                 |   27 +----
 fs/ocfs2/super.c                        |    7 -
 fs/reiserfs/journal.c                   |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c              |    5 +-
 fs/xfs/xfs_mru_cache.c                  |    2 +-
 include/linux/workqueue.h               |    4 +
 kernel/workqueue.c                      |    6 +-
 net/9p/trans_fd.c                       |   52 ++------
 net/rds/ib.c                            |    9 +--
 net/rds/ib.h                            |    2 -
 net/rds/ib_rdma.c                       |   27 +----
 net/sunrpc/sched.c                      |    2 +-
 32 files changed, 190 insertions(+), 339 deletions(-)

-- 
tejun
