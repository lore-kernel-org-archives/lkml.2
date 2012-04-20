Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2DTJEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:04:52 -0400
Received: from shutemov.name ([176.9.204.213]:42946 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab2DTJEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:04:51 -0400
Date: Fri, 20 Apr 2012 12:04:57 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yuri Matylitski <ym@tekinsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <jhovold@gmail.com>,
        Preston Fick <preston.fick@silabs.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed too small hardcoded timeout values for
 usb_control_msg in driver for SiliconLabs cp210x-based usb-to-serial
 adapters. Replaced with USB_CTRL_GET_TIMEOUT/USB_CTRL_SET_TIMEOUT.
Message-ID: <20120420090457.GA23077@shutemov.name>
References: <1334910722-7357-1-git-send-email-ym@tekinsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334910722-7357-1-git-send-email-ym@tekinsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 11:32:02AM +0300, Yuri Matylitski wrote:

The first line of the commit message (which is in Subject) should be a
short summary of the change. More detailed description should be added
after an empty line.

More commit message hints:

http://who-t.blogspot.com/2009/12/on-commit-messages.html

Otherwise:

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

> Signed-off-by: Yuri Matylitski <ym@tekinsoft.com>
> ---
>  drivers/usb/serial/cp210x.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index 0310e2d..e56066b 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -287,7 +287,8 @@ static int cp210x_get_config(struct usb_serial_port *port, u8 request,
>  	/* Issue the request, attempting to read 'size' bytes */
>  	result = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
>  				request, REQTYPE_DEVICE_TO_HOST, 0x0000,
> -				port_priv->bInterfaceNumber, buf, size, 300);
> +				port_priv->bInterfaceNumber, buf, size,
> +				USB_CTRL_GET_TIMEOUT);
>  
>  	/* Convert data into an array of integers */
>  	for (i = 0; i < length; i++)
> @@ -340,12 +341,14 @@ static int cp210x_set_config(struct usb_serial_port *port, u8 request,
>  		result = usb_control_msg(serial->dev,
>  				usb_sndctrlpipe(serial->dev, 0),
>  				request, REQTYPE_HOST_TO_DEVICE, 0x0000,
> -				port_priv->bInterfaceNumber, buf, size, 300);
> +				port_priv->bInterfaceNumber, buf, size,
> +				USB_CTRL_SET_TIMEOUT);
>  	} else {
>  		result = usb_control_msg(serial->dev,
>  				usb_sndctrlpipe(serial->dev, 0),
>  				request, REQTYPE_HOST_TO_DEVICE, data[0],
> -				port_priv->bInterfaceNumber, NULL, 0, 300);
> +				port_priv->bInterfaceNumber, NULL, 0,
> +				USB_CTRL_SET_TIMEOUT);
>  	}
>  
>  	kfree(buf);
> -- 
> 1.7.0.4
> 

-- 
 Kirill A. Shutemov
