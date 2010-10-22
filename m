Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0JVIAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:00:07 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38057 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab0JVIAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:00:05 -0400
Message-ID: <4CC14495.5090900@fusionio.com>
Date: Fri, 22 Oct 2010 10:00:21 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PUL] block driver updates for 2.6.37-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A collection of block driver updates for 2.6.37-rc1. Biggest chunk is a
huge chunk of drbd updates and fixes, cciss follows close behind with a
series of nice cleanups.

On the fast moving side of floppy, a few patches from Vivek and myself
to get rid of queue sharing. Once this work is completely, we can remove
some of the ugly hacks in bdi_register() and friends.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-2.6.37/drivers

Dan Carpenter (1):
      drbd: cleanup: change "<= 0" to "== 0"

Jens Axboe (1):
      floppy: switch to one queue per drive instead of sharing a queue

Lars Ellenberg (33):
      drbd: fix list corruption (recent regression)
      drbd: let drbd_free_ee implicitly free any digest
      drbd: remove outdated comment and dead code
      drbd: use rolling marks for resync speed calculation
      drbd: reduce code duplication when receiving data requests
      drbd: new configuration parameter c-min-rate
      drbd: fix race between deconfiguring and reconfiguring network
      drbd: fix race on meta-data update
      drbd: implicitly create unconfigured devices on sync-after dependencies
      drbd: fix race on meta-data update, addendum
      drbd: drbd_md_sync before calling user space helpers
      drbd: don't count sendpage()d pages only referenced by tcp as in use
      drbd: fix potential kernel BUG (NULL deref)
      drbd: fix spurious protocol error
      drbd: cosmetic, don't report resync for online-verify
      drbd: fix for spurious full sync (becoming sync target looked like invalidate)
      drbd: DIV_ROUND_UP not needed here
      drbd: protocol compatibility for maximum packet sizes
      drbd: fix possible access after free
      drbd: Fix regression in recv_bm_rle_bits (compressed bitmap)
      drbd: drbd_send_ack_dp must not rely on header information
      drbd: preparation commit, using full state in receive_state()
      drbd: allow for explicit resync-finished notifications
      drbd: fix for spurious fullsync (uuids rotated too fast)
      drbd: fix unlikely access after free and list corruption
      drbd: fix for possible deadlock on IO error during resync
      drbd: add explicit drbd_md_sync to drbd_resync_finished
      drbd: cleanup useless leftover warn/error printk's
      drbd: drop wrong debug asserts, fix recently introduced race
      drbd: add some more explicit drbd_md_sync
      drbd: relax the grace period of the md_sync timer again
      drbd: use dynamic_dev_dbg to optionally log uuid changes
      drbd: add race-breaker to drbd_go_diskless

Mike Miller (1):
      cciss: fix PCI IDs for new Smart Array controllers

Milan Broz (1):
      loop: add some basic read-only sysfs attributes

