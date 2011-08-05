Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1HELvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 07:51:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17221 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1HELvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 07:51:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 05 Aug 2011 04:51:20 -0700
From: Danny Huang <dahuang@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "mike@compulab.co.il" <mike@compulab.co.il>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Xin Xie <xxie@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Aug 2011 19:51:15 +0800
Subject: RE: [PATCH] regulator: tps6586x: add SMx slew rate setting
Thread-Topic: [PATCH] regulator: tps6586x: add SMx slew rate setting
Thread-Index: AcxSo3lz5yU+dRWUQsiyeYqeJsiy5wAwdpow
Message-ID: <1BA5D2DFD2730747A2B3725B59933B93C07A47561C@HKMAIL01.nvidia.com>
References: <1312457662-4490-1-git-send-email-dahuang@nvidia.com>
 <20110804121237.GA9959@opensource.wolfsonmicro.com>
In-Reply-To: <20110804121237.GA9959@opensource.wolfsonmicro.com>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the feedback.
The reason for using driver_data is that I can't find a proper field in regulator_init_data for the slew rate setting.
I'll do some correction based on the feedback and try to add a new field for the slew rate setting.

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Thursday, August 04, 2011 20:13
To: Danny Huang
Cc: lrg@ti.com; mike@compulab.co.il; sameo@linux.intel.com; Xin Xie; gking@nvidia.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps6586x: add SMx slew rate setting

On Thu, Aug 04, 2011 at 07:34:22PM +0800, dahuang@nvidia.com wrote:
> From: Danny Huang <dahuang@nvidia.com>
> 
> Add output vlotage slew rate setting for SM0/SM1
> 
> From: Xin Xie <xxie@nvidia.com>

Looks like you messed up here, I rather suspect Xin Xie rather than you should be the author?

> +static int tps6586x_regulator_set_slew_rate(struct platform_device 
> +*pdev) {
> +	struct device *parent = pdev->dev.parent;
> +	struct regulator_init_data *p = pdev->dev.platform_data;
> +	struct tps6586x_settings *setting = p->driver_data;

If this is system configured data (which is what one would expect for
this) it should be coming in as platform data not driver data - what's happened here?

> +	default:
> +		dev_err(&pdev->dev, "invalid regulator ID\n");
> +		return -EINVAL;
> +	}

Should say what data is invalid here, otherwise it's not going to be at all obvious what's invalid.

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

If the values are being written directly to the chip you should probably explicitly specify the values that are being set.
