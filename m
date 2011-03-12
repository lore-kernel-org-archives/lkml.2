Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1CLJOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 04:14:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62969 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab1CLJOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 04:14:39 -0500
Date: Sat, 12 Mar 2011 02:14:37 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Miguel Gaio <miguel.gaio@efixo.com>,
        Mocean Laboratories <info@mocean-labs.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gpio: Use  __devexit at necessary places
Message-ID: <20110312091437.GI9347@angua.secretlab.ca>
References: <1299748245.18619.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299748245.18619.5.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 05:10:45PM +0800, Axel Lin wrote:
> The function gen_74x164_remove and mc33880_remove are used only wrapped
> by __devexit_p so define it using __devexit.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Miguel Gaio <miguel.gaio@efixo.com>
> Cc: Mocean Laboratories <info@mocean-labs.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/74x164.c  |    2 +-
>  drivers/gpio/mc33880.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/74x164.c b/drivers/gpio/74x164.c
> index d91ff4c..84e0702 100644
> --- a/drivers/gpio/74x164.c
> +++ b/drivers/gpio/74x164.c
> @@ -133,7 +133,7 @@ exit_destroy:
>  	return ret;
>  }
>  
> -static int gen_74x164_remove(struct spi_device *spi)
> +static int __devexit gen_74x164_remove(struct spi_device *spi)
>  {
>  	struct gen_74x164_chip *chip;
>  	int ret;
> diff --git a/drivers/gpio/mc33880.c b/drivers/gpio/mc33880.c
> index 935479d..00f6d24 100644
> --- a/drivers/gpio/mc33880.c
> +++ b/drivers/gpio/mc33880.c
> @@ -146,7 +146,7 @@ exit_destroy:
>  	return ret;
>  }
>  
> -static int mc33880_remove(struct spi_device *spi)
> +static int __devexit mc33880_remove(struct spi_device *spi)
>  {
>  	struct mc33880 *mc;
>  	int ret;
> -- 
> 1.7.2
> 
> 
> 
