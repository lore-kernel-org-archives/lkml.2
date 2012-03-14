Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2CNOiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:38:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:57384 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2CNOiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:38:10 -0400
Message-ID: <4F60AD2B.3040702@kernel.dk>
Date: Wed, 14 Mar 2012 15:37:31 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 3.3 final
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Been sitting on this for a while, but lets get this out the door.
This fixes various important bugs for 3.3 final, along with a few more
trivial ones. Please pull!


  git://git.kernel.dk/linux-block.git for-linus


Alan Stern (1):
      Block: use a freezable workqueue for disk-event polling

Dan Carpenter (1):
      block, sx8: fix pointer math issue getting fw version

Danny Kukawka (2):
      drivers/block/DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare warning
      drivers/block/DAC960: fix -Wuninitialized warning

Jun'ichi Nomura (1):
      block: Fix NULL pointer dereference in sd_revalidate_disk

Muthukumar R (1):
      block: Fix setting bio flags in drivers (sd_dif/floppy)

Stanislaw Gruszka (1):
      block: fix __blkdev_get and add_disk race condition

Tejun Heo (3):
      block: replace icq->changed with icq->flags
      block: simplify ioc_release_fn()
      block: exit_io_context() should call elevator_exit_icq_fn()

Xiaotian Feng (1):
      block: fix ioc leak in put_io_context

 block/blk-ioc.c           |  135 +++++++++++++++++++++++++++++----------------
 block/cfq-iosched.c       |   12 ++--
 block/genhd.c             |   42 ++++++++------
 block/partition-generic.c |   48 +++++++++++++---
 drivers/block/DAC960.c    |   18 +++---
 drivers/block/floppy.c    |    2 +-
 drivers/block/sx8.c       |    2 +-
 drivers/scsi/sd_dif.c     |    2 +-
 fs/block_dev.c            |   16 ++++--
 include/linux/genhd.h     |    1 +
 include/linux/iocontext.h |   10 +++-
 include/linux/workqueue.h |    4 ++
 kernel/workqueue.c        |    7 ++-
 13 files changed, 201 insertions(+), 98 deletions(-)

-- 
Jens Axboe

