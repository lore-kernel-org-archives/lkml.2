Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab2JCNtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:49:18 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:42090 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JCNtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:49:17 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd-8.3 updates
Date: Wed, 03 Oct 2012 15:49:13 +0200
Message-ID: <1646250.CkOtqoMF8x@fat-tyre>
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic; KDE/4.8.4; x86_64; ; )
In-Reply-To: <506C343E.60203@kernel.dk>
References: <8391701.3EY4hQfmFv@fat-tyre> <10403443.3yRLLBkj5b@fat-tyre> <506C343E.60203@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks, one question before this is pulled in:
> > Philipp Reisner (6):
> >       drbd: Add a drbd directory to sysfs
> >       drbd: expose the data generation identifiers via sysfs
> 
> What are these? It's sitting in /sys/block/<dev>/drbd/, I don't see any
> documentation or justification for that.
> 
> Why isn't it off in debugfs or similar instead?

The long-time goal is to get rid of the /proc/drbd virtual file, and
present the information that was there in a more structured way in /sys.

This patch adds a very first step into that direction. Later we intend to
have here things like the connections state, device roles, statistics
counters there.

When coming up with the layout we used the sysfs presence of software raid 
as example.

I have removed it from this pull-request, so that there is more time for
consideration before the next merge window.

The following changes since commit fab74e7a8f0f8d0af2356c28aa60d55f9e6f5f8b:

  loop: Make explicit loop device destruction lazy (2012-09-28 10:42:23 +0200)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens

for you to fetch changes up to 56a2dabd4d953b70c4630387368d79d6d1625c1d:

  drbd: log request sector offset and size for IO errors (2012-10-03 15:46:04 +0200)

----------------------------------------------------------------
Lars Ellenberg (8):
      drbd: introduce stop-sector to online verify
      drbd: panic on delayed completion of aborted requests
      drbd: fix potential deadlock during bitmap (re-)allocation
      drbd: a few more GFP_KERNEL -> GFP_NOIO
      drbd: wait for meta data IO completion even with failed disk, unless force-detached
      drbd: prepare for more than 32 bit flags
      drbd: always write bitmap on detach
      drbd: log request sector offset and size for IO errors

Philipp Reisner (4):
      drbd: Protect accesses to the uuid set with a spinlock
      drbd: Fix a potential issue with the DISCARD_CONCURRENT flag
      drbd: Avoid NetworkFailure state during disconnect
      drbd: Remove dead code

 drivers/block/drbd/drbd_actlog.c   |   19 ++--
 drivers/block/drbd/drbd_bitmap.c   |   24 ++---
 drivers/block/drbd/drbd_int.h      |  108 +++++++++++++++++------
 drivers/block/drbd/drbd_main.c     |  170 ++++++++++++++++++++++++------------
 drivers/block/drbd/drbd_nl.c       |   74 +++++++++-------
 drivers/block/drbd/drbd_proc.c     |   14 ++-
 drivers/block/drbd/drbd_receiver.c |  147 ++++++++++++++++---------------
 drivers/block/drbd/drbd_req.c      |   43 ++++++---
 drivers/block/drbd/drbd_worker.c   |   87 ++++++++++++++----
 include/linux/drbd.h               |    4 +-
 include/linux/drbd_nl.h            |    1 +
 11 files changed, 451 insertions(+), 240 deletions(-)

Best,
 Phil
