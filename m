Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1CQFpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 01:45:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1CQFpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 01:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z6jfeK606UpgGM2ocFOvjOXlqnXYjc2pXh1GrOrfmm/WpU9rqD+vgaVCrqGbBZt5cC
         UsW9vkmY1Zky2CtAN9RHPrpAOkS71T5xStmHUxivmH5GVE9oF+DlUcq3vaLqi4+sPqni
         ioO47MUSE7nGTeW3m+uIYscKfOarJAkfBHQpk=
MIME-Version: 1.0
In-Reply-To: <20110316235608.GY22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
Date: Thu, 17 Mar 2011 13:45:33 +0800
Message-ID: <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
Subject: Re: [git pull] mnt_devname queue
From: Xiaotian Feng <xtfeng@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 7:56 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        Kills ->mnt_devname mangling in NFS, completes switch from ->get_sb()
> to ->mount() (and kills the remnants of ->get_sb() helpers), makes /proc/mounts
> and /proc/*/mountinfo show the right thing after mount --bind on NFS.  Trond
> has ACKed the nfs side of things and suggested to push through the vfs tree,
> so please pull from
> git:git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ mnt_devname
>
> Shortlog:
> Al Viro (8):
>      nfs: propagate devname to nfs{,4}_get_root()
>      nfs: store devname at disconnected NFS roots
>      nfs: make nfs_path() work without vfsmount
>      nfs: nfs_do_{ref,sub}mount() superblock argument is redundant
>      vfs: new superblock methods to override /proc/*/mount{s,info}
>      nfs: stop mangling ->mnt_devname on NFS
>      nfs: switch NFS from ->get_sb() to ->mount()
>      vfs: bury ->get_sb()

I guess we need also switch pstore from ->get_sb() to ->mount()

fs/pstore/inode.c:253: error: unknown field ‘get_sb’ specified in initializer
fs/pstore/inode.c:253: warning: initialization makes integer from
pointer without a cast
fs/pstore/inode.c:253: error: initializer element is not computable at load time
fs/pstore/inode.c:253: error: (near initialization for
‘pstore_fs_type.fs_flags’)

>
> Diffstat:
>  Documentation/filesystems/Locking |    6 +-
>  Documentation/filesystems/porting |    7 ++
>  Documentation/filesystems/vfs.txt |   56 ++++++-----
>  fs/namespace.c                    |   39 ++++++--
>  fs/nfs/dir.c                      |   13 +++
>  fs/nfs/getroot.c                  |   42 +++++++-
>  fs/nfs/internal.h                 |   21 ++--
>  fs/nfs/namespace.c                |   66 ++++++++-----
>  fs/nfs/nfs4namespace.c            |   41 +++-----
>  fs/nfs/super.c                    |  194 +++++++++++++++++++------------------
>  fs/nfs/unlink.c                   |   20 ++++
>  fs/super.c                        |   67 +------------
>  include/linux/fs.h                |   16 +---
>  13 files changed, 316 insertions(+), 272 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
