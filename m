Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2IDI1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:27:34 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:63680 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab2IDI1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:27:31 -0400
Message-ID: <5045BB6A.8060309@atmel.com>
Date: Tue, 4 Sep 2012 10:27:22 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        <klaus.falkner@solectrix.de>, <ludovic.desroches@atmel.com>
Subject: Re: [PATCH] USB: ohci-at91: fix PIO handling in relation with number
 of ports
References: <1346233758-27009-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1346233758-27009-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 11:49 AM, Nicolas Ferre :
> If the number of ports present on the SoC/board is not the maximum
> and that the platform data is not filled with all data, there is
> an easy way to mess the PIO setup for this interface.
> This quick fix addresses mis-configuration in USB host platform data
> that is common in at91 boards since commit 0ee6d1e (USB: ohci-at91:
> change maximum number of ports) that did not modified the associatd
> board files.
> 
> Reported-by: Klaus Falkner <klaus.falkner@solectrix.de>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Cc: Stable <stable@vger.kernel.org> [3.4+]

Alan, Greg, gentle ping...

I really would like to seen it landing in stable soon...

Thanks, best regards,

> ---
>  drivers/usb/host/ohci-at91.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index a665b3e..aaa8d2b 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -570,6 +570,16 @@ static int __devinit ohci_hcd_at91_drv_probe(struct platform_device *pdev)
>  
>  	if (pdata) {
>  		at91_for_each_port(i) {
> +			/*
> +			 * do not configure PIO if not in relation with
> +			 * real USB port on board
> +			 */
> +			if (i >= pdata->ports) {
> +				pdata->vbus_pin[i] = -EINVAL;
> +				pdata->overcurrent_pin[i] = -EINVAL;
> +				break;
> +			}
> +
>  			if (!gpio_is_valid(pdata->vbus_pin[i]))
>  				continue;
>  			gpio = pdata->vbus_pin[i];
> 


-- 
Nicolas Ferre
