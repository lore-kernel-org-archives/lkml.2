Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab0HIHfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:35:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41917 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755418Ab0HIHfA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:35:00 -0400
References: <1281324445.12901.1.camel@mola> (sfid-20100809_042548_456204_B2C4C107)
Message-Id: <CA50E81F-C114-4734-9EF4-88CFD1487DB6@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
In-Reply-To: <1281324445.12901.1.camel@mola> (sfid-20100809_042548_456204_B2C4C107)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: iPad Mail (7B405)
Mime-Version: 1.0 (iPad Mail 7B405)
Subject: Re: [PATCH] regulator: tps6507x - add missing platform_set_drvdata in tps6507x_pmic_probe
Date: Mon, 9 Aug 2010 08:35:08 +0100
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 9 Aug 2010, at 04:27, Axel Lin <axel.lin@gmail.com> wrote:

> We should call platform_set_drvdata() before calling platform_get_drvdata().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> drivers/regulator/tps6507x-regulator.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
> index 8152d65..fbe21f7 100644
> --- a/drivers/regulator/tps6507x-regulator.c
> +++ b/drivers/regulator/tps6507x-regulator.c
> @@ -614,6 +614,7 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
>  	}
> 
>  	tps6507x_dev->pmic = tps;
> +	platform_set_drvdata(pdev, tps6507x_dev);
> 
>  	return 0;
> 
> @@ -640,6 +641,7 @@ static int __devexit tps6507x_pmic_remove(struct platform_device *pdev)
>  	for (i = 0; i < TPS6507X_NUM_REGULATOR; i++)
>  		regulator_unregister(tps->rdev[i]);
> 
> +	platform_set_drvdata(pdev, NULL);
>  	kfree(tps);

This is not needed - we're unbinding the driver so should no longer be looking at the driver data.

> 
>  	return 0;
> -- 
> 1.5.4.3
> 
> 
> 
