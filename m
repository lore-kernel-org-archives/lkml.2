Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab1JTXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:25:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1JTXZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:25:55 -0400
Date: Fri, 21 Oct 2011 01:25:53 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] writeback: requeue_io_wait() when failed to grab
 superblock
Message-ID: <20111020232553.GF20542@quack.suse.cz>
References: <20111020152240.751936131@intel.com>
 <20111020153706.523067174@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020153706.523067174@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-10-11 23:22:47, Wu Fengguang wrote:
> It's some block condition that's not really related to the inode, but
> still need to move it to b_more_io_wait to prevent possible busy looping.
> 
> CC: Jan Kara <jack@suse.cz>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/fs-writeback.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-10-20 22:43:42.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-10-20 22:46:53.000000000 +0800
> @@ -652,17 +652,17 @@ static long __writeback_inodes_wb(struct
>  		struct super_block *sb = inode->i_sb;
>  
>  		if (!grab_super_passive(sb)) {
>  			/*
>  			 * grab_super_passive() may fail consistently due to
>  			 * s_umount being grabbed by someone else. Don't use
>  			 * requeue_io() to avoid busy retrying the inode/sb.
>  			 */
> -			redirty_tail(inode, wb);
> +			requeue_io_wait(inode, wb);
>  			continue;
>  		}
>  		wrote += writeback_sb_inodes(sb, wb, work);
>  		drop_super(sb);
>  
>  		/* refer to the same tests at the end of writeback_sb_inodes */
>  		if (wrote) {
>  			if (time_is_before_jiffies(start_time + HZ / 10UL))
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
