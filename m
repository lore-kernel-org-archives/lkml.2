Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2GCOpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:45:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab2GCOpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:45:20 -0400
Date: Tue, 3 Jul 2012 10:45:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com,
        martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v2 1/3] block: add sysfs entry for
 discard_alignment
Message-ID: <20120703144509.GA15612@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
 <1341235225-27551-2-git-send-email-pbonzini@redhat.com>
 <20120703023442.GB3586@redhat.com>
 <4FF2DCB1.2090704@redhat.com>
 <20120703140048.GC11272@redhat.com>
 <4FF2FFEE.4000401@redhat.com>
 <20120703143949.GE11272@redhat.com>
 <4FF30468.30407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF30468.30407@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 04:40:40PM +0200, Paolo Bonzini wrote:
> Il 03/07/2012 16:39, Vivek Goyal ha scritto:
> >> > +static inline int bdev_discard_alignment(struct block_device *bdev)
> >> > +{
> >> > +	struct request_queue *q = bdev_get_queue(bdev);
> >> > +
> >> > +	if (bdev != bdev->bd_contains)
> >> > +		return bdev->bd_part->discard_alignment;
> >> > +
> >> > +	return q->limits.discard_alignment;
> >> > +}
> >> > +
> >> >  static inline unsigned int queue_discard_zeroes_data(struct request_queue *q)
> >> >  {
> >> >  	if (q->limits.max_discard_sectors && q->limits.discard_zeroes_data == 1)
> >> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> >> > index b2bde5c..77d8869 100644
> >> > --- a/block/blk-lib.c
> >> > +++ b/block/blk-lib.c
> >> > @@ -58,7 +58,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
> >> >  	/* Zero-sector (unknown) and one-sector granularities are the same.  */
> >> >  	granularity = max(q->limits.discard_granularity >> 9, 1U);
> >> >  	mask = granularity - 1;
> >> > -	alignment = (q->limits.discard_alignment >> 9) & mask;
> >> > +	alignment = bdev_discard_alignment(bdev) >> 9;
> > Why are you removing AND with mask operation? I don't see any AND
> > operation being done in bdev_discard_alignment().
> 
> For partitions it is done by queue_limits_discard_alignment.  For disks,
> it shouldn't be necessary at all but I can leave it.

Ok. I am fine with both with and without mask.

Thanks
Vivek
