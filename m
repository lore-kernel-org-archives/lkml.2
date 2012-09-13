Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab2IMIDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:03:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18670 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab2IMIDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:03:40 -0400
Date: Thu, 13 Sep 2012 11:03:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bruce Humphrey <brucehum@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: fl512: Replace printk with dev_info
 et al
Message-ID: <20120913080309.GJ19396@mwanda>
References: <1347500796-4432-1-git-send-email-brucehum@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347500796-4432-1-git-send-email-brucehum@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 03:46:36AM +0200, Bruce Humphrey wrote:
> Replace printk(KERN_XXX with the appropiate dev_info, dev_warn, dev_dbg in fl512.c
> 
> Signed-off-by: Bruce Humphrey Ventura <brucehum@gmail.com>
> ---
>  drivers/staging/comedi/drivers/fl512.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
> index d1da809..5a8e0ae 100644
> --- a/drivers/staging/comedi/drivers/fl512.c
> +++ b/drivers/staging/comedi/drivers/fl512.c
> @@ -118,9 +118,9 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	struct comedi_subdevice *s;
>  
>  	iobase = it->options[0];
> -	printk(KERN_INFO "comedi:%d fl512: 0x%04lx", dev->minor, iobase);
> +	dev_info(dev->class_dev, "%s: 0x%04lx\n", dev->board_name, iobase);

Only print this at the end when it succeeds.

>  	if (!request_region(iobase, FL512_SIZE, "fl512")) {
> -		printk(KERN_WARNING " I/O port conflict\n");
> +		dev_warn(dev->class_dev, " I/O port conflict\n");
                                          ^
Bogus space.

>  		return -EIO;
>  	}
>  	dev->iobase = iobase;
> @@ -129,7 +129,7 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  		return -ENOMEM;
>  
>  #if DEBUG
> -	printk(KERN_DEBUG "malloc ok\n");
> +	dev_dbg(dev->class_dev, "malloc ok\n");
>  #endif

Remove this section.

>  
>  	ret = comedi_alloc_subdevices(dev, 2);
> @@ -153,7 +153,8 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	s->range_table = &range_fl512;
>  	/* function to call when read AD */
>  	s->insn_read = fl512_ai_insn;
> -	printk(KERN_INFO "comedi: fl512: subdevice 0 initialized\n");
> +	dev_info(dev->class_dev, "%s: subdevice 0 initialized\n",
> +		dev->board_name);

Delete.

>  
>  	/* Analog output */
>  	s = dev->subdevices + 1;
> @@ -171,7 +172,8 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	s->insn_write = fl512_ao_insn;
>  	/* function to call when reading DA */
>  	s->insn_read = fl512_ao_insn_readback;
> -	printk(KERN_INFO "comedi: fl512: subdevice 1 initialized\n");
> +	dev_info(dev->class_dev, "%s: subdevice 1 initialized\n",
> +		dev->board_name);

Move the print from the start down to here.  Re-word it.  Copy from
one that Hartley has worked on.

regards,
dan carpenter

>  
>  	return 1;
>  }
> -- 
> 1.7.9.5
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
