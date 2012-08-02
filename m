Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2HBGYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab2HBGYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:24:16 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Shaohua Li <shli@kernel.org>,
        Tejun Heo <tj@kernel.org>, virtualization@lists.linux-foundation.org
Subject: [PATCH V5 0/4] Improve virtio-blk performance
Date: Thu,  2 Aug 2012 14:25:52 +0800
Message-Id: <1343888757-25723-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

This version added REQ_FLUSH and REQ_FUA support as suggested by Christoph and
rebased against latest linus's tree. 

Jens, could you please consider picking up the dependencies 1/4 and 2/4 in your
tree. Thanks!

This patchset implements bio-based IO path for virito-blk to improve
performance.

Fio test shows bio-based IO path gives the following performance improvement:

1) Ramdisk device
     With bio-based IO path, sequential read/write, random read/write
     IOPS boost         : 28%, 24%, 21%, 16%
     Latency improvement: 32%, 17%, 21%, 16%
2) Fusion IO device
     With bio-based IO path, sequential read/write, random read/write
     IOPS boost         : 11%, 11%, 13%, 10%
     Latency improvement: 10%, 10%, 12%, 10%

Asias He (4):
  block: Introduce __blk_segment_map_sg() helper
  block: Add blk_bio_map_sg() helper
  virtio-blk: Add bio-based IO path for virtio-blk
  virtio-blk: Add REQ_FLUSH and REQ_FUA support to bio path

 block/blk-merge.c          | 117 +++++++++++++------
 drivers/block/virtio_blk.c | 279 ++++++++++++++++++++++++++++++++++++++-------
 include/linux/blkdev.h     |   2 +
 3 files changed, 324 insertions(+), 74 deletions(-)

-- 
1.7.11.2

