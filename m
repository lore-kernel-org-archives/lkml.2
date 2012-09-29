Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2I2WJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 18:09:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63366 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2I2WJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 18:09:19 -0400
Message-ID: <1348956554.7401.1.camel@maxim-laptop>
Subject: Re: [patch 1/2] memstick: use after free in msb_disk_release()
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Date: Sun, 30 Sep 2012 00:09:14 +0200
In-Reply-To: <20120929071104.GB10993@elgon.mountain>
References: <20120929071104.GB10993@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-09-29 at 10:11 +0300, Dan Carpenter wrote: 
> The original code dereferenced "msb" after freeing it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
> index c815fe5..a8e8915 100644
> --- a/drivers/memstick/core/ms_block.c
> +++ b/drivers/memstick/core/ms_block.c
> @@ -1983,9 +1983,9 @@ static int msb_disk_release(struct gendisk *disk)
>  			msb->usage_count--;
>  
>  		if (!msb->usage_count) {
> -			kfree(msb);
>  			disk->private_data = NULL;
>  			idr_remove(&msb_disk_idr, msb->disk_id);
> +			kfree(msb);
>  			put_disk(disk);
>  		}
>  	}

Oops, I added this bug in latest iteration, when removed support for
major.
Acked-by: Maxim Levitsky <maximlevitsly@gmail.com>

Best regards,
Maxim Levitsky

