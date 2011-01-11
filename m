Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1AKUoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:44:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:51949 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1AKUoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:44:04 -0500
Date: Tue, 11 Jan 2011 21:44:01 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] Ext2, Ext3 and quota updates for 2.6.38-rc1
Message-ID: <20110111204401.GB4501@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  Appart from various smaller ext2, ext3, and quota fixes and cleanups, the
tree contains also patches to make ext[23] directory operations less CPU
hungry (from Eric Sandeen) and discard ioctl support for ext3 (from Lukas
Czerner).

The full shortlog is:

Darrick J. Wong (1):
      ext3: Return error code from generic_check_addressable

Eric Sandeen (2):
      ext2: speed up file creates by optimizing rec_len functions
      ext3: speed up file creates by optimizing rec_len functions

Joe Perches (3):
      fs/ext2/super.c: Use printf extension %pV
      fs/ext3/super.c: Use printf extension %pV
      quota: Use %pV and __attribute__((format (printf in __quota_error and fix fallout

Josh Hunt (1):
      ext2: Resolve 'dereferencing pointer to incomplete type' when enabling EXT2_XATTR_DEBUG

Lukas Czerner (2):
      ext3: Add batched discard support for ext3
      ext3: Add FITRIM handling

Maciej Żenczykowski (1):
      ext3: don't update sb journal_devnum when RO dev

Namhyung Kim (5):
      ext3: Add error check in ext3_mkdir()
      ext3: Add journal error check into ext3_delete_entry()
      ext3: Add journal error check into ext3_rename()
      ext3: Add journal error check in resize.c
      ext3: Add more journal error check

Theodore Ts'o (2):
      ext3: Avoid uninitialized memory references with a corrupted htree directory
      ext3: Use search_dirblock() in ext3_dx_find_entry()

Tobias Klauser (2):
      ext2: Remove redundant unlikely()
      ext3: Remove redundant unlikely()

The diffstat is

 fs/ext2/dir.c            |   19 +++-
 fs/ext2/namei.c          |    2 +-
 fs/ext2/super.c          |   25 +++--
 fs/ext3/balloc.c         |  266 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext3/dir.c            |   15 ++--
 fs/ext3/inode.c          |    6 +-
 fs/ext3/ioctl.c          |   22 ++++
 fs/ext3/namei.c          |  138 ++++++++++++++----------
 fs/ext3/resize.c         |   65 +++++++++---
 fs/ext3/super.c          |   64 +++++++----
 fs/mbcache.c             |   12 --
 fs/quota/dquot.c         |   18 ++--
 fs/quota/quota_tree.c    |    9 +-
 include/linux/ext3_fs.h  |   10 ++
 include/linux/mbcache.h  |   11 ++
 include/linux/quotaops.h |    5 +-
 16 files changed, 545 insertions(+), 142 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
