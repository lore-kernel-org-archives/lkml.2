Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab1GDE61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 00:58:27 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:58114 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab1GDE6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 00:58:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFBHEU55LCkB/2dsb2JhbABSp3t4iHrCLQ6GKASaTIgy
Date: Mon, 4 Jul 2011 14:58:20 +1000
From: Dave Chinner <david@fromorbit.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 3/7] xfs: there is no CONFIG_KDB_MODULES
Message-ID: <20110704045820.GE1026@dastard>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309643272-364-4-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 12:47:48AM +0300, Phil Carmody wrote:

Hi Phil,

You should probably cc the relevant lists with such patchsets so the
developers actually see the patches go by....

> Seems like there was a decade ago, but no longer, so this block
> is dead code. The list being returned disappeared back in commit
> ff57ab21995a8636cfc72efeebb09cc6034d756f.

When you quote a commit, short form followed by the name (i.e.
one-line form) is preferable because it gives context to the commit
without needing to go look it up in a git tree. Commit IDs are not
human readable, while commit log should be.

The commit in question - ff57ab2 ("xfs: convert xfsbud shrinker to a
per-buftarg shrinker.") - removed the list but the code being
removed was already long dead. FWIW, I know just by reading the
commit description when the list went away and who was responsible
for missing that. i.e. me. ;)

> Part of a shotgun patchset; found by greps, seds, and diffs
> rather than actual understanding.

Not necessary in a commit description - the zero patch of a series,
yes, to describe how the issues were found, but it doesn't need to
be recorded forever in the commit log. ;)

> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    8 --------
>  fs/xfs/linux-2.6/xfs_buf.h |    4 ----
>  2 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 5e68099..5bccae0 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1889,11 +1889,3 @@ xfs_buf_terminate(void)
>  	destroy_workqueue(xfslogd_workqueue);
>  	kmem_zone_destroy(xfs_buf_zone);
>  }
> -
> -#ifdef CONFIG_KDB_MODULES
> -struct list_head *
> -xfs_get_buftarg_list(void)
> -{
> -	return &xfs_buftarg_list;
> -}
> -#endif
> diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
> index 50a7d5f..6881321 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.h
> +++ b/fs/xfs/linux-2.6/xfs_buf.h
> @@ -339,10 +339,6 @@ extern void xfs_wait_buftarg(xfs_buftarg_t *);
>  extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
>  extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
>  
> -#ifdef CONFIG_KDB_MODULES
> -extern struct list_head *xfs_get_buftarg_list(void);
> -#endif
> -
>  #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
>  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)

Code changes look good. Can you fix the commit description and
resend to xfs@oss.sgi.com?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
