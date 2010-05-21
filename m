Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab0EUWsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:48:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479Ab0EUWr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:47:58 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 22 May 2010 08:47:49 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19447.3477.501889.730865@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md updates for 2.6.35
X-Mailer: VM under 22.3.1 (x86_64-pc-linux-gnu)
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 please pull the following updates for md for 2.6.35.

 The head commit is a merge which fixes up a conflict between some
 patches in here and other that went in late in 2.6.34,
 and also resolves a compile-time conflict with sysfs patches (which
 added an arg to sysfs_get_dirent (as discovered in -next).

 All have been seen on linux-raid mailing list and have been in -next
 for a while.

 The first few are tagged for -stable.

Thanks,
NeilBrown


The following changes since commit d515e86e639890b33a09390d062b0831664f04a2:

  Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6 (2010-05-21 11:17:43 -0700)

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Dan Williams (4):
      md: set mddev readonly flag on blkdev BLKROSET ioctl
      md/raid4: permit raid0 takeover
      md: notify mdstat waiters of level change
      md: allow integers to be passed to md/level

Gabriele A. Trombetti (1):
      md/raid6: Fix raid-6 read-error correction in degraded state

H Hartley Sweeten (1):
      drivers/md: Remove unnecessary casts of void *

Maciej Trela (2):
      md: Correctly handle device removal via sysfs
      md: notify level changes through sysfs.

NeilBrown (34):
      md/linear: avoid possible oops and array stop
      md: remove unneeded sysfs files more promptly
      md: manage redundancy group in sysfs when changing level.
      md/raid1: fix counting of write targets.
      md: remove some dead fields from mddev_s
      md: discard StateChanged device flag.
      md: don't use mddev->raid_disks in raid0 or raid10 while array is active.
      md: Relax checks on ->max_disks when external metadata handling is used.
      md: add support for raid5 to raid4 conversion
      md/raid5: small tidyup in raid5_align_endio
      md: move io accounting out of personalities into md_make_request
      md: don't reference gendisk in getgeo
      md: remove ->changed and related code.
      md: factor do_md_run to separate accesses to ->gendisk
      md: start to refactor do_md_stop
      md: factor md_stop_writes out of do_md_stop.
      md: split md_set_readonly out of do_md_stop
      md: call md_stop_writes from md_stop
      md: pass mddev to make_request functions rather than request_queue
      md: factor out init code for an mddev
      md: don't unregister the thread in mddev_suspend
      md/raid1: fix confusing 'redirect sector' message.
      md/raid1: delay reads that could overtake behind-writes.
      md: remove EXPERIMENTAL designation from RAID10
      md/raid5: improve consistency of error messages.
      md/raid1: improve printk messages
      md/raid10: tidy up printk messages.
      md/raid0: tidy up printk messages.
      md/linear: standardise all printk messages
      md: Fix read balancing in RAID1 and RAID10 on drives > 2TB
      md: restore ability of spare drives to spin down.
      md: simplify updating of event count to sometimes avoid updating spares.
      md: don't insist on valid event count for spare devices.
      Merge commit '3ff195b011d7decf501a4d55aeed312731094796' into for-linus

Paul Clements (1):
      md: expose max value of behind writes counter

Trela Maciej (1):
      md:Add support for Raid0->Raid5 takeover

Trela, Maciej (2):
      md: Add support for Raid5->Raid0 and Raid10->Raid0 takeover
      md: Add support for Raid0->Raid10 takeover

 drivers/md/Kconfig     |    4 +-
 drivers/md/bitmap.c    |   41 +++-
 drivers/md/bitmap.h    |    2 +
 drivers/md/faulty.c    |    9 +-
 drivers/md/linear.c    |   36 ++--
 drivers/md/md.c        |  537 +++++++++++++++++++++++++++++-------------------
 drivers/md/md.h        |   16 +-
 drivers/md/multipath.c |   13 +-
 drivers/md/raid0.c     |  251 +++++++++++++++++------
 drivers/md/raid0.h     |    3 +
 drivers/md/raid1.c     |  114 ++++++-----
 drivers/md/raid10.c    |  300 ++++++++++++++++++---------
 drivers/md/raid10.h    |   12 +
 drivers/md/raid5.c     |  231 ++++++++++++----------
 14 files changed, 987 insertions(+), 582 deletions(-)
