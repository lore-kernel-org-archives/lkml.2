Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2LZD3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 22:29:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:3730 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab2LZD30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 22:29:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,355,1355126400"; 
   d="scan'208";a="236679171"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Wei Ni <wni@nvidia.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>
Subject: RE: [PATCH 8/8] Thermal: Dummy driver used for testing
Thread-Topic: [PATCH 8/8] Thermal: Dummy driver used for testing
Thread-Index: AQHN3QLtu/Aw9GxFLkibyW8K13qBG5go4ByAgAGX9xA=
Date: Wed, 26 Dec 2012 03:29:21 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5924ED4F@BGSMSX101.gar.corp.intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
 <1355822977-4804-9-git-send-email-durgadoss.r@intel.com>
 <50D965F1.6000806@nvidia.com>
In-Reply-To: <50D965F1.6000806@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wei Ni [mailto:wni@nvidia.com]
> Sent: Tuesday, December 25, 2012 2:08 PM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> hongbo.zhang@linaro.org
> Subject: Re: [PATCH 8/8] Thermal: Dummy driver used for testing
> 
> On 12/18/2012 05:29 PM, Durgadoss R wrote:
> > This patch has a dummy driver that can be used for
> > testing purposes. This patch is not for merge.
> >
> > Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
> > ---
> >  drivers/thermal/Kconfig        |    5 +
> >  drivers/thermal/Makefile       |    3 +
> >  drivers/thermal/thermal_test.c |  315
> ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 323 insertions(+)
> >  create mode 100644 drivers/thermal/thermal_test.c
> >
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index c5ba3340..3b92a76 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -136,4 +136,9 @@ config DB8500_CPUFREQ_COOLING
> >  	  bound cpufreq cooling device turns active to set CPU frequency low
> to
> >  	  cool down the CPU.
> >
> > +config THERMAL_TEST
> > +	tristate "test driver"
> > +	help
> > +	  Enable this to test the thermal framework.
> > +
> >  endif
> > diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
> > index d8da683..02c3edb 100644
> > --- a/drivers/thermal/Makefile
> > +++ b/drivers/thermal/Makefile
> > @@ -18,3 +18,6 @@ obj-$(CONFIG_RCAR_THERMAL)	+=
> rcar_thermal.o
> >  obj-$(CONFIG_EXYNOS_THERMAL)	+= exynos_thermal.o
> >  obj-$(CONFIG_DB8500_THERMAL)	+= db8500_thermal.o
> >  obj-$(CONFIG_DB8500_CPUFREQ_COOLING)	+=
> db8500_cpufreq_cooling.o
> > +
> > +# dummy driver for testing
> > +obj-$(CONFIG_THERMAL_TEST)	+= thermal_test.o
> > diff --git a/drivers/thermal/thermal_test.c
> b/drivers/thermal/thermal_test.c
> > new file mode 100644
> > index 0000000..5a11e34
> > --- /dev/null
> > +++ b/drivers/thermal/thermal_test.c
> > @@ -0,0 +1,315 @@
> > +/*
> > + * thermal_test.c - This driver can be used to test Thermal
> > + *			   Framework changes. Not specific to any
> > + *			   platform. Fills the log buffer generously ;)
> > + *
> > + * Copyright (C) 2012 Intel Corporation
> > + *
> > + *
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~~~~~~~
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See
> the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> along
> > + * with this program; if not, write to the Free Software Foundation, Inc.,
> > + * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
> > + *
> > + *
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ~~~~~~~~~~~~~~~~
> > + * Author: Durgadoss R <durgadoss.r@intel.com>
> > + */
> > +
> > +#define pr_fmt(fmt)  "thermal_test: " fmt
> > +
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/err.h>
> > +#include <linux/param.h>
> > +#include <linux/device.h>
> > +#include <linux/slab.h>
> > +#include <linux/pm.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/thermal.h>
> > +
> > +#define MAX_THERMAL_ZONES	2
> > +#define MAX_THERMAL_SENSORS	2
> > +#define MAX_COOLING_DEVS	4
> > +#define NUM_THRESHOLDS		3
> > +
> > +static struct ts_data {
> > +	int curr_temp;
> > +	int flag;
> > +} ts_data;
> > +
> > +int active_trips[10] = {100, 90, 80, 70, 60, 50, 40, 30, 20, 10};
> > +int passive_trips[5] = {100, 90, 60, 50, 40};
> > +
> > +static struct platform_device *pdev;
> > +static unsigned long cur_cdev_state = 2;
> > +static struct thermal_sensor *ts, *ts1;
> > +static struct thermal_zone *tz;
> > +static struct thermal_cooling_device *cdev;
> > +
> > +static long thermal_thresholds[NUM_THRESHOLDS] = {30000, 40000,
> 50000};
> > +
> > +static struct thermal_trip_point trip = {
> > +	.hot = 90,
> > +	.crit = 100,
> > +	.num_passive_trips = 5,
> > +	.passive_trips = passive_trips,
> > +	.num_active_trips = 10,
> > +	.active_trips = active_trips,
> > +	.active_trip_mask = 0xCFF,
> > +};
> > +
> > +static struct thermal_trip_point trip1 = {
> > +	.hot = 95,
> > +	.crit = 125,
> > +	.num_passive_trips = 0,
> > +	.passive_trips = passive_trips,
> > +	.num_active_trips = 6,
> > +	.active_trips = active_trips,
> > +	.active_trip_mask = 0xFF,
> > +};
> > +
> > +static int read_cur_state(struct thermal_cooling_device *cdev,
> > +			unsigned long *state)
> > +{
> > +	*state = cur_cdev_state;
> > +	return 0;
> > +}
> > +
> > +static int write_cur_state(struct thermal_cooling_device *cdev,
> > +			unsigned long state)
> > +{
> > +	cur_cdev_state = state;
> > +	return 0;
> > +}
> > +
> > +static int read_max_state(struct thermal_cooling_device *cdev,
> > +			unsigned long *state)
> > +{
> > +	*state = 5;
> > +	return 0;
> > +}
> > +
> > +static int read_curr_temp(struct thermal_sensor *ts, long *temp)
> > +{
> > +	*temp = ts_data.curr_temp;
> > +	return 0;
> > +}
> > +
> > +static ssize_t
> > +flag_show(struct device *dev, struct device_attribute *devattr, char
> *buf)
> > +{
> > +	return sprintf(buf, "%d\n", ts_data.flag);
> > +}
> > +
> > +static ssize_t
> > +flag_store(struct device *dev, struct device_attribute *attr,
> > +		    const char *buf, size_t count)
> > +{
> > +	long flag;
> > +
> > +	if (kstrtol(buf, 10, &flag))
> > +		return -EINVAL;
> > +
> > +	ts_data.flag = flag;
> > +
> > +	if (flag == 0) {
> > +		thermal_sensor_unregister(ts);
> > +		ts = NULL;
> > +		pr_err("thermal_sensor_unregister (ts) done\n");
> > +	} else if (flag == 1) {
> > +		thermal_sensor_unregister(ts1);
> > +		ts1 = NULL;
> > +		pr_err("thermal_sensor_unregister (ts1) done\n");
> > +	} else if (flag == 2) {
> > +		thermal_cooling_device_unregister(cdev);
> > +		cdev = NULL;
> > +		pr_err("cdev unregister (cdev) done\n");
> > +	} else if (flag == 3) {
> > +		if (tz)
> > +			remove_thermal_zone(tz);
> > +		tz = NULL;
> > +		pr_err("removed thermal zone\n");
> > +	}
> > +
> > +	return count;
> > +}
> 
> What does this flag_show()/flag_store() mean?
> I noticed that you didn't call xxx_unregister() in the remove callback.
> Do you mean we need to provide these functions in the platform thermal
> driver? or this is just for test?

At Runtime, I wanted to test register/unregister APIs. That's why I used this
kind of a mechanism. This is _only_ for test.

Thanks,
Durga
