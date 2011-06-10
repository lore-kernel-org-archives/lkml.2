Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1FJLdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:33:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51341 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755995Ab1FJLdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:33:41 -0400
Date: Fri, 10 Jun 2011 12:33:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv2 5/11 ] REGULATOR: Added current_limit functionality for
 buck
Message-ID: <20110610113338.GI26436@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151C2507A6@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151C2507A6@KCINPUNHJCMS01.kpit.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 04:45:31PM +0530, Ashish Jangam wrote:
> Hi Mark
> 
> current_limit functionality has been added for bucks. Also get_voltage are replaced by get_voltage_sel and dedicated regulator_ops has been added for bucks and ldos.

Every time you submit patches I find myself telling you to follow the
instructions in SubmittingPatches.  Could you please do this?  Ignoring
this just means the same feedback needs to be provided every time you
resubmit.  There's been some improvement but it's extremely slow and
it's very tiresome having to go over basic issues again and again -
you've been sending these for long enough that we should be over these
issues by now.  As I've said before it really doesn't feel like you're
valuing the time and effort people spend on review.

Here your changelog isn't a changelog for the patch you're submitting at
all, you're submitting a new driver not updating an existing one so your
changelog should be about how you're adding a new driver, you've
got word wrapping issues and so on. an existing one, you've got word
wrapping issues and so on. an existing one, you've got word wrapping
issues and so on. an existing one, you've got word wrapping issues and
so on.

> +static int da9052_dcdc_get_current_limit(struct regulator_dev *rdev)
> +{
> +       struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
> +       int offset = rdev_get_id(rdev);
> +       int ret;
> +
> +       ret = da9052_reg_read(regulator->da9052, DA9052_BUCKA_REG + offset/2);
> +       if (ret < 0)
> +               return ret;
> +
> +/*
> + * Determine the odd or event bit pos of the buck current limit field
> +*/

Indentation and throughout the rest of the driver.

> +static int da9052_set_ldo_voltage(struct regulator_dev *rdev,
> +                       int min_uV, int max_uV, unsigned int *selector)
> +{
> +       return da9052_regulator_set_voltage_int(rdev, min_uV, max_uV, selector);
> +
> +}

You keep adding these random blank lines a the end of functions...

> +static int da9052_get_regulator_voltage_sel(struct regulator_dev *rdev)
> +{
> +       struct da9052_regulator *regulator = rdev_get_drvdata(rdev);
> +       struct da9052_regulator_info *info = regulator->info;
> +       int offset = rdev_get_id(rdev);
> +       int ret;
> +
> +       ret = da9052_reg_read(regulator->da9052, DA9052_BUCKCORE_REG + offset);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret &= ((1 << info->volt_shift) - 1);
> +
> +       return da9052_list_voltage(rdev, ret);
> +

Either your list_voltage() is buggy or this is buggy.  A _sel()
get_voltage() should return a selector and list_voltage() should return
a voltage.  Similarly for the other get_voltage() functions.  Have you
tested this code?
