Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1GDQHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:07:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60768 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115Ab1GDQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:07:03 -0400
Subject: Re: [patch] regulator/tps65912: storing error codes in u8
From: Liam Girdwood <lrg@kernel.org>
To: Dan Carpenter <error27@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20110623055715.GM14591@shale.localdomain>
References: <20110623055715.GM14591@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 17:06:58 +0100
Message-ID: <1309795618.3272.9.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 08:57 +0300, Dan Carpenter wrote:
> get_ctrl_reg() returns -EINVAL so the error handling won't work here
> if reg is a u8.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
> index d2c6542..3a9313e 100644
> --- a/drivers/regulator/tps65912-regulator.c
> +++ b/drivers/regulator/tps65912-regulator.c
> @@ -417,7 +417,7 @@ static int tps65912_reg_enable(struct regulator_dev *dev)
>  	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
>  	struct tps65912 *mfd = pmic->mfd;
>  	int id = rdev_get_id(dev);
> -	u8 reg;
> +	int reg;
>  
>  	if (id < TPS65912_REG_DCDC1 || id > TPS65912_REG_LDO10)
>  		return -EINVAL;

Samuel, would you mind taking this since tps65912 is upstreaming via
mfd.

Thanks !

Liam

