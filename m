Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab2FDK00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:26:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab2FDK0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:26:25 -0400
Date: Mon, 4 Jun 2012 12:26:23 +0200
From: Jan Kara <jack@suse.cz>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] minixfs: use memweight()
Message-ID: <20120604102623.GE7670@quack.suse.cz>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
 <1338644416-11417-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338644416-11417-2-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 02-06-12 22:40:08, Akinobu Mita wrote:
> Use memweight() to count the total number of bits clear in memory area.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: linux-fsdevel@vger.kernel.org
> ---
> 
> No changes from v1
> 
>  fs/minix/bitmap.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
> index 4bc50da..564f1a5 100644
> --- a/fs/minix/bitmap.c
> +++ b/fs/minix/bitmap.c
> @@ -29,10 +29,8 @@ static __u32 count_free(struct buffer_head *map[], unsigned blocksize, __u32 num
>  	unsigned blocks = DIV_ROUND_UP(numbits, blocksize * 8);
>  
>  	while (blocks--) {
> -		unsigned words = blocksize / 2;
> -		__u16 *p = (__u16 *)(*map++)->b_data;
> -		while (words--)
> -			sum += 16 - hweight16(*p++);
> +		sum += blocksize * BITS_PER_BYTE -
> +			memweight((*map++)->b_data, blocksize);
  Hmm, just using bitmap_weight() should be fine here as well AFAICS...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
