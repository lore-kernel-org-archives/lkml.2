Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab0KDPFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0KDPFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:05:47 -0400
Date: Thu, 4 Nov 2010 11:04:00 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, jack@suse.cz, leochen@broadcom.com,
        heiko.carstens@de.ibm.com, adilger.kernel@dilger.ca,
        konishi.ryusuke@lab.ntt.co.jp, shaggy@linux.vnet.ibm.com,
        drbd-dev@lists.linbit.com, joel.becker@oracle.com, hch@infradead.org,
        aelder@sgi.com, mfasheh@suse.com, joern@logfs.org,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
        swhiteho@redhat.com, chris.mason@oracle.com, axboe@kernel.dk,
        tytso@mit.edu, sbranden@broadcom.com, petero2@telia.com,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 4/5] block: make blkdev_get/put() handle exclusive access
Message-ID: <20101104150400.GA32504@redhat.com>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
 <1288628129-12811-5-git-send-email-tj@kernel.org>
 <20101103161059.GA13621@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101103161059.GA13621@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03 2010 at 12:10pm -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Nov 01, 2010 at 05:15:28PM +0100, Tejun Heo wrote:
> > * blkdev_get() is extended to include exclusive access management.
> >   @holder argument is added and, if is @FMODE_EXCL specified, it will
> >   gain exclusive access atomically w.r.t. other exclusive accesses.
> > 
> > * blkdev_put() is similarly extended.  It now takes @mode argument and
> >   if @FMODE_EXCL is set, it releases an exclusive access.  Also, when
> >   the last exclusive claim is released, the holder/slave symlinks are
> >   removed automatically.
> 
> Could we get rid of FMODE_EXCL and just make a non-NULL holder field
> mean to open it exlusively (and pass a holder to the blkdev_put to
> release it)?

I agree that the need for a FMODE_EXCL flag is awkward.  Christoph's
proposed change should clean things up nicely.

Other than that, for the DM bits:

Acked-by: Mike Snitzer <snitzer@redhat.com>
