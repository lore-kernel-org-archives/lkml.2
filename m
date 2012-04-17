Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2DQMmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 08:42:06 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:22327 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab2DQMmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 08:42:02 -0400
Message-ID: <4F8D64F5.5060300@atmel.com>
Date: Tue, 17 Apr 2012 14:41:25 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org,
        Alan Stern <stern@rowland.harvard.edu>
CC: arnd@arndb.de, olof@lixom.net, plagnioj@jcrosoft.com,
        ludovic.desroches@atmel.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 11/12] USB: ohci-at91: change annotations for probe/remove
 functions
References: <cover.1334567594.git.nicolas.ferre@atmel.com> <79e2edff922c337d1f0e8407f18e506b32df488e.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <79e2edff922c337d1f0e8407f18e506b32df488e.1334567594.git.nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 11:20 AM, Nicolas Ferre :
> Add __devinit and __devexit on *_probe() and *_remove() functions
> with proper modification of struct platform_driver.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>

Alan,

Can I have your "Acked-by" for this modification? I plan to push a
"fixes" series though arm-soc git tree.

Thanks, best regards,

> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/host/ohci-at91.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 09f597a..13ebeca 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -94,7 +94,7 @@ static void at91_stop_hc(struct platform_device *pdev)
>  
>  /*-------------------------------------------------------------------------*/
>  
> -static void usb_hcd_at91_remove (struct usb_hcd *, struct platform_device *);
> +static void __devexit usb_hcd_at91_remove (struct usb_hcd *, struct platform_device *);
>  
>  /* configure so an HC device and id are always provided */
>  /* always called with process context; sleeping is OK */
> @@ -108,7 +108,7 @@ static void usb_hcd_at91_remove (struct usb_hcd *, struct platform_device *);
>   * then invokes the start() method for the HCD associated with it
>   * through the hotplug entry's driver_data.
>   */
> -static int usb_hcd_at91_probe(const struct hc_driver *driver,
> +static int __devinit usb_hcd_at91_probe(const struct hc_driver *driver,
>  			struct platform_device *pdev)
>  {
>  	int retval;
> @@ -203,7 +203,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   * context, "rmmod" or something similar.
>   *
>   */
> -static void usb_hcd_at91_remove(struct usb_hcd *hcd,
> +static void __devexit usb_hcd_at91_remove(struct usb_hcd *hcd,
>  				struct platform_device *pdev)
>  {
>  	usb_remove_hcd(hcd);
> @@ -545,7 +545,7 @@ static int __devinit ohci_at91_of_init(struct platform_device *pdev)
>  
>  /*-------------------------------------------------------------------------*/
>  
> -static int ohci_hcd_at91_drv_probe(struct platform_device *pdev)
> +static int __devinit ohci_hcd_at91_drv_probe(struct platform_device *pdev)
>  {
>  	struct at91_usbh_data	*pdata;
>  	int			i;
> @@ -620,7 +620,7 @@ static int ohci_hcd_at91_drv_probe(struct platform_device *pdev)
>  	return usb_hcd_at91_probe(&ohci_at91_hc_driver, pdev);
>  }
>  
> -static int ohci_hcd_at91_drv_remove(struct platform_device *pdev)
> +static int __devexit ohci_hcd_at91_drv_remove(struct platform_device *pdev)
>  {
>  	struct at91_usbh_data	*pdata = pdev->dev.platform_data;
>  	int			i;
> @@ -696,7 +696,7 @@ MODULE_ALIAS("platform:at91_ohci");
>  
>  static struct platform_driver ohci_hcd_at91_driver = {
>  	.probe		= ohci_hcd_at91_drv_probe,
> -	.remove		= ohci_hcd_at91_drv_remove,
> +	.remove		= __devexit_p(ohci_hcd_at91_drv_remove),
>  	.shutdown	= usb_hcd_platform_shutdown,
>  	.suspend	= ohci_hcd_at91_drv_suspend,
>  	.resume		= ohci_hcd_at91_drv_resume,


-- 
Nicolas Ferre
