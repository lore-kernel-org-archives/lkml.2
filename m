Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1HRQSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:18:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38054 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755332Ab1HRQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:18:29 -0400
Date: Fri, 19 Aug 2011 01:18:13 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: sameo@openedhand.com, linux-kernel@vger.kernel.org,
        Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org,
        arnd@arndb.de
Subject: Re: [PATCH 01/11] MFD: DA9052/53 MFD core module v4
Message-ID: <20110818161811.GC20208@opensource.wolfsonmicro.com>
References: <1313675603.4108.151.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313675603.4108.151.camel@L-0532.kpit.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 07:23:22PM +0530, ashishj3 wrote:

> +int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
> +{
> +	int val, ret;
> +
> +	if (reg > DA9052_MAX_REG_CNT) {
> +		dev_err(da9052->dev, "invalid reg %x\n", reg);
> +		return -EINVAL;
> +	}
> +
> +	if (da9052->bustype == BUS_SPI)
> +		reg = (reg << 1) | 1;

The same comment I made last time applies now: this isn't something that
should be being handled at the driver level.

For all your I/O functions there's not really any work going on in the
function except the translation from struct da9052 to the regmap it
points to.  May as well just turn the functions into inlines.

> +	if (events == 0)
> +		goto err;
> +
> +	for (i = 0; i < 32; i++) {
> +		if (events & (1 << i))
> +			handle_nested_irq(da9052->irq_base + i);
> +	}
> +
> +	da9052_group_write(da9052, DA9052_EVENT_A_REG, 4, v);
> +
> +	if (da9052->chip_id == DA9052 || da9052->chip_id == DA9053_AA)
> +		DA9052_FIXME();
> +
> +err:
> +	return IRQ_HANDLED;

If you hit an error you didn't handle an IRQ and so ought to be
returning IRQ_NONE.
