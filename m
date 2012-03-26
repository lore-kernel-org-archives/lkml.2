Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2CZLEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:04:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3567 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301Ab2CZLE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:04:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 26 Mar 2012 04:04:28 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Mar 2012 16:34:23 +0530
Subject: RE: [PATCH 1/2] mfd: tps65090: Fix ifdefs for suspend mode
Thread-Topic: [PATCH 1/2] mfd: tps65090: Fix ifdefs for suspend mode
Thread-Index: Ac0IWxPp47b4NkbvTLW1KNYlLaKtOwC5Ps2w
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3128294@BGMAIL02.nvidia.com>
References: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1332441541-28197-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark for clarifying.

Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>


> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Friday, March 23, 2012 12:09 AM
> To: Samuel Ortiz; Venu Byravarasu
> Cc: linux-kernel@vger.kernel.org; Mark Brown
> Subject: [PATCH 1/2] mfd: tps65090: Fix ifdefs for suspend mode
> 
> CONFIG_PM also covers runtime only PM.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/tps65090.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index a66d4df..ac7e8b1 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -334,7 +334,7 @@ static int __devexit tps65090_i2c_remove(struct
> i2c_client *client)
>  	return 0;
>  }
> 
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  static int tps65090_i2c_suspend(struct i2c_client *client, pm_message_t state)
>  {
>  	if (client->irq)
> @@ -363,7 +363,7 @@ static struct i2c_driver tps65090_driver = {
>  	},
>  	.probe		= tps65090_i2c_probe,
>  	.remove		= __devexit_p(tps65090_i2c_remove),
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>  	.suspend	= tps65090_i2c_suspend,
>  	.resume		= tps65090_i2c_resume,
>  #endif
> --
> 1.7.9.1

