Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1FTXYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:24:07 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:40027 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167Ab1FTXYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:24:04 -0400
Message-ID: <4DFFD64F.8040902@metafoo.de>
Date: Tue, 21 Jun 2011 01:22:55 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 2/8] regmap: Add I2C bus support
References: <20110620124608.GB31140@opensource.wolfsonmicro.com> <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1308574489-31322-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1308574489-31322-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2011 02:54 PM, Mark Brown wrote:
> [...]
> +
> +#include <linux/regmap.h>
> +#include <linux/i2c.h>

#include <linux/init.h>

> [...]
> +
> +static int regmap_i2c_read(struct device *dev,
> +			   const void *reg, size_t reg_size,
> +			   void *val, size_t val_size)
> +{
> +	struct i2c_client *i2c = to_i2c_client(dev);
> +	struct i2c_msg xfer[2];
> +	int ret;
> +
> +	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_PROTOCOL_MANGLING))
> +		return -ENOTSUPP;

You shouldn't need I2C_FUNC_PROTOCOL_MANGLING for reading.

> [...]
> diff --git a/drivers/regmap/regmap.c b/drivers/regmap/regmap.c
> index a8610c7..896b710 100644
> --- a/drivers/regmap/regmap.c
> +++ b/drivers/regmap/regmap.c
> @@ -461,7 +461,7 @@ out:
>  [...]

I guess this should be part of the first patch.


