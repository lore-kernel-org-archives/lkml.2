Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0JVLQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:16:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53415 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0JVLQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:16:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Blunck <jblunck@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] BKL work in file systems
Date: Fri, 22 Oct 2010 13:15:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201010221315.54064.arnd@arndb.de>
X-Provags-ID: V02:K0:pLnMj1VwFG267WxkpE3Nwn75QGGe3NBy3A1MalLsKE/
 /WdumxdU7Iyx4O5wxKDM6bR3IzSteMdS4/Un/MDgR3nondnSdH
 XRAW6ozdUMqRHtFFk6VK7Xv6wUS7hEtBkKTrKNGx8f5FFNcmT0
 Z9z9xZ3/aVFr8IjKohWresJaYlXeRo1uXfI5kE1Oy3d3YbDnrw
 5Quyopys+jY7KH2m+MaWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This series moves the BKL out of do_new_mount into the individual
file systems that still use it elsewhere, and then removes it one
way or another from most of them.

Most of the hard work was done by Jan Blunck, I did some more in this
series, and a few file system maintainers (nfs, coda, hfsplus, ...)
have additional patches that go along with this series.

The conversion of fs/locks.c is partial, I will follow up with a
smaller patch to do the rest once the lockd and ceph changes are
merged.

Please pull

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git vfs

Arnd Bergmann (12):
      BKL: Remove BKL from fat
      BKL: Remove BKL from isofs
      BKL: Remove BKL from autofs4
      BKL: Remove BKL from USB gadgetfs
      BKL: Remove BKL from afs
      BKL: Remove BKL from ecryptfs
      BKL: Remove BKL from jffs2
      BKL: Remove BKL from squashfs
      BKL: Remove BKL from OCFS2
      fs/locks.c: prepare for BKL removal
      BKL: remove BKL from qnx4
      BKL: remove BKL from freevxfs

Felipe Contreras (1):
      autofs4: Only declare function when CONFIG_COMPAT is defined

Jan Blunck (14):
      BKL: Explicitly add BKL around get_sb/fill_super
      BKL: Remove BKL from Amiga FFS
      BKL: Remove BKL from BFS
      BKL: Remove BKL from CifsFS
      BKL: Remove BKL from ext3 fill_super()
      BKL: Remove BKL from ext3_put_super() and ext3_remount()
      BKL: Remove BKL from ext4 filesystem
      BKL: Remove BKL from HFS
      BKL: Remove BKL from JFS
      BKL: Remove BKL from NILFS2
      BKL: Remove BKL from NTFS
      BKL: Remove BKL from cgroup
      BKL: Remove BKL from do_new_mount()
      BKL: Remove BKL from ext2 filesystem

Márton Németh (1):
      autofs: Only declare function when CONFIG_COMPAT is defined

Petr Vandrovec (2):
      BKL: Remove BKL from ncpfs
      ncpfs: Lock socket in ncpfs while setting its callbacks

 drivers/usb/gadget/inode.c |    1 -
 fs/adfs/super.c            |    8 +-
 fs/affs/super.c            |   14 +-
 fs/afs/flock.c             |    5 +-
 fs/afs/super.c             |    5 -
 fs/autofs/root.c           |    2 +
 fs/autofs4/root.c          |   14 +-
 fs/bfs/inode.c             |    5 -
 fs/cifs/cifsfs.c           |   13 +-
 fs/coda/inode.c            |    8 +-
 fs/ecryptfs/file.c         |    3 -
 fs/ext2/super.c            |    6 +-
 fs/ext3/super.c            |   13 --
 fs/ext4/super.c            |   11 -
 fs/fat/inode.c             |    5 -
 fs/fat/namei_msdos.c       |    6 +-
 fs/fat/namei_vfat.c        |    6 +-
 fs/freevxfs/vxfs_lookup.c  |   14 +--
 fs/freevxfs/vxfs_super.c   |    7 +-
 fs/gfs2/file.c             |    2 +
 fs/hfs/super.c             |    6 +-
 fs/hpfs/super.c            |    8 +-
 fs/isofs/dir.c             |    6 +-
 fs/isofs/inode.c           |    9 +-
 fs/isofs/isofs.h           |    1 +
 fs/isofs/namei.c           |    8 +-
 fs/isofs/rock.c            |   10 +-
 fs/jffs2/fs.c              |    4 -
 fs/jffs2/super.c           |    9 +-
 fs/jfs/super.c             |   23 +--
 fs/locks.c                 |  112 +++++++----
 fs/namespace.c             |    2 -
 fs/ncpfs/dir.c             |  221 ++++++++++++---------
 fs/ncpfs/file.c            |   25 +--
 fs/ncpfs/inode.c           |   55 +++--
 fs/ncpfs/ioctl.c           |  470 ++++++++++++++++++++++++--------------------
 fs/ncpfs/ncplib_kernel.c   |  101 ++++++-----
 fs/ncpfs/ncplib_kernel.h   |   15 +-
 fs/ncpfs/ncpsign_kernel.c  |   10 +-
 fs/ncpfs/sock.c            |    1 -
 fs/nfs/delegation.c        |   10 +-
 fs/nfs/nfs4state.c         |   10 +-
 fs/nfsd/nfs4state.c        |    6 +-
 fs/nilfs2/ioctl.c          |    1 -
 fs/nilfs2/super.c          |   10 -
 fs/ntfs/super.c            |   24 +--
 fs/ocfs2/stack_user.c      |    3 -
 fs/ocfs2/super.c           |    7 -
 fs/qnx4/dir.c              |    4 -
 fs/qnx4/inode.c            |    6 -
 fs/qnx4/namei.c            |    4 -
 fs/smbfs/inode.c           |    5 +
 fs/squashfs/super.c        |    5 -
 fs/udf/super.c             |    8 +-
 fs/ufs/super.c             |    5 +
 include/linux/fs.h         |   14 +-
 include/linux/ncp_fs.h     |   28 ---
 include/linux/ncp_fs_sb.h  |    4 +-
 kernel/cgroup.c            |    4 -
 59 files changed, 691 insertions(+), 711 deletion
