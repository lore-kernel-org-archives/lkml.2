Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab1JWJaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 05:30:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38898 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab1JWJaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 05:30:22 -0400
Date: Sun, 23 Oct 2011 10:30:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Add S5M8767 regulator driver
Message-ID: <20111023093020.GC3135@opensource.wolfsonmicro.com>
References: <009501cc915b$809ce880$81d6b980$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009501cc915b$809ce880$81d6b980$@com>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 05:12:27PM +0900, Sangbeom Kim wrote:

This mostly looks good, a few smaller comments below but nothing major.

> +static int s5m8767_reg_enable_suspend(struct regulator_dev *rdev)
> +{
> +	return 0;
> +}

> +static int s5m8767_reg_disable_suspend(struct regulator_dev *rdev)
> +{

I guess you need an implementation for enable_suspend() (otherwise you
can't do disable->enable).

> +	{
> +		.name	= "AP 32KHz",
> +		.id	= S5M8767_32KHZAP_EN,
> +		.ops	= &s5m8767_others_ops,
> +		.type	= REGULATOR_VOLTAGE,
> +		.owner	= THIS_MODULE,
> +	}, {
> +		.name	= "CP 32KHz",
> +		.id	= S5M8767_32KHZAP_EN,
> +		.ops	= &s5m8767_others_ops,
> +		.type	= REGULATOR_VOLTAGE,
> +		.owner	= THIS_MODULE,
> +	},

Do these actually share anything with the other regulators?  If not then
I guess it's better to do with the struct clk framework.

> +	if (!pdata) {
> +		dev_err(pdev->dev.parent, "Platform data not supplied\n");
> +		return -ENODEV;
> +	}

It should be possible to register without platform data now (giving
readback only support).  Older versions of the regulator API required
constraints.

> +				dev_warn(&pdev->dev, "Duplicated gpio
> request"
> +						" for SET3\n");

Please keep the strings on one line (it makes grepping for errors
easier).
