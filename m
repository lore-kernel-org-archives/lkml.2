Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0GCIqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 04:46:46 -0400
Received: from sh.osrg.net ([192.16.179.4]:47304 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab0GCIqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 04:46:43 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: axboe@kernel.dk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/9] remove q->prepare_flush_fn hook
Date: Sat,  3 Jul 2010 17:45:31 +0900
Message-Id: <1278146740-8731-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 03 Jul 2010 17:46:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes q->prepare_flush_fn. Except for ide and scsi, all the
users just mark flush requests. They can use REQ_FLUSH flag
instead.

SCSI and ide can use q->prep_rq_fn to build flush requests.

This can be applied to the block's for-2.6.36.

=
 block/blk-barrier.c          |   14 +---------
 drivers/block/brd.c          |    2 +-
 drivers/block/loop.c         |    2 +-
 drivers/block/osdblk.c       |   12 +--------
 drivers/block/ps3disk.c      |   25 +++++---------------
 drivers/block/virtio_blk.c   |   52 +++++++++++++++++------------------------
 drivers/block/xen-blkfront.c |    3 +-
 drivers/ide/ide-disk.c       |   16 +++++++++----
 drivers/md/dm.c              |   16 +-----------
 drivers/mmc/card/queue.c     |    2 +-
 drivers/s390/block/dasd.c    |    2 +-
 drivers/scsi/sd.c            |   26 +++++++++++++--------
 include/linux/bio.h          |    2 +
 include/linux/blkdev.h       |    4 +--
 14 files changed, 69 insertions(+), 109 deletions(-)

