Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab1EYNHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:07:50 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:47582 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab1EYNHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:07:48 -0400
X-ASG-Debug-ID: 1306328867-03d6a50f5b25f10001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDCFF20.8070300@fusionio.com>
Date: Wed, 25 May 2011 15:07:44 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block driver updates for 2.6.40
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Block driver updates for 2.6.40
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306328867
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After the core bits, here are the drivers bits queued up
for 2.6.40.

- DRBD update

- Support for XEN blkback, a higher performance block device backend
  driver.

- cciss update

- A few good bug fixes for loop

- Rest is mostly little fixes, comment fixes, etc.


Please pull!


  git://git.kernel.dk/linux-2.6-block.git for-2.6.40/drivers

Andrew Morton (1):
      drbd: fix warning

Bart Van Assche (1):
      drbd: Fix spelling

Chris Lalancette (1):
      xen/blkback: Flush blkback data when connecting.

Ian Campbell (1):
      xen: rename blkbk module xen-blkback.

Jan Beulich (2):
      xen/blkback: simplify address translations
      xen/blkback: don't fail empty barrier requests

Jens Axboe (2):
      cciss: fix compile issue
      Merge branches 'for-jens/xen-backend-fixes' and 'for-jens/xen-blkback-v3.3' of git://git.kernel.org/.../konrad/xen into for-2.6.40/drivers

Jeremy Fitzhardinge (8):
      xen-blkback-porting
      xen/blkback: don't include xen/evtchn.h
      block: export blk_get/put_queue for blkback
      xen/blkback: deal with hardsect_size to logical_block_size rename
      xen/blkback: remove spurious debug output noise
      xen/blkback: little cleanups
      xen/blkback: use drv_get/set_drvdata rather than directly accessing driver_data.
      xen/blkback: add accessor for xenbus backend device

K. Y. Srinivasan (2):
      xen/blkback: Propagate changed size of VBDs
      xen/blkback: Print additional information when a vbd is resized.

Kees Cook (1):
      iosched: remove redundant sprintf

Keir Fraser (2):
      blkback: Fix potential resource leak.
      blkback: Fix CVE-2010-3699

Konrad Rzeszutek Wilk (58):
      xen: add blkback support
      Fix compile warnings: ignoring return value of 'xenbus_register_backend' ..
      xen/blkback: Replace WRITE_BARRIER with (REQ_FLUSH | REQ_FUA)
      xen/blkback: Update to use blkdev_get_by_dev instead of open_by_devnum.
      xen/blkback: Move global/static variables into struct xen_blkbk.
      xen/blkback: Union the blkif_request request specific fields
      xen/blkback: Use 'vzalloc' for page arrays and pre-allocate pages.
      xen/blkback: Utilize the M2P override mechanism for GNTMAP_host_map
      xen/blkback: Use kzalloc's, and GFP_KERNEL for data structures.
      xen/blkback: Add some comments.
      xen/blkback: blkif->struct blkif_st
      xen/blkback: Fix checkpatch warnings in vbd.c
      xen/blkback: Fix interface.c checkpatch warnings .. except
      xen/blkback: Fix checkpatch warnings of xenbus.c
      xen/blkback: Fix checkpatch warnings in blkback.c
      xen/blkback: remove per-queue plugging
      xen/blkback: Seperate the bio allocation and the bio submission.
      xen/blkback: Cleanup move the code a bit around.
      xen/blkback: Shuffle code around (vbd_translate moved higher).
      xen/blkback: Move the check for misaligned I/O higher.
      xen/blkback: Change fast_flush_area to xen_blkbk_unmap, and tweak xen_blk_map_seg.
      xen/blkback: Move the check for misaligned I/O once more.
      xen/blkback: Get the 'requeust_queue' properly.
      block, xen/blkback: remove blk_[get|put]_queue calls.
      xen/blkback: Move it from drivers/xen to drivers/block
      xen/blkback: Squash vbd.c,interface.c in blkback.c and xenbus.c respectivly.
      xen-blkback: Remove from the copyright notice the address.
      xen-blkback: Inline some of the functions that were moved from vbd/interface.c
      xen/blkback: Prefix exposed functions with xen_
      xen/blkback: Move the plugging/unplugging to a higher level.
      xen/blkback: Stick REQ_SYNC on WRITEs to deal with CFQ I/O scheduler.
      Revert "xen/blkback: Move the plugging/unplugging to a higher level."
      xen-blkfront: Provide for 'feature-flush-cache' the BLKIF_OP_WRITE_FLUSH_CACHE operation.
      xen/blkback: Add support for BLKIF_OP_FLUSH_DISKCACHE and drop BLKIF_OP_WRITE_BARRIER.
      xen/blkback: Squash the checking for operation into dispatch_rw_block_io
      xen/blkback: Fix up some of the comments.
      xen/blkback: Fixed up comments and converted spaces to tabs.
      xen-blkfront: Provide for 'feature-flush-cache' the BLKIF_OP_WRITE_FLUSH_CACHE operation.
      xen-blkfront: Introduce BLKIF_OP_FLUSH_DISKCACHE support.
      xen/blkback: Change printk/DPRINTK to pr_.. type variant.
      xen/blkback: Make the DPRINTK uniform.
      xen/blkback: Use the DRV_PFX in the pr_.. macros.
      xen/blkback: Removing the debug_lvl option.
      xen/blkback: Move blkif_get_x86_[32|64]_req to common.h in block/xen-blkback dir.
      xen/blkback: Fix spelling mistakes.
      xen/blkback: Flesh out the description in the Kconfig.
      xen/blkback: Fix checkpatch.pl warnings about more than 80 lines.
      xen/blkback: Checkpatch.pl recommend against multiple assigments.
      xen/blkback: Fixing some more of the cleanpatch.pl warnings.
      xen/blkback: Move include/xen/blkif.h into drivers/block/xen-blkback/common.h
      xen/blkback: Remove the unused typedefs.
      xen/blkback: Change structure name blkif_st to xen_blkif.
      xen/blkback: Prefix 'vbd' with 'xen' in structs and functions.
      xen/blkback: Add the prefix XEN in the common.h.
      xen/blkback: if log_stats is enabled print out the data.
      xen/blkback: Align the tabs on the structure.
      xen/p2m/m2p/gnttab: Support GNTMAP_host_map in the M2P override.
      xen/p2m: Add EXPORT_SYMBOL_GPL to the M2P override functions.

