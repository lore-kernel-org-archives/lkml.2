Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab2HYSbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 14:31:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36454 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab2HYSbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 14:31:18 -0400
Date: Sat, 25 Aug 2012 11:31:14 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-leds@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Wim Van Sebroeck <wim@iguana.be>, Bryan Wu <bryan.wu@canonical.com>,
        "Richard Purdie <rpurdie@rpsys.net> Anthony Olech" 
	<anthony.olech@diasemi.com>
Subject: Re: [PATCH 1/8] mfd: Add Dialog DA906x core driver.
Message-ID: <20120825183113.GE6520@opensource.wolfsonmicro.com>
References: <201208241445@sw-eng-lt-dc-vm2>
 <201208241450@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208241450@sw-eng-lt-dc-vm2>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 02:50:00PM +0100, Krystian Garbaciak wrote:

> This is MFD module providing access to registers and interrupts of DA906x
> series PMIC. It is used by other functional modules, registered as MFD cells.
> Driver uses regmap with paging to access extended register list. Register map
> is divided into two pages, where the second page is used during initialisation.

Your selection of people to CC here appears both large and random...

> +inline unsigned int da906x_to_range_reg(u16 reg)
> +{
> +	return reg + DA906X_MAPPING_BASE;
> +}

I've no real idea what this stuff is all about, it at least needs some
comments somewhere.  The fact that you're just adding a constant offset
to all registers is at best odd.

> +	if (pdata->flags & DA906X_FLG_NO_CACHE)
> +		config = &da906x_no_cache_regmap_config;

No, why would anyone ever want this and why would this not apply to all
other drivers?

> +static const struct i2c_device_id da906x_i2c_id[] = {
> +	{"da906x", PMIC_DA9063},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(i2c, da906x_i2c_id);

List the actual devices here.

> +#define DA906X_IRQ_BASE_OFFSET	0

Hrm?
