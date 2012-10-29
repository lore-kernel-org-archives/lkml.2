Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab2J2SVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:21:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51519 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2J2SVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:21:30 -0400
Message-ID: <508EC926.3040906@kernel.dk>
Date: Mon, 29 Oct 2012 19:21:26 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block driver bits for 3.7
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Later than I would have liked, but I was traveling around the merge
window and then a fixes snuck in past that and I wanted to ensure that
everything was fully baked again. There was a particular issue around a
floppy regression due to the genhd change, which has now gotten
reverted. So without further ado, here are the driver updates queued up
for 3.7. It contains:

- Updates to the Micron mtip32xx real-ssd card from Micron.
- A few fixes for loop, from Dave Chinner and Eric Biederman.
- A round of floppy fixes, and a subsequent revert of genhd
  part since it caused regressions.
- The usual round of drbd updates/fixes.
- A single xen-blkback fixup.
- A few other minor fixes and/or code cleanups.
- memstick driver and later revert, this isn't well reviewed
  enough yet to go directly in.

Please pull!

  git://git.kernel.dk/linux-block.git for-3.7/drivers

for you to fetch changes up to a13c29ddf73d3be4fbb2b1bbced64014986cd87a:

  Merge branch 'for-jens' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/linux-block into for-3.7/drivers (2012-10-29 19:20:25 +0100)

----------------------------------------------------------------

Akinobu Mita (1):
      cciss: select CONFIG_CHECK_SIGNATURE

Asai Thambi S P (6):
      mtip32xx: Add support for new devices
      mtip32xx: Handle NCQ commands during the security locked state
      mtip32xx: Increase timeout for standby command
      mtip32xx: Proper reporting of write protect status on big-endian
      mtip32xx: Change printk to pr_xxxx
      mtip32xx: Remove dead code

Ben Hutchings (1):
      genhd: Make put_disk() safe for disks that have not been registered

Dave Chinner (1):
      loop: Make explicit loop device destruction lazy

David Milburn (1):
      mtip32xx: fix user_buffer check in exec_drive_command

Eric W. Biederman (1):
      userns: Convert loop to use kuid_t instead of uid_t

Herton Ronaldo Krzesinski (5):
      floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
      floppy: do put_disk on current dr if blk_init_queue fails
      floppy: properly handle failure on add_disk loop
      floppy: use common function to check if floppies can be registered
      floppy: remove dr, reuse drive on do_floppy_init

Jens Axboe (6):
      Merge branch 'stable/for-jens-3.7' of git://git.kernel.org/.../konrad/xen into for-3.7/drivers
      Merge branch 'for-jens' of git://git.kernel.org/.../jikos/linux-block into for-3.7/drivers
      Merge branch 'stable/for-jens-3.7' of git://git.kernel.org/.../konrad/xen into for-3.7/drivers
      Merge branch 'for-3.7/core' into for-3.7/drivers
      Revert "memstick: add support for legacy memorysticks"
      Merge branch 'for-jens' of git://git.kernel.org/.../jikos/linux-block into for-3.7/drivers

Jiri Kosina (3):
      pktcdvd: update MAINTAINERS
      Merge branches 'floppy' and 'pktcdvd' into for-jens
      Revert "genhd: Make put_disk() safe for disks that have not been registered"

Konrad Rzeszutek Wilk (1):
      xen/blkback: Fix compile warning

Lars Ellenberg (8):
      drbd: introduce stop-sector to online verify
      drbd: panic on delayed completion of aborted requests
      drbd: fix potential deadlock during bitmap (re-)allocation
      drbd: a few more GFP_KERNEL -> GFP_NOIO
      drbd: wait for meta data IO completion even with failed disk, unless force-detached
      drbd: prepare for more than 32 bit flags
      drbd: always write bitmap on detach
      drbd: log request sector offset and size for IO errors

Maxim Levitsky (1):
      memstick: add support for legacy memorysticks

Oliver Chick (1):
      xen/blkback: Change xen_vbd's flush_support and discard_secure to have type unsigned int, rather than bool

Philipp Reisner (4):
      drbd: Protect accesses to the uuid set with a spinlock
      drbd: Fix a potential issue with the DISCARD_CONCURRENT flag
      drbd: Avoid NetworkFailure state during disconnect
      drbd: Remove dead code

Selvan Mani (1):
      mtip32xx:Added appropriate timeout value for secure erase

Wei Yongjun (2):
      xen/blkback: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
      cciss: remove unneeded memset()

 MAINTAINERS                        |    2 +-
 drivers/block/Kconfig              |    1 +
 drivers/block/cciss.c              |    1 -
 drivers/block/drbd/drbd_actlog.c   |   19 ++--
 drivers/block/drbd/drbd_bitmap.c   |   24 ++---
 drivers/block/drbd/drbd_int.h      |  108 +++++++++++++++++------
 drivers/block/drbd/drbd_main.c     |  170 ++++++++++++++++++++++++------------
 drivers/block/drbd/drbd_nl.c       |   74 +++++++++-------
 drivers/block/drbd/drbd_proc.c     |   14 ++-
 drivers/block/drbd/drbd_receiver.c |  147 ++++++++++++++++---------------
 drivers/block/drbd/drbd_req.c      |   43 ++++++---
 drivers/block/drbd/drbd_worker.c   |   87 ++++++++++++++----
 drivers/block/floppy.c             |   86 ++++++++++--------
 drivers/block/loop.c               |   21 ++++-
 drivers/block/mtip32xx/mtip32xx.c  |   57 ++++++++----
 drivers/block/mtip32xx/mtip32xx.h  |   13 ++-
 drivers/block/xen-blkback/common.h |    4 +-
 drivers/block/xen-blkback/xenbus.c |    9 +-
 include/linux/drbd.h               |    4 +-
 include/linux/drbd_nl.h            |    1 +
 include/linux/loop.h               |    2 +-
 init/Kconfig                       |    1 -
 22 files changed, 575 insertions(+), 313 deletions(-)

-- 
Jens Axboe

