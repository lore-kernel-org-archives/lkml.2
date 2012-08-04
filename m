Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2HDGTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 02:19:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41597 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2HDGTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 02:19:06 -0400
Date: Sat, 4 Aug 2012 07:19:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: Linux 3.6-rc1
Message-ID: <20120804061904.GJ23464@ZenIV.linux.org.uk>
References: <CA+55aFy4vnD5-8SWF_WDC3oTGotzkDg2_4=YHXd6qMiJ=OKekw@mail.gmail.com>
 <1343976472.1730.18.camel@sauron.fi.intel.com>
 <CA+55aFz322dKXUwtmrrW=nfp5XJa5ACh1syE8RXOOdcA7V_76A@mail.gmail.com>
 <20120804044659.GI23464@ZenIV.linux.org.uk>
 <1344058715.1716.1.camel@kyv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344058715.1716.1.camel@kyv>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 08:38:35AM +0300, Artem Bityutskiy wrote:
> On Sat, 2012-08-04 at 05:46 +0100, Al Viro wrote:
> > OK...  I've ported Artem's patchset on top of exofs merge; Artem, could
> > you check if you are OK with the result currently in vfs.git#for-linus?
> 
> Thanks Al, yes, it looks all right.

OK, then...  Artem's patchset + do_dentry_open() fix is in the usual place -
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
Please, pull...

Shortlog:
Al Viro (1):
      missed mnt_drop_write() in do_dentry_open()

Artem Bityutskiy (15):
      vfs: kill write_super and sync_supers
      Documentation: get rid of write_super
      Documentation: fix the VM knobs descritpion WRT pdflush
      ext3: nuke write_super from comments
      ext4: nuke write_super from comments
      ext4: nuke pdflush from comments
      btrfs: nuke write_super from comments
      btrfs: nuke pdflush from comments
      jbd/jbd2: nuke write_super from comments
      vfs: nuke pdflush from comments
      hfs: nuke write_super from comments
      nilfs2: nuke write_super from comments
      drbd: nuke pdflush from comments
      gfs2: nuke pdflush from comments
      UBIFS: nuke pdflush from comments

Diffstat:
 Documentation/DocBook/filesystems.tmpl |    4 +-
 Documentation/filesystems/Locking      |    2 -
 Documentation/filesystems/porting      |    5 +--
 Documentation/filesystems/vfs.txt      |    4 --
 Documentation/laptops/laptop-mode.txt  |   12 ++++----
 Documentation/sysctl/vm.txt            |   14 ++++----
 Documentation/sysctl/vm.txt.rej        |   21 +++++++++++++
 drivers/block/drbd/drbd_main.c         |    4 +-
 fs/bio.c                               |    2 +-
 fs/btrfs/inode.c                       |    3 +-
 fs/btrfs/ordered-data.c                |    2 +-
 fs/btrfs/super.c                       |    4 --
 fs/btrfs/volumes.c                     |    4 --
 fs/ext3/inode.c                        |    8 -----
 fs/ext3/super.c                        |   11 -------
 fs/ext4/inode.c                        |   10 +-----
 fs/ext4/super.c                        |   11 -------
 fs/gfs2/meta_io.c                      |    2 +-
 fs/hfs/mdb.c                           |    4 +-
 fs/jbd/journal.c                       |    4 +-
 fs/jbd2/journal.c                      |    4 +-
 fs/nilfs2/super.c                      |    4 --
 fs/nilfs2/the_nilfs.h                  |    2 -
 fs/open.c                              |    2 +-
 fs/super.c                             |   40 ------------------------
 fs/ubifs/file.c                        |   10 +++---
 fs/ubifs/super.c                       |    2 +-
 include/linux/backing-dev.h            |    1 -
 include/linux/fs.h                     |    3 --
 include/linux/writeback.h              |    1 -
 mm/backing-dev.c                       |   52 --------------------------------
 mm/page-writeback.c                    |    1 -
 32 files changed, 59 insertions(+), 194 deletions(-)
 create mode 100644 Documentation/sysctl/vm.txt.rej
