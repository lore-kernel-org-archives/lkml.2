Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0KKTVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:21:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab0KKTVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:21:06 -0500
Subject: Re: [PATCH 7/5] block: clean up blkdev_get() wrappers and their
 users
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, shaggy@linux.vnet.ibm.com, joern@logfs.org,
        konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org,
        viro@zeniv.linux.org.uk, philipp.reisner@linbit.com,
        snitzer@redhat.com
In-Reply-To: <4CDC23BB.10505@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
	 <4CDC23BB.10505@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 11 Nov 2010 19:19:18 +0000
Message-ID: <1289503158.2451.18.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2010-11-11 at 18:11 +0100, Tejun Heo wrote:
> After recent blkdev_get() modifications, open_by_devnum() and
> open_bdev_exclusive() are simple wrappers around blkdev_get().
> Replace them with blkdev_get_by_dev() and blkdev_get_by_path().
> 
> blkdev_get_by_dev() is identical to open_by_devnum().
> blkdev_get_by_path() is slightly different in that it doesn't
> automatically add %FMODE_EXCL to @mode.
> 
> All users are converted.  Most conversions are mechanical and don't
> introduce any behavior difference.  There are several exceptions.
> 
> * btrfs now sets FMODE_EXCL in btrfs_device->mode, so there's no
>   reason to OR it explicitly on blkdev_put().
> 
> * gfs2, nilfs2 and the generic mount_bdev() now set FMODE_EXCL in
>   sb->s_mode.
> 
> * With the above changes, sb->s_mode now always should contain
>   FMODE_EXCL.  WARN_ON_ONCE() added to kill_block_super() to detect
>   errors.
> 
> The new blkdev_get_*() functions are with proper docbook comments.
> While at it, add function description to blkdev_get() too.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Philipp Reisner <philipp.reisner@linbit.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Joern Engel <joern@lazybastard.org>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
> Cc: reiserfs-devel@vger.kernel.org
> Cc: xfs-masters@oss.sgi.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.


