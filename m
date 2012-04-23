Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2DWSU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:20:26 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:37917 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2DWSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:20:24 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F959D6F.6020101@cam.ac.uk>
Date: Mon, 23 Apr 2012 19:20:31 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120314 Thunderbird/11.0
MIME-Version: 1.0
To: Jon Brenner <jbrenner@taosinc.com>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V7] TAOS tsl2x7x
References: <72d308ec-abc5-4d59-8ceb-51d704ba63ad@email.android.com>
In-Reply-To: <72d308ec-abc5-4d59-8ceb-51d704ba63ad@email.android.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Jon, my battery packed up half way through writing this.

Jon Brenner <jbrenner@taosinc.com> wrote:

>On Mon, 2012-04-23 at 16:34 +0100, Jonathan Cameron wrote:
>> On 4/20/2012 11:41 PM, Jon Brenner wrote:
>> > TAOS device driver (version 7) for the tsl/tmd 2771 and 2772 device
>families (inc. all variants).
>> >
>> > Updates:
>> > Documentation - added prefix corrections.
>> Sorry Jon,
>> 
>> Few more bits in here..
>> 
>> err. I still see illuminance0_calibrate and proximity_calibrate. Both
>of 
>> those want prefixes as well.
>OK - Was under impression those didn't want in_.  
>Will fix - should have asked.
>
>How about the 'available' abi
>(ie. dev_attr_illuminance0_calibscale_available) ?
>
Yes. in_ as well
>> Also in_illuminance0_intergration_time isn't in the abi docs. If we
>are 
>> happy with this abi, we'll move
>> it into info_mask in the core.
>It's in the sysfs-bus-iio-light doc.
>Noticed that most do not have the 'in_' prefix in this doc.  Do they
>need it?
Yes. My bad as I clearly missed it.  Been meaning to do pass of all
drivers and clean up prefixes. Just never get round to it!

In most cases the attributes are generated from the channel description
and so the prefix is added by that. I clearly missed a lot of instances
of attributes directly defined in various drivers and in the
documentation.
>
>> 
>> Also the merge on the docs seems to have messed up. Pleasee fix that.
>> 
>What do you mean by messed up - please explain?7
I made a few fixes in syfs-bus-iio that have I think been reverted by
your patch. I've highlighted them inline below.
>
>What about the /Documentation/light/ directory - do you still what this
>in there?
>> Note that if this crosses with the move out of staging series then
>the 
>> header paths will need
>> updating.  
>When is this going to happen and what header paths are you talking
>about?
Shortly (i.e. later this week unless anyone hits significant issues)

