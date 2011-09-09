Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067Ab1IIXMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:12:38 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35413 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934027Ab1IIXMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:12:32 -0400
X-Sasl-enc: L4HqVEP7ZjnfEGq0a8iap0II+R5bvlyQZmmoBJlRKfGY 1315609951
Date: Fri, 9 Sep 2011 16:11:28 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] zram: Simplify zram disk resizing interface
Message-ID: <20110909231128.GA24604@kroah.com>
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org>
 <1315609264-13632-5-git-send-email-ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315609264-13632-5-git-send-email-ngupta@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"simplify" it in what way?

What just got changed, and why, and did it just break any documentation?


On Fri, Sep 09, 2011 at 07:01:03PM -0400, Nitin Gupta wrote:
> Also remove unnecessary messages.
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reviewed-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  drivers/staging/zram/zram_drv.c |   42 +++++++++++---------------------------
>  1 files changed, 12 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index b2e29dd..b1c4abd 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -104,33 +104,16 @@ static int page_zero_filled(void *ptr)
>  	return 1;
>  }
>  
> -static void zram_set_disksize(struct zram *zram, size_t totalram_bytes)
> +static u64 zram_default_disksize_bytes(void)
>  {
> -	if (!zram->disksize) {
> -		pr_info(
> -		"disk size not provided. You can use disksize_kb module "
> -		"param to specify size.\nUsing default: (%u%% of RAM).\n",
> -		default_disksize_perc_ram
> -		);
> -		zram->disksize = default_disksize_perc_ram *
> -					(totalram_bytes / 100);
> -	}
> -
> -	if (zram->disksize > 2 * (totalram_bytes)) {
> -		pr_info(
> -		"There is little point creating a zram of greater than "
> -		"twice the size of memory since we expect a 2:1 compression "
> -		"ratio. Note that zram uses about 0.1%% of the size of "
> -		"the disk when not in use so a huge zram is "
> -		"wasteful.\n"
> -		"\tMemory Size: %zu kB\n"
> -		"\tSize you selected: %llu kB\n"
> -		"Continuing anyway ...\n",
> -		totalram_bytes >> 10, zram->disksize
> -		);
> -	}

Why are these print messages removed, aren't they useful to people?

greg k-h
