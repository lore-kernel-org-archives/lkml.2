Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab2LPCPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 21:15:22 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6246 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab2LPCPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 21:15:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap0NAEMuzVB5LIoV/2dsb2JhbABFhVKyeYQAggYXc4IeAQEEATocIwULCAMRAwECAS4UDRgDEw4TiAEDCQWxRQ2JVRSLYGmEQwOUNIFViziFEYMH
Date: Sun, 16 Dec 2012 13:15:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: ys <sickamd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger@dilger.ca
Subject: Re: [PATCH] vfs: update atimes over one day in the past or future
Message-ID: <20121216021508.GG9806@dastard>
References: <50CC9663.4010200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CC9663.4010200@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ please place patches inline, not as attachments. ]

On Sat, Dec 15, 2012 at 11:25:23PM +0800, ys wrote:
> From 3d56c131b58a21c05bcd677b9d2ba915abcbf195 Mon Sep 17 00:00:00 2001
> From: yangsheng <sickamd@gmail.com>
> Date: Sat, 15 Dec 2012 21:46:22 +0800
> Subject: [PATCH] vfs: update atimes over one day in the past or future
> 
> Relatime should update the inode atime if it is more than one day
> in the future.  The original problem seen was a tarball that had
> a bad atime in the distant future, but could also happen if someone
> fat-fingers a "touch".  The future atime will never be fixed.
> 
> Without relatime enabled, a future atime is updated to the current
> kernel time on access.  Relatime is meant to reduce the frequency
> of atime updates, not decide if whether the system clock or the
> inode timestamp is correct or not.
> 
> Signed-off-by: Yang Sheng <sickamd@gmail.com>
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>
> Acked-by: David Chinner <david@fromorbit.com>

No I didn't. Please don't add tags that someone has not added
directly in a reply to the original patch.

> CC: stable@vger.kernel.org
> ---
>  fs/inode.c | 7 ++++---
>  1 ??????????????????????????? 4 ???(+)????????? 3 ???(-)

There's something wrong with the character encoding you are using...

> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 14084b7..8713dc8 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1488,10 +1488,11 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>  		return 1;
>  
>  	/*
> -	 * Is the previous atime value older than a day? If yes,
> -	 * update atime:
> +	 * Update atime if it's older than a day or more than a day
> +	 * in the future, which we assume is corrupt.
> +	 * 	 	 

A time in the future is not a corruption - the comment should
reflect exactly what you've put in the commit message. i.e. that
relatime is for reducing updates, not preventing atime from ever
moving backwards.

Also, you've added an extra line of whitespace damage that doesn't
need to be there.....

FWIW, could you write a test for xfstests for this behaviour
so we can confirm that we don't break it in future?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
