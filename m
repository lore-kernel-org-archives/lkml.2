Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0K3Eia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:38:30 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:39028 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753172Ab0K3Ei3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:38:29 -0500
Date: Tue, 30 Nov 2010 15:38:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 3/3] xfs: demultiplex xfs_icsb_modify_counters()
Message-ID: <20101130043817.GE3556@dastard>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
 <1290991002-18680-4-git-send-email-david@fromorbit.com>
 <20101129091920.GB13902@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129091920.GB13902@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 04:19:20AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 11:36:41AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With the conversion to percpu counters, xfs_icsb_modify_counters() really does
> > not need to exist. Convert the inode counter modifications to use a common
> > helper function for the one place that calls them, and add another function for
> > the free block modification and convert all the callers to use that.
> 
> > +xfs_icsb_modify_inodes(
> > +	xfs_mount_t	*mp,
> 
> struct xfs_mount, please.
> 
> > +	int		cntr,
> > +	int64_t		delta,
> > +	int		rsvd)
> 
> the rsvd argument isn't used at all.
> 
> > +{
> > +	int		ret = 0;
> > +
> > +	ASSERT(cntr == XFS_ICSB_ICOUNT || cntr == XFS_ICSB_IFREE);
> > +
> > +	ret = xfs_icsb_add(mp, cntr, delta, 0);
> > +	if (ret < 0) {
> > +		ASSERT(0);
> > +		return XFS_ERROR(EINVAL);
> > +	}
> > +	return 0;
> 
> You could get rdif of the ret argument as we don't care about the
> value.  I also don't think we need the assert here - the caller already
> does one for us.
> 
> > +xfs_icsb_modify_free_blocks(
> > +	xfs_mount_t	*mp,
> 
> same here.

Ok, makes sense. I'll clean it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
