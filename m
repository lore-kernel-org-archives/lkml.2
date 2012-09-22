Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2IVJOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 05:14:16 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52740 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2IVJOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 05:14:14 -0400
Message-ID: <505D8168.8000003@kernel.org>
Date: Sat, 22 Sep 2012 10:14:16 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iio: inkern: put the IIO device when it fails to
 allocate memory
References: <A874F61F95741C4A9BA573A70FE3998F41EF5397@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF5397@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 05:55 AM, Kim, Milo wrote:
>  The reference count of the IIO device is increased if the IIO map has
>  matched consumer name.
>  After then, it tries to allocate the iio_channel which is used by the consumer.
>  If it fails to allocate memory, the reference count should be decreased.
> 
>  This patch enables restoring the reference count of the IIO device.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Thanks add to togreg branch of iio.git

> ---
>  drivers/iio/inkern.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index 13748c0..aff034b 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -132,7 +132,7 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
>  
>  	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
>  	if (channel == NULL)
> -		return ERR_PTR(-ENOMEM);
> +		goto error_no_mem;
>  
>  	channel->indio_dev = c->indio_dev;
>  
> @@ -151,6 +151,9 @@ error_no_chan:
>  	iio_device_put(c->indio_dev);
>  	kfree(channel);
>  	return ERR_PTR(-EINVAL);
> +error_no_mem:
> +	iio_device_put(c->indio_dev);
> +	return ERR_PTR(-ENOMEM);
>  }
>  EXPORT_SYMBOL_GPL(iio_channel_get);
>  
> 
