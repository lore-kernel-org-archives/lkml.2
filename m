Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1IZWpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:45:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34172 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab1IZWpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:45:35 -0400
X-Sasl-enc: k0YL037wXT8aS5oxFXJk4uAKdpA1CwUDutAfxmwjO9R7 1317077134
Date: Mon, 26 Sep 2011 15:34:30 -0700
From: Greg KH <greg@kroah.com>
To: Matthias Dellweg <2500@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/core/devio.c: Check for printer class specific
 request
Message-ID: <20110926223430.GA21960@kroah.com>
References: <20110923195726.0cf0e8b5@horus>
 <Pine.LNX.4.44L0.1109231427280.2059-100000@iolanthe.rowland.org>
 <20110925144651.0ed3daaf@horus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110925144651.0ed3daaf@horus>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 25, 2011 at 02:46:51PM +0200, Matthias Dellweg wrote:
> From: Matthias Dellweg <2500@gmx.de>
> 
> In the usb printer class specific request get_device_id the value of
> wIndex is (interface << 8 | altsetting) instead of just interface.
> This enables the detection of some printers with libusb.
> 
> The hardware I tested this patch with is a Prolific
> USB->Centronics cable (067b:2305).
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Matthias Dellweg <2500@gmx.de>
> Cc: stable <stable@kernel.org>
> ---
>  drivers/usb/core/devio.c |   21 ++++++++++++++++++---
>  1 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 37518df..1d73709 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -607,9 +607,10 @@ static int findintfep(struct usb_device *dev, unsigned int ep)
>  }
>  
>  static int check_ctrlrecip(struct dev_state *ps, unsigned int requesttype,
> -                          unsigned int index)
> +                          unsigned int request, unsigned int index)
>  {
>         int ret = 0;
> +       struct usb_host_interface *alt_setting;
>  
>         if (ps->dev->state != USB_STATE_UNAUTHENTICATED
>          && ps->dev->state != USB_STATE_ADDRESS

All of the tabs were stripped out of this email, making it impossible to
apply it :(

Care to fix this up and resend it so that I can apply it?

thanks,

greg k-h
