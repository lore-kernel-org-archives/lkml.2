Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833Ab0J2IhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:37:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:52653 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756007Ab0J2IhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:37:13 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Oct 2010 19:37:06 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19658.34738.159280.954794@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md update for current merge window
X-Mailer: VM 8.1.0 under 22.3.1 (x86_64-pc-linux-gnu)
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 as detailed below, a few updates for md for 2.6.37.
 Nothing really major.  The most significant is a few improvements to
 allocation of bios so we don't exhaust a global pool and so run the
 risk of dead-lock when multiple md devices are stacked, or used with
 something else (like swap) that allocates bios from the global pool.

 Apart from that, minor bug fixes and clean-up.

Thanks,
NeilBrown



The following changes since commit 12ba8d1e9262ce81a695795410bd9ee5c9407ba1:

  fix braino in fs: do not assign default i_ino in new_inode (2010-10-26 20:25:45 -0700)

are available in the git repository at:
  git://neil.brown.name/md for-linus

NeilBrown (12):
      md: Fix regression with raid1 arrays without persistent metadata.
      md: remove md_mutex locking.
      md: use sector_t in bitmap_get_counter
      md: Fix possible deadlock with multiple mempool allocations.
      md: use bio_kmalloc rather than bio_alloc when failure is acceptable.
      md/raid1: perform mem allocation before disabling writes during resync.
      md: change type of first arg to sync_page_io.
      md: use separate bio pool for each md device.
      md: unplug writes to external bitmaps.
      md/raid1: discard unused variable.
      md/raid1: fix some typos in comments.
      md: tidy up device searches in read_balance.

Tejun Heo (1):
      md: fix and update workqueue usage

 drivers/md/bitmap.c |   30 ++++----
 drivers/md/bitmap.h |    4 +-
 drivers/md/faulty.c |    2 +-
 drivers/md/md.c     |  159 ++++++++++++++++++++++++++++--------
 drivers/md/md.h     |    8 ++-
 drivers/md/raid1.c  |  224 ++++++++++++++++++++++----------------------------
 drivers/md/raid1.h  |    2 -
 drivers/md/raid10.c |   42 +++++-----
 drivers/md/raid5.c  |    6 +-
 9 files changed, 272 insertions(+), 205 deletions(-)
