Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2HAMM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:12:56 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:51952 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab2HAMMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:12:55 -0400
X-ASG-Debug-ID: 1343823174-0421b5402c4c500001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50191D3F.3050308@fusionio.com>
Date: Wed, 1 Aug 2012 14:12:47 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Neil Brown <neilb@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block IO core bits for 3.6
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Block IO core bits for 3.6
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1343823174
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.104368
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Later than usual, your merge window coincided with my vacation. I'm sure
we both agree that this should never ever happen again. Kthx.

The most complicated part if this is the request allocation rework by
Tejun, which has been queued up for a long time and has been in for-next
ditto as well. There are a few commits from yesterday and today, mostly
trivial and obvious fixes. So I'm pretty confident that it is sound.
It's also smaller than usual.

It auto-merges directly into current master, so you should have no
trouble with conflict resolutions.

Please pull:

  git://git.kernel.dk/linux-block.git for-3.6/core

Mike Snitzer (1):
      block: do not artificially constrain max_sectors for stacking drivers

Olof Johansson (1):
      block: uninitialized ioc->nr_tasks triggers WARN_ON

Tejun Heo (10):
      blkcg: __blkg_lookup_create() doesn't need radix preload
      blkcg: make root blkcg allocation use %GFP_KERNEL
      mempool: add @gfp_mask to mempool_create_node()
      block: drop custom queue draining used by scsi_transport_{iscsi|fc}
      block: refactor get_request[_wait]()
      block: allocate io_context upfront
      blkcg: inline bio_blkcg() and friends
      block: add q->nr_rqs[] and move q->rq.elvpriv to q->nr_rqs_elvpriv
      block: prepare for multiple request_lists
      blkcg: implement per-blkg request allocation

Vivek Goyal (1):
      block: add partition resize function to blkpg ioctl

Yuanhan Liu (1):
      block: remove dead func declaration

 Documentation/block/queue-sysfs.txt |   7 ++
 block/blk-cgroup.c                  | 139 +++++++++++++++---------
 block/blk-cgroup.h                  | 128 +++++++++++++++++++++-
 block/blk-core.c                    | 209 +++++++++++++++++++-----------------
 block/blk-ioc.c                     |   1 +
 block/blk-settings.c                |   3 +-
 block/blk-sysfs.c                   |  34 +++---
 block/blk-throttle.c                |   3 -
 block/blk.h                         |   4 +-
 block/bsg-lib.c                     |  53 ---------
 block/genhd.c                       |  20 +++-
 block/ioctl.c                       |  59 +++++++++-
 block/partition-generic.c           |   4 +-
 drivers/scsi/scsi_transport_fc.c    |  38 -------
 drivers/scsi/scsi_transport_iscsi.c |   2 +-
 include/linux/blkdev.h              |  53 +++++----
 include/linux/blkpg.h               |   1 +
 include/linux/bsg-lib.h             |   1 -
 include/linux/genhd.h               |  57 ++++++++++
 include/linux/mempool.h             |   3 +-
 mm/mempool.c                        |  12 ++-
 21 files changed, 530 insertions(+), 301 deletions(-)

-- 
Jens Axboe

