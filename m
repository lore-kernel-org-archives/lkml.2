Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab1HHFHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:07:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42501 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947Ab1HHFHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:07:21 -0400
Date: Mon, 8 Aug 2011 14:07:14 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Convert pcf50633 to use new register map API
Message-ID: <20110808050712.GA31168@opensource.wolfsonmicro.com>
References: <1312602304-21504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4E3F5817.2090405@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3F5817.2090405@metafoo.de>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 05:29:27AM +0200, Lars-Peter Clausen wrote:

> >  EXPORT_SYMBOL_GPL(pcf50633_reg_clear_bits);

> I would prefer making the wrappers static inline functions.

I considered doing this for all the conversions but preferred to go for
a minimal diff for ease of review, it seems better to do such code
motion changes later on.  Similarly for the return value stuff which
I'll update shortly.

> --- a/drivers/base/regmap/regmap-i2c.c
> +++ b/drivers/base/regmap/regmap-i2c.c
> @@ -70,6 +70,8 @@ static int regmap_i2c_read(struct device *dev,
>  	struct i2c_msg xfer[2];
>  	int ret;
> 
> +	printk("regmap_read: %d %d\n", reg_size, val_size);
> +

Clearly not ideal...
