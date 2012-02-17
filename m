Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab2BQJmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:42:17 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:37950 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2BQJmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:42:15 -0500
Message-ID: <4F3E20CC.5090205@atmel.com>
Date: Fri, 17 Feb 2012 10:41:32 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120210 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, tglx@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, avictor.za@gmail.com,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 3/9] ARM/USB: at91/ohci-at91: remove the use of irq_to_gpio
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com> <fab15f7eaf6622e68e62bc3afa533b12f48ca27e.1329139662.git.nicolas.ferre@atmel.com>
In-Reply-To: <fab15f7eaf6622e68e62bc3afa533b12f48ca27e.1329139662.git.nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 03:43 PM, Nicolas Ferre :
> irq_to_gpio() macro will be removed from AT91 GPIO interrupt
> controller. So we replace it with the use of gpio_to_irq()
> and a reworked test.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: linux-usb@vger.kernel.org

Hi Greg,

I would like to queue this patch through arm-soc git tree (with all AT91
material of this patch series).

So, can I have your "Acked-by" on this one?

> ---
>  drivers/usb/host/ohci-at91.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 77afabc..8e855eb 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -448,10 +448,11 @@ static irqreturn_t ohci_hcd_at91_overcurrent_irq(int irq, void *data)
>  
>  	/* From the GPIO notifying the over-current situation, find
>  	 * out the corresponding port */
> -	gpio = irq_to_gpio(irq);
>  	for (port = 0; port < ARRAY_SIZE(pdata->overcurrent_pin); port++) {
> -		if (pdata->overcurrent_pin[port] == gpio)
> +		if (gpio_to_irq(pdata->overcurrent_pin[port]) == irq) {
> +			gpio = pdata->overcurrent_pin[port];
>  			break;
> +		}
>  	}
>  
>  	if (port == ARRAY_SIZE(pdata->overcurrent_pin)) {

Thanks, best regards,
-- 
Nicolas Ferre
