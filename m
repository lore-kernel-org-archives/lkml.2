Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2LNJ5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:57:04 -0500
Received: from smtp-out-011.synserver.de ([212.40.185.11]:1116 "EHLO
	smtp-out-237.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755084Ab2LNJ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:57:00 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31930
Message-ID: <50CAF7E9.7000905@metafoo.de>
Date: Fri, 14 Dec 2012 10:56:57 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 1/6] iio: adc: ad7266: Don't set error code to st->vref_uv
References: <1355471245.11297.1.camel@phoenix>
In-Reply-To: <1355471245.11297.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 08:47 AM, Axel Lin wrote:
> regulator_get_voltage() may return negative error code.
> Add error checking to avoid setting error code to st->vref_uv.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks Axel, for the whole series:
Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  drivers/iio/adc/ad7266.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/ad7266.c b/drivers/iio/adc/ad7266.c
> index a6f4fc5..e36107d 100644
> --- a/drivers/iio/adc/ad7266.c
> +++ b/drivers/iio/adc/ad7266.c
> @@ -411,7 +411,11 @@ static int __devinit ad7266_probe(struct spi_device *spi)
>  		if (ret)
>  			goto error_put_reg;
>  
> -		st->vref_uv = regulator_get_voltage(st->reg);
> +		ret = regulator_get_voltage(st->reg);
> +		if (ret < 0)
> +			goto error_disable_reg;
> +
> +		st->vref_uv = ret;
>  	} else {
>  		/* Use internal reference */
>  		st->vref_uv = 2500000;

