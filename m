Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab0HAPQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 11:16:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44669 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab0HAPP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 11:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vn47yG/oFqfKFDl0FF2SW8TfK4lHVhrey/DmI/PyzyLnhTKfwl0qtkcCqvg/jW0jUs
         iSOrqk9YjZiHRmjNTem7noq3fVDAvnTM1F8wKlNhJSzvPiCMWUeboCVpNoWEo3fYFo1h
         pnMT8rbib1vybB4IJ192L05Rl3j6TxGBipoMU=
Date: Mon, 2 Aug 2010 00:15:51 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20100801151551.GA8158@barrios-desktop>
References: <20100722050928.653312535@intel.com>
 <20100722061822.906037624@intel.com>
 <20100726105736.GM5300@csn.ul.ie>
 <20100726125635.GC11947@localhost>
 <20100726125954.GT5300@csn.ul.ie>
 <20100726131152.GF11947@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726131152.GF11947@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu, 

> Subject: writeback: sync expired inodes first in background writeback
> From: Wu Fengguang <fengguang.wu@intel.com>
> Date: Wed Jul 21 20:11:53 CST 2010
> 
> A background flush work may run for ever. So it's reasonable for it to
> mimic the kupdate behavior of syncing old/expired inodes first.
> 
> The policy is
> - enqueue all newly expired inodes at each queue_io() time
> - enqueue all dirty inodes if there are no more expired inodes to sync
> 
> This will help reduce the number of dirty pages encountered by page
> reclaim, eg. the pageout() calls. Normally older inodes contain older
> dirty pages, which are more close to the end of the LRU lists. So
> syncing older inodes first helps reducing the dirty pages reached by
> the page reclaim code.
> 
> CC: Jan Kara <jack@suse.cz>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |   23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2010-07-26 20:19:01.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2010-07-26 21:10:42.000000000 +0800
> @@ -217,14 +217,14 @@ static void move_expired_inodes(struct l
>  				struct writeback_control *wbc)
>  {
>  	unsigned long expire_interval = 0;
> -	unsigned long older_than_this;
> +	unsigned long older_than_this = 0; /* reset to kill gcc warning */

Maybe I am rather late. 

Nitpick. 
uninitialized_var is consistent. :)

I haven't followed up this patch series. but his patch series is a fundamental way 
to go for reducing pageout. 
-- 
Kind regards,
Minchan Kim
