Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab2BJQLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:11:54 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:48725 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752939Ab2BJQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:11:53 -0500
Message-ID: <4F3541AE.50807@xenotime.net>
Date: Fri, 10 Feb 2012 08:11:26 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch] usb: add missing Kconfig UWB select to USB_WHCI_HCD and
 USB_HWA_HCD
References: <1328857675.7327.8.camel@marge.simpson.net>
In-Reply-To: <1328857675.7327.8.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 11:07 PM, Mike Galbraith wrote:
> usb: add missing Kconfig UWB select to USB_WHCI_HCD and USB_HWA_HCD
> 
> cripts/kconfig/conf --oldconfig Kconfig
> warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
> warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
> warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
> warning: (USB_WHCI_HCD) selects UWB_WHCI which has unmet direct dependencies (UWB && PCI)
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

I have 2 patches in linux-next that fix the UWB/WUSB problems by using "depends on"
instead...


> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 91413ca..b224959 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -547,6 +547,7 @@ config USB_WHCI_HCD
>  	tristate "Wireless USB Host Controller Interface (WHCI) driver (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL
>  	depends on PCI && USB
> +	select UWB
>  	select USB_WUSB
>  	select UWB_WHCI
>  	help
> @@ -560,6 +561,7 @@ config USB_HWA_HCD
>  	tristate "Host Wire Adapter (HWA) driver (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL
>  	depends on USB
> +	select UWB
>  	select USB_WUSB
>  	select UWB_HWA
>  	help
> 
> 
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
