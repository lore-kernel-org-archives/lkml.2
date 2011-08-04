Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1HDMik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:38:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55261 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753912Ab1HDMiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:38:24 -0400
Date: Thu, 4 Aug 2011 21:12:39 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dahuang@nvidia.com
Cc: lrg@ti.com, mike@compulab.co.il, sameo@linux.intel.com, xxie@nvidia.com,
        gking@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: add SMx slew rate setting
Message-ID: <20110804121237.GA9959@opensource.wolfsonmicro.com>
References: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 07:34:22PM +0800, dahuang@nvidia.com wrote:
> From: Danny Huang <dahuang@nvidia.com>
> 
> Add output vlotage slew rate setting for SM0/SM1
> 
> From: Xin Xie <xxie@nvidia.com>

Looks like you messed up here, I rather suspect Xin Xie rather than you
should be the author?

> +static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev)
> +{
> +	struct device *parent = pdev->dev.parent;
> +	struct regulator_init_data *p = pdev->dev.platform_data;
> +	struct tps6586x_settings *setting = p->driver_data;

If this is system configured data (which is what one would expect for
this) it should be coming in as platform data not driver data - what's
happened here?

> +	default:
> +		dev_err(&pdev->dev, "invalid regulator ID\n");
> +		return -EINVAL;
> +	}

Should say what data is invalid here, otherwise it's not going to be at
all obvious what's invalid.

> +enum {
> +	TPS6586x_SLEW_RATE_INSTANTLY,
> +	TPS6586x_SLEW_RATE_110UV,
> +	TPS6586x_SLEW_RATE_220UV,
> +	TPS6586x_SLEW_RATE_440UV,
> +	TPS6586x_SLEW_RATE_880UV,
> +	TPS6586x_SLEW_RATE_1760UV,
> +	TPS6586x_SLEW_RATE_3520UV,
> +	TPS6586x_SLEW_RATE_7040UV,
> +};

If the values are being written directly to the chip you should probably
explicitly specify the values that are being set.
