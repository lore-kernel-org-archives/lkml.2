Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0I3BpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:45:18 -0400
Received: from kroah.org ([198.145.64.141]:35768 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab0I3BpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:45:16 -0400
Date: Wed, 29 Sep 2010 18:37:00 -0700
From: Greg KH <greg@kroah.com>
To: David Cross <david.cross@cypress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Staging: west bridge, cyasgadget fix for
	usb_gadget_probe_driver
Message-ID: <20100930013700.GA22193@kroah.com>
References: <1285287600.17888.2.camel@odc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285287600.17888.2.camel@odc-laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 05:20:00PM -0700, David Cross wrote:
> This patch fixes the west bridge cyasgadget driver in order to allow for
> compilation against the linux-next tree. This changes
> usb_gadget_register_driver to usb_gadget_probe_driver and updates this
> function based on the new function definition (bind call).
> 
> Signed-off-by: David Cross <david.cross@cypress.com>
> 
> --- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-20 23:40:58.000000000 -0700
> +++ linux-next-incremen/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-09-23 16:54:32.000000000 -0700
> @@ -1882,9 +1882,8 @@ static void cyas_ep0_start(
>   * disconnect is reported.  then a host may connect again, or
>   * the driver might get unbound.
>   */
> -int usb_gadget_register_driver(
> -				struct usb_gadget_driver *driver
> -				)
> +int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
> +		int (*bind)(struct usb_gadget *))
>  {
>  	cyasgadget *dev = cy_as_gadget_controller ;
>  	int		retval;
> @@ -1898,7 +1897,7 @@ int usb_gadget_register_driver(
>  	* "must not be used in normal operation"
>  	*/
>  	if (!driver
> -		|| !driver->bind
> +		|| !bind
>  		|| !driver->unbind
>  		|| !driver->setup)
>  		return -EINVAL;
> @@ -1919,7 +1918,7 @@ int usb_gadget_register_driver(
>  	cyas_usb_reset(dev) ; /* External usb */
>  	cyas_usb_reinit(dev) ; /* Internal */
>  
> -	retval = driver->bind(&dev->gadget);
> +	retval = bind(&dev->gadget);
>  	if (retval) {
>  		#ifndef WESTBRIDGE_NDEBUG
>  		cy_as_hal_print_message("%s bind to driver %s --> %d\n",
> @@ -1938,7 +1937,7 @@ int usb_gadget_register_driver(
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(usb_gadget_register_driver);
> +EXPORT_SYMBOL(usb_gadget_probe_driver);

That's a pretty generic name you are exporting, I'd recommend changing
this very soon...

thanks,

greg k-h
