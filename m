Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab2FZPtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:49:14 -0400
Received: from antcom.de ([188.40.178.216]:59975 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab2FZPtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:49:12 -0400
Message-ID: <4FE9D9F5.5030701@antcom.de>
Date: Tue, 26 Jun 2012 17:49:09 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Fix Kconfig dependency for Phy drivers
References: <1340722608-997-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1340722608-997-1-git-send-email-aletes.xgr@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 04:56 PM, Alexandre Pereira da Silva wrote:
> USB phy layer driver are only built if usb host is selected, but they
> are used too by USB_GADGET drivers
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Acked-by: Roland Stigge <stigge@antcom.de>

> ---
>  drivers/usb/Makefile    |    2 +-
>  drivers/usb/phy/Kconfig |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> index c691eea..f5ed3d7 100644
> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -46,7 +46,7 @@ obj-$(CONFIG_USB_MICROTEK)	+= image/
>  obj-$(CONFIG_USB_SERIAL)	+= serial/
>  
>  obj-$(CONFIG_USB)		+= misc/
> -obj-$(CONFIG_USB)		+= phy/
> +obj-$(CONFIG_USB_COMMON)	+= phy/
>  obj-$(CONFIG_EARLY_PRINTK_DBGP)	+= early/
>  
>  obj-$(CONFIG_USB_ATM)		+= atm/
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index 3cfabcb..e7cf84f 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -2,11 +2,11 @@
>  # Physical Layer USB driver configuration
>  #
>  comment "USB Physical Layer drivers"
> -	depends on USB
> +	depends on USB || USB_GADGET
>  
>  config USB_ISP1301
>  	tristate "NXP ISP1301 USB transceiver support"
> -	depends on USB
> +	depends on USB || USB_GADGET
>  	depends on I2C
>  	help
>  	  Say Y here to add support for the NXP ISP1301 USB transceiver driver.

