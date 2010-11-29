Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab0K2JTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:19:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0K2JTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:19:21 -0500
Date: Mon, 29 Nov 2010 04:19:20 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 3/3] xfs: demultiplex xfs_icsb_modify_counters()
Message-ID: <20101129091920.GB13902@infradead.org>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
 <1290991002-18680-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290991002-18680-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:36:41AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the conversion to percpu counters, xfs_icsb_modify_counters() really does
> not need to exist. Convert the inode counter modifications to use a common
> helper function for the one place that calls them, and add another function for
> the free block modification and convert all the callers to use that.

> +xfs_icsb_modify_inodes(
> +	xfs_mount_t	*mp,

struct xfs_mount, please.

> +	int		cntr,
> +	int64_t		delta,
> +	int		rsvd)

the rsvd argument isn't used at all.

> +{
> +	int		ret = 0;
> +
> +	ASSERT(cntr == XFS_ICSB_ICOUNT || cntr == XFS_ICSB_IFREE);
> +
> +	ret = xfs_icsb_add(mp, cntr, delta, 0);
> +	if (ret < 0) {
> +		ASSERT(0);
> +		return XFS_ERROR(EINVAL);
> +	}
> +	return 0;

You could get rdif of the ret argument as we don't care about the
value.  I also don't think we need the assert here - the caller already
does one for us.

> +xfs_icsb_modify_free_blocks(
> +	xfs_mount_t	*mp,

same here.

