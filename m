Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2DMNih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:38:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19752 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab2DMNid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:38:33 -0400
Date: Fri, 13 Apr 2012 09:38:29 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20120413133829.GY29506@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090206.4F882C58.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My for-linus branch has btrfs fixes and updates:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The top commit is the only one that isn't strictly a bug fix.  It
updates the btrfs metadata checker code to support metadata blocks
larger than the page size.  This code isn't compiled in by default, and
it is only used by developers.  I put it at the top so you could just
peel it off if you didn't want it.  I also put a for-linus-min branch
without this commit:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-min

The others are pure bug fixes.  We have a use-after-free in there, along
with errors when mount -o discard is enabled, and a BUG_ON(we should
compile with UP more often).

Stefan Behrens (1) commits (+415/-146):
    Btrfs: change integrity checker to support big blocks

Chris Mason (2) commits (+2/-2):
    Revert "Btrfs: increase the global block reserve estimates" (+1/-1)
    Btrfs: fix uninit variable in repair_eb_io_failure (+1/-1)

Dave Jones (1) commits (+5/-4):
    Btrfs: fix use-after-free in __btrfs_end_transaction

Liu Bo (1) commits (+18/-2):
    Btrfs: fix eof while discarding extents

Ilya Dryomov (1) commits (+2/-3):
    Btrfs: remove lock assert from get_restripe_target()

Josef Bacik (1) commits (+3/-10):
    Btrfs: use commit root when loading free space cache

Tsutomu Itoh (1) commits (+10/-0):
    Btrfs: check return value of bio_alloc() properly

Total: (8) commits (+455/-167)

 fs/btrfs/check-integrity.c  |  561 ++++++++++++++++++++++++++++++++-----------
 fs/btrfs/compression.c      |    2 +
 fs/btrfs/extent-tree.c      |   11 +-
 fs/btrfs/extent_io.c        |    6 +-
 fs/btrfs/free-space-cache.c |    9 +-
 fs/btrfs/scrub.c            |    4 +
 fs/btrfs/transaction.c      |    9 +-
 fs/btrfs/volumes.c          |   20 +-
 8 files changed, 455 insertions(+), 167 deletions(-)
