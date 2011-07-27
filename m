Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1G0BKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 21:10:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34981 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1G0BK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 21:10:27 -0400
Date: Wed, 27 Jul 2011 02:10:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs/fs fixes
Message-ID: <20110727011026.GA31146@ZenIV.linux.org.uk>
References: <20110724232409.GM24703@ZenIV.linux.org.uk>
 <CA+55aFwkEaxyxaHWjQLRQx1Oq2mkJC4w_Jmx1w4XoUAzoscBrQ@mail.gmail.com>
 <20110725184748.GT24703@ZenIV.linux.org.uk>
 <CA+55aFwihZNDhDD4dXX3fKTECqf4puUOJmJc6Scebs1f4UFwGA@mail.gmail.com>
 <20110725200303.GB22133@ZenIV.linux.org.uk>
 <CA+55aFyNfkex19B3TERTohm6SMAJkwn3z=c+0KgFk_p1a=22BA@mail.gmail.com>
 <20110725205832.GC22133@ZenIV.linux.org.uk>
 <20110726183421.GA15641@ZenIV.linux.org.uk>
 <CA+55aFxDQK5Tu0d6PqxvoRqvs1zZM5f8fVEKbJEQ1P3fm7PbHQ@mail.gmail.com>
 <20110726185440.GK22133@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726185440.GK22133@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 07:54:40PM +0100, Al Viro wrote:
> The next commit in there turns it into umode_t ;-)  I can put it (or both,
> for that matter) into today's pull - I'm waiting for s-o-b'ed version of
> XFS fix right now...

Grr...  Looks like that will have to wait until tomorrow when the guy
wakes up.  In the meanwhile, here's what I've got in queue at the moment,
if you prefer to pull it now rather than wait for tomorrow:

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (10):
      v9fs_iop_get_acl: get rid of unused variable
      snd_msnd ->mode is fmode_t, not mode_t
      jffs2: S_ISLNK(mode & S_IFMT) is pointless
      pci-label.c: size_t misspelled as mode_t
      ima: fmode_t misspelled as mode_t...
      btrfs: S_ISREG(mode) is not mode & S_IFREG...
      omfs: fix (mode & S_IFDIR) abuse
      xfs: get rid of open-coded S_ISREG(), etc.
      xfs: fix misspelled S_IS...()
      merge fchmod() and fchmodat() guts, kill ancient broken kludge

Dan Carpenter (1):
      fs: add missing unlock in default_llseek()

Eric Dumazet (1):
      vfs: dont chain pipe/anon/socket on superblock s_inodes list

Jeff Layton (1):
      vfs: document locking requirements for d_move, __d_move and d_materialise_unique

Phillip Lougher (1):
      Documentation: Exporting: update description of d_splice_alias

Diffstat:
 Documentation/filesystems/nfs/Exporting |    9 +++-
 drivers/pci/pci-label.c                 |    2 +-
 fs/9p/acl.c                             |    1 -
 fs/anon_inodes.c                        |    2 +-
 fs/btrfs/inode.c                        |    4 +-
 fs/dcache.c                             |   11 +++--
 fs/inode.c                              |   39 ++++++++++++----
 fs/jffs2/fs.c                           |    2 +-
 fs/omfs/dir.c                           |    2 +-
 fs/open.c                               |   78 +++++++++++--------------------
 fs/pipe.c                               |    2 +-
 fs/read_write.c                         |   12 +++--
 fs/xfs/linux-2.6/xfs_ioctl.c            |    6 +-
 fs/xfs/xfs_bmap.c                       |    7 +--
 fs/xfs/xfs_dir2.c                       |   16 +++---
 fs/xfs/xfs_filestream.c                 |   14 +++---
 fs/xfs/xfs_inode.c                      |   16 +++---
 fs/xfs/xfs_inode.h                      |    2 +-
 fs/xfs/xfs_log_recover.c                |    4 +-
 fs/xfs/xfs_mount.c                      |    2 +-
 fs/xfs/xfs_rename.c                     |    4 +-
 fs/xfs/xfs_vnodeops.c                   |   10 ++--
 include/linux/fs.h                      |    3 +-
 net/socket.c                            |    2 +-
 security/integrity/ima/ima_main.c       |    2 +-
 sound/isa/msnd/msnd.h                   |    2 +-
 26 files changed, 133 insertions(+), 121 deletions(-)
