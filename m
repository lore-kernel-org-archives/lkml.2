Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2J3N0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:26:07 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:51291 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158Ab2J3N0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:26:05 -0400
X-ASG-Debug-ID: 1351603564-0421b562ecb5c90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <508FD55C.2070601@fusionio.com>
Date: Tue, 30 Oct 2012 14:25:48 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block driver bits for 3.7
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block driver bits for 3.7
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1351603564
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.112795
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Distilled down variant, the rest will pass over to 3.8. I pulled it into
the for-linus branch I had waiting for a pull request as well, in case
you are wondering why there are new entries in here too. This also got
rid of two reverts and the ones of the mtip32xx patches that went in
later in the 3.6 cycle, so the series looks a bit cleaner.

Please pull!

  git://git.kernel.dk/linux-block.git for-linus

Akinobu Mita (1):
      cciss: select CONFIG_CHECK_SIGNATURE

Anna Leuschner (1):
      vfs: fix: don't increase bio_slab_max if krealloc() fails

Dave Chinner (1):
      loop: Make explicit loop device destruction lazy

Herton Ronaldo Krzesinski (5):
      floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
      floppy: do put_disk on current dr if blk_init_queue fails
      floppy: properly handle failure on add_disk loop
      floppy: use common function to check if floppies can be registered
      floppy: remove dr, reuse drive on do_floppy_init

Jianpeng Ma (1):
      block: Add blk_rq_pos(rq) to sort rq when plushing

Jiri Kosina (1):
      pktcdvd: update MAINTAINERS

Jun'ichi Nomura (2):
      blkcg: Fix use-after-free of q->root_blkg and q->root_rl.blkg
      blkcg: stop iteration early if root_rl is the only request list

Kees Cook (2):
      block: remove CONFIG_EXPERIMENTAL
      drivers/block: remove CONFIG_EXPERIMENTAL

Konrad Rzeszutek Wilk (1):
      xen/blkback: Fix compile warning

Oliver Chick (1):
      xen/blkback: Change xen_vbd's flush_support and discard_secure to have type unsigned int, rather than bool

Selvan Mani (1):
      mtip32xx:Added appropriate timeout value for secure erase

Wei Yongjun (2):
      xen/blkback: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
      cciss: remove unneeded memset()

 MAINTAINERS                        |  2 +-
 block/Kconfig                      |  2 +-
 block/blk-cgroup.c                 | 10 +++++
 block/blk-core.c                   |  3 +-
 drivers/block/Kconfig              | 15 ++++---
 drivers/block/cciss.c              |  1 -
 drivers/block/floppy.c             | 90 ++++++++++++++++++++------------------
 drivers/block/loop.c               | 17 ++++++-
 drivers/block/mtip32xx/mtip32xx.c  | 19 ++++++--
 drivers/block/mtip32xx/mtip32xx.h  |  3 ++
 drivers/block/xen-blkback/common.h |  4 +-
 drivers/block/xen-blkback/xenbus.c |  9 ++--
 fs/bio.c                           |  6 ++-
 13 files changed, 113 insertions(+), 68 deletions(-)

-- 
Jens Axboe

