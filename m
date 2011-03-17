Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1CQQeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:34:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39647 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1CQQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:34:08 -0400
Date: Thu, 17 Mar 2011 10:34:04 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] rtc-{ds1390,ds3234,m41t94}: Use spi_get_drvdata() for
 SPI devices
Message-ID: <20110317163404.GA9597@angua.secretlab.ca>
References: <alpine.DEB.2.00.1103171446130.23741@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1103171446130.23741@ayla.of.borg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 02:47:56PM +0100, Geert Uytterhoeven wrote:
> The recently increased type checking in platform_get_drvdata() reveals a few
> offenders:
> 
> drivers/rtc/rtc-ds1390.c:161: warning: passing argument 1 of ‘platform_get_drvdata’ from incompatible pointer type
> drivers/rtc/rtc-ds3234.c:161: warning: passing argument 1 of ‘platform_get_drvdata’ from incompatible pointer type
> drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of ‘platform_get_drvdata’ from incompatible pointer type
> 
> Use spi_get_drvdata() instead of platform_get_drvdata().
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Obviously correct, thanks.

Merged.

g.

> ---
>  drivers/rtc/rtc-ds1390.c |    2 +-
>  drivers/rtc/rtc-ds3234.c |    2 +-
>  drivers/rtc/rtc-m41t94.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
> index 26a86d2..b038d2c 100644
> --- a/drivers/rtc/rtc-ds1390.c
> +++ b/drivers/rtc/rtc-ds1390.c
> @@ -158,7 +158,7 @@ static int __devinit ds1390_probe(struct spi_device *spi)
>  
>  static int __devexit ds1390_remove(struct spi_device *spi)
>  {
> -	struct ds1390 *chip = platform_get_drvdata(spi);
> +	struct ds1390 *chip = spi_get_drvdata(spi);
>  
>  	rtc_device_unregister(chip->rtc);
>  	kfree(chip);
> diff --git a/drivers/rtc/rtc-ds3234.c b/drivers/rtc/rtc-ds3234.c
> index a774ca3..bbd2622 100644
> --- a/drivers/rtc/rtc-ds3234.c
> +++ b/drivers/rtc/rtc-ds3234.c
> @@ -158,7 +158,7 @@ static int __devinit ds3234_probe(struct spi_device *spi)
>  
>  static int __devexit ds3234_remove(struct spi_device *spi)
>  {
> -	struct rtc_device *rtc = platform_get_drvdata(spi);
> +	struct rtc_device *rtc = spi_get_drvdata(spi);
>  
>  	rtc_device_unregister(rtc);
>  	return 0;
> diff --git a/drivers/rtc/rtc-m41t94.c b/drivers/rtc/rtc-m41t94.c
> index c8c97a4..e259ed7 100644
> --- a/drivers/rtc/rtc-m41t94.c
> +++ b/drivers/rtc/rtc-m41t94.c
> @@ -136,7 +136,7 @@ static int __devinit m41t94_probe(struct spi_device *spi)
>  
>  static int __devexit m41t94_remove(struct spi_device *spi)
>  {
> -	struct rtc_device *rtc = platform_get_drvdata(spi);
> +	struct rtc_device *rtc = spi_get_drvdata(spi);
>  
>  	if (rtc)
>  		rtc_device_unregister(rtc);
> -- 
> 1.7.0.4
> 
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
