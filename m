Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0HHLoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 07:44:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:60191 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab0HHLo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 07:44:28 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Aug 2010 21:44:15 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19550.39055.227259.954794@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: [PULL REQUEST] md updates for 2.6.36
X-Mailer: VM 8.1.0 under 22.3.1 (x86_64-pc-linux-gnu)
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 here is my merge-window pull request for md.
 The bulk of this update is changes to allow md/raid5 to be plugged
 into dm as a dm target.  The changes to dm to make this happen are
 with the dm maintainer who has given in-principle agreement - they
 just need to be carefully reviewed.

 The remainder are some deadlock fixes which are tagged for -stable,
 one of which should have been around for quite some time, but have
 only manifested recently for some strange reason.

Thanks,
NeilBrown


The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

Dan Williams (1):
      md: move revalidate_disk() back outside open_mutex

NeilBrown (21):
      md: reduce dependence on sysfs.
      md/raid5: factor out code for changing size of stripe cache.
      md/raid5: ensure we create a unique name for kmem_cache when mddev has no gendisk
      md: be more careful setting MD_CHANGE_CLEAN
      md: split out md_rdev_init
      md: export various start/stop interfaces
      md: add support for raising dm events.
      raid5: Don't set read-ahead when there is no queue
      md/raid5: export is_congested test
      md/raid5: add simple plugging infrastructure.
      md/plug: optionally use plugger to unplug an array during resync/recovery.
      md/raid5: export raid5 unplugging interface.
      md/bitmap: white space clean up and similar.
      md/bitmap: reduce dependence on sysfs.
      md/bitmap: clean up plugging calls.
      md/bitmap: optimise scanning of empty bitmaps.
      md/bitmap: prepare for storing write-intent-bitmap via dm-dirty-log.
      md/bitmap:  separate out loading a bitmap from initialising the structures.
      md/raid10: fix deadlock with unaligned read during resync
      md: fix another deadlock with removing sysfs attributes.
      md: clean up do_md_stop

 drivers/md/bitmap.c |  508 ++++++++++++++++++++++++++++-----------------------
 drivers/md/bitmap.h |    6 +
 drivers/md/md.c     |  286 ++++++++++++++++++-----------
 drivers/md/md.h     |   55 ++++++-
 drivers/md/raid10.c |   18 ++
 drivers/md/raid5.c  |  168 ++++++++++-------
 drivers/md/raid5.h  |    9 +-
 7 files changed, 643 insertions(+), 407 deletions(-)
