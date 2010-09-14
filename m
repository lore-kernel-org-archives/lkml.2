Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0INVO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 17:14:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab0INVO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 17:14:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [NEXT] Remove the BKL from file systems
Date: Tue, 14 Sep 2010 23:14:49 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3+; KDE/4.5.1; x86_64; ; )
Cc: Matthew Wilcox <matthew@wil.cx>, Jan Blunck <jblunck@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009142314.49625.arnd@arndb.de>
X-Provags-ID: V02:K0:Bqbr5D1tTQWoj9gXlC94DLlYoWhEIVRAEwVp5RDs47u
 n76yl4zsWAAJ9wKE6srVAdHjkoV8Mf49hZf96AFqa5VNA2wx4A
 S5UECST9NL4CAx3lNcE3Y/vi9IBMRHMU21656nduMNF1LPU6C1
 62VC6josZr1+d4M2fORh/jDMYXGxAzcsPlIJ6rwq7Eum1ut0R2
 xZD+lEgZWCZZSY6OCL6Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series has been posted a few times, so I'm only posting the summary
here. It removes the BKL from ->get_sb by pushing it into the individual
file systems, and then removes it from the important ones. I've added
a few more file systems to the original series.

Stephen, please add this to next:
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git vfs

Jan Blunck (15):
  BKL: Explicitly add BKL around get_sb/fill_super
  BKL: Remove BKL from Amiga FFS
  BKL: Remove BKL from BFS
  BKL: Remove BKL from CifsFS
  BKL: Remove BKL from ext3 fill_super()
  BKL: Remove BKL from ext3_put_super() and ext3_remount()
  BKL: Remove BKL from ext4 filesystem
  BKL: Remove BKL from HFS
  BKL: Remove BKL from HFS+
  BKL: Remove BKL from JFS
  BKL: Remove BKL from NILFS2
  BKL: Remove BKL from NTFS
  BKL: Remove BKL from cgroup
  BKL: Remove BKL from do_new_mount()
  BKL: Remove BKL from ext2 filesystem

Arnd Bergmann (5):
  BKL: Remove the BKL from usbfs
  BKL: Remove the BKL from fat
  BKL: Remove the BKL from isofs
  BKL: Remove the BKL from autofs4
  BKL: Remove the BKL from ReiserFS

 drivers/isdn/capi/capifs.c |   10 ++++++++--
 drivers/usb/core/inode.c   |    1 -
 drivers/usb/gadget/inode.c |   12 ++++++++++--
 fs/adfs/super.c            |    8 +++++++-
 fs/affs/super.c            |   14 ++++----------
 fs/afs/super.c             |    5 +++++
 fs/autofs4/root.c          |   12 +++++++-----
 fs/bfs/inode.c             |    5 -----
 fs/cifs/cifsfs.c           |    9 +++------
 fs/coda/inode.c            |    8 +++++++-
 fs/ecryptfs/main.c         |    4 ++++
 fs/ext2/super.c            |    6 ++++--
 fs/ext3/super.c            |   13 -------------
 fs/ext4/super.c            |   11 -----------
 fs/fat/inode.c             |    5 -----
 fs/fat/namei_msdos.c       |    6 +++++-
 fs/fat/namei_vfat.c        |    6 +++++-
 fs/freevxfs/vxfs_super.c   |    7 ++++++-
 fs/hfs/super.c             |    6 +-----
 fs/hfsplus/super.c         |    5 -----
 fs/hpfs/super.c            |    8 +++++++-
 fs/isofs/dir.c             |    6 +++---
 fs/isofs/inode.c           |   16 +++++++++-------
 fs/isofs/namei.c           |    8 ++++----
 fs/isofs/rock.c            |    8 ++++----
 fs/jffs2/super.c           |   11 +++++++++--
 fs/jfs/super.c             |   23 +++++------------------
 fs/namespace.c             |    2 --
 fs/ncpfs/inode.c           |    8 +++++++-
 fs/nfs/super.c             |   24 ++++++++++++++++++++++++
 fs/nilfs2/ioctl.c          |    1 -
 fs/nilfs2/super.c          |   10 ----------
 fs/ntfs/super.c            |   24 ++----------------------
 fs/ocfs2/dlmfs/dlmfs.c     |    9 ++++++++-
 fs/ocfs2/super.c           |    5 +++++
 fs/qnx4/inode.c            |    8 +++++++-
 fs/reiserfs/super.c        |    2 --
 fs/smbfs/inode.c           |    5 +++++
 fs/squashfs/super.c        |    6 ++++++
 fs/udf/super.c             |    8 +++++++-
 fs/ufs/super.c             |    5 +++++
 kernel/cgroup.c            |    4 ----
 42 files changed, 193 insertions(+), 161 deletions(-)

