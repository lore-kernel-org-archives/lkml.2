Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1CaEhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 00:37:17 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52516 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1CaEhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 00:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=AcqXKRuoTqmn5fChd9v37kOU8
	2by4lAnIORtjLMMN/lYlKsYn2rlvfSj7m4tQ0CoAbcjf3au2WwXsfrsdlD9YOxUD
	ksdBLkyhDNhwziAlc07o3klPGbxSqqgqTE7TyDLlKXgwpI+h55tchwZ9sWtgbos4
	VkMUM+KqHGrvDIgRLA=
Date: Wed, 30 Mar 2011 21:40:15 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Dave Chinner <david@fromorbit.com>
cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Subject: Re: [PATCH 4/7] vfs: push dentry_unhash on rename_dir into file
 systems
In-Reply-To: <20110331030926.GB30279@dastard>
Message-ID: <Pine.LNX.4.64.1103302133090.6767@cobra.newdream.net>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
 <1301522968-4382-5-git-send-email-sage@newdream.net> <20110331030926.GB30279@dastard>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Dave Chinner wrote:
> On Wed, Mar 30, 2011 at 03:09:25PM -0700, Sage Weil wrote:
> > Only a few file systems need this.  Start by pushing it down into each
> > rename method so that it can be dealt with on a per-fs basis.
> 
> What is the criteria for a filesystem needing this?

As I understand it, it's normally just a question of whether the FS can 
handle references to the directory's struct inode and dentry after they've 
been unlinked.  A few file systems bail out of rmdir/rename if 
!d_unhashed(dentry) (dentry_unhash() doesn't unhash if there are any other 
dentry references).

All but a handful of file systems should be able to drop the dentry_unhash 
entirely.

> > Signed-off-by: Sage Weil <sage@newdream.net>
> > ---
> >  fs/9p/vfs_inode.c       |    3 +++
> >  fs/affs/namei.c         |    3 +++
> >  fs/afs/dir.c            |    3 +++
> >  fs/bfs/dir.c            |    3 +++
> >  fs/btrfs/inode.c        |    3 +++
> >  fs/ceph/dir.c           |    3 +++
> >  fs/cifs/inode.c         |    3 +++
> >  fs/coda/dir.c           |    3 +++
> >  fs/ecryptfs/inode.c     |    3 +++
> >  fs/exofs/namei.c        |    3 +++
> >  fs/ext2/namei.c         |    3 +++
> >  fs/ext3/namei.c         |    3 +++
> >  fs/ext4/namei.c         |    3 +++
> >  fs/fat/namei_msdos.c    |    3 +++
> >  fs/fat/namei_vfat.c     |    3 +++
> >  fs/fuse/dir.c           |    4 ++++
> >  fs/gfs2/ops_inode.c     |    3 +++
> >  fs/hfs/dir.c            |    3 +++
> >  fs/hostfs/hostfs_kern.c |    3 +++
> >  fs/hpfs/namei.c         |    4 ++++
> >  fs/jffs2/dir.c          |    3 +++
> >  fs/jfs/namei.c          |    3 +++
> >  fs/libfs.c              |    3 +++
> >  fs/logfs/dir.c          |    3 +++
> >  fs/minix/namei.c        |    3 +++
> >  fs/namei.c              |    5 +----
> >  fs/ncpfs/dir.c          |    3 +++
> >  fs/nfs/dir.c            |    3 +++
> >  fs/nilfs2/namei.c       |    3 +++
> >  fs/ocfs2/namei.c        |    3 +++
> >  fs/omfs/dir.c           |    3 +++
> >  fs/reiserfs/namei.c     |    3 +++
> >  fs/sysv/namei.c         |    3 +++
> >  fs/ubifs/dir.c          |    3 +++
> >  fs/udf/namei.c          |    3 +++
> >  fs/ufs/namei.c          |    3 +++
> >  36 files changed, 108 insertions(+), 4 deletions(-)
> 
> You didn't push it down into XFS, hence my question....

Whoops... I was grepping for .rmdir and .rename in fs/*.c.  I'll fix it 
up.

sage
