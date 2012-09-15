Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2IOJ2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 05:28:13 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:35256 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2IOJ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 05:28:11 -0400
Message-ID: <50544A29.1080704@kernel.org>
Date: Sat, 15 Sep 2012 10:28:09 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] iio: inkern: allocate zeroed memory
References: <A874F61F95741C4A9BA573A70FE3998F41EF4C3E@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF4C3E@DQHE02.ent.ti.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 02:24 AM, Kim, Milo wrote:
>  Use kzalloc() rather than kmalloc() for initializing the iio_channel structure.
>  This patch enables the iio_dev and iio_chan_spec are set to NULL.
>  This may prevent the page fault problem because the pointer of iio_chan_spec
>  is initialized as NULL.
> 
>  The iio_chan_spec is updated only in case that the IIO map has
>  specific channel label.
>  When the map has no ADC channel label, then the value of iio_chan_spec
>  remains as invalid pointer.
>  To prevent this problem, the pointer should be initialized as NULL.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
merged to togreg branch of iio.git


> ---
>  drivers/iio/inkern.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index b5afc2f..1faa240 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -130,7 +130,7 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
>  	if (c == NULL)
>  		return ERR_PTR(-ENODEV);
>  
> -	channel = kmalloc(sizeof(*channel), GFP_KERNEL);
> +	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
>  	if (channel == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
> 
