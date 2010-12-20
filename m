Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab0LTOMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:12:43 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:47996 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112Ab0LTOMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:12:42 -0500
X-ASG-Debug-ID: 1292854360-2c9de5330001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D0F643B.7030804@fusionio.com>
Date: Mon, 20 Dec 2010 15:12:11 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Final block bits for 2.6.37
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Final block bits for 2.6.37
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292854360
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0556 1.0000 -1.6647
X-Barracuda-Spam-Score: -1.66
X-Barracuda-Spam-Status: No, SCORE=-1.66 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.49984
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This little christmas bundle has been collected over the
last 2-3 weeks and represent the final block fixes for
2.6.37 unless a critical issue shows up.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-linus

Lars Ellenberg (2):
      drbd: don't recvmsg with zero length
      drbd: fix for spin_lock_irqsave in endio callback

Martin K. Petersen (1):
      block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead

Mike Snitzer (1):
      block: max hardware sectors limit wrapper

Stephen M. Cameron (1):
      cciss: fix cciss_revalidate panic

Vivek Goyal (2):
      blk-throttle: Trim/adjust slice_end once a bio has been dispatched
      blk-throttle: Correct the placement of smp_rmb()

Xiaotian Feng (1):
      block: check for proper length of iov entries earlier in blk_rq_map_user_iov()

 block/blk-map.c                    |    5 ++-
 block/blk-merge.c                  |    6 ++--
 block/blk-settings.c               |   51 +++++++++++++++--------------------
 block/blk-sysfs.c                  |    2 +-
 block/blk-throttle.c               |   39 +++++++++++++++++----------
 drivers/block/cciss.c              |    2 +
 drivers/block/drbd/drbd_receiver.c |   14 +++++----
 drivers/block/drbd/drbd_req.h      |    3 +-
 drivers/block/drbd/drbd_worker.c   |   10 ++++++-
 drivers/md/dm-table.c              |   10 +-----
 drivers/md/md.c                    |    3 --
 drivers/scsi/scsi_lib.c            |    3 +-
 include/linux/blkdev.h             |   10 +++++--
 13 files changed, 85 insertions(+), 73 deletions(-)


-- 
Jens Axboe