Lars Ellenberg (5):
      lru_cache.h: fix comments referring to ts_ instead of lc_
      drbd: fix potential distributed deadlock
      drbd: fix disconnect/reconnect loop, if ping-timeout == ping-int
      drbd: fix potential activity log refcount imbalance in error path
      drbd: fix schedule in atomic

Laszlo Ersek (1):
      xen/blkback: fix xenbus_transaction_start() hang caused by double xenbus_transaction_end()

Marek Marczykowski (1):
      xen-blkfront: fix data size for xenbus_gather in blkfront_connect

Namhyung Kim (2):
      loop: limit 'max_part' module param to DISK_MAX_PARTS
      loop: handle on-demand devices correctly

Philipp Reisner (7):
      drbd: Fix for application IO with the on-io-error=pass-on policy
      drbd: Only downgrade the disk state in case of disk failures
      drbd: Fix for the connection problems on high latency links
      drbd: Disallow the peer_disk_state to be D_OUTDATED while connected
      drbd: Fixed state transitions after async outdate-peer-handler returned
      drbd: Take a more conservative approach when deciding max_bio_size
      drbd: fix warning

Stephen M. Cameron (16):
      cciss: add readl after writel in interrupt mask setting code
      cciss: do a better job of detecting controller reset failure
      cciss: factor out command pool allocation functions
      cciss: factor out scatterlist allocation functions
      cciss: factor out irq request code
      cciss: fix reply pool and block fetch table memory leaks
      cciss: get rid of message related magic numbers
      cciss: increase time to wait for board reset to start
      cciss: clarify messages around reset behavior
      cciss: increase timeouts for post-reset no-ops
      cciss: use new doorbell-bit-5 reset method
      cciss: do soft reset if hard reset is broken
      cciss: remove superfluous sleeps around reset code
      cciss: do not attempt PCI power management reset method if we know it won't work.
      cciss: do not use bit 2 doorbell reset
      cciss: add cciss_tape_cmds module paramter

Tao Ma (1):
      block: Remove 'plug/unplug' comment in blk_execute_rq_nowait

Tejun Heo (3):
      cdrom: always check_disk_change() on open
      block: rescan partitions on invalidated devices on -ENOMEDIA too
      block: don't block events on excl write for non-optical devices

Tom Goetz (1):
      xen/blkback: Fix the WRITE_BARRIER

 Documentation/blockdev/cciss.txt    |   15 +
 arch/x86/include/asm/xen/page.h     |    5 +-
 arch/x86/xen/p2m.c                  |   13 +-
 block/blk-exec.c                    |    2 +-
 block/elevator.c                    |    7 +-
 drivers/block/Kconfig               |   21 +
 drivers/block/Makefile              |    1 +
 drivers/block/cciss.c               |  571 +++++++++++++++++++-----
 drivers/block/cciss.h               |   11 +-
 drivers/block/cciss_cmd.h           |   11 +
 drivers/block/cciss_scsi.c          |   41 +-
 drivers/block/cciss_scsi.h          |    4 -
 drivers/block/drbd/drbd_actlog.c    |    2 +-
 drivers/block/drbd/drbd_bitmap.c    |    6 +-
 drivers/block/drbd/drbd_int.h       |   19 +-
 drivers/block/drbd/drbd_main.c      |   37 ++-
 drivers/block/drbd/drbd_nl.c        |  127 ++++--
 drivers/block/drbd/drbd_receiver.c  |   68 ++--
 drivers/block/drbd/drbd_req.c       |   20 +-
 drivers/block/drbd/drbd_req.h       |    5 +-
 drivers/block/drbd/drbd_worker.c    |   98 +++--
 drivers/block/loop.c                |   11 +-
 drivers/block/paride/pcd.c          |    1 +
 drivers/block/xen-blkback/Makefile  |    3 +
 drivers/block/xen-blkback/blkback.c |  824 +++++++++++++++++++++++++++++++++++
 drivers/block/xen-blkback/common.h  |  233 ++++++++++
 drivers/block/xen-blkback/xenbus.c  |  768 ++++++++++++++++++++++++++++++++
 drivers/block/xen-blkfront.c        |   51 ++-
 drivers/cdrom/cdrom.c               |    6 +-
 drivers/cdrom/viocd.c               |    3 +-
 drivers/ide/ide-cd.c                |    2 +-
 drivers/scsi/sr.c                   |    2 +-
 drivers/xen/grant-table.c           |   31 +-
 fs/block_dev.c                      |   44 ++-
 include/linux/drbd.h                |   10 +-
 include/linux/drbd_tag_magic.h      |    2 +-
 include/linux/genhd.h               |    1 +
 include/linux/lru_cache.h           |   12 +-
 include/xen/interface/io/blkif.h    |   13 +
 39 files changed, 2749 insertions(+), 352 deletions(-)
 create mode 100644 drivers/block/xen-blkback/Makefile
 create mode 100644 drivers/block/xen-blkback/blkback.c
 create mode 100644 drivers/block/xen-blkback/common.h
 create mode 100644 drivers/block/xen-blkback/xenbus.c

-- 
Jens Axboe

