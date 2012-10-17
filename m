Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2JQHob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:44:31 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:50699 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab2JQHoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:44:30 -0400
X-Auth-Info: 2HXiH63AxNJzhV2VP7xCAbNfpzDhfYuBwKimfgwzFAM=
From: Marek Vasut <marex@denx.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 1/2] backlight: lms283gf05: use devm_gpio_request_one
Date: Wed, 17 Oct 2012 09:01:13 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
References: <003801cdac2b$3c1012f0$b43038d0$%han@samsung.com>
In-Reply-To: <003801cdac2b$3c1012f0$b43038d0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210170901.13149.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jingoo Han,

> By using devm_gpio_request_one it is possible to set the direction
> and initial value in one shot. Thus, using devm_gpio_request_one
> can make the code simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Marek Vasut <marek.vasut@gmail.com>

Acked-by: Marek Vasut <marex@denx.de>

> ---
>  drivers/video/backlight/lms283gf05.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/video/backlight/lms283gf05.c
> b/drivers/video/backlight/lms283gf05.c index ea43f22..c452210 100644
> --- a/drivers/video/backlight/lms283gf05.c
> +++ b/drivers/video/backlight/lms283gf05.c
> @@ -158,13 +158,9 @@ static int __devinit lms283gf05_probe(struct
> spi_device *spi) int ret = 0;
> 
>  	if (pdata != NULL) {
> -		ret = devm_gpio_request(&spi->dev, pdata->reset_gpio,
> -					"LMS285GF05 RESET");
> -		if (ret)
> -			return ret;
> -
> -		ret = gpio_direction_output(pdata->reset_gpio,
> -						!pdata->reset_inverted);
> +		ret = devm_gpio_request_one(&spi->dev, pdata->reset_gpio,
> +				GPIOF_DIR_OUT | !pdata->reset_inverted,
> +				"LMS285GF05 RESET");
>  		if (ret)
>  			return ret;
>  	}

Best regards,
Marek Vasut
