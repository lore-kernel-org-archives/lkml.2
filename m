Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab0JGPjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:39:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34064 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750836Ab0JGPjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:39:53 -0400
Date: Thu, 7 Oct 2010 11:39:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: tlinder <tlinder@codeaurora.org>
cc: USB list <linux-usb@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v2 1/3] Add usb_endpoint_descriptor to be part of
 the struct usb_ep
In-Reply-To: <1286465037-12438-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010071136380.1753-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, tlinder wrote:

> Change ep_choose() and usb_ep_enable() prototypes to use endpoint
> descriptor from usb_ep. This optimization prevents the FDs from handling
> the endpoint chosen descriptor.
> This optimization is not full though. To fully exploit this change one
> needs to update all the UDCs as well since in the current implementation
> each of them saves the endpoint descriptor in it's internal (and extended)
> endpoint structure.
> This patch is a preparation for adding SuperSpeed support to the gadget
> framework.
> 
> Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>

...

> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index d3ef42d..5e5198d 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -133,18 +133,25 @@ struct usb_ep_ops {
>   *      the endpoint descriptor used to configure the endpoint.
>   * @driver_data:for use by the gadget driver.  all other fields are
>   *	read-only to gadget drivers.
> + * @bEndpointAddress: used to identify ep when finding descriptor that matches
> + *	connection speed
> + * @desc:endpoint descriptor.  this pointer set before endpoint is enabled and
> + *	remains valid until the endpoint is disabled; the data byte order
> + *	is little-endian (usb-standard).

The kerneldoc for @driver_data states that @bEndpointAddress and @desc 
are read-only for gadget drivers.  This contradicts the changes this 
patch makes to those drivers.

Alan Stern

