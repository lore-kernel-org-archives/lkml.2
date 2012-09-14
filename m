Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2INFGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:06:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60086 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab2INFGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:06:12 -0400
X-Sasl-enc: exNPo7I3QZbPehNOjNzDcixyBZq6kKrHmGO7taDn9RQd 1347599172
Date: Thu, 13 Sep 2012 22:03:28 -0700
From: Greg KH <greg@kroah.com>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4]: ezusb: move ezusb.c from drivers/usb/serial to
 drivers/usb/misc
Message-ID: <20120914050328.GB21944@kroah.com>
References: <7120fd46-da21-4203-8293-7dcdb70f02dc@shmail0>
 <f7e8f1a4-fb32-4933-ba9d-81a2f1fb7ba8@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f7e8f1a4-fb32-4933-ba9d-81a2f1fb7ba8@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 10:19:11PM +0200, Rene Buergel wrote:
> This patch moves drivers/usb/serial/ezusb.c to drivers/usb/misc/and
> adapts Makefiles and Kconfigs
> 
> Signed-off-by: René Bürgel <rene.buergel@sohard.de>
> --
> diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
> index 1bfcd02..1c63b54 100644
> --- a/drivers/usb/misc/Kconfig
> +++ b/drivers/usb/misc/Kconfig
> @@ -244,3 +244,7 @@ config USB_YUREX
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called yurex.
>  
> +config USB_EZUSB
> +	bool "Functions for loading firmware on EZUSB chips"
> +	help
> +	    Say Y here if you need EZUSB device support.
> diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
> index 796ce7e..f1f7815 100644
> --- a/drivers/usb/misc/Makefile
> +++ b/drivers/usb/misc/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_USB_CYPRESS_CY7C63)	+= cypress_cy7c63.o
>  obj-$(CONFIG_USB_CYTHERM)		+= cytherm.o
>  obj-$(CONFIG_USB_EMI26)			+= emi26.o
>  obj-$(CONFIG_USB_EMI62)			+= emi62.o
> +obj-$(CONFIG_USB_EZUSB)			+= ezusb.o
>  obj-$(CONFIG_USB_FTDI_ELAN)		+= ftdi-elan.o
>  obj-$(CONFIG_USB_IDMOUSE)		+= idmouse.o
>  obj-$(CONFIG_USB_IOWARRIOR)		+= iowarrior.o
> diff --git a/drivers/usb/misc/ezusb.c b/drivers/usb/misc/ezusb.c
> new file mode 100644
> index 0000000..867a3e1
> --- /dev/null
> +++ b/drivers/usb/misc/ezusb.c

Git should show this as a move, not as a "add a file and remove a file"
type patch.  Are you generating it properly?

Also, why move it?  Are there other modules that need to use it?

thanks,

greg k-h
