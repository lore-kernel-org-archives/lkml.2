Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1AKUwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:52:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673Ab1AKUwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:52:35 -0500
Date: Tue, 11 Jan 2011 21:52:33 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PULL REQUEST] UDF tree
Message-ID: <20110111205233.GC4501@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

The largest portion of patches is BKL removal from UDF. Also there is a fix
for a long standing directory corruption bug which I've hit while testing
BKL removal patches.

The full shortlog is:

Alessio Igor Bogani (3):
      udf: Replace bkl with the UDF_I(inode)->i_data_sem for protect udf_inode_info struct
      udf: Use of s_alloc_mutex to serialize udf_relocate_blocks() execution
      udf: Remove unnecessary bkl usages

Jan Kara (10):
      udf: Convert UDF_SB(sb)->s_flags to use bitops
      udf: Remove BKL from udf_update_inode
      udf: Move handling of uniqueID into a helper function and protect it by a s_alloc_mutex
      udf: Protect all modifications of LVID with s_alloc_mutex
      udf: Protect default inode credentials by rwlock
      udf: Remove BKL from udf_put_super() and udf_remount_fs()
      udf: Call udf_add_free_space() for more blocks at once in udf_free_blocks()
      udf: Remove BKL from free space counting functions
      udf: Protect udf_file_aio_write from possible races
      udf: Fix directory corruption after extent merging

Jesper Juhl (1):
      UDF: Close small mem leak in udf_find_entry()

Joe Perches (2):
      fs/udf: Use vzalloc
      fs/udf: Add printf format/argument verification

The diffstat is

 fs/udf/balloc.c    |    3 +-
 fs/udf/dir.c       |    5 --
 fs/udf/file.c      |   11 ++---
 fs/udf/ialloc.c    |   21 +++-------
 fs/udf/inode.c     |   51 +++++++++++--------------
 fs/udf/namei.c     |  107 ++++++++++++++--------------------------------------
 fs/udf/partition.c |   27 +++++++++----
 fs/udf/super.c     |   67 ++++++++++++++++++++-------------
 fs/udf/symlink.c   |   12 +++--
 fs/udf/udf_i.h     |   13 ++++++
 fs/udf/udf_sb.h    |   22 +++++++++--
 fs/udf/udfdecl.h   |    4 +-
 12 files changed, 164 insertions(+), 179 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
