Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1AGNaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:30:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1AGNaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:30:03 -0500
Date: Fri, 7 Jan 2011 08:30:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] hfsplus updates
Message-ID: <20110107133002.GA27044@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the hfsplus updates for this merge window.  The most
important bits is fixing up fsync and sync to actually work correctly.
In addition to that hfsplus also stops using buffer heads for it's
superblock (volume header) as it needs to be accesses at 512 byte
granularity.  The rest is various small patches and a couple of cleanups
contributed by Anton.


The following changes since commit ff8b16d7e15a8ba2a6086645614a483e048e3fbf:

  vmstat: fix offset calculation on void* (2010-11-03 14:39:58 -0400)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus.git for-next

Anton Salikhmetov (5):
      hfsplus: fix an artifact in ioctl flag checking
      hfsplus: over 80 character lines clean-up
      hfsplus: C99 comments clean-up
      hfsplus: spaces/indentation clean-up
      hfsplus: %L-to-%ll, macro correction, and remove unneeded braces

Christoph Hellwig (12):
      hfsplus: fix option parsing during remount
      hfsplus: silence a few debug printks
      hfsplus: always use hfsplus_sync_fs to write the volume header
      hfsplus: use raw bio access for the volume headers
      hfsplus: use raw bio access for partition tables
      hfsplus: make sure sync writes out all metadata
      hfsplus: avoid useless work in hfsplus_sync_fs
      hfsplus: simplify fsync
      hfsplus: write up fsync for directories
      hfsplus: split up inode flags
      hfsplus: optimize fsync
      hfsplus: flush disk caches in sync and fsync

 fs/hfsplus/bfind.c       |    6 +-
 fs/hfsplus/bitmap.c      |    3 +-
 fs/hfsplus/bnode.c       |   70 +++++++++++-------
 fs/hfsplus/brec.c        |   28 +++++---
 fs/hfsplus/btree.c       |   33 ++++++---
 fs/hfsplus/catalog.c     |   85 ++++++++++++++--------
 fs/hfsplus/dir.c         |   37 +++++++---
 fs/hfsplus/extents.c     |   96 ++++++++++++++++---------
 fs/hfsplus/hfsplus_fs.h  |  125 +++++++++++++++++++-------------
 fs/hfsplus/hfsplus_raw.h |    3 +-
 fs/hfsplus/inode.c       |   89 +++++++++++++++--------
 fs/hfsplus/ioctl.c       |    6 +-
 fs/hfsplus/options.c     |   44 +++++++++++-
 fs/hfsplus/part_tbl.c    |  129 +++++++++++++++++++--------------
 fs/hfsplus/super.c       |  130 ++++++++++++++++++++-------------
 fs/hfsplus/unicode.c     |   41 +++++++----
 fs/hfsplus/wrapper.c     |  178 +++++++++++++++++++++++++++++-----------------
 17 files changed, 703 insertions(+), 400 deletions(-)

