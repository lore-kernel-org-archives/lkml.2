Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2KSSXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:23:16 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54746 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2KSSXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:23:14 -0500
Date: Mon, 19 Nov 2012 10:20:02 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20121119182002.GA2670@lizard>
References: <19040462.WFXWijAIDd@pali>
 <2562836.SjVVyiPAk1@pali>
 <20121118231239.GC29066@lizard.sbx05977.paloaca.wayport.net>
 <5320319.2WmO5VDT8j@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5320319.2WmO5VDT8j@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 01:18:29PM +0100, Pali Rohár wrote:
[...] 
> Ok. Here is missing patch which register this driver in Nokia N900 board code. Without it driver is not loaded.

Cc'ing OMAP folks.

> From 0b60efd06a71668439bcb761c6572dd7df91dc17 Mon Sep 17 00:00:00 2001
> From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
> Date: Mon, 19 Nov 2012 09:05:24 +0100
> Subject: [PATCH 1/3] ARM: OMAP: rx51: Register platform device for
>  rx51_battery driver
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index 020e03c..fe1ac7e 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -271,11 +271,17 @@ static struct platform_device rx51_charger_device = {
>  	},
>  };
>  
> +static struct platform_device rx51_battery_device = {
> +	.name		= "rx51-battery",
> +	.id		= -1,
> +};
> +
>  static void __init rx51_charger_init(void)
>  {
>  	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
>  		GPIOF_OUT_INIT_HIGH, "isp1704_reset"));
>  
> +	platform_device_register(&rx51_battery_device);
>  	platform_device_register(&rx51_charger_device);
>  }
>  
> -- 
> 1.7.10.4
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com
