Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab0JSNjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:39:13 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:49658 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717Ab0JSNjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:39:11 -0400
Message-ID: <4CBD9FD5.506@nokia.com>
Date: Tue, 19 Oct 2010 16:40:37 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: ext Felipe Contreras <felipe.contreras@gmail.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com> <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
In-Reply-To: <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 10/19/2010 01:03 PM, ext Felipe Contreras wrote:
> Add missing dependencies, and remove redundant ones, and select sensible
> defaults.
>
> Signed-off-by: Felipe Contreras<felipe.contreras@gmail.com>
> ---
>   drivers/mfd/Kconfig        |    3 ++-
>   drivers/regulator/Kconfig  |    1 +
>   drivers/usb/gadget/Kconfig |    3 +--
>   drivers/usb/musb/Kconfig   |    6 ++----
>   drivers/usb/otg/Kconfig    |    2 ++
>   5 files changed, 8 insertions(+), 7 deletions(-)
>

> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index c530bc6..2aac57e 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -111,7 +111,6 @@ config	USB_GADGET_SELECTED
>   #
>   choice
>   	prompt "USB Peripheral Controller"
> -	depends on USB_GADGET
>   	help
>   	   A USB device uses a controller to talk to its host.
>   	   Systems should have only one such upstream link.
> @@ -191,7 +190,6 @@ config USB_GADGET_OMAP
>   	boolean "OMAP USB Device Controller"
>   	depends on ARCH_OMAP
>   	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3 || MACH_OMAP_H4_OTG
> -	select USB_OTG_UTILS if ARCH_OMAP
>   	help
>   	   Many Texas Instruments OMAP processors have flexible full
>   	   speed USB device controllers, with support for up to 30
> @@ -843,6 +841,7 @@ config USB_CDC_COMPOSITE
>   config USB_G_NOKIA
>   	tristate "Nokia composite gadget"
>   	depends on PHONET
> +	depends on USB_GADGET_MUSB_HDRC

This is wrong. Is there a build problem or run-time problem without this?

-- 
regards,
-roger