Basically, drivers/staging/iio/*.h -> include/linux/iio/*

So all the core headers.  Here,

"../events.h" -> <iio/events.h>
"../sysfs.h" -> <iio/sysfs.h>
"../iio.h" -> <iio/iio.h>

I think...

Also, staging/iio/Documentation/sysfs-bus-iio ->
Documentation/ABI/experimental/sysfs-bus-iio which
will cause issues with your additions to that file.

If the last few fixes go in here by Wednesday I'll do an update
on my series before I send it on to Greg to take into account your
new driver.

Shortly after that series has gone, we'll start hammering any
remaining abi issues in the clean drivers and pushing them out of
staging into drivers/iio/<type>/ as well.

For the coming merge window we really want to get the core out, but
obviously it would be good to do a few drivers as well!

>
>
>> Sorry for making life hard all over again!
>> 
>> 
>Thanks
>Jon
>> 
>> Jonathan
>> > Code - removed FP division, incorporation of new IIO_CHAN_INFO_
>bitmasks into .info_mask, various comment and consistency clean-ups.
>> >
>> > Signed-off-by: Jon Brenner<jbrenner@taosinc.com>
>> >
>> > ---
>> >   .../light/sysfs-bus-iio-light-tsl2583              |    6 +
>> >   .../light/sysfs-bus-iio-light-tsl2x7x              |   13 +
>> >   drivers/staging/iio/Documentation/sysfs-bus-iio    |   16 +-
>> >   .../staging/iio/Documentation/sysfs-bus-iio-light  |    8 +-
>> >   drivers/staging/iio/light/Kconfig                  |    8 +
>> >   drivers/staging/iio/light/Makefile                 |    1 +
>> >   drivers/staging/iio/light/tsl2x7x.h                |  100 +
>> >   drivers/staging/iio/light/tsl2x7x_core.c           | 2073
>++++++++++++++++++++
>> >   8 files changed, 2217 insertions(+), 8 deletions(-)
>> >
>> > diff --git
>a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>> > new file mode 100755
>> > index 0000000..8f2a038
>> > --- /dev/null
>> > +++
>b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>> > @@ -0,0 +1,6 @@
>> > +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
>> > +KernelVersion:	2.6.37
>> > +Contact:	linux-iio@vger.kernel.org
>> > +Description:
>> > +		This property causes an internal calibration of the als gain
>trim
>> > +		value which is later used in calculating illuminance in lux.
>> > diff --git
>a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
>b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
>> > new file mode 100755
>> > index 0000000..c0b1d4d
>> > --- /dev/null
>> > +++
>b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
>> > @@ -0,0 +1,13 @@
>> > +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
>> > +KernelVersion:	3.3-rc1
>> > +Contact:	linux-iio@vger.kernel.org
>> > +Description:
>> > +		Causes an internal calibration of the als gain trim
>> > +		value which is later used in calculating illuminance in lux.
>> > +
>> > +What:		/sys/bus/iio/devices/device[n]/proximity_calibrate
>> > +KernelVersion:	3.3-rc1
>> > +Contact:	linux-iio@vger.kernel.org
>> > +Description:
>> > +		Causes a recalculation and adjustment to the
>> > +		proximity_thresh_rising_value.
>> > diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio
>b/drivers/staging/iio/Documentation/sysfs-bus-iio
>> > index ca12784..14cba73 100644
>> > --- a/drivers/staging/iio/Documentation/sysfs-bus-iio
>> > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio
>> > @@ -258,6 +258,8 @@
>What		/sys/bus/iio/devices/iio:deviceX/in_accel_z_calibscale
>> >   What		/sys/bus/iio/devices/iio:deviceX/in_anglvel_x_calibscale
>> >   What		/sys/bus/iio/devices/iio:deviceX/in_anglvel_y_calibscale
>> >   What		/sys/bus/iio/devices/iio:deviceX/in_anglvel_z_calibscale
>> > +what		/sys/bus/iio/devices/iio:deviceX/in_illuminance0_calibscale
>> > +what		/sys/bus/iio/devices/iio:deviceX/in_proximity_calibscale
>> >   KernelVersion:	2.6.35
>> >   Contact:	linux-iio@vger.kernel.org
>> >   Description:
>> > @@ -453,10 +455,14 @@
>What:		/sys/.../events/in_magn_z_raw_thresh_rising_value
>> >   What:		/sys/.../events/in_magn_z_raw_thresh_falling_value
>> >   What:		/sys/.../events/in_voltageY_supply_raw_thresh_rising_value
>> >  
>What:		/sys/.../events/in_voltageY_supply_raw_thresh_falling_value
This leaves us with two in_voltageY_raw_thresh_falling_value entries and
in_tempY_raw_thresh_falling_value entries.  These were originally there
due to a cut and paste messup by me but I've fixed them already.
Your patch puts the error back again!
>> > -What:		/sys/.../events/in_voltageY_raw_thresh_rising_value
>> >   What:		/sys/.../events/in_voltageY_raw_thresh_falling_value
>> > -What:		/sys/.../events/in_tempY_raw_thresh_rising_value
>> > +What:		/sys/.../events/in_voltageY_raw_thresh_falling_value
>> > +What:		/sys/.../events/in_tempY_raw_thresh_falling_value
>> err. I think a merge has gone wrong here.  Please fix.  Check the
>rest 
>> as well.
>> >   What:		/sys/.../events/in_tempY_raw_thresh_falling_value
>> > +What:		/sys/.../events/in_illuminance0_thresh_falling_value
>> > +what:		/sys/.../events/in_illuminance0_thresh_rising_value
>> > +what:		/sys/.../events/in_proximity_thresh_falling_value
>> > +what:		/sys/.../events/in_proximity_thresh_rising_value
>> >   KernelVersion:	2.6.37
>> >   Contact:	linux-iio@vger.kernel.org
>> >   Description:
>> > @@ -490,9 +496,9 @@
>What:		/sys/.../events/in_magn_z_raw_roc_rising_value
>> >   What:		/sys/.../events/in_magn_z_raw_roc_falling_value
>> >   What:		/sys/.../events/in_voltageY_supply_raw_roc_rising_value
>> >   What:		/sys/.../events/in_voltageY_supply_raw_roc_falling_value
>> > -What:		/sys/.../events/in_voltageY_raw_roc_rising_value
>> >   What:		/sys/.../events/in_voltageY_raw_roc_falling_value
>> > -What:		/sys/.../events/in_tempY_raw_roc_rising_value
>> > +What:		/sys/.../events/in_voltageY_raw_roc_falling_value
The patch leaves us with two in_voltageY_raw_roc_falling_value entries
whereas a fixup I pushed out the other day had changed one of them into
a rising varient.
>> > +What:		/sys/.../events/in_tempY_raw_roc_falling_value
>> >   What:		/sys/.../events/in_tempY_raw_roc_falling_value
>> >   KernelVersion:	2.6.37
>> >   Contact:	linux-iio@vger.kernel.org
>> > @@ -556,6 +562,8 @@
>What:		/sys/.../events/in_tempY_thresh_falling_period
>> >   What:		/sys/.../events/in_tempY_roc_rising_period
>> >   What:		/sys/.../events/in_tempY_roc_falling_period
>> >   What:		/sys/.../events/in_accel_x&y&z_mag_falling_period
>> > +What:		/sys/.../events/in_intensity_thresh_period
>> > +What:		/sys/.../events/in_proximity_thresh_period
>> >   KernelVersion:	2.6.37
>> >   Contact:	linux-iio@vger.kernel.org
>> >   Description:
>> > diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>> > index edbf470..4385c70 100644
>> > --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>> > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>> > @@ -76,10 +76,10 @@ Contact:	linux-iio@vger.kernel.org
>> >   Description:
>> >   		This property gets/sets the sensors ADC analog integration
>time.
>> >
>> > -What:		/sys/bus/iio/devices/device[n]/illuminance0_calibscale
>> > +What:		/sys/bus/iio/devices/device[n]/lux_table
>> >   KernelVersion:	2.6.37
>> >   Contact:	linux-iio@vger.kernel.org
>> >   Description:
>> > -		Hardware or software applied calibration scale factor assumed
>> > -		to account for attenuation due to industrial design (glass
>> > -		filters or aperture holes).
>> > +		This property gets/sets the table of coefficients
>> > +		used in calculating illuminance in lux.
>> > +
>> > diff --git a/drivers/staging/iio/light/Kconfig
>b/drivers/staging/iio/light/Kconfig
>> > index bb633f6..821ad6b 100644
>> > --- a/drivers/staging/iio/light/Kconfig
>> > +++ b/drivers/staging/iio/light/Kconfig
>> > @@ -41,4 +41,12 @@ config TSL2583
>> >   	 Provides support for the TAOS tsl2580, tsl2581 and tsl2583
>devices.
>> >   	 Access ALS data via iio, sysfs.
>> >
>> > +config TSL2x7x
>> > +	tristate "TAOS TSL/TMD2x71 and TSL/TMD2x72 Family of light and
>proximity sensors"
>> > +	depends on I2C
>> > +	help
>> > +	 Support for: tsl2571, tsl2671, tmd2671, tsl2771, tmd2771,
>tsl2572, tsl2672,
>> > +	 tmd2672, tsl2772, tmd2772 devices.
>> > +	 Provides iio_events and direct access via sysfs.
>> > +
>> >   endmenu
>> > diff --git a/drivers/staging/iio/light/Makefile
>b/drivers/staging/iio/light/Makefile
>> > index 535d313..141af1e 100644
>> > --- a/drivers/staging/iio/light/Makefile
>> > +++ b/drivers/staging/iio/light/Makefile
>> > @@ -6,3 +6,4 @@ obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>> >   obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
>> >   obj-$(CONFIG_SENSORS_ISL29028)	+= isl29028.o
>> >   obj-$(CONFIG_TSL2583)	+= tsl2583.o
>> > +obj-$(CONFIG_TSL2x7x)	+= tsl2x7x_core.o
>> > diff --git a/drivers/staging/iio/light/tsl2x7x.h
>b/drivers/staging/iio/light/tsl2x7x.h
>> > new file mode 100755
>> > index 0000000..c4acf5f
>> > --- /dev/null
>> > +++ b/drivers/staging/iio/light/tsl2x7x.h
>> > @@ -0,0 +1,100 @@
>> > +/*
>> > + * Device driver for monitoring ambient light intensity (lux)
>> > + * and proximity (prox) within the TAOS TSL2X7X family of devices.
>> > + *
>> > + * Copyright (c) 2012, TAOS Corporation.
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>modify
>> > + * it under the terms of the GNU General Public License as
>published by
>> > + * the Free Software Foundation; either version 2 of the License,
>or
>> > + * (at your option) any later version.
>> > + *
>> > + * This program is distributed in the hope that it will be useful,
>but WITHOUT
>> > + * ANY WARRANTY; without even the implied warranty of
>MERCHANTABILITY or
>> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>License for
>> > + * more details.
>> > + *
>> > + * You should have received a copy of the GNU General Public
>License along
>> > + * with this program; if not, write to the Free Software
>Foundation, Inc.,
>> > + * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
>> > + */
>> > +
>> > +#ifndef __TSL2X7X_H
>> > +#define __TSL2X7X_H
>> > +#include<linux/pm.h>
>> > +
>> > +/* Max number of segments allowable in LUX table */
>> > +#define TSL2X7X_MAX_LUX_TABLE_SIZE		9
>> > +#define MAX_DEFAULT_TABLE_BYTES (sizeof(int) *
>TSL2X7X_MAX_LUX_TABLE_SIZE)
>> > +
>> > +struct iio_dev;
>> > +
>> > +struct tsl2x7x_lux {
>> > +	unsigned int ratio;
>> > +	unsigned int ch0;
>> > +	unsigned int ch1;
>> > +};
>> > +
>> > +/**
>> > + * struct tsl2x7x_default_settings - power on defaults unless
>> > + *                                   overridden by platform data.
>> > + *  @als_time:              ALS Integration time - multiple of
>50mS
>> > + *  @als_gain:              Index into the ALS gain table.
>> > + *  @als_gain_trim:         default gain trim to account for
>> > + *                          aperture effects.
>> > + *  @wait_time:             Time between PRX and ALS cycles
>> > + *                          in 2.7 periods
>> > + *  @prx_time:              5.2ms prox integration time -
>> > + *                          decrease in 2.7ms periods
>> > + *  @prx_gain:              Proximity gain index
>> > + *  @prox_config:           Prox configuration filters.
>> > + *  @als_cal_target:        Known external ALS reading for
>> > + *                          calibration.
>> > + *  @interrupts_en:         Enable/Disable - 0x00 = none, 0x10 =
>als,
>> > + *                                           0x20 = prx,  0x30 =
>bth
>> > + *  @persistence:           H/W Filters, Number of 'out of limits'
>> > + *                          ADC readings PRX/ALS.
>> > + *  @als_thresh_low:        CH0 'low' count to trigger interrupt.
>> > + *  @als_thresh_high:       CH0 'high' count to trigger interrupt.
>> > + *  @prox_thres_low:        Low threshold proximity detection.
>> > + *  @prox_thres_high:       High threshold proximity detection
>> > + *  @prox_pulse_count:      Number if proximity emitter pulses
>> > + *  @prox_max_samples_cal:  Used for prox cal.
>> > + */
>> > +struct tsl2x7x_settings {
>> > +	int als_time;
>> > +	int als_gain;
>> > +	int als_gain_trim;
>> > +	int wait_time;
>> > +	int prx_time;
>> > +	int prox_gain;
>> > +	int prox_config;
>> > +	int als_cal_target;
>> > +	u8  interrupts_en;
>> > +	u8  persistence;
>> > +	int als_thresh_low;
>> > +	int als_thresh_high;
>> > +	int prox_thres_low;
>> > +	int prox_thres_high;
>> > +	int prox_pulse_count;
>> > +	int prox_max_samples_cal;
>> > +};
>> > +
>> > +/**
>> > + * struct tsl2X7X_platform_data - Platform callback, glass and
>defaults
>> > + * @platform_power:            Suspend/resume platform callback
>> > + * @power_on:                  Power on callback
>> > + * @power_off:                 Power off callback
>> > + * @platform_lux_table:        Device specific glass coefficents
>> > + * @platform_default_settings: Device specific power on defaults
>> > + *
>> > + */
>> > +struct tsl2X7X_platform_data {
>> > +	int (*platform_power)(struct device *dev, pm_message_t);
>> > +	int (*power_on)      (struct iio_dev *indio_dev);
>> > +	int (*power_off)     (struct i2c_client *dev);
>> > +	struct tsl2x7x_lux
>platform_lux_table[TSL2X7X_MAX_LUX_TABLE_SIZE];
>> > +	struct tsl2x7x_settings *platform_default_settings;
>> > +};
>> > +
>> > +#endif /* __TSL2X7X_H */
>> > diff --git a/drivers/staging/iio/light/tsl2x7x_core.c
>b/drivers/staging/iio/light/tsl2x7x_core.c
>> > new file mode 100755
>> > index 0000000..79605a8
>> > --- /dev/null
>> > +++ b/drivers/staging/iio/light/tsl2x7x_core.c
>> > @@ -0,0 +1,2073 @@
>> > +/*
>> > + * Device driver for monitoring ambient light intensity in (lux)
>> > + * and proximity detection (prox) within the TAOS TSL2X7X family
>of devices.
>> > + *
>> > + * Copyright (c) 2012, TAOS Corporation.
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>modify
>> > + * it under the terms of the GNU General Public License as
>published by
>> > + * the Free Software Foundation; either version 2 of the License,
>or
>> > + * (at your option) any later version.
>> > + *
>> > + * This program is distributed in the hope that it will be useful,
>but WITHOUT
>> > + * ANY WARRANTY; without even the implied warranty of
>MERCHANTABILITY or
>> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>License for
>> > + * more details.
>> > + *
>> > + * You should have received a copy of the GNU General Public
>License along
>> > + * with this program; if not, write to the Free Software
>Foundation, Inc.,
>> > + * 51 Franklin Street, Fifth Floor, Boston, MA        02110-1301,
>USA.
>> > + */
>> > +
>> > +#include<linux/kernel.h>
>> > +#include<linux/i2c.h>
>> > +#include<linux/errno.h>
>> > +#include<linux/delay.h>
>> > +#include<linux/mutex.h>
>> > +#include<linux/interrupt.h>
>> > +#include<linux/slab.h>
>> > +#include<linux/module.h>
>> > +#include<linux/version.h>
>> > +#include "tsl2x7x.h"
>> > +#include "../events.h"
>> > +#include "../iio.h"
>> > +#include "../sysfs.h"
>> > +
>> > +/* Cal defs*/
>> > +#define PROX_STAT_CAL        0
>> > +#define PROX_STAT_SAMP       1
>> > +#define MAX_SAMPLES_CAL      200
>> > +
>> > +/* TSL2X7X Device ID */
>> > +#define TRITON_ID    0x00
>> > +#define SWORDFISH_ID 0x30
>> > +#define HALIBUT_ID   0x20
>> > +
>> > +/* Lux calculation constants */
>> > +#define TSL2X7X_LUX_CALC_OVER_FLOW     65535
>> > +
>> > +/* TAOS Register definitions - note:
>> > + * depending on device, some of these register are not used and
>the
>> > + * register address is benign.
>> > + */
>> > +/* 2X7X register offsets */
>> > +#define TSL2X7X_MAX_CONFIG_REG         16
>> > +
>> > +/* Device Registers and Masks */
>> > +#define TSL2X7X_CNTRL                  0x00
>> > +#define TSL2X7X_ALS_TIME               0X01
>> > +#define TSL2X7X_PRX_TIME               0x02
>> > +#define TSL2X7X_WAIT_TIME              0x03
>> > +#define TSL2X7X_ALS_MINTHRESHLO        0X04
>> > +#define TSL2X7X_ALS_MINTHRESHHI        0X05
>> > +#define TSL2X7X_ALS_MAXTHRESHLO        0X06
>> > +#define TSL2X7X_ALS_MAXTHRESHHI        0X07
>> > +#define TSL2X7X_PRX_MINTHRESHLO        0X08
>> > +#define TSL2X7X_PRX_MINTHRESHHI        0X09
>> > +#define TSL2X7X_PRX_MAXTHRESHLO        0X0A
>> > +#define TSL2X7X_PRX_MAXTHRESHHI        0X0B
>> > +#define TSL2X7X_PERSISTENCE            0x0C
>> > +#define TSL2X7X_PRX_CONFIG             0x0D
>> > +#define TSL2X7X_PRX_COUNT              0x0E
>> > +#define TSL2X7X_GAIN                   0x0F
>> > +#define TSL2X7X_NOTUSED                0x10
>> > +#define TSL2X7X_REVID                  0x11
>> > +#define TSL2X7X_CHIPID                 0x12
>> > +#define TSL2X7X_STATUS                 0x13
>> > +#define TSL2X7X_ALS_CHAN0LO            0x14
>> > +#define TSL2X7X_ALS_CHAN0HI            0x15
>> > +#define TSL2X7X_ALS_CHAN1LO            0x16
>> > +#define TSL2X7X_ALS_CHAN1HI            0x17
>> > +#define TSL2X7X_PRX_LO                 0x18
>> > +#define TSL2X7X_PRX_HI                 0x19
>> > +
>> > +/* tsl2X7X cmd reg masks */
>> > +#define TSL2X7X_CMD_REG                0x80
>> > +#define TSL2X7X_CMD_SPL_FN             0x60
>> > +
>> > +#define TSL2X7X_CMD_PROX_INT_CLR       0X05
>> > +#define TSL2X7X_CMD_ALS_INT_CLR        0x06
>> > +#define TSL2X7X_CMD_PROXALS_INT_CLR    0X07
>> > +
>> > +/* tsl2X7X cntrl reg masks */
>> > +#define TSL2X7X_CNTL_ADC_ENBL          0x02
>> > +#define TSL2X7X_CNTL_PWR_ON            0x01
>> > +
>> > +/* tsl2X7X status reg masks */
>> > +#define TSL2X7X_STA_ADC_VALID          0x01
>> > +#define TSL2X7X_STA_PRX_VALID          0x02
>> > +#define TSL2X7X_STA_ADC_PRX_VALID      (TSL2X7X_STA_ADC_VALID |\
>> > +					TSL2X7X_STA_PRX_VALID)
>> > +#define TSL2X7X_STA_ALS_INTR           0x10
>> > +#define TSL2X7X_STA_PRX_INTR           0x20
>> > +
>> > +/* tsl2X7X cntrl reg masks */
>> > +#define TSL2X7X_CNTL_REG_CLEAR         0x00
>> > +#define TSL2X7X_CNTL_PROX_INT_ENBL     0X20
>> > +#define TSL2X7X_CNTL_ALS_INT_ENBL      0X10
>> > +#define TSL2X7X_CNTL_WAIT_TMR_ENBL     0X08
>> > +#define TSL2X7X_CNTL_PROX_DET_ENBL     0X04
>> > +#define TSL2X7X_CNTL_PWRON             0x01
>> > +#define TSL2X7X_CNTL_ALSPON_ENBL       0x03
>> > +#define TSL2X7X_CNTL_INTALSPON_ENBL    0x13
>> > +#define TSL2X7X_CNTL_PROXPON_ENBL      0x0F
>> > +#define TSL2X7X_CNTL_INTPROXPON_ENBL   0x2F
>> > +
>> > +/*Prox diode to use */
>> > +#define TSL2X7X_DIODE0                 0x10
>> > +#define TSL2X7X_DIODE1                 0x20
>> > +#define TSL2X7X_DIODE_BOTH             0x30
>> > +
>> > +/* LED Power */
>> > +#define TSL2X7X_mA100                  0x00
>> > +#define TSL2X7X_mA50                   0x40
>> > +#define TSL2X7X_mA25                   0x80
>> > +#define TSL2X7X_mA13                   0xD0
>> > +#define TSL2X7X_MAX_TIMER_CNT          (0xFF)
>> > +
>> > +/*Common device IIO EventMask */
>> > +#define TSL2X7X_EVENT_MASK \
>> > +		(IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) | \
>> > +		IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING)),
>> > +
>> > +/* TAOS txx2x7x Device family members */
>> > +enum {
>> > +	tsl2571,
>> > +	tsl2671,
>> > +	tmd2671,
>> > +	tsl2771,
>> > +	tmd2771,
>> > +	tsl2572,
>> > +	tsl2672,
>> > +	tmd2672,
>> > +	tsl2772,
>> > +	tmd2772
>> > +};
>> > +
>> > +enum {
>> > +	TSL2X7X_CHIP_UNKNOWN = 0,
>> > +	TSL2X7X_CHIP_WORKING = 1,
>> > +	TSL2X7X_CHIP_SUSPENDED = 2
>> > +};
>> > +
>> > +struct tsl2x7x_parse_result {
>> > +	int integer;
>> > +	int fract;
>> > +};
>> > +
>> > +/* Per-device data */
>> > +struct tsl2x7x_als_info {
>> > +	u16 als_ch0;
>> > +	u16 als_ch1;
>> > +	u16 lux;
>> > +};
>> > +
>> > +struct tsl2x7x_prox_stat {
>> > +	int min;
>> > +	int max;
>> > +	int mean;
>> > +	unsigned long stddev;
>> > +};
>> > +
>> > +struct tsl2x7x_chip_info {
>> > +	int chan_table_elements;
>> > +	struct iio_chan_spec		channel[4];
>> > +	const struct iio_info		*info;
>> > +};
>> > +
>> > +struct tsl2X7X_chip {
>> > +	kernel_ulong_t id;
>> > +	struct mutex prox_mutex;
>> > +	struct mutex als_mutex;
>> > +	struct i2c_client *client;
>> > +	u16 prox_data;
>> > +	struct tsl2x7x_als_info als_cur_info;
>> > +	struct tsl2x7x_settings tsl2x7x_settings;
>> > +	struct tsl2X7X_platform_data *pdata;
>> > +	int als_time_scale;
>> > +	int als_saturation;
>> > +	int tsl2x7x_chip_status;
>> > +	u8 tsl2x7x_config[TSL2X7X_MAX_CONFIG_REG];
>> > +	const struct tsl2x7x_chip_info	*chip_info;
>> > +	const struct iio_info *info;
>> > +	s64 event_timestamp;
>> > +	/* This structure is intentionally large to accommodate
>> > +	 * updates via sysfs. */
>> > +	/* Sized to 9 = max 8 segments + 1 termination segment */
>> > +	struct tsl2x7x_lux
>tsl2x7x_device_lux[TSL2X7X_MAX_LUX_TABLE_SIZE];
>> > +};
>> > +
>> > +/* Different devices require different coefficents */
>> > +static const struct tsl2x7x_lux tsl2x71_lux_table[] = {
>> > +	{ 14461,   611,   1211 },
>> > +	{ 18540,   352,    623 },
>> > +	{     0,     0,      0 },
>> > +};
>> > +
>> > +static const struct tsl2x7x_lux tmd2x71_lux_table[] = {
>> > +	{ 11635,   115,    256 },
>> > +	{ 15536,    87,    179 },
>> > +	{     0,     0,      0 },
>> > +};
>> > +
>> > +static const struct tsl2x7x_lux tsl2x72_lux_table[] = {
>> > +	{ 14013,   466,   917 },
>> > +	{ 18222,   310,   552 },
>> > +	{     0,     0,     0 },
>> > +};
>> > +
>> > +static const struct tsl2x7x_lux tmd2x72_lux_table[] = {
>> > +	{ 13218,   130,   262 },
>> > +	{ 17592,   92,    169 },
>> > +	{     0,     0,     0 },
>> > +};
>> > +
>> > +static const struct tsl2x7x_lux *tsl2x7x_default_lux_table_group[]
>= {
>> > +	[tsl2571] =	tsl2x71_lux_table,
>> > +	[tsl2671] =	tsl2x71_lux_table,
>> > +	[tmd2671] =	tmd2x71_lux_table,
>> > +	[tsl2771] =	tsl2x71_lux_table,
>> > +	[tmd2771] =	tmd2x71_lux_table,
>> > +	[tsl2572] =	tsl2x72_lux_table,
>> > +	[tsl2672] =	tsl2x72_lux_table,
>> > +	[tmd2672] =	tmd2x72_lux_table,
>> > +	[tsl2772] =	tsl2x72_lux_table,
>> > +	[tmd2772] =	tmd2x72_lux_table,
>> > +};
>> > +
>> > +static const struct tsl2x7x_settings tsl2x7x_default_settings = {
>> > +	.als_time = 219, /* 101 ms */
>> > +	.als_gain = 0,
>> > +	.prx_time = 254, /* 5.4 ms */
>> > +	.prox_gain = 1,
>> > +	.wait_time = 245,
>> > +	.prox_config = 0,
>> > +	.als_gain_trim = 1000,
>> > +	.als_cal_target = 150,
>> > +	.als_thresh_low = 200,
>> > +	.als_thresh_high = 256,
>> > +	.persistence = 255,
>> > +	.interrupts_en = 0,
>> > +	.prox_thres_low  = 0,
>> > +	.prox_thres_high = 512,
>> > +	.prox_max_samples_cal = 30,
>> > +	.prox_pulse_count = 8
>> > +};
>> > +
>> > +static const s16 tsl2X7X_als_gainadj[] = {
>> > +	1,
>> > +	8,
>> > +	16,
>> > +	120
>> > +};
>> > +
>> > +static const s16 tsl2X7X_prx_gainadj[] = {
>> > +	1,
>> > +	2,
>> > +	4,
>> > +	8
>> > +};
>> > +
>> > +/* Channel variations */
>> > +enum {
>> > +	ALS,
>> > +	PRX,
>> > +	ALSPRX,
>> > +	PRX2,
>> > +	ALSPRX2,
>> > +};
>> > +
>> > +const u8 device_channel_config[] = {
>> > +	ALS,
>> > +	PRX,
>> > +	PRX,
>> > +	ALSPRX,
>> > +	ALSPRX,
>> > +	ALS,
>> > +	PRX2,
>> > +	PRX2,
>> > +	ALSPRX2,
>> > +	ALSPRX2
>> > +};
>> > +
>> > +/**
>> > + * tsl2x7x_parse_buffer() - parse a decimal result from a buffer.
>> > + * @*buf:                   pointer to char buffer to parse
>> > + * @*result:                pointer to buffer to contain
>> > + *                          resulting interger / decimal as ints.
>> > + *
>> > + */
>> > +static int
>> > +tsl2x7x_parse_buffer(const char *buf, struct tsl2x7x_parse_result
>*result)
>> > +{
>> > +	int integer = 0, fract = 0, fract_mult = 100000;
>> > +	bool integer_part = true, negative = false;
>> > +
>> > +	if (buf[0] == '-') {
>> > +		negative = true;
>> > +		buf++;
>> > +	}
>> > +
>> > +	while (*buf) {
>> > +		if ('0'<= *buf&&  *buf<= '9') {
>> > +			if (integer_part)
>> > +				integer = integer*10 + *buf - '0';
>> > +			else {
>> > +				fract += fract_mult*(*buf - '0');
>> > +				if (fract_mult == 1)
>> > +					break;
>> > +				fract_mult /= 10;
>> > +			}
>> > +		} else if (*buf == '\n') {
>> > +			if (*(buf + 1) == '\0')
>> > +				break;
>> > +			else
>> > +				return -EINVAL;
>> > +		} else if (*buf == '.') {
>> > +			integer_part = false;
>> > +		} else {
>> > +			return -EINVAL;
>> > +		}
>> > +		buf++;
>> > +	}
>> > +	if (negative) {
>> > +		if (integer)
>> > +			integer = -integer;
>> > +		else
>> > +			fract = -fract;
>> > +	}
>> > +
>> > +	result->integer = integer;
>> > +	result->fract = fract;
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +/**
>> > + * tsl2x7x_i2c_read() - Read a byte from a register.
>> > + * @client:	i2c client
>> > + * @reg:	device register to read from
>> > + * @*val:	pointer to location to store register contents.
>> > + *
>> > + */
>> > +static int
>> > +tsl2x7x_i2c_read(struct i2c_client *client, u8 reg, u8 *val)
>> > +{
>> > +	int ret = 0;
>> > +
>> > +	/* select register to write */
>> > +	ret = i2c_smbus_write_byte(client, (TSL2X7X_CMD_REG | reg));
>> > +	if (ret<  0) {
>> > +		dev_err(&client->dev, "%s: failed to write register %x\n"
>> > +				, __func__, reg);
>> > +		return ret;
>> > +	}
>> > +
>> > +	/* read the data */
>> > +	ret = i2c_smbus_read_byte(client);
>> > +	if (ret>= 0)
>> > +		*val = (u8)ret;
>> > +	else
>> > +		dev_err(&client->dev, "%s: failed to read register %x\n"
>> > +						, __func__, reg);
>> > +
>> > +	return ret;
>> > +}
>> > +
>> > +/**
>> > + * tsl2x7x_get_lux() - Reads and calculates current lux value.
>> > + * @indio_dev:	pointer to IIO device
>> > + *
>> > + * The raw ch0 and ch1 values of the ambient light sensed in the
>last
>> > + * integration cycle are read from the device.
>> > + * Time scale factor array values are adjusted based on the
>integration time.
>> > + * The raw values are multiplied by a scale factor, and device
>gain is obtained
>> > + * using gain index. Limit checks are done next, then the ratio of
>a multiple
>> > + * of ch1 value, to the ch0 value, is calculated. Array
>tsl2x7x_device_lux[]
>> > + * is then scanned to find the first ratio value that is just
>above the ratio
>> > + * we just calculated. The ch0 and ch1 multiplier constants in the
>array are
>> > + * then used along with the time scale factor array values, to
>calculate the
>> > + * lux.
>> > + */
>> > +static int tsl2x7x_get_lux(struct iio_dev *indio_dev)
>> > +{
>> > +	u16 ch0, ch1; /* separated ch0/ch1 data from device */
>> > +	u32 lux; /* raw lux calculated from device data */
>> > +	u64 lux64;
>> > +	u32 ratio;
>> > +	u8 buf[4];
>> > +	struct tsl2x7x_lux *p;
>> > +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>> > +	int i, ret;
>> > +	u32 ch0lux = 0;
>> > +	u32 ch1lux = 0;
>> > +
>> > +	if (mutex_trylock(&chip->als_mutex) == 0)
>> > +		return chip->als_cur_info.lux; /* busy, so return LAST VALUE */
>> > +
>> > +	if (chip->tsl2x7x_chip_status != TSL2X7X_CHIP_WORKING) {
>> > +		/* device is not enabled */
>> > +		dev_err(&chip->client->dev, "%s: device is not enabled\n",
>> > +				__func__);
>> > +		ret = -EBUSY ;
>> > +		goto out_unlock;
>> > +	}
>> > +
>> > +	ret = tsl2x7x_i2c_read(chip->client,
>> > +		(TSL2X7X_CMD_REG | TSL2X7X_STATUS),&buf[0]);
>> > +	if (ret<  0) {
>> > +		dev_err(&chip->client->dev,
>> > +			"%s: Failed to read STATUS Reg\n", __func__);
>> > +		goto out_unlock;
>> > +	}
>> > +	/* is data new&  valid */
>> > +	if (!(buf[0]&  TSL2X7X_STA_ADC_VALID)) {
>> > +		dev_err(&chip->client->dev,
>> > +			"%s: data not valid yet\n", __func__);
>> > +		ret = chip->als_cur_info.lux; /* return LAST VALUE */
>> > +		goto out_unlock;
>> > +	}
>> > +
>> > +	for (i = 0; i<  4; i++) {
>> > +		ret = tsl2x7x_i2c_read(chip->client,
>> > +			(TSL2X7X_CMD_REG | (TSL2X7X_ALS_CHAN0LO + i)),
>> > +			&buf[i]);
>> > +		if (ret<  0) {
>> > +			dev_err(&chip->client->dev,
>> > +				"%s: failed to read. err=%x\n", __func__, ret);
>> > +			goto out_unlock;
>> > +		}
>> > +	}
>> > +
>> > +	/* clear any existing interrupt status */
>> > +	ret = i2c_smbus_write_byte(chip->client,
>> > +		(TSL2X7X_CMD_REG |
>> > +				TSL2X7X_CMD_SPL_FN |
>> > +				TSL2X7X_CMD_ALS_INT_CLR));
>> > +	if (ret<  0) {
>> > +		dev_err(&chip->client->dev,
>> > +		"%s: i2c_write_command failed - err = %d\n",
>> > +			__func__, ret);
>> > +		goto out_unlock; /* have no data, so return failure */
>> > +	}
>> > +
>> > +	/* extract ALS/lux data */
>> > +	ch0 = le16_to_cpup((const __le16 *)&buf[0]);
>> > +	ch1 = le16_to_cpup((const __le16 *)&buf[2]);
>> > +
>> > +	chip->als_cur_info.als_ch0 = ch0;
>> > +	chip->als_cur_info.als_ch1 = ch1;
>> > +
>> > +	if ((ch0>= chip->als_saturation) || (ch1>= chip->als_saturation))
>{
>> > +		lux = TSL2X7X_LUX_CALC_OVER_FLOW;
>> > +		goto return_max;
>> > +	}
>> > +
>> > +	if (ch0 == 0) {
>> > +		/* have no data, so return LAST VALUE */
>> > +		ret = chip->als_cur_info.lux;
>> > +		goto out_unlock;
>> > +	}
>> > +	/* calculate ratio */
>> > +	ratio = (ch1<<  15) / ch0;
>> > +	/* convert to unscaled lux using the pointer to the table */
>> > +	p = (struct tsl2x7x_lux *) chip->tsl2x7x_device_lux;
>> > +	while (p->ratio != 0&&  p->ratio<  ratio)
>> > +		p++;
>> > +
>> > +	if (p->ratio == 0) {
>> > +		lux = 0;
>> > +	} else {
>> > +		ch0lux = DIV_ROUND_UP((ch0 * p->ch0),
>> > +			tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain]);
>> > +		ch1lux = DIV_ROUND_UP((ch1 * p->ch1),
>> > +			tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain]);
>> > +		lux = ch0lux - ch1lux;
>> > +	}
>> > +
>> > +	/* note: lux is 31 bit max at this point */
>> > +	if (ch1lux>  ch0lux) {
>> > +		dev_dbg(&chip->client->dev, "ch1lux>  ch0lux-return last
>value\n");
>> > +		ret = chip->als_cur_info.lux;
>> > +		goto out_unlock;
>> > +	}
>> > +
>> > +	/* adjust for active time scale */
>> > +	if (chip->als_time_scale == 0)
>> > +		lux = 0;
>> > +	else
>> > +		lux = (lux + (chip->als_time_scale>>  1)) /
>> > +			chip->als_time_scale;
>> > +
>> > +	/* adjust for active gain scale
>> > +	 * The tsl2x7x_device_lux tables have a factor of 256 built-in.
>> > +	 * User-specified gain provides a multiplier.
>> > +	 * Apply user-specified gain before shifting right to retain
>precision.
>> > +	 * Use 64 bits to avoid overflow on multiplication.
>> > +	 * Then go back to 32 bits before division to avoid using
>div_u64().
>> > +	 */
>> > +
>> > +	lux64 = lux;
>> > +	lux64 = lux64 * chip->tsl2x7x_settings.als_gain_trim;
>> > +	lux64>>= 8;
>> > +	lux = lux64;
>> > +	lux = (lux + 500) / 1000;
>> > +
>> > +	if (lux>  TSL2X7X_LUX_CALC_OVER_FLOW) /* check for overflow */
>> > +		lux = TSL2X7X_LUX_CALC_OVER_FLOW;
>> > +
>> > +	/* Update the structure with the latest lux. */
>> > +return_max:
>> > +	chip->als_cur_info.lux = lux;
>> > +	ret = lux;
>> > +
>> > +out_unlock:
>> > +	mutex_unlock(&chip->als_mutex);
>> > +
>> > +	return ret;
>> > +}
>> > +
>> > +/**
>> > + * tsl2x7x_get_prox() - Reads proximity data registers and updates
>> > + *                      chip->prox_data.
>> > + *
>> > + * @indio_dev:	pointer to IIO device
>> > + */
>> > +static int tsl2x7x_get_prox(struct iio_dev *indio_dev)
>> > +{
>> > +	int i;
>> > +	int ret;
>> > +	u8 status;
>> > +	u8 chdata[2];
>> > +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
>> > +
>> > +	if (mutex_trylock(&chip->prox_mutex) == 0) {
>> > +		dev_err(&chip->client->dev,
>> > +			"%s: Can't get prox mutex\n", __func__);
>> > +		return -EBUSY;
>> > +	}
>> > +
>> > +	ret = tsl2x7x_i2c_read(chip->client,
>> > +		(TSL2X7X_CMD_REG | TSL2X7X_STATUS),&status);
>> > +	if (ret<  0) {
>> > +		dev_err(&chip->client->dev,
>> > +		"%s: i2c err=%d\n", __func__, ret);
>> > +		goto prox_poll_err;
>> > +	}
>> > +
>> > +	switch (chip->id) {
>> > +	case tsl2571:
>> > +	case tsl2671:
>> > +	case tmd2671:
>> > +	case tsl2771:
>> > +	case tmd2771:
>> > +		if (!(status&  TSL2X7X_STA_ADC_VALID))
>> > +			goto prox_poll_err;
>> > +	break;
>> > +	case tsl2572:
>> > +	case tsl2672:
>> > +	case tmd2672:
>> > +	case tsl2772:
>> > +	case tmd2772:
>> > +		if (!(status&  TSL2X7X_STA_PRX_VALID))
>> > +			goto prox_poll_err;
>> > +	break;
>> > +	}
>> > +
>> > +	for (i = 0; i<  2; i++) {
>> > +		ret = tsl2x7x_i2c_read(chip->client,
>> > +			(TSL2X7X_CMD_REG |
>> > +					(TSL2X7X_PRX_LO + i)),&chdata[i]);
>> > +		if (ret<  0)
>> > +			goto prox_poll_err;
>> > +	}
>> > +
>> > +	chip->prox_data =
>> > +			le16_to_cpup((const __le16 *)&chdata[0]);
>> > +
>> > +prox_poll_err:
>> > +
>> > +	mutex_unlock(&chip->prox_mutex);
>> > +
>> > +	return chip->prox_data;
>> > +}
>> > +
>> > +/**
>> > + * tsl2x7x_defaults() - Populates the device nominal operating
>parameters
>> > + *                      with those provided by a 'platform' data
>struct or
>> > + *                      with prefined defaults.
>> > + *
>> > + * @chip:               pointer to device structure.
>> > + */
>> > +static void tsl2x7x_defaults(struct tsl2X7X_ch
