Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2JOJUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:20:06 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51304 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab2JOJUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:20:05 -0400
Message-ID: <507BD53D.2070407@mev.co.uk>
Date: Mon, 15 Oct 2012 10:19:57 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
CC: Greg Kroah-Hartman <greg@kroah.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: Use dev_ printks in drivers/vmk80xx.c
References: <1350222055-7666-1-git-send-email-yamanetoshi@gmail.com>
In-Reply-To: <1350222055-7666-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/10/14 02:40 PM, YAMANE Toshiaki wrote:
> fixed below checkpatch warning.
> - Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/vmk80xx.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
> index df277aa..3e77d40 100644
> --- a/drivers/staging/comedi/drivers/vmk80xx.c
> +++ b/drivers/staging/comedi/drivers/vmk80xx.c
> @@ -1371,12 +1371,12 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
>  
>  	if (dev->board.model == VMK8061_MODEL) {
>  		vmk80xx_read_eeprom(dev, IC3_VERSION);
> -		printk(KERN_INFO "comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
> +		dev_info(&intf->dev, "%s: %s\n", __FILE__, dev->fw.ic3_vers);

I think __FILE__ is the wrong thing to use in these logs.  Better to use
vmk80xx or perhaps KBUILD_MODNAME.

>  
>  		if (vmk80xx_check_data_link(dev)) {
>  			vmk80xx_read_eeprom(dev, IC6_VERSION);
> -			printk(KERN_INFO "comedi#: vmk80xx: %s\n",
> -			       dev->fw.ic6_vers);
> +			dev_info(&intf->dev, "%s: %s\n",
> +				 __FILE__, dev->fw.ic6_vers);
>  		} else {
>  			dbgcm("comedi#: vmk80xx: no conn. to CPU\n");
>  		}
> @@ -1387,8 +1387,8 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
>  
>  	dev->probed = 1;
>  
> -	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now attached\n",
> -	       dev->count, dev->board.name);
> +	dev_info(&intf->dev, "%s: board #%d [%s] now attached\n",
> +		 __FILE__, dev->count, dev->board.name);
>  
>  	mutex_unlock(&glb_mutex);
>  
> @@ -1422,8 +1422,8 @@ static void vmk80xx_usb_disconnect(struct usb_interface *intf)
>  	kfree(dev->usb_rx_buf);
>  	kfree(dev->usb_tx_buf);
>  
> -	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now detached\n",
> -	       dev->count, dev->board.name);
> +	dev_info(&intf->dev, "%s: board #%d [%s] now detached\n",
> +		 __FILE__, dev->count, dev->board.name);
>  
>  	up(&dev->limit_sem);
>  	mutex_unlock(&glb_mutex);
> 


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
