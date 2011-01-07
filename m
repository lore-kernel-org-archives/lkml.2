Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab1AGP0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:26:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32940 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1AGP0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:26:45 -0500
MIME-Version: 1.0
In-Reply-To: <1294410361-9092-1-git-send-email-richard.genoud@gmail.com>
References: <AANLkTimpTUz_Fizef09urPBR8vP80KU-5yApjzGWFwc0@mail.gmail.com> <1294410361-9092-1-git-send-email-richard.genoud@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 7 Jan 2011 08:26:23 -0700
X-Google-Sender-Auth: qIUDqVabCtOgWOfwQZS0dwZZo8U
Message-ID: <AANLkTin0eXCpLD1B0+zABqYcWxzG8+kM1cpRyD+Af_2n@mail.gmail.com>
Subject: Re: [PATCH] spi_imx.c: correct the test on platform_get_irq() return value
To: Richard Genoud <richard.genoud@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net,
        David Brownell <dbrownell@users.sourceforge.net>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 7:26 AM, Richard Genoud <richard.genoud@gmail.com> wrote:
> The test "if (spi_imx->irq <= 0)" is not testing the IRQ value, but the return value of platform_get_irq().
> As platform_get_irq() can return an error (-ENXIO) or the IRQ value it found, the test should be "if (spi_imx->irq < 0)"
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

For the majority of architectures in Linux, 0 is not a valid IRQ for
devices.  Unless there is an actual imx platform that currently
assigns linux irq 0 to the spi controller then I'd rather not apply
this change.

g.

> ---
>  drivers/spi/spi_imx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
> index 55a38e2..793ae99 100644
> --- a/drivers/spi/spi_imx.c
> +++ b/drivers/spi/spi_imx.c
> @@ -847,7 +847,7 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
>        }
>
>        spi_imx->irq = platform_get_irq(pdev, 0);
> -       if (spi_imx->irq <= 0) {
> +       if (spi_imx->irq < 0) {
>                ret = -EINVAL;
>                goto out_iounmap;
>        }
> --
> 1.7.1
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
