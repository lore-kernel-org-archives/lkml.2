Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1EXI74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:59:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33613 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1EXI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:59:54 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 04:59:54 EDT
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] DRBD bits for 2.6.40
Date: Tue, 24 May 2011 10:50:24 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241050.24719.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 779d530632c98967820d3bbcae15d492fc20301e:

  Merge branches 'for-jens/xen-backend-fixes' and 'for-jens/xen-blkback-v3.3' 
of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen into 
for-2.6.40/drivers (2011-05-19 09:46:00 +0200)

are available in the git repository at:

  git://git.drbd.org/linux-2.6-drbd.git for-jens

DRBD's changelog:
8.3.11 (api:88/proto:86-96)
--------
 * Fixed handling of read errors during online verify runs
 * Fixes for possible distributed deadlocks during online verify and
   checksum based resync processes
 * Fixed handling of IO errors with an on-io-error=pass-on policy; the
   disk state goes to inconsistent
 * Fixed the behavior in case ping-timeout and ping-int are set to the
   same value
 * Fix for connecting on high latency network links
 * Fixed state transitions if fence-peer handler returns after connection was
   established again
 * Made die max_bio_size negotiation conservative instead of optimistic
 * Network timeouts for mirrored write requests are now always enforced,
   no longer only when the socket is congested



Andrew Morton (1):
      drbd: fix warning

Bart Van Assche (1):
      drbd: Fix spelling

Lars Ellenberg (5):
      lru_cache.h: fix comments referring to ts_ instead of lc_
      drbd: fix potential distributed deadlock
      drbd: fix disconnect/reconnect loop, if ping-timeout == ping-int
      drbd: fix potential activity log refcount imbalance in error path
      drbd: fix schedule in atomic

Philipp Reisner (7):
      drbd: Fix for application IO with the on-io-error=pass-on policy
      drbd: Only downgrade the disk state in case of disk failures
      drbd: Fix for the connection problems on high latency links
      drbd: Disallow the peer_disk_state to be D_OUTDATED while connected
      drbd: Fixed state transitions after async outdate-peer-handler returned
      drbd: Take a more conservative approach when deciding max_bio_size
      drbd: fix warning

 drivers/block/drbd/drbd_actlog.c   |    2 +-
 drivers/block/drbd/drbd_bitmap.c   |    6 +-
 drivers/block/drbd/drbd_int.h      |   19 ++++--
 drivers/block/drbd/drbd_main.c     |   37 +++++++++--
 drivers/block/drbd/drbd_nl.c       |  127 ++++++++++++++++++++++++++---------
 drivers/block/drbd/drbd_receiver.c |   68 ++++++++------------
 drivers/block/drbd/drbd_req.c      |   20 +++---
 drivers/block/drbd/drbd_req.h      |    5 +-
 drivers/block/drbd/drbd_worker.c   |   98 +++++++++++++++++-----------
 include/linux/drbd.h               |   10 ++--
 include/linux/drbd_tag_magic.h     |    2 +-
 include/linux/lru_cache.h          |   12 ++--
 12 files changed, 255 insertions(+), 151 deletions(-)
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
