Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1JLFHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 01:07:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62589 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1JLFHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 01:07:14 -0400
Message-ID: <4E95207C.90302@linaro.org>
Date: Wed, 12 Oct 2011 13:07:08 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20111005 Icedove/3.1.15
MIME-Version: 1.0
To: ashish.jangam@kpitcummins.com
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dajun <dajun.chen@diasemi.com>, sameo@openedhand.com,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 01/11] MFD: DA9052/53 MFD core module v6
References: <1316435562.344.131.camel@L-0761.kpit.com>
In-Reply-To: <1316435562.344.131.camel@L-0761.kpit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011年09月19日 20:32), ashishj3 wrote:
> --- /dev/null
> +++ b/drivers/mfd/da9052-i2c.c
> @@ -0,0 +1,142 @@
> +/*
> + * I2C access for DA9052 PMICs.
> + *
> + * Copyright(c) 2011 Dialog Semiconductor Ltd.
> + *
> + * Author: David Dajun Chen <dchen@diasemi.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + */
> +
> +#include <linux/device.h>
> +#include <linux/input.h>
> +#include <linux/mfd/core.h>
> +#include <linux/i2c.h>
> +#include <linux/err.h>
> +
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +
> +static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
> +{
> +	int reg_val, ret;
> +
> +	ret = regmap_read(da9052->regmap, DA9052_CONTROL_B_REG, &reg_val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (reg_val & DA9052_CONTROL_B_WRITEMODE) {
> +		reg_val = ~DA9052_CONTROL_B_WRITEMODE;

Hi Ashish,

I think you should use reg_val &= ~DA9052_CONTROL_B_WRITEMODE; instead
of just "=".

Regards,
Paul
