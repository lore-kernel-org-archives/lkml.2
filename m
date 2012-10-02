Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2JBNC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:02:29 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:51075 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2JBNC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:02:28 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [GIT PULL] drbd-8.3 updates
Date: Tue, 02 Oct 2012 15:02:24 +0200
Message-ID: <8391701.3EY4hQfmFv@fat-tyre>
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please consider to pull these changes for the 3.7 merge window.

Best,
 Phil

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens

for you to fetch changes up to a783d564a1badbb87b3f96aa8df581ed4167a9c9:

  drbd: log request sector offset and size for IO errors (2012-10-02 14:52:24 +0200)

----------------------------------------------------------------
Lars Ellenberg (9):
      drbd: introduce stop-sector to online verify
      drbd: change error cleanup goto for failed kobject_init_and_add
      drbd: panic on delayed completion of aborted requests
      drbd: fix potential deadlock during bitmap (re-)allocation
      drbd: a few more GFP_KERNEL -> GFP_NOIO
      drbd: wait for meta data IO completion even with failed disk, unless force-detached
      drbd: prepare for more than 32 bit flags
      drbd: always write bitmap on detach
      drbd: log request sector offset and size for IO errors

Philipp Reisner (6):
      drbd: Add a drbd directory to sysfs
      drbd: expose the data generation identifiers via sysfs
      drbd: Protect accesses to the uuid set with a spinlock
      drbd: Fix a potential issue with the DISCARD_CONCURRENT flag
      drbd: Avoid NetworkFailure state during disconnect
      drbd: Remove dead code

 drivers/block/drbd/Makefile        |    1 +
 drivers/block/drbd/drbd_actlog.c   |   19 ++--
 drivers/block/drbd/drbd_bitmap.c   |   24 ++---
 drivers/block/drbd/drbd_int.h      |  112 +++++++++++++++++------
 drivers/block/drbd/drbd_main.c     |  175 ++++++++++++++++++++++++------------
 drivers/block/drbd/drbd_nl.c       |  109 +++++++++++++---------
 drivers/block/drbd/drbd_proc.c     |   14 ++-
 drivers/block/drbd/drbd_receiver.c |  147 ++++++++++++++++--------------
 drivers/block/drbd/drbd_req.c      |   43 ++++++---
 drivers/block/drbd/drbd_sysfs.c    |   86 ++++++++++++++++++
 drivers/block/drbd/drbd_worker.c   |   87 ++++++++++++++----
 include/linux/drbd.h               |    4 +-
 include/linux/drbd_nl.h            |    1 +
 13 files changed, 571 insertions(+), 251 deletions(-)
 create mode 100644 drivers/block/drbd/drbd_sysfs.c

