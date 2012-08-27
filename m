Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab2H0RZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 13:25:22 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55989 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2H0RZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 13:25:19 -0400
Message-ID: <503BAD7C.5010608@kernel.org>
Date: Mon, 27 Aug 2012 18:25:16 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 2/3] iio: use IIO_CHAN_INFO_RAW rather than 0
References: <A874F61F95741C4A9BA573A70FE3998F41EEFD76@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EEFD76@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 08:39 AM, Kim, Milo wrote:
> (a) For better readability, replace 0 with IIO_CHAN_INFO_RAW.
> (b) Make same line-format as other apis()
>     : iio_read_channel_scale() and iio_read_channel_offset()
> 
merged. Thanks.
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/iio/inkern.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index bd09245..5103337 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -239,8 +239,10 @@ int iio_read_channel_raw(struct iio_channel *chan, int *val)
>  		goto err_unlock;
>  	}
>  
> -	ret = chan->indio_dev->info->read_raw(chan->indio_dev, chan->channel,
> -					      val, &val2, 0);
> +	ret = chan->indio_dev->info->read_raw(chan->indio_dev,
> +					      chan->channel,
> +					      val, &val2,
> +					      IIO_CHAN_INFO_RAW);
>  err_unlock:
>  	mutex_unlock(&chan->indio_dev->info_exist_lock);
>  
> 
