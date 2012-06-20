Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2FTLcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 07:32:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45489 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2FTLcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 07:32:39 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1340189141-20219-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1340189141-20219-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 20 Jun 2012 19:32:18 +0800
Message-ID: <CAF+7xWmmmUGy7zYdv+n66KVDUqLKJncjfGDosM7js17Mb2XSZg@mail.gmail.com>
Subject: Re: [PATCH] regulator: arizona: Add support for microphone supplies
 on Arizona devices
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -88,6 +88,13 @@ config REGULATOR_AAT2870
>          If you have a AnalogicTech AAT2870 say Y to enable the
>          regulator driver.
>
> +config REGULATOR_ARIZONA
> +       tristate "Wolfson Arizona class devices"
> +       depends on MFD_ARIZONA
> +       help
> +         Support for the regulators found on Wolfson Arizona class
> +         devices.
> +

I think you may want to put this Kconfig entriy along with other
Wolfson Microelectronics chips. So all Wolfson chips show in a group.

BTW, seems the MFD_ARIZONA patchs are not (yet) available in LKML.

> +static int arizona_micsupp_map_voltage(struct regulator_dev *rdev,
> +                                      int min_uV, int max_uV)
> +{
> +       unsigned int voltage;
> +       int selector;
> +
> +       if (min_uV < 1700000)
> +               min_uV = 1700000;
> +
> +       if (min_uV >= 3300000)
> +               selector = ARIZONA_MICSUPP_MAX_SELECTOR;
> +       else
> +               selector = DIV_ROUND_UP(min_uV - 1700000, 50000);
> +
> +       if (selector < 0)
> +               return -EINVAL;
I think you don't need this checking. You already ensure min_uV >= 1700000.

The rest of the code looks good to me.
Reviewed-by: Axel Lin <axel.lin@gmail.com>

Regards,
Axel
