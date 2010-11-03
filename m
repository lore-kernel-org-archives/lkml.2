Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0KCQLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:11:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56427 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0KCQLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:11:38 -0400
Date: Wed, 3 Nov 2010 12:10:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/5] block: make blkdev_get/put() handle exclusive access
Message-ID: <20101103161059.GA13621@infradead.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
 <1288628129-12811-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288628129-12811-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 05:15:28PM +0100, Tejun Heo wrote:
> * blkdev_get() is extended to include exclusive access management.
>   @holder argument is added and, if is @FMODE_EXCL specified, it will
>   gain exclusive access atomically w.r.t. other exclusive accesses.
> 
> * blkdev_put() is similarly extended.  It now takes @mode argument and
>   if @FMODE_EXCL is set, it releases an exclusive access.  Also, when
>   the last exclusive claim is released, the holder/slave symlinks are
>   removed automatically.

Could we get rid of FMODE_EXCL and just make a non-NULL holder field
mean to open it exlusively (and pass a holder to the blkdev_put to
release it)?

> * bd_link_disk_holder() remains the same but bd_unlink_disk_holder()
>   is no longer necessary and removed.

That's a rather asymetric interface.  What about having
blkdev_get_stacked that require a gendisk as holder and set up the
links underneath?


> open_bdev_exclusive() and open_by_devnum() can use further cleanup -
> rename to blkdev_get_by_path() and blkdev_get_by_devt() and drop
> special features.  Well, let's leave them for another day.

s/blkdev_get_by_devt/blkdev_get_by_dev/

And yes, that rename is a good idea and should go in ASAP after this
patch.