commit 775d1df554071c7c5cef76ef1396645f9b942b94
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Sep 14 23:04:09 2010 +0200

    BKL: Remove the BKL from ReiserFS
    
    The BKL only got into reiserfs through the pushdown into
    ->fill_super. This function is already sufficiently
    serialized using reiserfs_write_lock(), so we can
    safely remove the BKL here.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit bccfa4989e5c8f7d05ac67ef05f50c228ffc034a
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Sep 14 23:00:34 2010 +0200

    BKL: Remove the BKL from autofs4
    
    autofs4 uses the BKL only to guard its ioctl operations.
    This can be trivially converted to use a mutex, as we have
    done with most device drivers before.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 146adfff904eab3e42096c03b53c5c650c17599f
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sun Sep 12 19:05:56 2010 +0200

    BKL: Remove the BKL from isofs
    
    As in other file systems, we can replace the big kernel lock
    with {un,}lock_super in isofs. This means we can now access
    multiple file systems concurrently, but it also means that
    we serialize readdir and lookup across sleeping operations
    which previously released the big kernel lock. This should
    not matter though, as these operations are in practice
    serialized through the hardware access.
    
    The isofs_get_blocks functions now does not take any lock
    any more, it used to recursively get the BKL. After looking
    at the code for hours, I convinced myself that it was never
    needed here anyway, because it only reads constant fields
    of the inode and writes to a buffer head array that is
    at this time only visible to the caller.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit e3b883a554f0c01d9728087608f6272d9e64cd16
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Sep 14 23:07:27 2010 +0200

    BKL: Remove BKL from fat
    
    The lock_kernel in fat_put_super is not needed because
    it only protects the super block itself and we know that
    no other thread can reach it because we are about to
    kfree the object.
    
    In the two fill_super functions, this converts the locking
    to use lock_super like elsewhere in the fat code. This
    is probably not needed either, but is consistent and puts
    us on the safe side.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Jan Blunck <jblunck@infradead.org>

commit 1e98080a9bb0c92af213578922204c1a44381a1e
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Sep 14 23:06:17 2010 +0200

    BKL: Remove the BKL from usbfs
    
    Nothing in there has a race that can be
    prevented by holding the BKL.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Jan Blunck <jblunck@infradead.org>

