Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2HFRji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:39:38 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65122 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2HFRjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:39:36 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 6 Aug 2012 10:39:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Randy Dunlop <randy.dunlap@oracle.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [NEW DRIVER V2 6/7] DA9058 HWMON driver
Message-ID: <20120806173943.GA29475@roeck-us.net>
References: <201208060737.q767biox005703@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208060737.q767biox005703@ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 09:43:44PM +0100, Anthony Olech wrote:
> This is the HWMON component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the core DA9058 MFD driver.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>

[ ... ]

> +static SENSOR_DEVICE_ATTR(vbat_mV, S_IRUGO, da9058_read_vbat, NULL, 0);
> +static SENSOR_DEVICE_ATTR(adc_mV, S_IRUGO, da9058_read_misc_channel, NULL,
> +				DA9058_ADCMAN_MUXSEL_ADCIN);
> +static SENSOR_DEVICE_ATTR(vfpin_mV, S_IRUGO, da9058_read_vfpin, NULL, 0);
> +static SENSOR_DEVICE_ATTR(vfpin_mode, S_IRUGO, da9058_vfpin_mode, NULL, 0);
> +static SENSOR_DEVICE_ATTR(tbat_mV, S_IRUGO, da9058_read_tbat, NULL, 0);
> +static SENSOR_DEVICE_ATTR(tjunc_in, S_IRUGO, da9058_read_tjunc, NULL, 0);
> +static SENSOR_DEVICE_ATTR(adc_mode, S_IWUSR | S_IRUGO, da9058_get_adc_mode,
> +				da9058_set_adc_mode, 0);

Please use standard sysfs attribute names for temperature and voltage attributes.
For configuration (XXX_mode), please use devicetreee and/or platform data, not
sysfs attributes.

Thanks,
Guenter
