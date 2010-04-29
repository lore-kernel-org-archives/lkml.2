Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab0D3RKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:10:42 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33528 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757530Ab0D3RK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:10:28 -0400
Date: Thu, 29 Apr 2010 12:43:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] exofs: Fix "add bdi backing to mount session" fall out
Message-ID: <20100429104344.GH27497@kernel.dk>
References: <201004282059.o3SKx7hG029846@hera.kernel.org> <4BD95E7A.90402@panasas.com> <4BD96188.2030507@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD96188.2030507@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29 2010, Boaz Harrosh wrote:
> 
> The patch: add bdi backing to mount session
> 	(b3d0ab7e60d1865bb6f6a79a77aaba22f2543236)
> 
> Has a bug in the placement of the bdi member at
> struct exofs_sb_info. The layout member must be kept
> last.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  fs/exofs/exofs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
> index 5437327..22721b2 100644
> --- a/fs/exofs/exofs.h
> +++ b/fs/exofs/exofs.h
> @@ -85,6 +85,7 @@ struct exofs_sb_info {
>  	u32		s_next_generation;	/* next gen # to use          */
>  	atomic_t	s_curr_pending;		/* number of pending commands */
>  	uint8_t		s_cred[OSD_CAP_LEN];	/* credential for the fscb    */
> +	struct 		backing_dev_info bdi;	/* register our bdi with VFS  */
>  
>  	struct pnfs_osd_data_map data_map;	/* Default raid to use
>  						 * FIXME: Needed ?
> @@ -93,7 +94,6 @@ struct exofs_sb_info {
>  	struct exofs_layout	layout;		/* Default files layout,
>  						 * contains the variable osd_dev
>  						 * array. Keep last */
> -	struct backing_dev_info bdi;
>  	struct osd_dev	*_min_one_dev[1];	/* Place holder for one dev   */
>  };

Irk, silly mistake. Apparently I missed the comment, and I did move it
prior to _min_one_dev[] but didn't think enough about it.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

