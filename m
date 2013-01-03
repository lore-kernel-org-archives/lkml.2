Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3ACLzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:55:25 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:42208 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab3ACLzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:55:23 -0500
Date: Thu, 3 Jan 2013 11:55:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>,
        Robert Marklund <robert.marklund@stericsson.com>
Subject: Re: [PATCH 01/18] power: ab8500_charger: Rename the power_loss
 function
Message-ID: <20130103115513.GC21994@gmail.com>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
 <1355412102-14265-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355412102-14265-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Poke for the patch-set.

On Thu, 13 Dec 2012, Lee Jones wrote:

> From: Paer-Olof Haakansson <par-olof.hakansson@stericsson.com>
> 
> Rename the ab8500_power_loss_handling function to a more
> descriptive name ab8500_enable_disable_sw_fallback
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Robert Marklund <robert.marklund@stericsson.com>
> Reviewed-by: Par-Olof HAKANSSON <par-olof.hakansson@stericsson.com>
> Reviewed-by: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>
> Tested-by: Par-Olof HAKANSSON <par-olof.hakansson@stericsson.com>
> ---
>  drivers/power/ab8500_charger.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index 2ddface..d6e1792 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -270,20 +270,19 @@ static enum power_supply_property ab8500_charger_usb_props[] = {
>  	POWER_SUPPLY_PROP_CURRENT_NOW,
>  };
>  
> -/**
> - * ab8500_power_loss_handling - set how we handle powerloss.
> - * @di:		pointer to the ab8500_charger structure
> - *
> - * Magic nummbers are from STE HW department.
> +/*
> + * Function for enabling and disabling sw fallback mode
> + * should always be disabled when no charger is connected.
>   */
> -static void ab8500_power_loss_handling(struct ab8500_charger *di)
> +static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
> +		bool fallback)
>  {
>  	u8 reg;
>  	int ret;
>  
> -	dev_dbg(di->dev, "Autopower : %d\n", di->autopower);
> +	dev_dbg(di->dev, "SW Fallback: %d\n", fallback);
>  
> -	/* read the autopower register */
> +	/* read the register containing fallback bit */
>  	ret = abx500_get_register_interruptible(di->dev, 0x15, 0x00, &reg);
>  	if (ret) {
>  		dev_err(di->dev, "%d write failed\n", __LINE__);
> @@ -297,12 +296,12 @@ static void ab8500_power_loss_handling(struct ab8500_charger *di)
>  		return;
>  	}
>  
> -	if (di->autopower)
> +	if (fallback)
>  		reg |= 0x8;
>  	else
>  		reg &= ~0x8;
>  
> -	/* write back the changed value to autopower reg */
> +	/* write back the changed fallback bit value to register */
>  	ret = abx500_set_register_interruptible(di->dev, 0x15, 0x00, reg);
>  	if (ret) {
>  		dev_err(di->dev, "%d write failed\n", __LINE__);
> @@ -332,12 +331,12 @@ static void ab8500_power_supply_changed(struct ab8500_charger *di,
>  		    !di->ac.charger_connected &&
>  		    di->autopower) {
>  			di->autopower = false;
> -			ab8500_power_loss_handling(di);
> +			ab8500_enable_disable_sw_fallback(di, false);
>  		} else if (!di->autopower &&
>  			   (di->ac.charger_connected ||
>  			    di->usb.charger_connected)) {
>  			di->autopower = true;
> -			ab8500_power_loss_handling(di);
> +			ab8500_enable_disable_sw_fallback(di, true);
>  		}
>  	}
>  	power_supply_changed(psy);
> -- 
> 1.7.9.5
> 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
