Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab2JSRm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:42:58 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:58455 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab2JSRm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:42:56 -0400
Message-ID: <508173B6.20806@kernel.org>
Date: Fri, 19 Oct 2012 16:37:26 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: "cbou@mail.ru" <cbou@mail.ru>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] lp8788-charger: use consumer device name on setting
 IIO channels
References: <A874F61F95741C4A9BA573A70FE3998F64178F97@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F64178F97@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 07:11 AM, Kim, Milo wrote:
>  To get the ADC value for the battery voltage and temperature,
>  LP8788 ADC driver is used.
>  LP8788 charger driver is the consumer of LP8788 ADC driver.
>  Thus, specific ADC driver name is required on getting the channel
>  using iio_channel_get().
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>

> ---
>  drivers/power/lp8788-charger.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/power/lp8788-charger.c b/drivers/power/lp8788-charger.c
> index e852d12..614e6aa 100644
> --- a/drivers/power/lp8788-charger.c
> +++ b/drivers/power/lp8788-charger.c
> @@ -592,7 +592,8 @@ static void lp8788_irq_unregister(struct platform_device *pdev,
>  	}
>  }
>  
> -static void lp8788_setup_adc_channel(struct lp8788_charger *pchg)
> +static void lp8788_setup_adc_channel(const char *consumer_name,
> +				struct lp8788_charger *pchg)
>  {
>  	struct lp8788_charger_platform_data *pdata = pchg->pdata;
>  	struct device *dev = pchg->lp->dev;
> @@ -616,7 +617,7 @@ static void lp8788_setup_adc_channel(struct lp8788_charger *pchg)
>  	case LPADC_VBATT_5P5:
>  	case LPADC_VBATT_6P0:
>  	case LPADC_VBATT_5P0:
> -		chan = iio_channel_get(NULL, chan_name[id]);
> +		chan = iio_channel_get(consumer_name, chan_name[id]);
>  		pchg->chan[LP8788_VBATT] = IS_ERR(chan) ? NULL : chan;
>  		break;
>  	default:
> @@ -631,7 +632,7 @@ static void lp8788_setup_adc_channel(struct lp8788_charger *pchg)
>  	case LPADC_ADC2:
>  	case LPADC_ADC3:
>  	case LPADC_ADC4:
> -		chan = iio_channel_get(NULL, chan_name[id]);
> +		chan = iio_channel_get(consumer_name, chan_name[id]);
>  		pchg->chan[LP8788_BATT_TEMP] = IS_ERR(chan) ? NULL : chan;
>  		break;
>  	default:
> @@ -747,7 +748,7 @@ static __devinit int lp8788_charger_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> -	lp8788_setup_adc_channel(pchg);
> +	lp8788_setup_adc_channel(pdev->name, pchg);
>  
>  	ret = lp8788_psy_register(pdev, pchg);
>  	if (ret)
> 
