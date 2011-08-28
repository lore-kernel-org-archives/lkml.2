Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1H1Qtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 12:49:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61289 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1H1QtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 12:49:24 -0400
Subject: Re: [PATCH 1/4] regulator: tps65023: Fixes i2c configuration issues
From: Liam Girdwood <lrg@kernel.org>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1312828175-11999-2-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
	 <1312828175-11999-1-git-send-email-marcus.folkesson@gmail.com>
	 <1312828175-11999-2-git-send-email-marcus.folkesson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Aug 2011 17:49:20 +0100
Message-ID: <1314550160.3666.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 20:29 +0200, Marcus Folkesson wrote:
> Allow i2c core voltage adjustments by clearing CORE ADJ Allowed bit in CTRL2
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/tps65023-regulator.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
> index 701a590..7bd3c4d 100644
> --- a/drivers/regulator/tps65023-regulator.c
> +++ b/drivers/regulator/tps65023-regulator.c
> @@ -63,6 +63,13 @@
>  #define TPS65023_REG_CTRL_LDO2_EN	BIT(2)
>  #define TPS65023_REG_CTRL_LDO1_EN	BIT(1)
>  
> +/* REG_CTRL2 bitfields */
> +#define TPS65023_REG_CTRL2_GO		BIT(7)
> +#define TPS65023_REG_CTRL2_CORE_ADJ	BIT(6)
> +#define TPS65023_REG_CTRL2_DCDC2	BIT(2)
> +#define TPS65023_REG_CTRL2_DCDC1	BIT(1)
> +#define TPS65023_REG_CTRL2_DCDC3	BIT(0)
> +
>  /* LDO_CTRL bitfields */
>  #define TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_id)	((ldo_id)*4)
>  #define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0xF0 >> ((ldo_id)*4))
> @@ -475,6 +482,10 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
>  
>  	i2c_set_clientdata(client, tps);
>  
> +	/* Enable setting output voltage by I2C */
> +	tps_65023_clear_bits(tps, TPS65023_REG_CON_CTRL2,
> +						TPS65023_REG_CTRL2_CORE_ADJ);
> +
>  	return 0;
>  
>   fail:

All Applied.

Thanks

Liam

