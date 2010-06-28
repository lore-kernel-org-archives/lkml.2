Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0F1EG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 00:06:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab0F1EGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 00:06:54 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Jun 2010 14:06:39 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19496.8143.920908.225279@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md: various bug fixes
X-Mailer: VM 8.1.0 under 22.3.1 (x86_64-pc-linux-gnu)
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
  Please consider pulling the following changes for 2.6.35.
  They are:

   - fixes for regressions introduced in -rc1 (Restore partition....)
   - fixes for enhancements added in -rc1 which were not yet perfect
        (mostly relating to 'takeover' of one level by another)
   - fixes for bugs of longer standing.
     One of these was poor handling of multiple device failure when converting
      a RAID5 to a RAID6 with several more devices.  This bug exposed 
      several issues and covers the "md/raid5:*" patches.

Thanks,
NeilBrown



The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  git://neil.brown.name/md/ for-linus

Maciej Trela (3):
      md: fix raid10 takeover: use new_layout for setup_conf
      md: clear layout after ->raid0 takeover
      md: enable raid4->raid0 takeover

NeilBrown (8):
      Restore partition detection of newly created md arrays.
      md: fix handling of array level takeover that re-arranges devices.
      md/raid5: avoid oops when number of devices is reduced then increased.
      md: Don't update ->recovery_offset when reshaping an array to fewer devices.
      md/raid5: More careful check for "has array failed".
      md/raid5: Allow recovered part of partially recovered devices to be in-sync
      md/raid5: add a missing 'continue' in a loop.
      md/raid5: don't include 'spare' drives when reshaping to fewer devices.

Prasanna S. Panchamukhi (1):
      md: raid10: Fix null pointer dereference in fix_read_error()

 drivers/md/md.c     |   38 +++++++++++--
 drivers/md/md.h     |    3 +
 drivers/md/raid0.c  |   21 ++++----
 drivers/md/raid0.h  |    3 -
 drivers/md/raid10.c |   46 ++++++----------
 drivers/md/raid10.h |    5 --
 drivers/md/raid5.c  |  150 +++++++++++++++++++++++++++++++++++++++++----------
 7 files changed, 187 insertions(+), 79 deletions(-)
