Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1AJGjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 01:39:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:41522 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1AJGix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 01:38:53 -0500
Date: Sun, 9 Jan 2011 22:39:09 -0800
From: Greg KH <gregkh@suse.de>
To: ahern.michael.t@gmail.com
Cc: u.kleine-koenig@pengutronix.de, julia@diku.dk, nikai@nikai.net,
        morgan.gatti@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] Coding style in unioxx5.c KERN_ facility level and
 coding style warnings as reported by checkpatch.pl Signed-off-by: Michael
 Ahern <ahern.michael.t@gmail.com>
Message-ID: <20110110063909.GC3016@suse.de>
References: <1294614196-6665-1-git-send-email-ahern.michael.t@gmail.com>
 <1294614196-6665-3-git-send-email-ahern.michael.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294614196-6665-3-git-send-email-ahern.michael.t@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:03:14AM +1100, ahern.michael.t@gmail.com wrote:
> From: mah <ahern.michael.t@gmail.com>
> 
> ---

You put the description and signed-off-by line on the subject:  You need
to put a blank line after the first line in your git commit to keep git
send-email from messing this up.


>  drivers/staging/comedi/drivers/unioxx5.c |   65 +++++++++++++++++++----------
>  1 files changed, 42 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
> index 598884e..334f036 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -72,13 +72,17 @@ Devices: [Fastwel] UNIOxx-5 (unioxx5),
>  #define ALL_2_INPUT  0		/* config all digital channels to input */
>  #define ALL_2_OUTPUT 1		/* config all digital channels to output */
>  
> -/* 'private' structure for each subdevice */
> +/* 'private' unioxx5 structure for each subdevice
> +	usp_module_type - 12 modules. each can be 70L or 73L
> +	usp_extra_data  - for saving previous written value for analog modules
> +	usp_prev_wr_val	- previous written value
> +	usp_prev_cn_val - previous channel value */
>  struct unioxx5_subd_priv {
>  	int usp_iobase;
> -	unsigned char usp_module_type[12];	/* 12 modules. each can be 70L or 73L */
> -	unsigned char usp_extra_data[12][4];	/* for saving previous written value for analog modules */
> -	unsigned char usp_prev_wr_val[3];	/* previous written value */
> -	unsigned char usp_prev_cn_val[3];	/* previous channel value */
> +	unsigned char usp_module_type[12];	/* see comment above */
> +	unsigned char usp_extra_data[12][4];	/* see comment above */
> +	unsigned char usp_prev_wr_val[3];	/* see comment above */
> +	unsigned char usp_prev_cn_val[3];	/* see comment above */

No need for the "comment above" just put all of the comments in the
comment.  And if you do that, use the proper kernel-doc format for this,
so it works properly.

>  static int unioxx5_attach(struct comedi_device *dev,
> @@ -99,7 +103,8 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
>  				   unsigned int *data, int channel, int minor);
>  static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
>  				  unsigned int *data, int channel, int minor);
> -/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp, int mode); */
> +/* static void __unioxx5_digital_config(struct unioxx5_subd_priv* usp,
> +					int mode); */
>  static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
>  				  unsigned int *data, int channel, int minor);
>  static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
> @@ -139,8 +144,10 @@ static int unioxx5_attach(struct comedi_device *dev,
>  	dev->iobase = iobase;
>  	iobase += UNIOXX5_SUBDEV_BASE;
>  
> -	/* defining number of subdevices and getting they types (it must be 'g01')  */
> -	for (i = n_subd = 0, ba = iobase; i < 4; i++, ba += UNIOXX5_SUBDEV_ODDS) {
> +	/* defining number of subdevices and getting types (it must be 'g01') */
> +	for (i = n_subd = 0, ba = iobase; i < 4;
> +		i++, ba += UNIOXX5_SUBDEV_ODDS) {
> +
>  		id = inb(ba + 0xE);
>  		num = inb(ba + 0xF);
>  
> @@ -169,7 +176,7 @@ static int unioxx5_attach(struct comedi_device *dev,
>  			return -1;
>  	}
>  
> -	printk("attached\n");
> +	printk(KERN_INFO "attached\n");
>  	return 0;
>  }
>  
> @@ -181,7 +188,8 @@ static int unioxx5_subdev_read(struct comedi_device *dev,
>  	int channel, type;
>  
>  	channel = CR_CHAN(insn->chanspec);
> -	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
> +	/* defining module type(analog or digital) */
> +	type = usp->usp_module_type[channel / 2];
>  
>  	if (type == MODULE_DIGITAL) {
>  		if (!__unioxx5_digital_read(usp, data, channel, dev->minor))
> @@ -202,7 +210,8 @@ static int unioxx5_subdev_write(struct comedi_device *dev,
>  	int channel, type;
>  
>  	channel = CR_CHAN(insn->chanspec);
> -	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
> +	/* defining module type(analog or digital) */
> +	type = usp->usp_module_type[channel / 2];
>  
>  	if (type == MODULE_DIGITAL) {
>  		if (!__unioxx5_digital_write(usp, data, channel, dev->minor))
> @@ -259,11 +268,16 @@ static int unioxx5_insn_config(struct comedi_device *dev,
>  	/*                                                        *\
>  	 * sets channels buffer to 1(after this we are allowed to *
>  	 * change channel type on input or output)                *
> +	 *
> +	outb(flags, ...) - changes type of _one_ channel
> +	outb(0, ...)	 - sets channels bank to 0(allows directly input/output)
> +	usp-> ... flags  - saves written value
> +	 *
>  	 \*                                                        */
>  	outb(1, usp->usp_iobase + 0);
> -	outb(flags, usp->usp_iobase + channel_offset);	/* changes type of _one_ channel */
> -	outb(0, usp->usp_iobase + 0);	/* sets channels bank to 0(allows directly input/output) */
> -	usp->usp_prev_cn_val[channel_offset - 1] = flags;	/* saves written value */
> +	outb(flags, usp->usp_iobase + channel_offset);	/* see comment above */
> +	outb(0, usp->usp_iobase + 0);				/* see above */
> +	usp->usp_prev_cn_val[channel_offset - 1] = flags;	/* see above */

No need to put the "see above".

thanks,

greg k-h
