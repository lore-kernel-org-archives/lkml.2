Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1JQVIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:08:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64673 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1JQVIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:08:07 -0400
MIME-Version: 1.0
In-Reply-To: <1318885455-905-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1318885455-905-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 17 Oct 2011 15:07:47 -0600
X-Google-Sender-Auth: rss3TEghwuCaH91t2eA4dMKMFwE
Message-ID: <CACxGe6vqUjayFVu1wNUYN_zjngKJcXkzzcxcGn4bwkHG7xv2yg@mail.gmail.com>
Subject: Re: [PATCH] gpio/samsung: Complain loudly if we don't know the SoC
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Grant Likely <grant@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 3:04 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> If we don't know the SoC type then we won't add any chips which is rather
> unfortunate as neither GPIO nor pinmux APIs will work, breaking lots of
> different subsystems. Logging at least provides a hint to the user as to
> what's gone wrong.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Be Bolder!  May as well use WARN() and be really obnoxious.  :-)

g.

> ---
>  drivers/gpio/gpio-samsung.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index 8baa946..90455de 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -2495,6 +2495,9 @@ static __init int samsung_gpiolib_init(void)
>                s5p_register_gpioint_bank(IRQ_GPIO_XA, 0, IRQ_GPIO1_NR_GROUPS);
>                s5p_register_gpioint_bank(IRQ_GPIO_XB, IRQ_GPIO1_NR_GROUPS, IRQ_GPIO2_NR_GROUPS);
>  #endif
> +       } else {
> +               pr_crit("Unknown SoC in gpio-samsung, no GPIOs added\n");
> +               return -ENODEV;
>        }
>
>        return 0;
> --
> 1.7.6.3
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
