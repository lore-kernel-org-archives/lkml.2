Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2FJOis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:38:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62202 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2FJOir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:38:47 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1339220131-24189-1-git-send-email-festevam@gmail.com>
References: <1339220131-24189-1-git-send-email-festevam@gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 10 Jun 2012 22:38:26 +0800
Message-ID: <CAF+7xWki5XXViroUUeZtwyRubDRAd7Okf3nLfjN8CpsKTrd30A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mfd: mc13xxx-i2c: Convert to devm_regmap_init_i2c()
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, u.kleine-koenig@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/9 Fabio Estevam <festevam@gmail.com>:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Current code misses a "regmap_exit(mc13xxx->regmap)" in the error and remove paths.
>
> Converting to devm_regmap_init_i2c() makes the regmap_exit unnecessary.

This is already included in this patch: (although it is not yet upstream)
http://www.spinics.net/lists/kernel/msg1346844.html

>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/mfd/mc13xxx-i2c.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
> index d22501d..0e38672 100644
> --- a/drivers/mfd/mc13xxx-i2c.c
> +++ b/drivers/mfd/mc13xxx-i2c.c
> @@ -72,7 +72,7 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
>        mc13xxx->dev = &client->dev;
>        mutex_init(&mc13xxx->lock);
>
> -       mc13xxx->regmap = regmap_init_i2c(client, &mc13xxx_regmap_i2c_config);
> +       mc13xxx->regmap = devm_regmap_init_i2c(client, &mc13xxx_regmap_i2c_config);
To convert to devm_regmap_init_i2c(), you also need to remove the
regmap_exit() call
in mc13xxx_common_cleanup().

Axel
