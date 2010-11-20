Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0KTAZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 19:25:09 -0500
Received: from kroah.org ([198.145.64.141]:52414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0KTAZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 19:25:07 -0500
Date: Fri, 19 Nov 2010 16:12:47 -0800
From: Greg KH <greg@kroah.com>
To: Jef Driesen <jefdriesen@telenet.be>,
        Robert Lukassen <Robert.Lukassen@tomtom.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: g_serial: Allow to override the default VID/PID
Message-ID: <20101120001247.GB17421@kroah.com>
References: <4CE6F807.1090607@telenet.be>
 <1290209554-7026-1-git-send-email-jefdriesen@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290209554-7026-1-git-send-email-jefdriesen@telenet.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 12:32:34AM +0100, Jef Driesen wrote:
> Override the default VID/PID if custom values are supplied through the
> idVendor and idProduct kernel module parameters.
> 
> Signed-off-by: Jef Driesen <jefdriesen@telenet.be>

So this patch resolves the bug found in
1ab83238740ff1e1773d5c13ecac43c60cf4aec4 which showed up in .35-rc1,
right?

Robert, any objection to this as it was your patch that broke things?

thanks,

greg k-h
> ---
>  drivers/usb/gadget/serial.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
> index f46a609..77b410e 100644
> --- a/drivers/usb/gadget/serial.c
> +++ b/drivers/usb/gadget/serial.c
> @@ -271,6 +271,11 @@ static int __init init(void)
>  	}
>  	strings_dev[STRING_DESCRIPTION_IDX].s = serial_config_driver.label;
>  
> +	if (idVendor)
> +		device_desc.idVendor = idVendor;
> +	if (idProduct)
> +		device_desc.idProduct = idProduct;
> +
>  	return usb_composite_register(&gserial_driver);
>  }
>  module_init(init);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
