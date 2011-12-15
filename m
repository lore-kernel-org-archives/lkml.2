Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab1LOC7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:59:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43513 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1LOC7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:59:34 -0500
MIME-Version: 1.0
In-Reply-To: <1323894411-12294-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1323894411-12294-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Thu, 15 Dec 2011 10:59:34 +0800
Message-ID: <CAFQ4atSVe26uwX5xw5yEW1Dgs7KFxdB+Msg9PkkfpSswtsnDoA@mail.gmail.com>
Subject: Re: [PATCH] serial/imx: propagate error from of_alias_get_id instead
 of using -ENODEV
From: Jason Hui <jason.hui@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/15 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> A quick look at of_alias_get_id shows that in the error case it returns
> -ENODEV, too, but still it's better style to propagate the value as is.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
> Cc: Jason Liu <jason.hui@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/tty/serial/imx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index 163fc90..75c159a 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -1301,7 +1301,7 @@ static int serial_imx_probe_dt(struct imx_port *sport,
>        ret = of_alias_get_id(np, "serial");
>        if (ret < 0) {
>                dev_err(&pdev->dev, "failed to get alias id, errno %d\n", ret);
> -               return -ENODEV;
> +               return ret;
>        }
>        sport->port.line = ret;

Acked-by: Jason Liu <jason.hui@linaro.org>

>
> --
> 1.7.7.3
>
