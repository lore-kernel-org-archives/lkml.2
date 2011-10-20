Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1JTXZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:25:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab1JTXZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:25:22 -0400
Date: Fri, 21 Oct 2011 01:25:20 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Michael Rubin <mrubin@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] writeback: requeue_io_wait() on pages_skipped inode
Message-ID: <20111020232520.GE20542@quack.suse.cz>
References: <20111020152240.751936131@intel.com>
 <20111020153706.265653153@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020153706.265653153@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-10-11 23:22:45, Wu Fengguang wrote:
> Use requeue_io_wait() if some pages were skipped due to locked buffers.
> 
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Michael Rubin <mrubin@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  Two signed-off-by?

Otherwise
  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-10-20 22:42:24.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-10-20 22:42:25.000000000 +0800
> @@ -618,11 +618,11 @@ static long writeback_sb_inodes(struct s
>  		if (wbc.pages_skipped) {
>  			/*
>  			 * writeback is not making progress due to locked
>  			 * buffers.  Skip this inode for now.
>  			 */
> -			redirty_tail(inode, wb);
> +			requeue_io_wait(inode, wb);
>  		}
>  		spin_unlock(&inode->i_lock);
>  		spin_unlock(&wb->list_lock);
>  		iput(inode);
>  		cond_resched();
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
