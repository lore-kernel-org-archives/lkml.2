Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2E3Mzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:55:45 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:50348 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab2E3Mzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:55:43 -0400
X-ASG-Debug-ID: 1338382542-0421b5669135830001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FC6189B.9080909@fusionio.com>
Date: Wed, 30 May 2012 14:54:51 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block driver bits for 3.5
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Block driver bits for 3.5
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1338382542
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.98438
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On top of the for-3.5/core pull request, here are the driver related
changes for 3.5. It contains:

- The floppy changes from Jiri. Jiri is now also marked as the
  maintainer of floppy.c, I shall be publically branding his forehead
  with red hot iron at the next opportune moment.

- A batch of drbd updates and fixes from the linbit crew, as well as
  fixes from others.

- Two small fixes for xen-blkfront courtesy of Jan.

Please pull.

  git://git.kernel.dk/linux-block.git for-3.5/drivers

for you to fetch changes up to 4fd1ffaa122cf66bfb710ced43679413df4f3605:

  Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-3.5/drivers (2012-05-18 16:20:06 +0200)

----------------------------------------------------------------

Andreas Gruenbacher (1):
      drbd: drbd_nl_resize(): Fix missing put_ldev() on error path

Arne Redlich (1):
      drbd: bm_page_async_io: properly initialize page->private

Cong Wang (1):
      drbd: check MODULE for THIS_MODULE

David Howells (1):
      DRBD: Fix comparison always false warning due to long/long long compare

Jan Beulich (2):
      xen-blkfront: properly name all devices
      xen-blkfront: module exit handling adjustments

Jens Axboe (2):
      Merge branch 'stable/for-jens-3.5' of git://git.kernel.org/.../konrad/xen into for-3.5/drivers
      Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-3.5/drivers

Jiri Kosina (3):
      floppy: convert to delayed work and single-thread wq
      floppy: remove floppy-specific O_EXCL handling
      floppy: take over maintainership

Lars Ellenberg (31):
      drbd: cosmetic: fix accidental division instead of modulo when pretty printing
      drbd: spelling fix: too small
      drbd: allow ping-timeout of up to 30 seconds
      drbd: downgraded error printk to info
      drbd: change some GFP_KERNEL to GFP_NOIO
      drbd: fix "stalled" empty resync
      drbd: fix harmless race to not trigger an ASSERT
      drbd: fix spurious meta data IO "error"
      drbd: send intermediate state change results to the peer
      drbd: fix potential spinlock deadlock
      drbd: fix race between disconnect and receive_state
      drbd: Fix module refcount leak in drbd_accept()
      drbd: add missing part_round_stats to _drbd_start_io_acct
      drbd: fix potential data corruption and protocol error
      drbd: remove now unused seq_num member from struct drbd_request
      drbd: missing wakeup after drbd_rs_del_all
      drbd: remove some very outdated comments
      drbd: remove unused static helper function
      drbd: don't pretend that barrier_nr == 0 was special
      drbd: make OOS_HANDED_TO_NETWORK its own case
      drbd: fix READ_RETRY_REMOTE_CANCELED to not complete if device is suspended
      drbd: fix WRITE_ACKED_BY_PEER_AND_SIS to not set RQ_NET_DONE
      drbd: move put_ldev from __req_mod() to the endio callback
      drbd: fix resend/resubmit of frozen IO
      drbd: fix race between drbdadm invalidate/verify and finishing resync
      drbd: allow bitmap to change during writeout from resync_finished
      drbd: add page pool to be used for meta data IO
      drbd: use the newly introduced page pool for bitmap IO
      drbd: remove unused define
      drbd: introduce a bio_set to allocate housekeeping bios from
      drbd: grammar fix in log message

Philipp Reisner (30):
      drbd: Lower log priority for an event that is definitely not an error
      drbd: Only print sanitize state's warnings, if the state change happens
      drbd: Improve compatibility with drbd's older than 8.3.7
      drbd: Keep a reference to barrier acked requests
      drbd: Immediately allow completion of IOs, that wait for IO completions on a failed disk
      drbd: moved md_io into mdev
      drbd: Replaced md_io_mutex by an atomic: md_io_in_use
      drbd: Implemented wait_until_done_or_disk_failure()
      drbd: Keep a reference to the bio until the completion handler finished
      drbd: Hold a reference to ldev while doing meta-data IO
      drbd: Added a kref to bm_aio_ctx
      drbd: Bitmap IO functions can now return prematurely if the disk breaks
      drbd: Allow new IOs while the local disk in in FAILED state
      drbd: Force flag for the detach operation
      drbd: Implemented the disk-timeout option
      drbd: Fixed current UUID generation
      drbd: Consider that the no-data-condition could be in connected state
      drbd: detach must not try to abort non-local requests from drbd-8.4
      drbd: Cleanup all epoch objects upon connection loss
      drbd: Bugfix for the connection behavior
      drbd: Derive sync-UUIDs only from the bitmap-uuid if it is non-zero
      drbd: Fixed a race condition between detach and start of resync
      drbd: Fixed an obvious copy-n-paste mistake
      drbd: Do not send state packets while lower than C_CONNECTED cstate
      drbd: Consider the disk-timeout also for meta-data IO operations
      drbd: Fix a potential race that could case data inconsistency
      drbd: Fix a potential write ordering issue on SyncTarget nodes
      drbd: Delay/reject other state changes while establishing a connection
      drbd: Ensure that data_size is not 0 before using data_size-1 as index
      drbd: Restore the request restart logic

 MAINTAINERS                        |    6 +
 drivers/block/drbd/drbd_actlog.c   |  104 ++++++++---
 drivers/block/drbd/drbd_bitmap.c   |  146 +++++++++++----
 drivers/block/drbd/drbd_int.h      |   90 +++++----
 drivers/block/drbd/drbd_main.c     |  357 +++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_nl.c       |   48 ++++-
 drivers/block/drbd/drbd_proc.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |   95 +++++++---
 drivers/block/drbd/drbd_req.c      |  132 ++++++++-----
 drivers/block/drbd/drbd_req.h      |   19 +-
 drivers/block/drbd/drbd_worker.c   |   31 +++-
 drivers/block/floppy.c             |  161 ++++++++--------
 drivers/block/xen-blkfront.c       |   44 +++--
 include/linux/drbd.h               |    6 +-
 include/linux/drbd_limits.h        |    7 +-
 include/linux/drbd_nl.h            |    5 +-
 16 files changed, 862 insertions(+), 391 deletions(-)

-- 
Jens Axboe

