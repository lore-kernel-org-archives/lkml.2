Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2LPLJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 06:09:54 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:46274 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2LPLJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 06:09:50 -0500
Message-ID: <50CDABF9.3030403@kernel.org>
Date: Sun, 16 Dec 2012 11:09:45 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] iio: dac: ad5504: Don't set error code to voltage_uv
References: <1355486789.3475.1.camel@phoenix>
In-Reply-To: <1355486789.3475.1.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 12:06 PM, Axel Lin wrote:
> regulator_get_voltage() may return negative error code.
> Add error checking to avoid setting error code to voltage_uv.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Axel,

I would definitely have prefered a resend of the whole series rather than
just the ones you have fixed up.

I assumed Lars would have no objection to Acking these as well!

Anyhow 1,2,6 from v1 and 3,4,5 from v2 added to fixes-togreg branch of
iio.git.

Thanks for all these!

Jonathan

> ---
> v2: check if ret is negative value
>  drivers/iio/dac/ad5504.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/dac/ad5504.c b/drivers/iio/dac/ad5504.c
> index 242bdc7..1e9a1f4 100644
> --- a/drivers/iio/dac/ad5504.c
> +++ b/drivers/iio/dac/ad5504.c
> @@ -296,7 +296,11 @@ static int __devinit ad5504_probe(struct spi_device *spi)
>  		if (ret)
>  			goto error_put_reg;
>  
> -		voltage_uv = regulator_get_voltage(reg);
> +		ret = regulator_get_voltage(reg);
> +		if (ret < 0)
> +			goto error_disable_reg;
> +
> +		voltage_uv = ret;
>  	}
>  
>  	spi_set_drvdata(spi, indio_dev);
> 