commit 7575131e6785e2a429bf89ce9820d0fc2734e42d
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:35 2010 +0100

    BKL: Remove BKL from ext2 filesystem
    
    The BKL is still used in ext2_put_super(), ext2_fill_super(), ext2_sync_fs()
    ext2_remount() and ext2_write_inode(). From these calls ext2_put_super(),
    ext2_fill_super() and ext2_remount() are protected against each other by
    the struct super_block s_umount rw semaphore. The call in ext2_write_inode()
    could only protect the modification of the ext2_sb_info through
    ext2_update_dynamic_rev() against concurrent ext2_sync_fs() or ext2_remount().
    ext2_fill_super() and ext2_put_super() can be left out because you need a
    valid filesystem reference in all three cases, which you do not have when
    you are one of these functions.
    
    If the BKL is only protecting the modification of the ext2_sb_info it can
    safely be removed since this is protected by the struct ext2_sb_info s_lock.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Cc: Jan Kara <jack@suse.cz>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 27b6567c293f995a32f0a60a5edb7455dc6662c1
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:35 2010 +0100

    BKL: Remove BKL from do_new_mount()
    
    After pushing down the BKL to the get_sb/fill_super operations of the
    filesystems that still make usage of the BKL it is safe to remove it from
    do_new_mount().
    
    I've read through all the code formerly covered by the BKL inside
    do_kern_mount() and have satisfied myself that it doesn't need the BKL
    any more.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Cc: Matthew Wilcox <matthew@wil.cx>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 8c8cc39da018a74b03c2c1dd4d984bca6752055a
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:34 2010 +0100

    BKL: Remove BKL from cgroup
    
    The BKL is only used in remount_fs and get_sb that are both protected by
    the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
    BKL entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 88d9c72994f5a27fc01e5a387ae8e2fbdc376123
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:33 2010 +0100

    BKL: Remove BKL from NTFS
    
    The BKL is only used in put_super, fill_super and remount_fs that are all
    three protected by the superblocks s_umount rw_semaphore. Therefore it is
    safe to remove the BKL entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 3fec873dc6e9026d98e2359202fa50fd06ee7b64
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:32 2010 +0100

    BKL: Remove BKL from NILFS2
    
    The BKL is only used in put_super, fill_super and remount_fs that are all
    three protected by the superblocks s_umount rw_semaphore. Therefore it is
    safe to remove the BKL entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 26cb2c8ba0e80612b03603e7f4748c2dc26deac7
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:31 2010 +0100

    BKL: Remove BKL from JFS
    
    The BKL is only used in put_super, fill_super and remount_fs that are all
    three protected by the superblocks s_umount rw_semaphore. Therefore it is
    safe to remove the BKL entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 45f8001fd75c01b5e4764e3a2805bc0910b72027
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:31 2010 +0100

    BKL: Remove BKL from HFS+
    
    The BKL is only used in put_super and fill_super that are both protected by
    the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
    BKL entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 8bf0e702e1a52c905af34e6d4de6a9a77de216bb
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:30 2010 +0100

    BKL: Remove BKL from HFS
    
    The BKL is only used in put_super and fill_super that are both protected by
    the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
    BKL entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 1d13f2441a25ba796288bcdc1643d25edce995a7
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:30 2010 +0100

    BKL: Remove BKL from ext4 filesystem
    
    The BKL is still used in ext4_put_super(), ext4_fill_super() and
    ext4_remount(). All three calles are protected against concurrent calls by
    the s_umount rw semaphore of struct super_block.
    
    Therefore the BKL is protecting nothing in this case.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Acked-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit fdfd042bef40385f71510fb24e5a1f28e930a360
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:30 2010 +0100

    BKL: Remove BKL from ext3_put_super() and ext3_remount()
    
    The BKL lock is protecting the remounting against a potential call to
    ext3_put_super(). This could not happen, since this is protected by the
    s_umount rw semaphore of struct super_block.
    
    Therefore I think the BKL is protecting nothing here.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Acked-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 5225ee24085c5acc4525bfc533589a746527de83
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:29 2010 +0100

    BKL: Remove BKL from ext3 fill_super()
    
    The BKL is protecting nothing than two memory allocations here.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Acked-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit f6e4131e7f3d18c84ea2c98b866d760d69b4ea6a
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:29 2010 +0100

    BKL: Remove BKL from CifsFS
    
    The BKL is only used in put_super and fill_super that are both protected by
    the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
    BKL entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Cc: Steve French <smfrench@gmail.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 1a2951923cea7a1c8e765f098db673dec2ef9f75
Author: Jan Blunck <jblunck@infradead.org>
Date:   Wed Feb 24 13:25:29 2010 +0100

    BKL: Remove BKL from BFS
    
    The BKL is only used in put_super and fill_super that are both protected by
    the superblocks s_umount rw_semaphore. Therefore it is safe to remove the BKL
    entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 18c1873e68959c970d7f0f72b8d05997a128a895
Author: Jan Blunck <jblunck@infradead.org>
Date:   Sun Aug 15 22:52:36 2010 +0200

    BKL: Remove BKL from Amiga FFS
    
    The BKL is only used in put_super, fill_super and remount_fs that are all
    three protected by the superblocks s_umount rw_semaphore. Therefore it is
    safe to remove the BKL entirely.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

commit 5cfc17f9036a43727c498ababa0ae79148bb4fb5
Author: Jan Blunck <jblunck@infradead.org>
Date:   Sun Aug 15 22:51:10 2010 +0200

    BKL: Explicitly add BKL around get_sb/fill_super
    
    This patch is a preparation necessary to remove the BKL from do_new_mount().
    It explicitly adds calls to lock_kernel()/unlock_kernel() around
    get_sb/fill_super operations for filesystems that still uses the BKL.
    
    I've read through all the code formerly covered by the BKL inside
    do_kern_mount() and have satisfied myself that it doesn't need the BKL
    any more.
    
    do_kern_mount() is already called without the BKL when mounting the rootfs
    and in nfsctl. do_kern_mount() calls vfs_kern_mount(), which is called
    from various places without BKL: simple_pin_fs(), nfs_do_clone_mount()
    through nfs_follow_mountpoint(), afs_mntpt_do_automount() through
    afs_mntpt_follow_link(). Both later functions are actually the filesystems
    follow_link inode operation. vfs_kern_mount() is calling the specified
    get_sb function and lets the filesystem do its job by calling the given
    fill_super function.
    
    Therefore I think it is safe to push down the BKL from the VFS to the
    low-level filesystems get_sb/fill_super operation.
    
    Signed-off-by: Jan Blunck <jblunck@infradead.org>
    Cc: Matthew Wilcox <matthew@wil.cx>
    Cc: Christoph Hellwig <hch@infradead.org>
    Cc: Arnd Bergmann <arnd@arndb.de>
