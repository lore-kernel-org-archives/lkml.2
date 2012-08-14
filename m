Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2HNU30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:29:26 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39511 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab2HNU3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:29:25 -0400
Message-ID: <502AB521.6090201@kernel.org>
Date: Tue, 14 Aug 2012 21:29:21 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: lm3533-als: Fix build warnings
References: <1343902209.1207.2.camel@phoenix>
In-Reply-To: <1343902209.1207.2.camel@phoenix>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 11:10 AM, Axel Lin wrote:
> Fix below build warnings:
>   CC [M]  drivers/iio/light/lm3533-als.o
> drivers/iio/light/lm3533-als.c:667:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/iio/light/lm3533-als.c:667:8: warning: (near initialization for 'dev_attr_in_illuminance0_thresh_either_en.show') [enabled by default]
> drivers/iio/light/lm3533-als.c:667:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/iio/light/lm3533-als.c:667:8: warning: (near initialization for 'dev_attr_in_illuminance0_thresh_either_en.store') [enabled by default]
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Thanks queued up.
> ---
>  drivers/iio/light/lm3533-als.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/light/lm3533-als.c b/drivers/iio/light/lm3533-als.c
> index c3e7bac..e45712a9 100644
> --- a/drivers/iio/light/lm3533-als.c
> +++ b/drivers/iio/light/lm3533-als.c
> @@ -404,7 +404,7 @@ out:
>  	return ret;
>  }
>  
> -static int show_thresh_either_en(struct device *dev,
> +static ssize_t show_thresh_either_en(struct device *dev,
>  					struct device_attribute *attr,
>  					char *buf)
>  {
> @@ -424,7 +424,7 @@ static int show_thresh_either_en(struct device *dev,
>  	return scnprintf(buf, PAGE_SIZE, "%u\n", enable);
>  }
>  
> -static int store_thresh_either_en(struct device *dev,
> +static ssize_t store_thresh_either_en(struct device *dev,
>  					struct device_attribute *attr,
>  					const char *buf, size_t len)
>  {
> 
