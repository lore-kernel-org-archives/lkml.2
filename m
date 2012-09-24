Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2IXA6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 20:58:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41330 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab2IXA6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 20:58:11 -0400
Message-ID: <505FB01C.4060905@gmail.com>
Date: Mon, 24 Sep 2012 09:58:04 +0900
From: gshark <gshark.jeong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: lm3642: Use regmap_update_bits() in lm3642_chip_init()
References: <1348296014.12906.2.camel@phoenix>
In-Reply-To: <1348296014.12906.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012년 09월 22일 15:40, Axel Lin 쓴 글:
> Use regmap_update_bits() to replace regmap_read() + regmap_write().
> With this patch, we only show the error message when regmap_update_bits()
> fails.
     Looks good..You're right.  Thank you Alex.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
     Acked-by: G.Shark Jeong<gshark.jeong@gmail.com>
> ---
>   drivers/leds/leds-lm3642.c |   15 +++------------
>   1 file changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/leds/leds-lm3642.c b/drivers/leds/leds-lm3642.c
> index 924853b..3285006 100644
> --- a/drivers/leds/leds-lm3642.c
> +++ b/drivers/leds/leds-lm3642.c
> @@ -95,23 +95,14 @@ struct lm3642_chip_data {
>   /* chip initialize */
>   static int __devinit lm3642_chip_init(struct lm3642_chip_data *chip)
>   {
> -	unsigned int reg_val;
>   	int ret;
>   	struct lm3642_platform_data *pdata = chip->pdata;
>   
>   	/* set enable register */
> -	ret = regmap_read(chip->regmap, REG_ENABLE, &reg_val);
> +	ret = regmap_update_bits(chip->regmap, REG_ENABLE, EX_PIN_ENABLE_MASK,
> +				 pdata->tx_pin);
>   	if (ret < 0)
> -		goto out;
> -
> -	reg_val &= (~EX_PIN_ENABLE_MASK);
> -	reg_val |= pdata->tx_pin;
> -	ret = regmap_write(chip->regmap, REG_ENABLE, reg_val);
> -	if (ret < 0)
> -		goto out;
> -
> -out:
> -	dev_err(chip->dev, "Failed to read REG_ENABLE Register\n");
> +		dev_err(chip->dev, "Failed to update REG_ENABLE Register\n");
>   	return ret;
>   }
>   

