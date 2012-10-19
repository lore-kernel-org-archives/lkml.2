Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab2JSTJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:09:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53272 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab2JSTJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:09:22 -0400
Date: Fri, 19 Oct 2012 12:09:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging/sbe-2t3e3: Use netdev_ or dev_ or pr_
 printks in module.c
Message-ID: <20121019190917.GA18080@kroah.com>
References: <1348754271-4987-1-git-send-email-yamanetoshi@gmail.com>
 <1348754350-5022-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348754350-5022-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:59:10PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warning.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> 
> and add pr_fmt.
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/sbe-2t3e3/module.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/sbe-2t3e3/module.c b/drivers/staging/sbe-2t3e3/module.c
> index cd778b3..4547137 100644
> --- a/drivers/staging/sbe-2t3e3/module.c
> +++ b/drivers/staging/sbe-2t3e3/module.c
> @@ -10,6 +10,8 @@
>   * This code is based on a driver written by SBE Inc.
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> @@ -66,7 +68,7 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
>  
>  	dev = alloc_hdlcdev(channel);
>  	if (!dev) {
> -		printk(KERN_ERR "SBE 2T3E3" ": Out of memory\n");
> +		pr_err("SBE 2T3E3" ": Out of memory\n");
>  		goto free_regions;
>  	}
>  
> @@ -93,7 +95,8 @@ static int __devinit t3e3_init_channel(struct channel *channel, struct pci_dev *
>  	t3e3_init(channel);
>  
>  	if (request_irq(dev->irq, &t3e3_intr, IRQF_SHARED, dev->name, dev)) {
> -		printk(KERN_WARNING "%s: could not get irq: %d\n", dev->name, dev->irq);
> +		netdev_warn(channel->dev, "%s: could not get irq: %d\n",
> +			    dev->name, dev->irq);
>  		goto free_regions;
>  	}
>  
> @@ -137,7 +140,8 @@ static int __devinit t3e3_init_card(struct pci_dev *pdev, const struct pci_devic
>  				break; /* found the second channel */
>  
>  		if (!pdev1) {
> -			printk(KERN_ERR "SBE 2T3E3" ": Can't find the second channel\n");
> +			dev_err(&pdev->dev,
> +				"SBE 2T3E3" ": Can't find the second channel\n");

The "SBE 2T3E3" is no longer needed here, now that you set pr_info.

Care to fix this up and resend it?

thanks,

greg k-h
