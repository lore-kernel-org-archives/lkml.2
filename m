Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab2HHIFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:05:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab2HHIFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:05:09 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Shaohua Li <shli@kernel.org>,
        Tejun Heo <tj@kernel.org>, virtualization@lists.linux-foundation.org
Subject: [PATCH V7 0/2] Improve virtio-blk performance
Date: Wed,  8 Aug 2012 16:07:03 +0800
Message-Id: <1344413225-1843-1-git-send-email-asias@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Changes in v7:
- Using vbr->flags to trace request type
- Dropped unnecessary struct virtio_blk *vblk parameter
- Reuse struct virtblk_req in bio done function
- Added performance data on normal SATA device and the reason why make it optional

Fio test shows bio-based IO path gives the following performance improvement:

1) Ramdisk device
     With bio-based IO path, sequential read/write, random read/write
     IOPS boost         : 28%, 24%, 21%, 16%
     Latency improvement: 32%, 17%, 21%, 16%
2) Fusion IO device
     With bio-based IO path, sequential read/write, random read/write
     IOPS boost         : 11%, 11%, 13%, 10%
     Latency improvement: 10%, 10%, 12%, 10%
3) Normal SATA device
     With bio-based IO path, sequential read/write, random read/write
     IOPS boost         : -10%, -10%, 4.4%, 0.5%
     Latency improvement: -12%, -15%, 2.5%, 0.8%

Asias He (2):
  virtio-blk: Add bio-based IO path for virtio-blk
  virtio-blk: Add REQ_FLUSH and REQ_FUA support to bio path

 drivers/block/virtio_blk.c | 301 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 264 insertions(+), 37 deletions(-)

-- 
1.7.11.2

