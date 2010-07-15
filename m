Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017Ab0GOSKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:10:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43908 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933954Ab0GOSK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:10:26 -0400
Date: Thu, 15 Jul 2010 14:10:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] xfs: convert inode shrinker to per-filesystem
 contexts
Message-ID: <20100715181025.GB14554@infradead.org>
References: <1279194418-16119-1-git-send-email-david@fromorbit.com>
 <1279194418-16119-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279194418-16119-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 09:46:57PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now the shrinker passes us a context, wire up a shrinker context per
> filesystem. This allows us to remove the global mount list and the
> locking problems that introduced. It also means that a shrinker call
> does not need to traverse clean filesystems before finding a
> filesystem with reclaimable inodes.  This significantly reduces
> scanning overhead when lots of filesystems are present.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_super.c |    2 -
>  fs/xfs/linux-2.6/xfs_sync.c  |   62 +++++++++--------------------------------
>  fs/xfs/linux-2.6/xfs_sync.h  |    2 -
>  fs/xfs/xfs_mount.h           |    2 +-
>  4 files changed, 15 insertions(+), 53 deletions(-)

And makes the code a lot simpler and more obvious.


Reviewed-by: Christoph Hellwig <hch@lst.de>

