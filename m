Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2JCKHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:07:13 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:34276 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2JCKHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:07:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd-8.3 updates
Date: Wed, 03 Oct 2012 12:07:08 +0200
Message-ID: <10403443.3yRLLBkj5b@fat-tyre>
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1538845.40xQlPEFSm@fat-tyre>
References: <8391701.3EY4hQfmFv@fat-tyre> <506BDECA.90701@kernel.dk> <1538845.40xQlPEFSm@fat-tyre>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 3. Oktober 2012, 11:24:09 schrieben Sie:
> > Not pulled. Two reasons:
> > 
> > - It's late (in the merge window)
> > - and it's not based off my for-3.7/drivers branch, hence I get a ton of
> > 
> >   unrelated changes with a pull into that branch.
> 
> Hi Jens,
> 
> I can rebase it for you in a few hours. Would influence this your decission?
> 

Hi Jens,

Is there a convenient way for me to find our when it is the right time
to send pull requests your way? (i.e. a notification when you create your
for-3.x/drivers branch)

Rebasing it on your drivers tree was trivial, here is the updated pull
request:

The following changes since commit fab74e7a8f0f8d0af2356c28aa60d55f9e6f5f8b:

  loop: Make explicit loop device destruction lazy (2012-09-28 10:42:23 +0200)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens

for you to fetch changes up to 61e8114a682b0e868696f8363ed03e5fd4c750d1:

  drbd: log request sector offset and size for IO errors (2012-10-03 11:54:45 +0200)

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

Best,
 Phil
