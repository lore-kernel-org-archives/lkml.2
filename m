Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2IZV1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:27:15 -0400
Received: from foo.stuge.se ([212.116.89.98]:50782 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752191Ab2IZV1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:27:13 -0400
Message-ID: <20120926212710.5775.qmail@stuge.se>
Date: Wed, 26 Sep 2012 23:27:10 +0200
From: Peter Stuge <peter@stuge.se>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch v5] ezusb: move ezusb.c from drivers/usb/serial to
	drivers/usb/misc
Mail-Followup-To: Rene Buergel <rene.buergel@sohard.de>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <c28594f9-45a3-4232-82fc-2f7c65cfb30c@shmail0> <47b117b0-5776-41c4-8b49-e3a21e80a6a4@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47b117b0-5776-41c4-8b49-e3a21e80a6a4@shmail0>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Buergel wrote:
> - renamed CONFIG_USB_EZUSB to CONFIG_USB_EZUSB_FX2 to avoid build errors

Is this really the reason for the build error? I doubt it.

Also, does the code in fact support only FX2, neither older chips nor
newer FX3?


> diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
> index 1bfcd02..bf7dc43 100644
> --- a/drivers/usb/misc/Kconfig
> +++ b/drivers/usb/misc/Kconfig
> @@ -244,3 +244,8 @@ config USB_YUREX
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called yurex.
>  
> +config USB_EZUSB_FX2
> +	tristate "Functions for loading firmware on EZUSB chips"

If only FX2 then I suggest mentioning that also in the immediately
user-visible option description, not only in the help.


> +	help
> +	  Say Y here if you need EZUSB device support.
> +	  (Cypress FX/FX2/FX2LP microcontrollers)

If FX is also supported then perhaps still rename the option,
although I think renaming is unrelated to the build problems.

I think it makes sense to call the option after the "highest"
supported chip.


//Peter
