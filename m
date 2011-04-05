Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1DEHhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:37:22 -0400
Received: from kroah.org ([198.145.64.141]:46416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1DEHhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:37:20 -0400
Date: Mon, 4 Apr 2011 22:51:08 -0700
From: Greg KH <greg@kroah.com>
To: ellwync@gmail.com
Cc: gregkh@suse.de, arun.thomas@gmail.com, julia@diku.dk, tj@kernel.org,
        john.d.sheehan@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ellwyn C <ellwync@googlemail.com>
Subject: Re: [PATCH] Staging: comedi: Fix 80 characters limit and printk
 issues in unioxx5.c
Message-ID: <20110405055108.GA547@kroah.com>
References: <4d7ffceb.dd25e30a.10e8.1876@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d7ffceb.dd25e30a.10e8.1876@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 11:57:04PM +0000, ellwync@gmail.com wrote:
> From: Ellwyn C <ellwync@googlemail.com>
> 
> This is a patch to the unioxx5.c file that fixes the 80 characters limit and
> printk warnings found by the checkpatch.pl tool
> 
> Signed-off-by: Ellwyn C <ellwync@googlemail.com>
> ---
>  drivers/staging/comedi/drivers/unioxx5.c |   61 +++++++++++++++++++-----------
>  1 files changed, 39 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
> index 598884e..0d91f53 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -75,8 +75,10 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
>  /* 'private' structure for each subdevice */
>  struct unioxx5_subd_priv {
>  	int usp_iobase;
> -	unsigned char usp_module_type[12];	/* 12 modules. each can be 70L or 73L */
> -	unsigned char usp_extra_data[12][4];	/* for saving previous written value for analog modules */
> +	unsigned char usp_module_type[12];
> +	/* 12 modules. each can be 70L or 73L */

No, it should be on the line before this, not after.

> +	unsigned char usp_extra_data[12][4];
> +	/* for saving previous written value for analog modules */
>  	unsigned char usp_prev_wr_val[3];	/* previous written value */
>  	unsigned char usp_prev_cn_val[3];	/* previous channel value */
>  };
> @@ -99,7 +101,8 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
>  				   unsigned int *data, int channel, int minor);
>  static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
>  				  unsigned int *data, int channel, int minor);
> -/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode); */
> +/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode)
> +; */

Don't put a ; on a new line, this is not needed at all.

>  static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
>  				  unsigned int *data, int channel, int minor);
>  static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
> @@ -139,8 +142,10 @@ static int unioxx5_attach(struct comedi_device *dev,
>  	dev->iobase = iobase;
>  	iobase += UNIOXX5_SUBDEV_BASE;
>  
> -	/* defining number of subdevices and getting they types (it must be 'g01')  */
> -	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
> +	/* defining number of subdevices and getting they types
> +	(it must be 'g01')  */
> +	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba +=
> +	UNIOXX5_SUBDEV_ODDS) {

Ick, no, wrong way to indent this, sorry.

And see the proper way to handle multi-line comments, this isn't the way
to do this.

>  		id = inb(ba + 0xE);
>  		num = inb(ba + 0xF);
>  
> @@ -169,7 +174,7 @@ static int unioxx5_attach(struct comedi_device *dev,
>  			return -1;
>  	}
>  
> -	printk("attached\n");
> +	pr_info("attached\n");

This isnt needed at all.

>  	return 0;
>  }
>  
> @@ -181,7 +186,8 @@ static int unioxx5_subdev_read(struct comedi_device *dev,
>  	int channel, type;
>  
>  	channel = CR_CHAN(insn->chanspec);
> -	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
> +	type = usp->usp_module_type[channel / 2];
> +	/* defining module type(analog or digital) */

Same problem as above, and in other places in this patch.

Care to do it all over and resend?

thanks,

greg k-h
