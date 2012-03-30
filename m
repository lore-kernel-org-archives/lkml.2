Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab2C3MsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:48:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60345 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759484Ab2C3MsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:48:05 -0400
Date: Fri, 30 Mar 2012 14:48:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] Fix USB Kconfig
Message-ID: <20120330124811.GA27330@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Rupesh Gujare <rgujare@ozmodevices.com>,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
References: <20120330100056.GA27427@x1.osrc.amd.com>
 <1333105532-7668-1-git-send-email-rgujare@ozmodevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333105532-7668-1-git-send-email-rgujare@ozmodevices.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 12:05:32PM +0100, Rupesh Gujare wrote:
> Fix menuconfig option for USB. 
> 
> Signed-off-by: Rupesh Gujare <rgujare@ozmodevices.com>
> Reported-by: Borislav Petkov <bp@alien8.de>
> ---
>  drivers/usb/Kconfig |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index cbd8f5f..884f3fa 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -10,6 +10,13 @@ menuconfig USB_SUPPORT
>  	  This option adds core support for Universal Serial Bus (USB).
>  	  You will also need drivers from the following menu to make use of it.
>  
> +if USB_SUPPORT
> +
> +config USB_COMMON
> +	tristate
> +	default y
> +	depends on USB || USB_GADGET
> +
>  # many non-PCI SOC chips embed OHCI
>  config USB_ARCH_HAS_OHCI
>  	boolean
> @@ -63,13 +70,6 @@ config USB_ARCH_HAS_XHCI
>  	boolean
>  	default PCI
>  
> -if USB_SUPPORT
> -
> -config USB_COMMON
> -	tristate
> -	default y
> -	depends on USB || USB_GADGET
> -
>  # Host-side USB depends on having a host controller
>  # NOTE:  dummy_hcd is always an option, but it's ignored here ...
>  # NOTE:  SL-811 option should be board-specific ...

Reportedly, there's a fix for this already, see thread at
http://marc.info/?l=linux-usb&m=133310173203793&w=2

Thanks.

-- 
Regards/Gruss,
Boris.
