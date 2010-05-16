Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0EPWZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:25:33 -0400
Received: from mga07.intel.com ([143.182.124.22]:29972 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754657Ab0EPWZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:25:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,243,1272870000"; 
   d="scan'208";a="277727467"
Date: Mon, 17 May 2010 00:25:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] GPIO: rdc321x fix inverted gpio data out registers
Message-ID: <20100516222553.GD3236@sortiz.org>
References: <201005161202.21614.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005161202.21614.florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Sun, May 16, 2010 at 12:02:18PM +0200, Florian Fainelli wrote:
> rdc_gpio_set_value_impl has the gpio data registers 1 and 2 inverted, fix this.
> 
Patch applied, thanks a lot.

Cheers,
Samuel.


> Signed-off-by: Bernhard Loos <bernhardloos@gmail.com>
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
> diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
> index 22f31dc..2762698 100644
> --- a/drivers/gpio/rdc321x-gpio.c
> +++ b/drivers/gpio/rdc321x-gpio.c
> @@ -73,7 +73,7 @@ static void rdc_gpio_set_value_impl(struct gpio_chip *chip,
>  		gpch->data_reg[reg] &= ~(1 << (gpio & 0x1f));
>  
>  	pci_write_config_dword(gpch->sb_pdev,
> -			reg ? gpch->reg1_data_base : gpch->reg2_data_base,
> +			reg ? gpch->reg2_data_base : gpch->reg1_data_base,
>  			gpch->data_reg[reg]);
>  }
>  

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
