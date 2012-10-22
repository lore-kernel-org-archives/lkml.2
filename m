Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2JVTv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:51:59 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58883 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab2JVTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:51:57 -0400
X-Sasl-enc: cTKWLNmP70fY+NGpbMhZhVCDB5ejzJ1REpvt9vNR9WtH 1350935517
Date: Mon, 22 Oct 2012 12:51:56 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: Use pr_ or dev_ printks in
 drivers/serial2002.c
Message-ID: <20121022195156.GC8567@kroah.com>
References: <1349871634-4479-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349871634-4479-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 09:20:33PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warning.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> 
> and added pr_fmt.
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/serial2002.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
> index 5bf84cf..cc4f6e7 100644
> --- a/drivers/staging/comedi/drivers/serial2002.c
> +++ b/drivers/staging/comedi/drivers/serial2002.c
> @@ -31,6 +31,8 @@ Status: in development
>  
>  */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include "../comedidev.h"
>  
>  #include <linux/delay.h>
> @@ -282,7 +284,7 @@ static struct serial_data serial_read(struct file *f, int timeout)
>  
>  		length++;
>  		if (data < 0) {
> -			printk(KERN_ERR "serial2002 error\n");
> +			pr_err("serial2002 error\n");

The "serial2002" word here is redundant.

>  			break;
>  		} else if (data & 0x80) {
>  			result.value = (result.value << 7) | (data & 0x7f);
> @@ -355,7 +357,8 @@ static int serial_2002_open(struct comedi_device *dev)
>  	devpriv->tty = filp_open(port, O_RDWR, 0);
>  	if (IS_ERR(devpriv->tty)) {
>  		result = (int)PTR_ERR(devpriv->tty);
> -		printk(KERN_ERR "serial_2002: file open error = %d\n", result);
> +		dev_err(dev->class_dev,
> +			"serial_2002: file open error = %d\n", result);

Same here.

greg k-h
