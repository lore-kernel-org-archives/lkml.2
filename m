Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1DFPf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:35:56 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17935 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab1DFPfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:35:54 -0400
Date: Wed, 6 Apr 2011 17:35:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: Add driver for AMD family 15h processor power
  information
Message-ID: <20110406173543.7308ba93@endymion.delvare>
In-Reply-To: <20110406151901.GE2177@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
	<20110405144536.GA5054@alberich.amd.com>
	<20110406161401.1c0ab6de@endymion.delvare>
	<20110406151901.GE2177@alberich.amd.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011 17:19:01 +0200, Andreas Herrmann wrote:
> On Wed, Apr 06, 2011 at 04:14:01PM +0200, Jean Delvare wrote:
> > On Tue, 5 Apr 2011 16:45:36 +0200, Andreas Herrmann wrote:
> > > +static ssize_t show_power(struct device *dev,
> > > +			  struct device_attribute *attr, char *buf)
> > > +{
> > > +	u32 val, btdp, tdpl, tdp2w, arange;
> > > +	s32 acap;
> > > +	u64 ctdp;
> > 
> > These variable names aren't easy to understand.
> 
> Just random names which eventually map to the spec:
> 
> btdp - base_tdp
> tdpl - tdp_limit
> tdp2w - tdp_to_watt
> acap - average_accumulator_capture (or even worse how about "processor_tdp_running_average_accumulator":(
> arange - average_range

avg_cap and avg_range would do, respectively, for the last two.

> I don't think that changing the names make it much easier to
> reconstruct the calculation but if you insist in changing it I'll
> adapt it.

I do prefer the "extended" names, really. Sure, this doesn't change the
calculations, but it helps the reader understand what's going on. Which
will be useful if one ever has to fix a bug in the code or extend it
for a different CPU family.

But maybe this is just me. Guenter, do you have an opinion?

> > > (...)
> > > +	dev_set_drvdata(&pdev->dev, hwmon_dev);
> > 
> > pci_set_drvdata()
> 
> Are you sure?

Yes, I'm sure. This function exists, so there is no reason not to use
it.

> No single hwmon driver is using this wrapper around dev_set_drvdata() so far. (Or I just missed it.)

$ grep i2c_set_clientdata drivers/hwmon/*.c | wc -l
67
$ grep spi_set_drvdata drivers/hwmon/*.c | wc -l
2
$ grep platform_set_drvdata drivers/hwmon/*.c | wc -l
66
$

> At the moment only dev_set_drvdata() is used by
> 
>  drivers/hwmon/adcxx.c
>  drivers/hwmon/lm70.c
>  drivers/hwmon/ultra45_env.c
>  drivers/hwmon/ibmpex.c
>  drivers/hwmon/k10temp.c
>  drivers/hwmon/ibmaem.c
>  drivers/hwmon/k8temp.c

Most of these (at least spi and pci drivers) should be fixed. I'll send
a patch later.

-- 
Jean Delvare
