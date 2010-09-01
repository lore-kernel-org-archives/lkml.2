Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0IARyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:54:17 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6787 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0IARyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:54:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Wed, 01 Sep 2010 10:54:09 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>
Date: Wed, 1 Sep 2010 10:53:29 -0700
Subject: RE: [PATCH 1/1] power supply: add driver for TI BQ20Z75 gas gauge	IC
Thread-Topic: [PATCH 1/1] power supply: add driver for TI BQ20Z75 gas gauge
	IC
Thread-Index: ActJDlgh6Hn9oirQSDSV7RkIyz9rdwAWclgw
Message-ID: <E88A1D35AF5437468E5B14C7C4BA61C702CF4B6201@HQMAIL01.nvidia.com>
References: <1282949443-8052-1-git-send-email-rklein@nvidia.com>
 <20100831131323.GA16671@sirena.org.uk>
In-Reply-To: <20100831131323.GA16671@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review, fixed up what you suggested. Will repost soon.

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Tuesday, August 31, 2010 6:13 AM
To: Rhyland Klein
Cc: cbouatmailru@gmail.com; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org; olof@lixom.net; Andrew Chew
Subject: Re: [PATCH 1/1] power supply: add driver for TI BQ20Z75 gas gauge IC

On Fri, Aug 27, 2010 at 03:50:43PM -0700, rklein@nvidia.com wrote:

> +	case POWER_SUPPLY_PROP_STATUS:
> +	case POWER_SUPPLY_PROP_CYCLE_COUNT:
> +	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> +	case POWER_SUPPLY_PROP_CURRENT_NOW:
> +	case POWER_SUPPLY_PROP_TEMP:
> +	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
> +	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
> +	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
> +		for (count = 0; count < REG_MAX; count++) {
> +			if (psp == bq20z75_data[count].psp)
> +				break;
> +		}

Rather than using REG_MAX it'd seem safer to use ARRAY_SIZE() to make
sure you're within the array.

-Done

> +		if (bq20z75_get_battery_property(count, psp, val))
> +			return -EINVAL;
> +			break;

Indentation is messed up here.

-Done

> +	printk(KERN_INFO "%s: property = %d, value = %d\n", __func__,
> +		psp, val->intval);

Remove unconditional logging like this, make it dev_dbg() if you want to
keep it in so it's only visible when explicitly requested.

-Done

> +	bq20z75_device = kzalloc(sizeof(*bq20z75_device), GFP_KERNEL);
> +	if (!bq20z75_device)
> +		return -ENOMEM;
> +
> +memset(bq20z75_device, 0, sizeof(*bq20z75_device));

Indentation again.

-Done

> +/* any smbus transaction will wake up bq20z75 */
> +static int bq20z75_resume(struct i2c_client *client)
> +{
> +	return 0;
> +}

No need for null functions like this.

-Done

> +#if defined CONFIG_PM
> +	.suspend	= bq20z75_suspend,
> +	.resume		= bq20z75_resume,
> +#endif

The standard way to do this is with the suspend/resume functions -
#define them to NULL which turns their assignments into noops.

-Done

> +MODULE_AUTHOR("NVIDIA Graphics Pvt Ltd");

This only makes sense if it's an actual person (or other contact
address); there's already copyright statements on the file, the author
information is more there to help find someone who might know something
about the driver.

-Done
