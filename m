Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab2JVTvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:51:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57393 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755964Ab2JVTvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:51:17 -0400
X-Sasl-enc: ls1PrGw9n47iJSODPoq7GSCN00CoKqBUF3jNAFrbVVhj 1350935476
Date: Mon, 22 Oct 2012 12:51:15 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: Use pr_ or dev_ printks in
 drivers/unioxx5.c
Message-ID: <20121022195115.GB8567@kroah.com>
References: <1349788072-5809-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349788072-5809-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:07:52PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warnings.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> and added pr_fmt.
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/unioxx5.c |   45 +++++++++++++++---------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
> index 9f1fdec..b5e58f5 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -42,6 +42,8 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
>  
>  */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "../comedidev.h"
>  #include <linux/ioport.h>
>  #include <linux/slab.h>
> @@ -144,8 +146,7 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
>  
>  	channel_offset = __unioxx5_define_chan_offset(channel);
>  	if (channel_offset < 0) {
> -		printk(KERN_ERR
> -		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
> +		pr_err("comedi%d: undefined channel %d. channel range is 0 .. 23\n",
>  		       minor, channel);
>  		return 0;
>  	}
> @@ -171,8 +172,7 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
>  
>  	/* defining if given module can work on input */
>  	if (usp->usp_module_type[module_no] & MODULE_OUTPUT_MASK) {
> -		printk(KERN_ERR
> -		       "comedi%d: module in position %d with id 0x%02x is for output only",
> +		pr_err("comedi%d: module in position %d with id 0x%02x is for output only",
>  		       minor, module_no, usp->usp_module_type[module_no]);
>  		return 0;
>  	}
> @@ -209,8 +209,7 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
>  
>  	channel_offset = __unioxx5_define_chan_offset(channel);
>  	if (channel_offset < 0) {
> -		printk(KERN_ERR
> -		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
> +		pr_err("comedi%d: undefined channel %d. channel range is 0 .. 23\n",
>  		       minor, channel);
>  		return 0;
>  	}
> @@ -240,8 +239,7 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
>  
>  	/* defining if given module can work on output */
>  	if (!(usp->usp_module_type[module] & MODULE_OUTPUT_MASK)) {
> -		printk(KERN_ERR
> -		       "comedi%d: module in position %d with id 0x%0x is for input only!\n",
> +		pr_err("comedi%d: module in position %d with id 0x%0x is for input only!\n",
>  		       minor, module, usp->usp_module_type[module]);
>  		return 0;
>  	}
> @@ -323,17 +321,17 @@ static int unioxx5_insn_config(struct comedi_device *dev,
>  	type = usp->usp_module_type[channel / 2];
>  
>  	if (type != MODULE_DIGITAL) {
> -		printk(KERN_ERR
> -		       "comedi%d: channel configuration accessible only for digital modules\n",
> -		       dev->minor);
> +		dev_err(dev->class_dev,
> +			"comedi%d: channel configuration accessible only for digital modules\n",
> +			dev->minor);
>  		return -1;
>  	}
>  
>  	channel_offset = __unioxx5_define_chan_offset(channel);
>  	if (channel_offset < 0) {
> -		printk(KERN_ERR
> -		       "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
> -		       dev->minor, channel);
> +		dev_err(dev->class_dev,
> +			"comedi%d: undefined channel %d. channel range is 0 .. 23\n",
> +			dev->minor, channel);
>  		return -1;
>  	}
>  
> @@ -348,7 +346,8 @@ static int unioxx5_insn_config(struct comedi_device *dev,
>  		flags |= mask;
>  		break;
>  	default:
> -		printk(KERN_ERR "comedi%d: unknown flag\n", dev->minor);
> +		dev_err(dev->class_dev,
> +			"comedi%d: unknown flag\n", dev->minor);
>  		return -1;
>  	}
>  
> @@ -375,19 +374,21 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
>  	int i, to, ndef_flag = 0;
>  
>  	if (!request_region(subdev_iobase, UNIOXX5_SIZE, DRIVER_NAME)) {
> -		printk(KERN_ERR "comedi%d: I/O port conflict\n", minor);
> +		dev_err(subdev->class_dev,
> +			"comedi%d: I/O port conflict\n", minor);
>  		return -EIO;
>  	}
>  
>  	usp = kzalloc(sizeof(*usp), GFP_KERNEL);
>  
>  	if (usp == NULL) {
> -		printk(KERN_ERR "comedi%d: error! --> out of memory!\n", minor);
> +		dev_err(subdev->class_dev,
> +			"comedi%d: error! --> out of memory!\n", minor);
>  		return -1;
>  	}
>  
>  	usp->usp_iobase = subdev_iobase;
> -	printk(KERN_INFO "comedi%d: |", minor);
> +	dev_info(subdev->class_dev, "comedi%d: |", minor);
>  
>  	/* defining modules types */
>  	for (i = 0; i < 12; i++) {
> @@ -433,7 +434,7 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
>  	/* for digital modules only!!! */
>  	subdev->insn_config = unioxx5_insn_config;
>  
> -	printk(KERN_INFO "subdevice configured\n");
> +	dev_info(subdev->class_dev, "subdevice configured\n");
>  
>  	return 0;
>  }
> @@ -464,8 +465,8 @@ static int unioxx5_attach(struct comedi_device *dev,
>  
>  	/* unioxx5 can has from two to four subdevices */
>  	if (n_subd < 2) {
> -		printk(KERN_ERR
> -		       "your card must has at least 2 'g01' subdevices\n");
> +		dev_err(dev->class_dev,
> +			"your card must has at least 2 'g01' subdevices\n");
>  		return -1;
>  	}
>  
> @@ -480,7 +481,7 @@ static int unioxx5_attach(struct comedi_device *dev,
>  			return -1;
>  	}
>  
> -	printk(KERN_INFO "attached\n");
> +	dev_info(dev->class_dev, "attached\n");
>  	return 0;

Some of these are "debug" type information (configured and attached
messages?)  Plese just drop them entirely, they aren't needed.

greg k-h
