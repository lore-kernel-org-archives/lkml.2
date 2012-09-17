Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2IQK3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:29:49 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:27843 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2IQK3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:29:47 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Liam Girdwood <lrg@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        "Jean Delvare" <khali@linux-fr.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
Thread-Topic: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
Thread-Index: AQHNevk4pB6rQXiUMUetWtkXJKtKrJdt4YyAgCCl2oA=
Date: Mon, 17 Sep 2012 10:29:43 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032CC96A@NB-EX-MBX02.diasemi.com>
References: <201208151518.q7FFILAM011604@latitude.olech.com>
 <20120827165057.GK4339@opensource.wolfsonmicro.com>
In-Reply-To: <20120827165057.GK4339@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.109]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 27 August 2012 17:51
> To: Opensource [Anthony Olech]
> Cc: Liam Girdwood; Guenter Roeck; Jean Delvare; Randy Dunlap; LKML; David
> Dajun Chen
> Subject: Re: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
> On Wed, Aug 15, 2012 at 04:05:25PM +0100, Anthony Olech wrote:
> > +static int da9058_buck_ramp_voltage(struct regulator_dev *rdev,
> > +					unsigned int old_selector,
> > +					unsigned int new_selector)
> > +{
> > +	ret = da9058_set_bits(da9058, regulator->ramp_register,
> > +					regulator->ramp_enable_mask);
> > +	if (ret)
> > +		return ret;
> > +	return 2200; /* micro Seconds needed to ramp to new voltage*/
> Why is this function writing to the hardware, especially writing the same value
> every time?


the ramp_register is DA9058_SUPPLY_REG and it is marked as volitile.
Writing to the ramp enable bit starts the voltage change. When the PMIC has
finished making the change it resets the bit. Thus to make another voltage
change the bit needs to be set again.

 
> > +static int da9058_get_fixed_regulator_voltage(struct regulator_dev
> > +*rdev) {
> > +	struct da9058_regulator *regulator = rdev_get_drvdata(rdev);
> > +
> > +	if (regulator_is_enabled_regmap(rdev))
> > +		return regulator->fixed_voltage;
> > +	else
> > +		return 0;
> > +}
> list_voltage_linear()
