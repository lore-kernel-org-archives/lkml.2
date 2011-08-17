Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1HQOim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:38:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64098 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1HQOil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:38:41 -0400
Message-ID: <4E4BD1F9.4010805@ru.mvista.com>
Date: Wed, 17 Aug 2011 18:36:41 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Michal Nazarewicz <mnazarewicz@google.com>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: get rid of USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED
References: <4E4B9D9C.2010607@linutronix.de> <aeb2d1e4eb36e6a0265ed0e6c279e81880bbfef2.1313585187.git.mina86@mina86.com>
In-Reply-To: <aeb2d1e4eb36e6a0265ed0e6c279e81880bbfef2.1313585187.git.mina86@mina86.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>

> This commit removes the use of USB_GADGET_DUALSPEED and
> USB_GADGET_SUPERSPEED Kconfig options.  Those were selected
> by UDC drivers which supported respective speeds.

> However, since kernel now allows multiple UDC drivers to be
> compiled, the options in question may no longer reflect the
> state of all gadgets.

> For instance, if one driver that supports dual speed is selected
> and another that does not, the USB_GADGE_DUALSPEED will be set
> "for both".

> This commit replaces all the #ifdefs by a run-time checks made
> by calling gadget_is_dualspeed().

> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
[...]

> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index 1b24099..1869478 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
[...]
> @@ -1015,9 +1013,8 @@ ep0_read (struct file *fd, char __user *buf, size_t len, loff_t *ptr)
>  			if (dev->current_config) {
>  				unsigned power;
>  
> -				if (gadget_is_dualspeed(dev->gadget)
> -						&& (dev->gadget->speed
> -							== USB_SPEED_HIGH))
> +				if (gadget_is_dualspeed(dev->gadget) &&
> +				    (dev->gadget->speed == USB_SPEED_HIGH))

    As Alan noted, this is quite unrelated white space change.

>  					power = dev->hs_config->bMaxPower;
>  				else
>  					power = dev->config->bMaxPower;
> @@ -1354,10 +1350,8 @@ static void make_qualifier (struct dev_data *dev)
>  
>  	memcpy (dev->rbuf, &qual, sizeof qual);
>  }
> -#endif
>  
> -static int
> -config_buf (struct dev_data *dev, u8 type, unsigned index)
> +static int config_buf (struct dev_data *dev, u8 type, unsigned index)
>  {
>  	int		len;
>  	int		hs = 0;

WARNING: space prohibited between function name and open parenthesis '('
#291: FILE: drivers/usb/gadget/inode.c:1354:
+static int config_buf (struct dev_data *dev, u8 type, unsigned index)

total: 0 errors, 1 warnings, 400 lines checked

patches/usb-gadget-get-rid-of-USB_GADGET_DUALSPEED-and-USB_GADGET_SUPERSPEED.patch 
has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

WBR, Sergei
