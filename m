Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab2LEBpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:45:53 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47112 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2LEBpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:45:51 -0500
MIME-Version: 1.0
In-Reply-To: <1353522362-25519-3-git-send-email-dianders@chromium.org>
References: <1353450428-2615-2-git-send-email-dianders@chromium.org>
	<1353522362-25519-1-git-send-email-dianders@chromium.org>
	<1353522362-25519-3-git-send-email-dianders@chromium.org>
Date: Wed, 5 Dec 2012 09:45:49 +0800
Message-ID: <CAN1soZyfCOpy_+K1O3dJ42X1vAKK3CrriDL5nBXkGs_f4zLjcA@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c: pxa: Use i2c-core to get bus number now
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-i2c@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 2:26 AM, Doug Anderson <dianders@chromium.org> wrote:
> The commit: "i2c-core: dt: Pick i2c bus number from i2c alias if
> present" adds support for automatically picking the bus number based
> on the alias ID.  Remove the now unnecessary code from i2c-pxa that
> did the same thing.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/i2c/busses/i2c-pxa.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
> index 1034d93..8ee9fa0 100644
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -1053,16 +1053,10 @@ static int i2c_pxa_probe_dt(struct platform_device *pdev, struct pxa_i2c *i2c,
>         struct device_node *np = pdev->dev.of_node;
>         const struct of_device_id *of_id =
>                         of_match_device(i2c_pxa_dt_ids, &pdev->dev);
> -       int ret;
>
>         if (!of_id)
>                 return 1;
> -       ret = of_alias_get_id(np, "i2c");
> -       if (ret < 0) {
> -               dev_err(&pdev->dev, "failed to get alias id, errno %d\n", ret);
> -               return ret;
> -       }
> -       pdev->id = ret;
> +       pdev->id = -1;
>         if (of_get_property(np, "mrvl,i2c-polling", NULL))
>                 i2c->use_pio = 1;
>         if (of_get_property(np, "mrvl,i2c-fast-mode", NULL))
> --
> 1.7.7.3
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
