Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1FBTZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:25:17 -0400
Received: from waste.org ([173.11.57.241]:59265 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab1FBTZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:25:15 -0400
Subject: Re: [PATCH] hw_random: timeriomem-rng: use resource_size
From: Matt Mackall <mpm@selenic.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, herbert@gondor.hengli.com.au
In-Reply-To: <201106011523.13707.hartleys@visionengravers.com>
References: <201106011523.13707.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 14:25:11 -0500
Message-ID: <1307042711.4204.633.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 15:23 -0700, H Hartley Sweeten wrote:
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Looks good to me.

Acked-by: Matt Mackall <mpm@selenic.com>

> ---
> 
> diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
> index a94e930..a8428e6 100644
> --- a/drivers/char/hw_random/timeriomem-rng.c
> +++ b/drivers/char/hw_random/timeriomem-rng.c
> @@ -100,8 +100,7 @@ static int __devinit timeriomem_rng_probe(struct platform_device *pdev)
>  
>  	timeriomem_rng_data = pdev->dev.platform_data;
>  
> -	timeriomem_rng_data->address = ioremap(res->start,
> -						res->end - res->start + 1);
> +	timeriomem_rng_data->address = ioremap(res->start, resource_size(res));
>  	if (!timeriomem_rng_data->address)
>  		return -EIO;
>  


-- 
Mathematics is the supreme nostalgia of our time.


