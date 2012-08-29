Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab2H2Nc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:32:57 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:2437 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab2H2Ncx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:32:53 -0400
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <lm-sensors@lm-sensors.org>, <linux-input@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jean Delvare <khali@linux-fr.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Andrew Jones <drjones@redhat.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        "Wim Van Sebroeck" <wim@iguana.be>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Anthony Olech <anthony.olech@diasemi.com>
Subject: Re: [PATCH] regulator: Fix bug in regulator_mode_to_status() core function.
References: <201208241500@sw-eng-lt-dc-vm2>
	<201208241505@sw-eng-lt-dc-vm2>
	<20120824184505.GA7275@roeck-us.net>
In-Reply-To: <20120824184505.GA7275@roeck-us.net>
Message-ID: <201208291425@sw-eng-lt-dc-vm2>
Date: Wed, 29 Aug 2012 14:25:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static const struct i_table vsys_tbl[] = {
> > +	ILINE(0, DA906X_ADC_MAX, 2500, 5500)
> > +};
> > +
> > +static const struct i_table adcin_tbl[] = {
> > +	ILINE(0, DA906X_ADC_MAX, 0, 2500)
> > +};
> > +
> > +static const struct i_table tjunc_tbl[] = {
> > +	ILINE(0, DA906X_ADC_MAX, 333, -86)
> > +};
> > +
> > +static const struct i_table vbbat_tbl[] = {
> > +	ILINE(0, DA906X_ADC_MAX, 0, 5000)
> > +};
> 
> Since the first parameter to ILINE is always 0, it is not needed. This means
> that x0 in itable is also always 0 and thus not needed.
> 
> > +
> > +static const struct channel_info da906x_channels[] = {
> > +	[DA906X_VSYS]	= { "VSYS",
> > +			    vsys_tbl, ARRAY_SIZE(vsys_tbl) - 1,
> > +			    DA906X_REG_VSYS_RES },
> > +	[DA906X_ADCIN1]	= { "ADCIN1",
> > +			    adcin_tbl,	ARRAY_SIZE(adcin_tbl) - 1,
> > +			    DA906X_REG_ADCIN1_RES },
> > +	[DA906X_ADCIN2]	= { "ADCIN2",
> > +			    adcin_tbl,	ARRAY_SIZE(adcin_tbl) - 1,
> > +			    DA906X_REG_ADCIN2_RES },
> > +	[DA906X_ADCIN3]	= { "ADCIN3",
> > +			    adcin_tbl,	ARRAY_SIZE(adcin_tbl) - 1,
> > +			    DA906X_REG_ADCIN3_RES },
> > +	[DA906X_TJUNC]	= { "TJUNC",
> > +			    tjunc_tbl,	ARRAY_SIZE(tjunc_tbl) - 1 },
> > +	[DA906X_VBBAT]	= { "VBBAT",
> > +			    vbbat_tbl,	ARRAY_SIZE(vbbat_tbl) - 1}
> 
> 	s/1}/1 }/
> 
> > +};
> 
> You lost me here a bit (I am missing something ?).
> 
> Seems to be each table has exactly one entry. Since the table size is 1,
> ARRAY_SIZE(vbbat_tbl) - 1 is 0, and ...

An initial idea was to make the interpolation of the channel values using more
ILINE segments. Eventually, it ended up with one linear segment for every
channel, so it makes sense to reduce the code as you propose.

As suggested, driver name will be changed from "da906x" to "da9063".
I will adapt proposed changes and fixes.

Thank you for your comments,
Krystian

