Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1DNI4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:56:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:40987 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab1DNI41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:56:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,210,1301900400"; 
   d="scan'208";a="909424609"
Date: Thu, 14 Apr 2011 10:56:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Juergen Kilb <J.Kilb@phytec.de>, balbi@ti.com
Cc: linux-arm-kernel@lists.infradead.org, dbrownell@users.sourceforge.net,
        gregkh@suse.de, linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed gpio polarity of gpio USB-phy reset.
Message-ID: <20110414085623.GA27253@sortiz-mobl>
References: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302766303-1157-1-git-send-email-J.Kilb@phytec.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juergen,

On Thu, Apr 14, 2011 at 09:31:43AM +0200, Juergen Kilb wrote:
> With commit 19403165 a main part of ehci-omap.c moved to
> drivers/mfd/omap-usb-host.c created by commit 17cdd29d.
> Due to this reorganisation the polarity used to reset the
> external USB phy changed and USB host doesn't recognize
> any devices.
If that fix is correct, it looks like it should make its way to 2.6.39.
Felipe, are you ok with this fix ?

Cheers,
Samuel.

> Signed-off-by: Juergen Kilb <J.Kilb@phytec.de>
> ---
>  drivers/mfd/omap-usb-host.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 53450f4..491cac5 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -719,14 +719,14 @@ static int usbhs_enable(struct device *dev)
>  			gpio_request(pdata->ehci_data->reset_gpio_port[0],
>  						"USB1 PHY reset");
>  			gpio_direction_output
> -				(pdata->ehci_data->reset_gpio_port[0], 1);
> +				(pdata->ehci_data->reset_gpio_port[0], 0);
>  		}
>  
>  		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1])) {
>  			gpio_request(pdata->ehci_data->reset_gpio_port[1],
>  						"USB2 PHY reset");
>  			gpio_direction_output
> -				(pdata->ehci_data->reset_gpio_port[1], 1);
> +				(pdata->ehci_data->reset_gpio_port[1], 0);
>  		}
>  
>  		/* Hold the PHY in RESET for enough time till DIR is high */
> @@ -906,11 +906,11 @@ static int usbhs_enable(struct device *dev)
>  
>  		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
>  			gpio_set_value
> -				(pdata->ehci_data->reset_gpio_port[0], 0);
> +				(pdata->ehci_data->reset_gpio_port[0], 1);
>  
>  		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
>  			gpio_set_value
> -				(pdata->ehci_data->reset_gpio_port[1], 0);
> +				(pdata->ehci_data->reset_gpio_port[1], 1);
>  	}
>  
>  end_count:
> -- 
> 1.7.0.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
