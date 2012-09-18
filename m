Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2IRSSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:18:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:58915 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab2IRSR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:17:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,444,1344236400"; 
   d="scan'208";a="194194565"
Date: Tue, 18 Sep 2012 11:17:51 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Neil Zhang <zhangwm@marvell.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] USB: remove CONFIG_EXPERIMENTAL dependancies
Message-ID: <20120918181751.GA17755@xanatos>
References: <20120915041550.GA28736@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120915041550.GA28736@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 09:15:50PM -0700, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> As discussed at the kernel summit this year, CONFIG_EXPERIMENTAL means
> nothing, so let's get rid of it.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: David Herrmann <dh.herrmann@googlemail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Neil Zhang <zhangwm@marvell.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/usb/core/Kconfig     |    2 +-
>  drivers/usb/gadget/Kconfig   |   17 ++++++-----------
>  drivers/usb/host/Kconfig     |   22 ++++++++++------------
>  drivers/usb/wusbcore/Kconfig |    3 +--
>  4 files changed, 18 insertions(+), 26 deletions(-)
> 
> Any objections to me applying this patch to the usb-next branch?

No objections for the xHCI changes.

Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

> 
> diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
> index 9981984..f70c1a1 100644
> --- a/drivers/usb/core/Kconfig
> +++ b/drivers/usb/core/Kconfig
> @@ -56,7 +56,7 @@ config USB_SUSPEND
>  
>  config USB_OTG
>  	bool "OTG support"
> -	depends on USB && EXPERIMENTAL
> +	depends on USB
>  	depends on USB_SUSPEND
>  	default n
>  	help
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index a53be32..dfb51a4 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -557,7 +557,7 @@ config USB_ZERO_HNPTEST
>  	  one serve as the USB host instead (in the "B-Host" role).
>  
>  config USB_AUDIO
> -	tristate "Audio Gadget (EXPERIMENTAL)"
> +	tristate "Audio Gadget"
>  	depends on SND
>  	select USB_LIBCOMPOSITE
>  	select SND_PCM
> @@ -672,8 +672,7 @@ config USB_G_NCM
>  	  dynamically linked module called "g_ncm".
>  
>  config USB_GADGETFS
> -	tristate "Gadget Filesystem (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Gadget Filesystem"
>  	help
>  	  This driver provides a filesystem based API that lets user mode
>  	  programs implement a single-configuration USB device, including
> @@ -681,15 +680,11 @@ config USB_GADGETFS
>  	  All endpoints, transfer speeds, and transfer types supported by
>  	  the hardware are available, through read() and write() calls.
>  
> -	  Currently, this option is still labelled as EXPERIMENTAL because
> -	  of existing race conditions in the underlying in-kernel AIO core.
> -
>  	  Say "y" to link the driver statically, or "m" to build a
>  	  dynamically linked module called "gadgetfs".
>  
>  config USB_FUNCTIONFS
> -	tristate "Function Filesystem (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Function Filesystem"
>  	select USB_LIBCOMPOSITE
>  	select USB_FUNCTIONFS_GENERIC if !(USB_FUNCTIONFS_ETH || USB_FUNCTIONFS_RNDIS)
>  	help
> @@ -799,8 +794,8 @@ config USB_G_SERIAL
>  	  make MS-Windows work with CDC ACM.
>  
>  config USB_MIDI_GADGET
> -	tristate "MIDI Gadget (EXPERIMENTAL)"
> -	depends on SND && EXPERIMENTAL
> +	tristate "MIDI Gadget"
> +	depends on SND
>  	select USB_LIBCOMPOSITE
>  	select SND_RAWMIDI
>  	help
> @@ -867,7 +862,7 @@ config USB_G_ACM_MS
>  	  dynamically linked module called "g_acm_ms".
>  
>  config USB_G_MULTI
> -	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
> +	tristate "Multifunction Composite Gadget"
>  	depends on BLOCK && NET
>  	select USB_G_MULTI_CDC if !USB_G_MULTI_RNDIS
>  	select USB_LIBCOMPOSITE
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 13cd6d5..b1deb0f 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -18,8 +18,8 @@ config USB_C67X00_HCD
>  	  module will be called c67x00.
>  
>  config USB_XHCI_HCD
> -	tristate "xHCI HCD (USB 3.0) support (EXPERIMENTAL)"
> -	depends on USB && USB_ARCH_HAS_XHCI && EXPERIMENTAL
> +	tristate "xHCI HCD (USB 3.0) support"
> +	depends on USB && USB_ARCH_HAS_XHCI
>  	---help---
>  	  The eXtensible Host Controller Interface (xHCI) is standard for USB 3.0
>  	  "SuperSpeed" host controller hardware.
> @@ -262,7 +262,7 @@ config USB_ISP116X_HCD
>  
>  config USB_ISP1760_HCD
>  	tristate "ISP 1760 HCD support"
> -	depends on USB && EXPERIMENTAL
> +	depends on USB
>  	---help---
>  	  The ISP1760 chip is a USB 2.0 host controller.
>  
> @@ -376,7 +376,7 @@ config USB_OHCI_HCD_PCI
>  
>  config USB_OHCI_HCD_SSB
>  	bool "OHCI support for Broadcom SSB OHCI core (DEPRECATED)"
> -	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD) && EXPERIMENTAL
> +	depends on USB_OHCI_HCD && (SSB = y || SSB = USB_OHCI_HCD)
>  	select USB_HCD_SSB
>  	select USB_OHCI_HCD_PLATFORM
>  	default n
> @@ -414,7 +414,7 @@ config USB_CNS3XXX_OHCI
>  
>  config USB_OHCI_HCD_PLATFORM
>  	bool "Generic OHCI driver for a platform device"
> -	depends on USB_OHCI_HCD && EXPERIMENTAL
> +	depends on USB_OHCI_HCD
>  	default n
>  	---help---
>  	  Adds an OHCI host driver for a generic platform device, which
> @@ -424,7 +424,7 @@ config USB_OHCI_HCD_PLATFORM
>  
>  config USB_EHCI_HCD_PLATFORM
>  	bool "Generic EHCI driver for a platform device"
> -	depends on USB_EHCI_HCD && EXPERIMENTAL
> +	depends on USB_EHCI_HCD
>  	default n
>  	---help---
>  	  Adds an EHCI host driver for a generic platform device, which
> @@ -591,8 +591,7 @@ config USB_RENESAS_USBHS_HCD
>  	  module will be called renesas-usbhs.
>  
>  config USB_WHCI_HCD
> -	tristate "Wireless USB Host Controller Interface (WHCI) driver (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Wireless USB Host Controller Interface (WHCI) driver"
>  	depends on PCI && USB && UWB
>  	select USB_WUSB
>  	select UWB_WHCI
> @@ -604,8 +603,7 @@ config USB_WHCI_HCD
>  	  will be called "whci-hcd".
>  
>  config USB_HWA_HCD
> -	tristate "Host Wire Adapter (HWA) driver (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Host Wire Adapter (HWA) driver"
>  	depends on USB && UWB
>  	select USB_WUSB
>  	select UWB_HWA
> @@ -656,7 +654,7 @@ config USB_OCTEON2_COMMON
>  
>  config USB_HCD_BCMA
>  	tristate "BCMA usb host driver"
> -	depends on BCMA && EXPERIMENTAL
> +	depends on BCMA
>  	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
>  	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
>  	help
> @@ -668,7 +666,7 @@ config USB_HCD_BCMA
>  
>  config USB_HCD_SSB
>  	tristate "SSB usb host driver"
> -	depends on SSB && EXPERIMENTAL
> +	depends on SSB
>  	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
>  	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
>  	help
> diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
> index f29fdd7..8bf1976 100644
> --- a/drivers/usb/wusbcore/Kconfig
> +++ b/drivers/usb/wusbcore/Kconfig
> @@ -2,8 +2,7 @@
>  # Wireless USB Core configuration
>  #
>  config USB_WUSB
> -	tristate "Enable Wireless USB extensions (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	tristate "Enable Wireless USB extensions"
>  	depends on USB
>  	depends on PCI
>  	depends on UWB
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