Philipp Reisner (42):
      drbd: renamed drbd_tl_epoch.n_req to drbd_tl_epoch.n_writes
      drbd: Track all IO requests on the TL, not writes only
      drbd: mod_req has now a return value
      drbd: factored tl_restart() out of tl_clear().
      drbd: Do not send two barriers without any writes between them
      drbd: factored drbd_req_make_private_bio() out of drbd_req_new()
      drbd: Removed redundant error checks in the request code path
      drbd: Finished the "on-no-data-accessible suspend-io;" functionality
      drbd: Do not allow a fencing-policy of resource-and-stonith with protocol A
      drbd: Disabled the crashed_primary detection for re-attach of last data while IO is frozen
      drbd: Now we need to handle the ed_uuid of an diskless, unconnected primary correctly
      drbd: Removing a by now obsolete clause in the state sanitizing
      drbd: Reduce the verbosity of some state transitions
      drbd: Run the fence-peer helper asynchronously
      drbd: Delayed creation of current-UUID
      drbd: Ensure that the peer was not rebootet in the meantime before resending TL
      drbd: Do not do a hard state change when establishing a connection [bugz 304]
      drbd: Fixed a deadlock, probably only affected UP machines
      drbd: Allow tl_restart() to do IO completion while IO is suspended
      drbd: Allow attach while IO is suspended
      drbd: Do not try to free tl_hash in drbd_disconnect() when IO is suspended
      drbd: Make sure tl_restart(, resend) can not get called multiple times for a new connection
      drbd: Initialize all members of sync_conf to their defaults [Bugz 315]
      drbd: New sync parameters for the smart resync rate controller
      drbd: New sync_param packet, that includes the parameters of the new controller
      drbd: The new, smarter resync speed controller
      drbd: Bugfix: rs_in_flight could become wrong if read_for_csum() requested reschedule later
      drbd: Replaced some casts by an union. Improved comments
      drbd: Microfix: Assigning sector once is sufficient
      drbd: Bugfix for regression introduced with f9bc8913c06022e
      drbd: Sending of big packets, for payloads from 64KByte to 4GByte
      drbd: receiving of big packets, for payloads between 64kByte and 4GByte
      drbd: Actually allow BIOs up to 128k (was 32k).
      drbd: Disable activity log updates when the whole device is out of sync
      drbd: Removed a race that could cause unexpected execution of w_make_resync_request()
      drbd: Adding support for BIO/Request flags: REQ_FUA, REQ_FLUSH and REQ_DISCARD
      drbd: Fixed compatibility with protocol versions smaller than 95
      drbd: Track the reasons to suspend IO in dedicated state bits
      drbd: Allow larger values for c-fill-target.
      drbd: Fixed a stupid copy and paste error
      drbd: Do not log an ASSERT for P_OV_REQUEST packets while C_CONNECTED
      dynamic_debug.h: Fix dynamic_dev_dbg() macro if CONFIG_DYNAMIC_DEBUG not set

Stephen M. Cameron (13):
      cciss: factor out cciss_getpciinfo
      cciss: factor out cciss_getintinfo
      cciss: factor out cciss_setintinfo
      cciss: factor out cciss_getnodename
      cciss: factor out cciss_setnodename
      cciss: factor out cciss_getheartbeat
      cciss: factor out cciss_getbustypes
      cciss: factor out cciss_getfirmver
      cciss: factor out cciss_getdrivver
      cciss: factor out cciss_getluninfo
      cciss: factor out cciss_passthru
      cciss: factor out cciss_big_passthru
      cciss: remove some superfluous tests from cciss_bigpassthru()

Vivek Goyal (3):
      amiga floppy: Stop sharing request queue across multiple gendisks
      atari floppy: Stop sharing request queue across multiple gendisks
      amiga floppy: Compile failure fixes

 drivers/block/amiflop.c            |   60 ++-
 drivers/block/ataflop.c            |   50 ++-
 drivers/block/cciss.c              |  882 +++++++++++++++++-----------------
 drivers/block/drbd/drbd_actlog.c   |   41 +-
 drivers/block/drbd/drbd_bitmap.c   |    2 +-
 drivers/block/drbd/drbd_int.h      |  216 ++++++---
 drivers/block/drbd/drbd_main.c     |  593 ++++++++++++++++-------
 drivers/block/drbd/drbd_nl.c       |  270 +++++++++--
 drivers/block/drbd/drbd_proc.c     |   34 +-
 drivers/block/drbd/drbd_receiver.c |  946 ++++++++++++++++++++----------------
 drivers/block/drbd/drbd_req.c      |  165 ++++---
 drivers/block/drbd/drbd_req.h      |   62 ++-
 drivers/block/drbd/drbd_worker.c   |  292 +++++++++---
 drivers/block/floppy.c             |   66 ++-
 drivers/block/loop.c               |  101 ++++
 include/linux/drbd.h               |   22 +-
 include/linux/drbd_limits.h        |   29 +-
 include/linux/drbd_nl.h            |    6 +
 include/linux/dynamic_debug.h      |    2 +-
 include/linux/pci_ids.h            |    1 +
 20 files changed, 2441 insertions(+), 1399 deletions(-)

-- 
Jens Axboe

