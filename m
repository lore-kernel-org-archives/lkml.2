Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2DUT6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 15:58:19 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58821 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2DUT6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 15:58:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Renzo Dani <arons7@gmail.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Added GenesysLogic BW Microscope device id
Date: Sat, 21 Apr 2012 17:07:04 +0200
Message-ID: <11816853.jz81JXdN3I@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.1; x86_64; ; )
In-Reply-To: <1334946523-14618-1-git-send-email-arons7@gmail.com>
References: <1334946523-14618-1-git-send-email-arons7@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Renzo,

On Friday 20 April 2012 20:28:43 Renzo Dani wrote:
> From: Renzo Dani <arons7@gmail.com>
> 
> Signed-off-by: Renzo Dani <arons7@gmail.com>

Thank you for the patch.

> ---
>  drivers/media/video/uvc/uvc_driver.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_driver.c
> b/drivers/media/video/uvc/uvc_driver.c index 1d13172..b8c94b4 100644
> --- a/drivers/media/video/uvc/uvc_driver.c
> +++ b/drivers/media/video/uvc/uvc_driver.c
> @@ -2176,7 +2176,16 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
> -	/* Hercules Classic Silver */
> +	/* Genesys Logic USB 2.0 BW Microscope */
> +        { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
> +                                | USB_DEVICE_ID_MATCH_INT_INFO,
> +          .idVendor             = 0x05e3,
> +          .idProduct            = 0x0511,
> +          .bInterfaceClass      = USB_CLASS_VIDEO,
> +          .bInterfaceSubClass   = 1,
> +          .bInterfaceProtocol   = 0,

Please use tabs instead of space to indent the code. Running 
scripts/checkpatch.pl on the patch before sending it catches this kind of 
issues, it's thus a good practice to do so. As the patch is small I've fixed 
the issue myself, there's no need to resubmit it.

> +          .driver_info          = UVC_QUIRK_STREAM_NO_FID },

I suppose you have tested the device without this patch and that it didn't 
work. Could you please confirm that ? Could you please also send me the output 
of

lsusb -v -d 05e3:0511

> +        /* Hercules Classic Silver */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
> 
>  	  .idVendor		= 0x06f8,

-- 
Regards,

Laurent Pinchart

