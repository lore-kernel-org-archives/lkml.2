Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab1JDUka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:40:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63932 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933628Ab1JDUk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:40:29 -0400
Date: Tue, 4 Oct 2011 12:37:10 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] gpio: langwell: ensure alternate function is cleared
Message-ID: <20111004183710.GG2870@ponder.secretlab.ca>
References: <1317641767-2942-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317641767-2942-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 02:36:07PM +0300, Adrian Hunter wrote:
> Alternate function must be zero for the pin to act as
> a GPIO.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/gpio/gpio-langwell.c |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index d2eb57c..00692e8 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -59,6 +59,7 @@ enum GPIO_REG {
>  	GRER,		/* rising edge detect */
>  	GFER,		/* falling edge detect */
>  	GEDR,		/* edge detect result */
> +	GAFR,		/* alt function */
>  };
>  
>  struct lnw_gpio {
> @@ -81,6 +82,31 @@ static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
>  	return ptr;
>  }
>  
> +static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
> +				   enum GPIO_REG reg_type)
> +{
> +	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
> +	unsigned nreg = chip->ngpio / 32;
> +	u8 reg = offset / 16;
> +	void __iomem *ptr;
> +
> +	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);

This looks wrong.  It looks to me like the __iomem annotation should
be added to ->reg_base.

Otherwise, the patch looks okay.

