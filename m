Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836Ab0KROzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:55:51 -0500
Received: from kroah.org ([198.145.64.141]:59992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307Ab0KROzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:55:33 -0500
Date: Thu, 18 Nov 2010 06:56:23 -0800
From: Greg KH <greg@kroah.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/4] usb gadget: Add usb_endpoint_descriptor to be
	part of the struct usb_ep
Message-ID: <20101118145623.GB16565@kroah.com>
References: <1290084400-25440-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290084400-25440-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:46:38PM +0200, Tatyana Brokhman wrote:
> Change usb_ep_enable() prototype to use endpoint descriptor from usb_ep.
> This optimization spares the FDs from saving the endpoint chosen
> descriptor.

Why is this a good thing to do?

> This optimization is not full though. To fully exploit this
> change one needs to update all the UDCs as well since in the current
> implementation each of them saves the endpoint descriptor in it's
> internal (and extended) endpoint structure.

Do you do that optimization later on in this patch series?

> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 006412c..937c8fa 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -131,20 +131,22 @@ struct usb_ep_ops {
>   * @maxpacket:The maximum packet size used on this endpoint.  The initial
>   *	value can sometimes be reduced (hardware allowing), according to
>   *      the endpoint descriptor used to configure the endpoint.
> - * @driver_data:for use by the gadget driver.  all other fields are
> - *	read-only to gadget drivers.
> + * @driver_data:for use by the gadget driver.

Why did you change the "all other fields..." portion?

> + * @desc: endpoint descriptor.  This pointer is set before the endpoint is
> + *	enabled and remains valid until the endpoint is disabled.
>   *
>   * the bus controller driver lists all the general purpose endpoints in
>   * gadget->ep_list.  the control endpoint (gadget->ep0) is not in that list,
>   * and is accessed only in response to a driver setup() callback.
>   */
>  struct usb_ep {
> -	void			*driver_data;
> +	void				*driver_data;
>  
> -	const char		*name;
> -	const struct usb_ep_ops	*ops;
> -	struct list_head	ep_list;
> -	unsigned		maxpacket:16;
> +	const char			*name;
> +	const struct usb_ep_ops		*ops;
> +	struct list_head		ep_list;
> +	unsigned			maxpacket:16;
> +	const struct usb_endpoint_descriptor	*desc;

Please don't reformat, it's hard to see what really was changed here.

thanks,

greg k-h
