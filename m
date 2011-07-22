Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1GVP1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:27:24 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42678
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab1GVP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:27:23 -0400
Date: Fri, 22 Jul 2011 11:27:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] hfsplus updates for Linux 3.1
Message-ID: <20110722152722.GA11946@infradead.org>
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

please pull the hfsplus updates for this merge window.  The patches are
largely bugfixes, but now that we have sorted the issues with
incorrectly used 32-bit types we can finally enable support for volumes
larger than 2 Terrabytes.

The following changes since commit ca56a95eedcc95f8fea7b49c87565cd961d74fe2:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-06-29 18:18:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus.git for-linus

Alexey Khoroshilov (3):
      hfsplus: Fix double iput of the same inode in hfsplus_fill_super()
      hfsplus: add error checking for hfs_find_init()
      hfsplus: Add error propagation for hfsplus_ext_write_extent_locked

Anton Salikhmetov (1):
      hfsplus: assignments inside `if' condition clean-up

Christoph Hellwig (3):
      hfsplus: fix overflow in hfsplus_get_block
      hfsplus: fix overflow in hfsplus_read_wrapper
      hfsplus: lift the 2TB size limit

Naohiro Aota (1):
      hfsplus: Add additional range check to handle on-disk corruptions

Seth Forshee (2):
      hfsplus: add missing call to bio_put()
      hfsplus: ensure bio requests are not smaller than the hardware sectors

 fs/hfsplus/brec.c       |    4 ++
 fs/hfsplus/catalog.c    |   14 +++++--
 fs/hfsplus/dir.c        |    8 +++-
 fs/hfsplus/extents.c    |   50 +++++++++++++++++-------
 fs/hfsplus/hfsplus_fs.h |   18 +++++++-
 fs/hfsplus/inode.c      |   12 +++--
 fs/hfsplus/part_tbl.c   |   32 +++++++++-------
 fs/hfsplus/super.c      |   45 +++++++++++++++-------
 fs/hfsplus/unicode.c    |   35 +++++++++++++----
 fs/hfsplus/wrapper.c    |   97 ++++++++++++++++++++++++++++++++++-------------
 10 files changed, 224 insertions(+), 91 deletions(-)
