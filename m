Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1BEUP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:15:29 -0500
Received: from netrider.rowland.org ([192.131.102.5]:47679 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753177Ab1BEUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:15:28 -0500
Date: Sat, 5 Feb 2011 15:15:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maciej Szmigiero <mhej@o2.pl>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Paul Mortier <mortier@btinternet.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [USB]Add quirk for Samsung Android phone modem
In-Reply-To: <4D4D8CEC.4090500@o2.pl>
Message-ID: <Pine.LNX.4.44L0.1102051514150.4210-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Feb 2011, Maciej Szmigiero wrote:

> [USB]Add quirk for Samsung Android phone modem
> 
> My Galaxy Spica needs this quirk when in modem mode, otherwise
> it causes endless USB bus resets and is unusable in this mode.
> 
> Unfortunately Samsung decided to reuse ID of its old CDMA phone SGH-I500
> for the modem part.
> That's why in addition to this patch the visior driver must be prevented
> from binding to SPH-I500 ID, so ACM driver can do that.
> 
> Signed-off-by: Maciej Szmigiero <mhej@o2.pl>
> 
> diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
> index 44c5954..363355b 100644
> --- a/drivers/usb/core/quirks.c
> +++ b/drivers/usb/core/quirks.c
> @@ -88,6 +88,10 @@ static const struct usb_device_id usb_quirk_list[] = {
>      /* INTEL VALUE SSD */
>      { USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
>  
> +    /* Samsung Android phone modem - ID conflict with SPH-I500 */
> +    { USB_DEVICE(0x04e8, 0x6601), .driver_info =
> +            USB_QUIRK_CONFIG_INTF_STRINGS },
> +
>      { }  /* terminating entry must be last */
>  };

Please follow the directions at the start of the source file: Keep the 
list ordered by vendor ID, then product ID.

Alan Stern

