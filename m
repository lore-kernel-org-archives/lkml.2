Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab2GTBwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:52:41 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:57958 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752589Ab2GTBwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:52:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmsKACG5CFB5LBuu/2dsb2JhbABFhQ6zAAOBKoEIgiABAQQBOhwjBQsIAw4GAQMuFCUDIROIBwW+eBSLOIE3hSkDlUOBFIgWhmCCcQ
Date: Fri, 20 Jul 2012 11:52:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Paulo Alcantara <pcacjr@zytor.com>
Cc: hch@infradead.org, baozich@gmail.com, bpm@sgi.com,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
Message-ID: <20120720015226.GJ23387@dastard>
References: <20120716151038.GI29979@sgi.com>
 <5292013E-6FF3-47F6-BE9F-FD7BA2BB2AA9@gmail.com>
 <20120717070643.GA4958@infradead.org>
 <20120717.224021.707783566146599004.pcacjr@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717.224021.707783566146599004.pcacjr@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 10:40:21PM -0300, Paulo Alcantara wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Tue, 17 Jul 2012 03:06:43 -0400
> 
> > Btw, if you need more reviers for the syslinus support feel free to pass
> > it by me (or the list).
> 
> This is the branch I'm maintaing for the XFS readonly driver:
> 
> git://zytor.com/users/pcacjr/syslinux.git (branch: xfs)
> 
> The current status is:
> 
>     - We are able to find the root inode by reading rootino field from
>       superblock (xfs_iget_root() function).
>     - We are able to find inodes that have core's format set to "local" only at
>       the moment, which is by reading leaf entries from inode btrees. The
>       function that looks up for an inode is the xfs_iget() one. We're looking
>       forward to implement the handling of keys in inode btrees (extents) also.
> 
> Baoszi is currently working on the inode btree's key part (extents), and I'm
> working on the data part of the file inode, which is the xfs_next_extent()
> function.
> 
> The xfs_next_extent() function must be able to read the inode (cast to the data
> fork) and populate a structure that stores physical starting number sector and
> number of consecutive sectors that contain the inode's data so that Syslinux
> will know where to read from.

As we discussed on #xfs, I'm still not convinced that parsing the
filesystem metadata in the bootloader is the way to go. Far better,
IMO, is simply to supply the bootloader with a list of extents for
the blocks it needs to read to get the files it needs. You can get
them via fiemap(), and it'll work for XFS, btrfs, ext3, ext4, etc
without needing to write code to parse the on-disk format of every
filesystem.

Especially as we are in the process of making major changes to the
XFS on-disk format, which means you'll have to make significant
changes to support a second XFS disk format in the not-to-distant
future...

> Thanks for the interest in helping us!

We want it to work! ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
