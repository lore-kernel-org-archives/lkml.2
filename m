Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1JMHIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:08:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46849 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1JMHId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:08:33 -0400
Message-ID: <4E968EE7.2080803@jp.fujitsu.com>
Date: Thu, 13 Oct 2011 16:10:31 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: toshi.okajima@jp.fujitsu.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, hch@infradead.org, akpm@linux-foundation.org,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/13] read-only remount race fix v7
References: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1318430946-7091-1-git-send-email-miklos@szeredi.hu>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

(2011/10/12 23:48), Miklos Szeredi wrote:
> Here's an update of the read-only remount race fixes.
> 
> It should now fix the races after unlink.  I haven't been able to
> trigger the bad behavior with the test scripts provided by Toshiyuki
> Okajima.
> 
> Toshiyuki-san, could you please test these patches too?
OK. I will test them with ext4. Please wait.

Best Regards,
Toshiyuki Okajima

> 
> Thanks,
> Miklos
> ---
> 
> Miklos Szeredi (13):
>       vfs: ignore error on forced remount
>       vfs: keep list of mounts for each superblock
>       vfs: protect remounting superblock read-only
>       vfs: fs_may_remount_ro: turn unnecessary check into a WARN_ON
>       hypfs: remove unnecessary nlink setting
>       jfs: remove unnecessary nlink setting
>       ocfs2: remove unnecessary nlink setting
>       logfs: remove unnecessary nlink setting
>       filesystems: add missing nlink wrappers
>       filesystems: add set_nlink()
>       vfs: protect i_nlink
>       vfs: count unlinked inodes
>       vfs: prevent remount read-only if pending removes
> 
> ---
>  arch/s390/hypfs/inode.c          |    6 +--
>  drivers/mtd/mtdchar.c            |    2 +-
>  drivers/staging/pohmelfs/inode.c |    2 +-
>  fs/9p/vfs_inode.c                |    4 +-
>  fs/9p/vfs_inode_dotl.c           |    4 +-
>  fs/adfs/inode.c                  |    2 +-
>  fs/affs/amigaffs.c               |    4 +-
>  fs/affs/inode.c                  |    8 ++--
>  fs/affs/namei.c                  |    6 +-
>  fs/afs/fsclient.c                |    2 +-
>  fs/afs/inode.c                   |    4 +-
>  fs/autofs4/inode.c               |    2 +-
>  fs/befs/linuxvfs.c               |    2 +-
>  fs/bfs/dir.c                     |    2 +-
>  fs/bfs/inode.c                   |    2 +-
>  fs/binfmt_misc.c                 |    2 +-
>  fs/btrfs/delayed-inode.c         |    2 +-
>  fs/btrfs/disk-io.c               |    2 +-
>  fs/btrfs/inode.c                 |    4 +-
>  fs/btrfs/tree-log.c              |    2 +-
>  fs/ceph/caps.c                   |    2 +-
>  fs/ceph/inode.c                  |    2 +-
>  fs/cifs/inode.c                  |    6 +-
>  fs/cifs/link.c                   |    2 +-
>  fs/coda/coda_linux.c             |    2 +-
>  fs/coda/dir.c                    |    2 +-
>  fs/devpts/inode.c                |    4 +-
>  fs/ecryptfs/inode.c              |   12 +++---
>  fs/efs/inode.c                   |    2 +-
>  fs/exofs/inode.c                 |    2 +-
>  fs/ext2/ialloc.c                 |    2 +-
>  fs/ext2/inode.c                  |    2 +-
>  fs/ext3/ialloc.c                 |    2 +-
>  fs/ext3/inode.c                  |    2 +-
>  fs/ext3/namei.c                  |    6 +-
>  fs/ext4/ialloc.c                 |    2 +-
>  fs/ext4/inode.c                  |    2 +-
>  fs/ext4/migrate.c                |    2 +-
>  fs/ext4/namei.c                  |    8 ++--
>  fs/fat/inode.c                   |    4 +-
>  fs/fat/namei_msdos.c             |    2 +-
>  fs/fat/namei_vfat.c              |    2 +-
>  fs/file_table.c                  |   23 ----------
>  fs/freevxfs/vxfs_inode.c         |    2 +-
>  fs/fuse/control.c                |    2 +-
>  fs/fuse/inode.c                  |    2 +-
>  fs/gfs2/glops.c                  |    2 +-
>  fs/hfs/dir.c                     |    4 +-
>  fs/hfs/inode.c                   |    4 +-
>  fs/hfsplus/dir.c                 |    4 +-
>  fs/hfsplus/inode.c               |   10 ++--
>  fs/hostfs/hostfs_kern.c          |    2 +-
>  fs/hpfs/dir.c                    |    2 +-
>  fs/hpfs/inode.c                  |   10 ++--
>  fs/hpfs/namei.c                  |    8 ++--
>  fs/hppfs/hppfs.c                 |    2 +-
>  fs/hugetlbfs/inode.c             |    2 +-
>  fs/inode.c                       |   83 +++++++++++++++++++++++++++++++++++++-
>  fs/internal.h                    |    1 +
>  fs/isofs/inode.c                 |    4 +-
>  fs/isofs/rock.c                  |    4 +-
>  fs/jffs2/dir.c                   |    6 +-
>  fs/jffs2/fs.c                    |    6 +-
>  fs/jfs/jfs_imap.c                |    6 +-
>  fs/jfs/jfs_inode.c               |    2 +-
>  fs/jfs/namei.c                   |   12 +++---
>  fs/jfs/super.c                   |    1 -
>  fs/libfs.c                       |    2 +-
>  fs/logfs/dir.c                   |    8 ++--
>  fs/logfs/inode.c                 |    3 +-
>  fs/logfs/readwrite.c             |    2 +-
>  fs/minix/inode.c                 |    4 +-
>  fs/namespace.c                   |   57 +++++++++++++++++++++++++-
>  fs/ncpfs/inode.c                 |    2 +-
>  fs/nfs/inode.c                   |    6 +-
>  fs/nilfs2/inode.c                |    4 +-
>  fs/nilfs2/namei.c                |    2 +-
>  fs/ntfs/inode.c                  |    8 ++--
>  fs/ocfs2/dir.c                   |    4 +-
>  fs/ocfs2/dlmglue.c               |    2 +-
>  fs/ocfs2/inode.c                 |    4 +-
>  fs/ocfs2/namei.c                 |   18 ++++-----
>  fs/openpromfs/inode.c            |    4 +-
>  fs/proc/base.c                   |   12 +++---
>  fs/proc/generic.c                |    2 +-
>  fs/proc/inode.c                  |    2 +-
>  fs/proc/proc_sysctl.c            |    2 +-
>  fs/qnx4/inode.c                  |    2 +-
>  fs/reiserfs/inode.c              |   10 ++--
>  fs/reiserfs/namei.c              |   16 ++++----
>  fs/romfs/super.c                 |    2 +-
>  fs/squashfs/inode.c              |   18 ++++----
>  fs/stack.c                       |    2 +-
>  fs/super.c                       |   27 ++++++++++--
>  fs/sysfs/inode.c                 |    2 +-
>  fs/sysv/inode.c                  |    2 +-
>  fs/ubifs/super.c                 |    2 +-
>  fs/ubifs/xattr.c                 |    4 +-
>  fs/udf/inode.c                   |    8 ++-
>  fs/udf/namei.c                   |   15 +++----
>  fs/ufs/ialloc.c                  |    2 +-
>  fs/ufs/inode.c                   |    4 +-
>  fs/xfs/xfs_iops.c                |    2 +-
>  include/linux/fs.h               |   66 ++++++++++--------------------
>  include/linux/mount.h            |    1 +
>  mm/shmem.c                       |    2 +-
>  106 files changed, 389 insertions(+), 286 deletions(-)
> 
> 
> 

