Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1LAICT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:02:19 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:53304
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751928Ab1LAICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:02:17 -0500
Message-ID: <4ED73481.2010904@compulab.co.il>
Date: Thu, 01 Dec 2011 10:02:09 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Keshava Munegowda <keshava_mgowda@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/4] mfd: omap-usb-host: Use gpio_request_one
References: <1322704074.11560.3.camel@phoenix> <1322704405.11560.7.camel@phoenix>
In-Reply-To: <1322704405.11560.7.camel@phoenix>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On 12/01/11 03:53, Axel Lin wrote:
> Use gpio_request_one() instead of multiple gpiolib calls.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/omap-usb-host.c |   20 +++++++-------------
>  1 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 86e1458..6533ecc 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -715,19 +715,13 @@ static int usbhs_enable(struct device *dev)
>  	clk_enable(omap->usbtll_ick);
>  
>  	if (pdata->ehci_data->phy_reset) {
> -		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0])) {
> -			gpio_request(pdata->ehci_data->reset_gpio_port[0],
> -						"USB1 PHY reset");
> -			gpio_direction_output
> -				(pdata->ehci_data->reset_gpio_port[0], 0);
> -		}
> +		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
> +			gpio_request_one(pdata->ehci_data->reset_gpio_port[0],
> +					 GPIOF_OUT_INIT_LOW, "USB1 PHY reset");
>  
> -		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1])) {
> -			gpio_request(pdata->ehci_data->reset_gpio_port[1],
> -						"USB2 PHY reset");
> -			gpio_direction_output
> -				(pdata->ehci_data->reset_gpio_port[1], 0);
> -		}
> +		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
> +			gpio_request_one(pdata->ehci_data->reset_gpio_port[1],
> +					 GPIOF_OUT_INIT_LOW, "USB2 PHY reset");

I was wondering, if we need the gpio_is_valid() check here and above?
gpio_request() already does the gpio_is_valid() check,
so why should we double check?


-- 
Regards,
Igor.
