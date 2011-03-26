Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1CZS4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:56:18 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:40999 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab1CZS4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:56:17 -0400
X-ASG-Debug-ID: 1301165775-01de284cf8c3170001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8E36CC.7080707@fusionio.com>
Date: Sat, 26 Mar 2011 19:56:12 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block drivers for 2.6.39-rc
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block drivers for 2.6.39-rc
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301165775
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59046
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the pull request for the block driver updates for 2.6.39. Two
things here:

- Big drbd update, as per usual...
- cciss update.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.39/drivers

Andreas Gruenbacher (22):
      drbd: Removed an unnecessary #undef
      drbd: Make sure that drbd_send() has sent the right number of bytes
      drbd: Remove left-over prototype
      drbd: Rename drbd_make_request_26 to drbd_make_request
      drbd: Get rid of unnecessary macros (1)
      drbd: Get rid of unnecessary macros (2)
      drbd: Rename enum drbd_ret_codes to enum drbd_ret_code
      drbd: Rename enum drbd_state_ret_codes to enum drbd_state_rv
      drbd: Be more explicit about functions that return an enum drbd_state_rv
      drbd: Another small enum drbd_state_rv cleanup
      drbd: This code is dead now
      drbd: Use the standard bool, true, and false keywords
      drbd: drbd_nl_disk_conf: Avoid a compiler warning
      drbd: receive_bitmap: Fix the wrong return value
      drbd: receive_bitmap: Avoid casting enum drbd_state_rv to int
      drbd: receive_bitmap: Missing free_page() on error path
      drbd: send_bitmap_rle_or_plain: Get rid of ugly and useless enum
      drbd: receive_bitmap_plain: Get rid of ugly and useless enum
      drbd: Fix: drbd_bitmap_io does not return an enum determine_dev_size
      drbd: Rename __inc_ap_bio_cond to may_inc_ap_bio
      drbd: Remove useless / wrong comments
      drbd: Remove unused function atodb_endio()

Bud Brown (1):
      cciss: fix lost command issue

Jens Axboe (1):
      Revert "cciss: Add missing allocation in scsi_cmd_stack_setup and  corresponding deallocation"

Lars Ellenberg (49):
      drbd: only reset online-verify start sector if verify completed
      drbd: improve online-verify progress tracking
      drbd: initialize online-verify progress tracking on verify target
      drbd: factor out advancement of resync marks for progress reporting
      drbd: advance progress step marks for online-verify
      drbd: show progress bar and ETA for online-verify
      drbd: factor out drbd_rs_controller_reset
      drbd: factor out drbd_rs_number_requests
      drbd: use the resync controller for online-verify requests as well
      drbd: fix potential wrap of 32bit oos:%lu display in /proc/drbd
      drbd: further converge progress display of resync and online-verify
      drbd: detect modification of in-flight buffers
      drbd: debug: limit nelink-broadcast of request on digest mismatch to 32k
      drbd: properly use max_hw_sectors to limit the our bio size
      drbd: restore compatibility with 32bit kernels
      drbd: Renamed write_flags_to_bio() to wire_flags_to_bio()
      drbd: increase module count on /proc/drbd access
      drbd: remove /proc/drbd before unregistering from netlink
      drbd: use kzalloc and memset(,0,) to start with clean buffers in drbd_nl
      drbd: add packet_type 27 (return_code_only) to netlink api
      drbd: fix regression, we need to close drbd epochs during normal operation
      drbd: fix incomplete error message
      drbd: bitmap: don't count unused bits (fix non-terminating resync)
      drbd: store in-core bitmap little endian, regardless of architecture
      drbd: bitmap keep track of changes vs on-disk bitmap
      drbd: allow petabyte storage on 64bit arch
      drbd: get rid of unused debug code
      drbd: Removed a reference to debug macros removed long time ago
      drbd: move bitmap write from resync_finished to after_state_change
      drbd: fix potential dereference of NULL pointer
      drbd: add debugging assert to make sure the protocol is clean
      drbd: serialize sending of resync uuid with pending w_send_oos
      drbd: be less noisy with some log messages
      drbd: spelling fix in log message
      drbd: improve on bitmap write out timing
      drbd: fix potential access of on-stack wait_queue_head_t after return
      drbd: ratelimit io error messages
      drbd: only generate and send a new sync uuid after a successful state change
      drbd: serialize admin requests for new resync with pending bitmap io
      drbd: don't pointlessly queue bitmap send, if we lost connection
      drbd: queue bitmap writeout more intelligently
      drbd: log UUIDs whenever they change
      drbd: describe bitmap locking for bulk operation in finer detail
      drbd: silence some noisy log messages during disconnect
      drbd: fix potential imbalance of ap_in_flight
      drbd: serialize admin requests for new verify run with pending bitmap io
      drbd: don't BUG_ON, if bio_add_page of a single page to an empty bio fails
      drbd: kill dead code
      drbd: improve log message if received sector offset exceeds local capacity

