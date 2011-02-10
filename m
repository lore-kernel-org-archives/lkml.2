Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1BJOnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 09:43:07 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:40971 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab1BJOnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 09:43:05 -0500
Date: Thu, 10 Feb 2011 08:43:00 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-ID: <20110210144300.GA15465@linux.vnet.ibm.com>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
References: <20110210163527.3b2cc580.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210163527.3b2cc580.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell (sfr@canb.auug.org.au) wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/zram/zram_drv.c between commit
> 5414e557fca545614ceedc3d3496f747457e2e3b ("staging: zram: fix data
> corruption issue") from the staging.current tree and commit
> 2787f959d6c5fb258d964218ac75346019f49ee9 ("zram: Return zero'd pages on
> new reads") from the staging tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/staging/zram/zram_drv.c
> index 4bd8cbd,1017d6d..0000000
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@@ -235,8 -237,7 +238,8 @@@ static void zram_read(struct zram *zram
>   		if (unlikely(!zram->table[index].page)) {
>   			pr_debug("Read before write: sector=%lu, size=%u",
>   				(ulong)(bio->bi_sector), bio->bi_size);
> - 			/* Do nothing */
> + 			handle_zero_page(page);
>  +			index++;
>   			continue;
>   		}
>   

This is correct, thanks.

--Rob Jennings
