Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab2LRTXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:23:13 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44730 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2LRTXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:23:11 -0500
Message-ID: <50D0C29D.3030209@kernel.org>
Date: Tue, 18 Dec 2012 19:23:09 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: dac: ad5446: Don't set error code to voltage_uv
References: <1355801617.11880.1.camel@phoenix>
In-Reply-To: <1355801617.11880.1.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 03:33 AM, Axel Lin wrote:
> regulator_get_voltage() may return negative error code.
> Add error checking to avoid setting error code to voltage_uv.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
added to fixes-togreg branch of iio.git
> ---
> Sorry. Just found I made the same mistake again.
> Here is v2, should check if ret is negative value.
>  drivers/iio/dac/ad5446.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/dac/ad5446.c b/drivers/iio/dac/ad5446.c
> index 3310cbb..607378f 100644
> --- a/drivers/iio/dac/ad5446.c
> +++ b/drivers/iio/dac/ad5446.c
> @@ -226,7 +226,11 @@ static int __devinit ad5446_probe(struct device *dev, const char *name,
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
>  	indio_dev = iio_device_alloc(sizeof(*st));
> 