Or Gerlitz (1):
      drbd: drop code present under #ifdef which is relevant to 2.6.28 and below

Philipp Reisner (40):
      drbd: Track the numbers of sectors in flight
      drbd: New configuration parameters for dealing with network congestion
      drbd: Implemented two new connection states Ahead/Behind
      drbd: New packet for Ahead/Behind mode: P_OUT_OF_SYNC
      drbd: When proxy's buffer drained off go into regular resync mode
      drbd: Do not cleanup resync LRU for the Ahead/Behind SyncSource/SyncTarget transitions
      drbd: Implemented priority inheritance for resync requests
      drbd: Make some functions static
      drbd: Implemented side-stepping in drbd_res_begin_io()
      drbd: Begin to account BIO processing time before inc_ap_bio()
      drbd: use test_and_set_bit() to decide if bm_io_work should be queued
      drbd: Fixed inc_ap_bio()
      drbd: Fixed race condition in drbd_queue_bitmap_io
      drbd: Improvements in sanitize_state()
      drbd: Starting with protocol 96 we can allow app-IO while receiving the bitmap
      drbd: Becoming sync target may not happen out of < C_WF_REPORT_PARAMS
      drbd: Removed 20 seconds upper bound for side-stepping
      drbd: --force option for disconnect
      drbd: Implemented the before-resync-source handler
      drbd: Documenting drbd_should_do_remote() and drbd_should_send_oos()
      drbd: There might be a resync after unfreezing IO due to no disk [Bugz 332]
      drbd: Fixed an issue with AHEAD -> SYNC_SOURCE transitions
      drbd: No longer answer P_RS_DATA_REQUEST packets when in C_AHEAD mode
      drbd: Be more careful with SyncSource -> Ahead transitions
      drbd: Cleaned up the resync timer logic
      drbd: Corrected off-by-one error in DRBD_MINOR_COUNT_MAX
      drbd: Do not full sync if a P_SYNC_UUID packet gets lost
      drbd: Nothing should stop SyncSource -> Ahead transitions
      drbd: Work on the Ahead -> SyncSource transition
      drbd: Do not drop net config if sending in drbd_send_protocol() fails
      drbd: Killed an assert that is no longer valid
      drbd: Fixed P_NEG_ACK processing for protocol A and B
      drbd: Ensure that an epoch contains only requests of one kind
      drbd: cleaned up __set_current_state() followed by schedule_timeout() calls
      drbd: Provide hints with the error message when clearing the sync pause flag
      drbd: We can not process BIOs with a size of 0
      drbd: Removed left over, now wrong comments
      drbd: Implemented real timeout checking for request processing time
      drbd: Fixed handling of read errors on a 'VerifyT' node
      drbd: Fixed handling of read errors on a 'VerifyS' node

Stephen M. Cameron (7):
      cciss: export resettable host attribute
      cciss: Add missing allocation in scsi_cmd_stack_setup and  corresponding deallocation
      cciss: hoist tag masking out of loop
      cciss: Inform controller we are using 32-bit tags.
      cciss: Mask off error bits of c->busaddr in cmd_special_free when calling pci_free_consistent
      cciss: remove unnecessary casts
      cciss: fix missed command status value CMD_UNABORTABLE

Stephen Rothwell (1):
      drbd: need include for bitops functions declarations

 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   12 +
 drivers/block/cciss.c                              |   86 ++-
 drivers/block/cciss.h                              |    1 +
 drivers/block/cciss_cmd.h                          |    1 +
 drivers/block/cciss_scsi.c                         |   13 +-
 drivers/block/drbd/drbd_actlog.c                   |  335 +++-------
 drivers/block/drbd/drbd_bitmap.c                   |  752 +++++++++++++-------
 drivers/block/drbd/drbd_int.h                      |  270 +++++---
 drivers/block/drbd/drbd_main.c                     |  673 ++++++++++++------
 drivers/block/drbd/drbd_nl.c                       |  183 ++++--
 drivers/block/drbd/drbd_proc.c                     |  114 +++-
 drivers/block/drbd/drbd_receiver.c                 |  608 ++++++++++------
 drivers/block/drbd/drbd_req.c                      |  169 ++++-
 drivers/block/drbd/drbd_req.h                      |   36 +-
 drivers/block/drbd/drbd_strings.c                  |    6 +-
 drivers/block/drbd/drbd_worker.c                   |  360 +++++-----
 drivers/block/drbd/drbd_wrappers.h                 |    2 +-
 include/linux/drbd.h                               |   23 +-
 include/linux/drbd_limits.h                        |   12 +-
 include/linux/drbd_nl.h                            |   13 +-
 include/linux/drbd_tag_magic.h                     |    1 +
 21 files changed, 2267 insertions(+), 1403 deletions(-)

-- 
Jens Axboe

