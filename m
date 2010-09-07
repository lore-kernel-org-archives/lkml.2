Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab0IHAZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 20:25:19 -0400
Received: from kroah.org ([198.145.64.141]:51484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab0IHAZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 20:25:17 -0400
Date: Tue, 7 Sep 2010 16:54:53 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] west bridge, block driver fixes
Message-ID: <20100907235453.GA12823@kroah.com>
References: <1283888253.7250.21.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283888253.7250.21.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 12:37:33PM -0700, David Cross wrote:
> This patch makes minor fixes to the block driver for locking issues,
> printk statements and minor change for a kernel update to 2.6.36.
> Please let me know if there are issues or concerns with this patch.

Again, you are doing at least 3 different things here, right?  Please
split them out into 3 different patches.

Remember, one patch per logical change please.

> Signed-off-by: David Cross <david.cross@cypress.com>
> 
> diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
> --- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-08-31 19:32:51.000000000 -0700
> +++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-09-07 11:28:49.000000000 -0700
> @@ -202,7 +202,7 @@ static struct cyasblkdev_blk_data *cyasb
>  	if (bd) {
>  		bd->usage++;
>  		#ifndef NBDEBUG
> -		cy_as_hal_print_message(
> +		printk(KERN_INFO
>  			"cyasblkdev_blk_get: usage = %d\n", bd->usage) ;
>  		#endif

No, just use dev_dbg() here then you can drop the #ifdef.

Oh wait, it's the other way around?  If you don't have debugging enabled
you want to print that message?  Huh?  Just drop the #ifndef and then
use dev_info() instead.  That will properly print out the device and
driver that is being used here.

You can do that for all of your *hal_print_message() calls.

thanks,

greg k-h
