Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab2BXQlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:41:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:41961 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772Ab2BXQl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:41:29 -0500
Date: Fri, 24 Feb 2012 11:41:24 -0500
From: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Btrfs updates
Message-ID: <20120224164124.GI26638@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F47BDB7.0059,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the for-linus branch of the btrfs repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is later than I wanted because I got backed up running through
btrfs bugs from the Oracle QA teams.  But they are all bug fixes that
we've queued and tested since rc1.

Nothing in particular stands out, this just reflects bug fixing and QA
done in parallel by all the btrfs developers.  The most user visible of
these is:

Btrfs: clear the extent uptodate bits during parent transid failures 

Because that helps deal with out of date drives (say an iscsi disk that
has gone away and come back).  The old code wasn't always properly
retrying the other mirror for this type of failure.

Liu Bo (6) commits (+24/-15):
    Btrfs: be less strict on finding next node in clear_extent_bit (+1/-2)
    Btrfs: skip states when they does not contain bits to clear (+10/-5)
    Btrfs: kick out redundant stuff in convert_extent_bit (+0/-5)
    Btrfs: increase the global block reserve estimates (+1/-1)
    Btrfs: fix trim 0 bytes after a device delete (+8/-1)
    Btrfs: fix a bug on overcommit stuff (+4/-1)

Chris Mason (6) commits (+93/-47):
    Btrfs: clear the extent uptodate bits during parent transid failures (+3/-4)
    Btrfs: add extra sanity checks on the path names in btrfs_mksubvol (+6/-0)
    Btrfs: don't reserve data with extents locked in btrfs_fallocate (+10/-15)
    Btrfs: improve error handling for btrfs_insert_dir_item callers (+26/-7)
    Btrfs: fix compiler warnings on 32 bit systems (+26/-20)
    Btrfs: make sure we update latest_bdev (+22/-1)

Tsutomu Itoh (3) commits (+15/-8):
    Btrfs: check return value of lookup_extent_mapping() correctly (+4/-2)
    Btrfs: fix memory leak in load_free_space_cache() (+1/-0)
    Btrfs: fix return value check of extent_io_ops (+10/-6)

David Sterba (2) commits (+17/-3):
    btrfs: fix structs where bitfields and spinlock/atomic share 8B word (+3/-3)
    btrfs: silence warning in raid array setup (+14/-0)

Jan Schmidt (1) commits (+2/-0):
    Btrfs: avoid positive number with ERR_PTR

Jeff Mahoney (1) commits (+53/-27):
    btrfs: delalloc for page dirtied out-of-band in fixup worker

Keith Mannthey (1) commits (+6/-0):
    btrfs: Sector Size check during Mount

Arne Jansen (1) commits (+5/-3):
    btrfs: don't check DUP chunks twice

Jeff Liu (1) commits (+2/-2):
    Btrfs: return the internal error unchanged if btrfs_get_extent_fiemap() call failed for SEEK_DATA/SEEK_HOLE inquiry

Miao Xie (1) commits (+29/-24):
    Btrfs: fix deadlock on page lock when doing auto-defragment

Florian Albrechtskirchinger (1) commits (+4/-2):
    btrfs: honor umask when creating subvol root

Total: (24) commits (+250/-131)

 fs/btrfs/backref.c          |    2 +
 fs/btrfs/check-integrity.c  |    2 +-
 fs/btrfs/compression.c      |    2 +
 fs/btrfs/ctree.h            |    2 +-
 fs/btrfs/disk-io.c          |   12 +++++
 fs/btrfs/extent-tree.c      |   51 ++++++++++++-------
 fs/btrfs/extent_io.c        |  113 +++++++++++++++++++++++++------------------
 fs/btrfs/extent_io.h        |    1 +
 fs/btrfs/extent_map.h       |    4 +-
 fs/btrfs/file.c             |   29 +++++-------
 fs/btrfs/free-space-cache.c |    1 +
 fs/btrfs/inode-map.c        |    6 ++-
 fs/btrfs/inode.c            |   40 +++++++++++++--
 fs/btrfs/ioctl.c            |   59 +++++++++++++---------
 fs/btrfs/scrub.c            |    8 ++-
 fs/btrfs/transaction.c      |   16 ++++---
 fs/btrfs/volumes.c          |   33 ++++++++++++-
 17 files changed, 250 insertions(+), 131 deletions(-)
