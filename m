Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab0LWWVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:21:06 -0500
Received: from imr4.ericy.com ([198.24.6.8]:35573 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0LWWVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:21:05 -0500
Date: Thu, 23 Dec 2010 14:20:27 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: dd diasemi <dd.diasemi@gmail.com>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCHv3 6/11] HWMON: HWMON module of DA9052
 device driver
Message-ID: <20101223222027.GA29608@ericsson.com>
References: <AANLkTin7N2HViUNSez9si7WytPkQAkTiR9NP3iUitbh4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTin7N2HViUNSez9si7WytPkQAkTiR9NP3iUitbh4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 12:52:50PM -0500, dd diasemi wrote:
> HWMON module for DA9052 PMIC device from Dialog Semiconductor.
> 
> Changes made since last submission:
> . removed the DA9052 customized success and error codes
> . changed da9052_manual_read() return type
> 
> Linux Kernel Version: 2.6.34
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>

[ ... ]

> +
> +static DEVICE_ATTR(name, S_IRUGO, da9052_adc_show_name, NULL);
> +static SENSOR_DEVICE_ATTR(read_vddout, S_IRUGO,
> +                               da9052_adc_read_start_stop, NULL,
> +                               DA9052_ADC_VDDOUT);
> +static SENSOR_DEVICE_ATTR(read_ich, S_IRUGO, da9052_adc_read_ich, NULL,
> +                               DA9052_ADC_ICH);
> +static SENSOR_DEVICE_ATTR(read_tbat, S_IRUGO, da9052_adc_read_tbat, NULL,
> +                               DA9052_ADC_TBAT);
> +static SENSOR_DEVICE_ATTR(read_vbat, S_IRUGO, da9052_adc_read_vbat, NULL,
> +                               DA9052_ADC_VBAT);
> +#if (DA9052_ADC_CONF_ADC4 == 1)
> +static SENSOR_DEVICE_ATTR(in4_input, S_IRUGO, da9052_adc_read_start_stop, NULL,
> +                               DA9052_ADC_ADCIN4);
> +#endif
> +#if (DA9052_ADC_CONF_ADC5 == 1)
> +static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, da9052_adc_read_start_stop, NULL,
> +                               DA9052_ADC_ADCIN5);
> +#endif
> +#if (DA9052_ADC_CONF_ADC6 == 1)
> +static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, da9052_adc_read_start_stop, NULL,
> +                               DA9052_ADC_ADCIN6);
> +#endif
> +static SENSOR_DEVICE_ATTR(read_tjunc, S_IRUGO, da9052_adc_read_tjunc, NULL,
> +                               DA9052_ADC_TJUNC);
> +static SENSOR_DEVICE_ATTR(read_vbbat, S_IRUGO, da9052_adc_read_vbbat, NULL,
> +                               DA9052_ADC_VBBAT);
> +

Driver doesn't follow hwmon sysfs ABI, with no good reason.
As for the labels, I am not sure if the provided labels reflect chip data 
or the use of the chip on a specific board. The product brief seems to indicate
the latter. If so, defining label attribute files is not appropriate. Labels
can then be assigned through sensors.conf.

The use of ifdefs in the code is excessive. There should be a single Kconfig entry
to enable the driver. Remaining data can be provided with platform data if it is 
mandatory, or sensors not supported on a given board can be configured to be 
ignored via sensors.conf.

Guenter
