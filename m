Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab0FRVzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:55:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:59462 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab0FRVzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:55:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,441,1272870000"; 
   d="scan'208";a="528243736"
Date: Fri, 18 Jun 2010 23:55:03 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Staticise ab3550 register access functions
Message-ID: <20100618215502.GJ3582@sortiz.org>
References: <1276091694-31331-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276091694-31331-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jun 09, 2010 at 02:54:54PM +0100, Mark Brown wrote:
> These are now exported via an ops table rather than referenced
> directly and so should be staticised.
Patch applied, thanks a lot.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/ab3550-core.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
> index f54ab62..8a98739 100644
> --- a/drivers/mfd/ab3550-core.c
> +++ b/drivers/mfd/ab3550-core.c
> @@ -589,16 +589,16 @@ static bool reg_read_allowed(const struct ab3550_reg_ranges *ranges, u8 reg)
>  }
>  
>  /*
> - * The exported register access functionality.
> + * The register access functionality.
>   */
> -int ab3550_get_chip_id(struct device *dev)
> +static int ab3550_get_chip_id(struct device *dev)
>  {
>  	struct ab3550 *ab = dev_get_drvdata(dev->parent);
>  	return (int)ab->chip_id;
>  }
>  
> -int ab3550_mask_and_set_register_interruptible(struct device *dev, u8 bank,
> -	u8 reg, u8 bitmask, u8 bitvalues)
> +static int ab3550_mask_and_set_register_interruptible(struct device *dev,
> +	u8 bank, u8 reg, u8 bitmask, u8 bitvalues)
>  {
>  	struct ab3550 *ab;
>  	struct platform_device *pdev = to_platform_device(dev);
> @@ -612,15 +612,15 @@ int ab3550_mask_and_set_register_interruptible(struct device *dev, u8 bank,
>  		bitmask, bitvalues);
>  }
>  
> -int ab3550_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
> -	u8 value)
> +static int ab3550_set_register_interruptible(struct device *dev, u8 bank,
> +	u8 reg, u8 value)
>  {
>  	return ab3550_mask_and_set_register_interruptible(dev, bank, reg, 0xFF,
>  		value);
>  }
>  
> -int ab3550_get_register_interruptible(struct device *dev, u8 bank, u8 reg,
> -	u8 *value)
> +static int ab3550_get_register_interruptible(struct device *dev, u8 bank,
> +	u8 reg, u8 *value)
>  {
>  	struct ab3550 *ab;
>  	struct platform_device *pdev = to_platform_device(dev);
> @@ -633,7 +633,7 @@ int ab3550_get_register_interruptible(struct device *dev, u8 bank, u8 reg,
>  	return get_register_interruptible(ab, bank, reg, value);
>  }
>  
> -int ab3550_get_register_page_interruptible(struct device *dev, u8 bank,
> +static int ab3550_get_register_page_interruptible(struct device *dev, u8 bank,
>  	u8 first_reg, u8 *regvals, u8 numregs)
>  {
>  	struct ab3550 *ab;
> @@ -649,7 +649,8 @@ int ab3550_get_register_page_interruptible(struct device *dev, u8 bank,
>  		numregs);
>  }
>  
> -int ab3550_event_registers_startup_state_get(struct device *dev, u8 *event)
> +static int ab3550_event_registers_startup_state_get(struct device *dev,
> +	u8 *event)
>  {
>  	struct ab3550 *ab;
>  
> @@ -661,7 +662,7 @@ int ab3550_event_registers_startup_state_get(struct device *dev, u8 *event)
>  	return 0;
>  }
>  
> -int ab3550_startup_irq_enabled(struct device *dev, unsigned int irq)
> +static int ab3550_startup_irq_enabled(struct device *dev, unsigned int irq)
>  {
>  	struct ab3550 *ab;
>  	struct ab3550_platform_data *plf_data;
> -- 
> 1.7.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
