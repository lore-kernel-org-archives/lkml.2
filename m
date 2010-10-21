Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0JUD0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 23:26:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab0JUD0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 23:26:31 -0400
Date: Wed, 20 Oct 2010 23:26:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] hfsplus updates
Message-ID: <20101021032629.GA10492@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various updates for the hfsplus filesystem, including proper SMP
locking, various corruption fixes and better handling of corrupt
filesystems.  This should address all outstanding bugs in the
kernel.org bugzilla.

Roman who used to maintain hfsplus has been MIA since 2008, so for
now I'll do the interims maintainer.

The following changes since commit 0f44fbd297e1cda5d9ecc9f5321a86fe647c7d4a:

  alpha: fix compile problem in arch/alpha/kernel/signal.c (2010-09-28 13:26:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus.git for-next

Al Viro (1):
      hfsplus: hfs_bnode_find() can fail, resulting in hfs_bnode_split() breakage

Christoph Hellwig (25):
      hfsplus: fix BKL leak in hfsplus_ioctl
      hfsplus: split hfsplus_ioctl
      hfsplus: protect setflags using i_mutex
      hfsplus: introduce alloc_mutex
      hfsplus: use alloc_mutex in hfsplus_sync_fs
      hfsplus: remove BKL from hfsplus_put_super
      hfsplus: fix HFSPLUS_SB calling convention
      hfsplus: fix HFSPLUS_I calling convention
      hfsplus: clean up hfsplus_iget
      hfsplus: clean up hfsplus_write_inode
      hfsplus: merge mknod/mkdir/creat
      hfsplus: fix error handling in hfsplus_symlink
      hfsplus: do not cache and write next_alloc
      hfsplus: remove the rsrc_inodes list
      hfsplus: add per-superblock lock for volume header updates
      hfsplus: use atomic bitops for the superblock flags
      hfsplus: protect readdir against removals from open_dir_list
      hfsplus: add missing extent locking in hfsplus_write_inode
      hfsplus: fix rename over directories
      hfsplus: validate btree flags
      hfsplus: fix link corruption
      hfsplus: remove superflous rootflags field in hfsplus_inode_info
      hfsplus: create correct initial catalog entries for device files
      hfsplus: remove the unused hfsplus_kmap/hfsplus_kunmap helpers
      hfsplus: fix getxattr return value

Eric Sandeen (1):
      hfsplus: handle more on-disk corruptions without oopsing

Jeff Mahoney (1):
      hfsplus: fix oops on mount with corrupted btree extent records

Thomas Gleixner (1):
      hfsplus: convert tree_lock to mutex

 fs/hfsplus/bfind.c       |   17 +++-
 fs/hfsplus/bitmap.c      |   20 ++--
 fs/hfsplus/brec.c        |   29 ++++-
 fs/hfsplus/btree.c       |   67 ++++++++---
 fs/hfsplus/catalog.c     |   50 ++++----
 fs/hfsplus/dir.c         |  201 ++++++++++++++----------------
 fs/hfsplus/extents.c     |  223 +++++++++++++++++++---------------
 fs/hfsplus/hfsplus_fs.h  |   85 +++++++------
 fs/hfsplus/hfsplus_raw.h |    3 +-
 fs/hfsplus/inode.c       |  185 ++++++++++++++--------------
 fs/hfsplus/ioctl.c       |  153 +++++++++++++----------
 fs/hfsplus/options.c     |   10 +-
 fs/hfsplus/part_tbl.c    |    5 +-
 fs/hfsplus/super.c       |  310 +++++++++++++++++++++++-----------------------
 fs/hfsplus/unicode.c     |   16 ++--
 fs/hfsplus/wrapper.c     |   40 ++++---
 16 files changed, 765 insertions(+), 649 deletions(-)
