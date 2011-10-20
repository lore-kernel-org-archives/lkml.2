Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1JTXbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:31:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab1JTXby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:31:54 -0400
Date: Fri, 21 Oct 2011 01:31:49 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] writeback: requeue_io_wait() on blocked inode
Message-ID: <20111020233149.GG20542@quack.suse.cz>
References: <20111020152240.751936131@intel.com>
 <20111020153706.397951190@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020153706.397951190@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-10-11 23:22:46, Wu Fengguang wrote:
> Use requeue_io_wait() if inode is somehow blocked.
> 
> CC: Jan Kara <jack@suse.cz>
> CC: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-10-20 22:42:25.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-10-20 22:43:42.000000000 +0800
> @@ -471,25 +471,25 @@ writeback_single_inode(struct inode *ino
>  				/*
>  				 * slice used up: queue for next turn
>  				 */
>  				requeue_io(inode, wb);
>  			} else {
>  				/*
>  				 * Writeback blocked by something other than
>  				 * congestion. Delay the inode for some time to
>  				 * avoid spinning on the CPU (100% iowait)
>  				 * retrying writeback of the dirty page/inode
>  				 * that cannot be performed immediately.
>  				 */
> -				redirty_tail(inode, wb);
> +				requeue_io_wait(inode, wb);
>  			}
>  		} else if (inode->i_state & I_DIRTY) {
>  			/*
>  			 * Filesystems can dirty the inode during writeback
>  			 * operations, such as delayed allocation during
>  			 * submission or metadata updates after data IO
>  			 * completion.
>  			 *
>  			 * For the latter case it is very important to give
>  			 * the inode another turn on b_more_io instead of
>  			 * redirtying it.  Constantly moving dirtied_when
>  			 * forward will prevent us from ever writing out
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
