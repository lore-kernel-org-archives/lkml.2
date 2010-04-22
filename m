Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0DVTJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:09:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0DVTJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:09:35 -0400
Date: Thu, 22 Apr 2010 21:09:37 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH 4/4] xfs: remove nr_to_write writeback windup.
Message-ID: <20100422190936.GB19286@quack.suse.cz>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
 <1271731314-5893-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271731314-5893-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-04-10 12:41:54, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the background flush code has been fixed, we shouldn't need to
> silently multiply the wbc->nr_to_write to get good writeback. Remove
> that code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_aops.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
> index 9962850..2b2225d 100644
> --- a/fs/xfs/linux-2.6/xfs_aops.c
> +++ b/fs/xfs/linux-2.6/xfs_aops.c
> @@ -1336,14 +1336,6 @@ xfs_vm_writepage(
>  	if (!page_has_buffers(page))
>  		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
>  
> -
> -	/*
> -	 *  VM calculation for nr_to_write seems off.  Bump it way
> -	 *  up, this gets simple streaming writes zippy again.
> -	 *  To be reviewed again after Jens' writeback changes.
> -	 */
> -	wbc->nr_to_write *= 4;
> -
  Hum, are you sure about this? I thought it's there because VM passes at
most 1024 pages to write from background writeback and you wanted to write
more in one go (at least ext4 wants to do this).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
