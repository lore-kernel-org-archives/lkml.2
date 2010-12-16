Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0LPRYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:24:01 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58519 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0LPRYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:24:00 -0500
MIME-Version: 1.0
In-Reply-To: <1292519639-21859-3-git-send-email-w.sang@pengutronix.de>
References: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de> <1292519639-21859-3-git-send-email-w.sang@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 16 Dec 2010 10:23:40 -0700
X-Google-Sender-Auth: G6W62QH-Pg746nvHjg2xSKkI5QY
Message-ID: <AANLkTi=hKvEDd7+e9hoFxF-VP-Fy648OEX7ha1gBLkKz@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi: mpc52xx_psc_spi: fix section mismatch warning
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 10:13 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Done by using of_probe_platform_driver() instead of
> of_register_platform_driver().
>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Move the probe hook to the __devinit section instead.

g.

> ---
>  drivers/spi/mpc52xx_psc_spi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/mpc52xx_psc_spi.c b/drivers/spi/mpc52xx_psc_spi.c
> index 983fbbf..4bf6d37 100644
> --- a/drivers/spi/mpc52xx_psc_spi.c
> +++ b/drivers/spi/mpc52xx_psc_spi.c
> @@ -509,7 +509,6 @@ static const struct of_device_id mpc52xx_psc_spi_of_match[] = {
>  MODULE_DEVICE_TABLE(of, mpc52xx_psc_spi_of_match);
>
>  static struct of_platform_driver mpc52xx_psc_spi_of_driver = {
> -       .probe = mpc52xx_psc_spi_of_probe,
>        .remove = __exit_p(mpc52xx_psc_spi_of_remove),
>        .driver = {
>                .name = "mpc52xx-psc-spi",
> @@ -520,7 +519,8 @@ static struct of_platform_driver mpc52xx_psc_spi_of_driver = {
>
>  static int __init mpc52xx_psc_spi_init(void)
>  {
> -       return of_register_platform_driver(&mpc52xx_psc_spi_of_driver);
> +       return of_probe_platform_driver(&mpc52xx_psc_spi_of_driver,
> +                                       mpc52xx_psc_spi_of_probe);
>  }
>  module_init(mpc52xx_psc_spi_init);
>
> --
> 1.7.2.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
