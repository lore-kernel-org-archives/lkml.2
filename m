Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2BLMKC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 07:10:02 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59726 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837Ab2BLMKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 07:10:00 -0500
Message-ID: <4F37AC06.1050909@metafoo.de>
Date: Sun, 12 Feb 2012 13:09:42 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging:iio:dac: Fix kcalloc parameters swapped
References: <1328922048.2787.1.camel@phoenix>
In-Reply-To: <1328922048.2787.1.camel@phoenix>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2012 02:00 AM, Axel Lin wrote:
> The first parameter should be "number of elements" and the second parameter
> should be "element size".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  drivers/staging/iio/dac/ad5360.c |    4 ++--
>  drivers/staging/iio/dac/ad5380.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/iio/dac/ad5360.c b/drivers/staging/iio/dac/ad5360.c
> index 710b256..cec3693 100644
> --- a/drivers/staging/iio/dac/ad5360.c
> +++ b/drivers/staging/iio/dac/ad5360.c
> @@ -439,8 +439,8 @@ static int __devinit ad5360_alloc_channels(struct iio_dev *indio_dev)
>  	struct iio_chan_spec *channels;
>  	unsigned int i;
>  
> -	channels = kcalloc(sizeof(struct iio_chan_spec),
> -			st->chip_info->num_channels, GFP_KERNEL);
> +	channels = kcalloc(st->chip_info->num_channels,
> +			   sizeof(struct iio_chan_spec), GFP_KERNEL);
>  
>  	if (!channels)
>  		return -ENOMEM;
> diff --git a/drivers/staging/iio/dac/ad5380.c b/drivers/staging/iio/dac/ad5380.c
> index eff97ae0..4c50716 100644
> --- a/drivers/staging/iio/dac/ad5380.c
> +++ b/drivers/staging/iio/dac/ad5380.c
> @@ -363,8 +363,8 @@ static int __devinit ad5380_alloc_channels(struct iio_dev *indio_dev)
>  	struct iio_chan_spec *channels;
>  	unsigned int i;
>  
> -	channels = kcalloc(sizeof(struct iio_chan_spec),
> -			st->chip_info->num_channels, GFP_KERNEL);
> +	channels = kcalloc(st->chip_info->num_channels,
> +			   sizeof(struct iio_chan_spec), GFP_KERNEL);
>  
>  	if (!channels)
>  		return -ENOMEM;

