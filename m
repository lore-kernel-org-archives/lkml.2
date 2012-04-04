Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2DDQX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:23:57 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:44185 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab2DDQXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:23:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <c0e6301f-ce07-4659-9239-8dbd96dc5b59@email.android.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <c0e6301f-ce07-4659-9239-8dbd96dc5b59@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: RE: [PATCH V5] TAOS tsl2x7x
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Wed, 04 Apr 2012 17:23:20 +0100
To: Jon Brenner <jbrenner@TAOSinc.com>
CC: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <99fd2098-2aee-4e2c-8f4e-2359977762df@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jon Brenner <jbrenner@TAOSinc.com> wrote:

>Hi Jonathan,
>Thanks for the review .
>
>Please see various responses - in line.
>
>Next patch will be V6 and the last - I hope!
>Jon 
>
>> -----Original Message-----
>> From: Jonathan Cameron [mailto:jic23@cam.ac.uk]
>> Sent: Wednesday, April 04, 2012 3:35 AM
>> To: Jon Brenner
>> Cc: linux-iio; Linux Kernel
>> Subject: Re: [PATCH V5] TAOS tsl2x7x
>> 
>> On 4/2/2012 5:50 PM, Jon Brenner wrote:
>> > TAOS device driver (version 5) for the tsl/tmd 2771 and 2772 device
>families
>> (inc. all variants).
>> Hi Jon,
>> 
>> Changes since last version?
>Correct.
>> 
>> A few bits still to sort out in here I'm afraid... (getting there
>though!)
>> My reviews tend to get more picky as the big stuff gets sorted out.
>> 
>> On trivial extra blank line to clear out.
>
>> Extra line for your next driver has snuck into the make file.
>Yikes!
>
>> Units don't look right for sampling frequency.  Sorry, but that's an
>abi
>> issue so even if it is
>> fiddly to do the conversion to Hz it needs to be done.
>> Would normally expect changes to events to get applied immediately.
>Here
>> I think that only
>> happens if you turn the device off and on again?
>This is per customer request - allows complete reconfiguration without
>many device on/offs.
> 
To match other devices turn off then on again iff previously on. Works for me and your customer!
>> 
>> For future reference (don't bother here!) make any documentation
>moves
>> not directly dependent on the
>> driver (such as those that will become used by multiple drivers) in a
>> precursor patch.
>OK
>
>> >
>> > Signed-off-by: Jon Brenner<jbrenner@taosinc.com>
>> > ---
>> >   .../light/sysfs-bus-iio-light-tsl2583              |    6 +
>> >   .../light/sysfs-bus-iio-light-tsl2x7x              |   14 +
>> >   drivers/staging/iio/Documentation/sysfs-bus-iio    |    7 +
>> >   .../staging/iio/Documentation/sysfs-bus-iio-light  |    8 +-
>> >   .../iio/Documentation/sysfs-bus-iio-light-tsl2583  |   20 -
>> >   drivers/staging/iio/light/Kconfig                  |    8 +
>> >   drivers/staging/iio/light/Makefile                 |    2 +
>> >   drivers/staging/iio/light/tsl2x7x.h                |   99 ++
>> >   drivers/staging/iio/light/tsl2x7x_core.c           | 1830
>++++++++++++++++++++
>> >   9 files changed, 1970 insertions(+), 24 deletions(-)
>> >
>> > diff --git
>a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>> b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
>> > new file mode 100644
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
>> b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
>> > new file mode 100644
>> > index 0000000..275ae54
>> > --- /dev/null
>> > +++
>b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
>> > @@ -0,0 +1,14 @@
>> > +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
>> > +KernelVersion:	2.6.37
>> > +Contact:	linux-iio@vger.kernel.org
>> > +Description:
>> > +		This property causes an internal calibration of the als gain
>trim
>> > +		value which is later used in calculating illuminance in lux.
>> Hmm.. could possibly move this into sysfs-bus-iio-light at some point
>> given we clearly have two drivers
>> using it. (fine for now though)
>> > +
>> > +What:		/sys/bus/iio/devices/device[n]/proximity_calibrate
>> > +KernelVersion:	3.3-rc1
>> > +Contact:	linux-iio@vger.kernel.org
>> > +Description:
>> > +		Causes an recalculation and adjustment to the
>> > +		proximity_thresh_rising_value.
>> This one is interesting as there are other proximity sensors out
>there
>> (not light based) so we
>> may want to move this at some later point to a
>sysfs-bus-iio-proximity
>> documentation file.
>> > +
>> > diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio
>> > index 46a995d..5b2b5d3 100644
>> > --- a/drivers/staging/iio/Documentation/sysfs-bus-iio
>> > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio
>> > @@ -258,6 +258,8 @@ What
>> 	/sys/bus/iio/devices/iio:deviceX/in_accel_z_calibscale
>> >   What
>> 	/sys/bus/iio/devices/iio:deviceX/in_anglvel_x_calibscale
>> >   What
>> 	/sys/bus/iio/devices/iio:deviceX/in_anglvel_y_calibscale
>> >   What
>> 	/sys/bus/iio/devices/iio:deviceX/in_anglvel_z_calibscale
>> > +what
>> 	/sys/bus/iio/devices/iio:deviceX/illuminance0_calibscale
>> > +what		/sys/bus/iio/devices/iio:deviceX/proximity_calibscale
>> >   KernelVersion:	2.6.35
>> >   Contact:	linux-iio@vger.kernel.org
>> >   Description:
>> > @@ -457,6 +459,10 @@ What:
>> 	/sys/.../events/in_voltageY_raw_thresh_falling_value
>> >   What:		/sys/.../events/in_voltageY_raw_thresh_falling_value
>> >   What:		/sys/.../events/in_tempY_raw_thresh_falling_value
>> >   What:		/sys/.../events/in_tempY_raw_thresh_falling_value
>> Oops, clearly and error in the lines above (repeats of falling and no
>> rising). I'll fix that up unless
>> someone else gets there first.
>OK - will not change in this patch.
>
>> > +What:		/sys/.../events/illuminance0_thresh_falling_value
>> > +what:		/sys/.../events/illuminance0_thresh_rising_value
>> > +what:		/sys/.../events/proximity_thresh_falling_value
>> > +what:		/sys/.../events/proximity_thresh_rising_value
>> >   KernelVersion:	2.6.37
>> >   Contact:	linux-iio@vger.kernel.org
>> >   Description:
>> > @@ -739,3 +745,4 @@ Description:
>> >   		system. To minimize the current consumption of the system,
>> >   		the bridge can be disconnected (when it is not being used
>> >   		using the bridge_switch_en attribute.
>> > +
>> loose this extra blank line.
>> > diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>> > index edbf470..4385c70 100644
>> > --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>> > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
>> > @@ -76,10 +76,10 @@ Contact:	linux-iio@vger.kernel.org
>> >   Description:
>> >   		This property gets/sets the sensors ADC analog integration
>> time.
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
>> > diff --git
>a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
>> b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
>> > deleted file mode 100644
>> > index 660781d..0000000
>> > --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
>> > +++ /dev/null
>> > @@ -1,20 +0,0 @@
>> > -What:		/sys/bus/iio/devices/device[n]/lux_table
>> > -KernelVersion:	2.6.37
>> > -Contact:	linux-iio@vger.kernel.org
>> > -Description:
>> > -		This property gets/sets the table of coefficients
>> > -		used in calculating illuminance in lux.
>> > -
>> > -What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
>> > -KernelVersion:	2.6.37
>> > -Contact:	linux-iio@vger.kernel.org
>> > -Description:
>> > -		This property causes an internal calibration of the als gain
>trim
>> > -		value which is later used in calculating illuminance in lux.
>> > -
>> > -What:
>> 	/sys/bus/iio/devices/device[n]/illuminance0_input_target
>> > -KernelVersion:	2.6.37
>> > -Contact:	linux-iio@vger.kernel.org
>> > -Description:
>> > -		This property is the known externally illuminance (in lux).
>> > -		It is used in the process of calibrating the device accuracy.
>> > diff --git a/drivers/staging/iio/light/Kconfig
>b/drivers/staging/iio/light/Kconfig
>> > index e7e9159..976f790 100644
>> > --- a/drivers/staging/iio/light/Kconfig
>> > +++ b/drivers/staging/iio/light/Kconfig
>> > @@ -31,4 +31,12 @@ config TSL2583
>> >   	 Provides support for the TAOS tsl2580, tsl2581 and tsl2583
>devices.
>> >   	 Access ALS data via iio, sysfs.
>> >
>> > +config TSL2x7x
>> > +	tristate "TAOS TSL/TMD2x71 and TSL/TMD2x72 Family of light and
>> proximity sensors"
>> > +	depends on I2C
>> > +	help
>> > +	 Support for: tsl2571, tsl2671, tmd2671, tsl2771, tmd2771,
>tsl2572,
>> tsl2672,
>> > +	 tmd2672, tsl2772, tmd2772 devices.
>> > +	 Provides iio_events and direct access via sysfs.
>> > +
>> >   endmenu
>> > diff --git a/drivers/staging/iio/light/Makefile
>> b/drivers/staging/iio/light/Makefile
>> > index 3011fbf..0b8fb22 100644
>> > --- a/drivers/staging/iio/light/Makefile
>> > +++ b/drivers/staging/iio/light/Makefile
>> > @@ -5,3 +5,5 @@
>> >   obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>> >   obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
>> >   obj-$(CONFIG_TSL2583)	+= tsl2583.o
>> > +obj-$(CONFIG_TSL2x7x)	+= tsl2x7x_core.o
>> > +obj-$(CONFIG_TCS3x7x)	+= tcs3x7x_core.o
>> Really?
>Oops
>
>> > diff --git a/drivers/staging/iio/light/tsl2x7x.h
>> b/drivers/staging/iio/light/tsl2x7x.h
>> > new file mode 100644
>> > index 0000000..fe9e853
>> > --- /dev/null
>> > +++ b/drivers/staging/iio/light/tsl2x7x.h
>> > @@ -0,0 +1,99 @@
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
>MERCHANTABILITY
>> or
>> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>License
>> for
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
>> TSL2X7X_MAX_LUX_TABLE_SIZE)
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
>> > + *  @prx_time:              5.2ms prox integration time -
>> > + *                          dec in 2.7ms periods
>> > + *  @wait_time:             Time between PRX and ALS cycles
>> > + *                          in 2.7 periods
>> > + *  @prox_config:           Prox configuration filters.
>> > + *  @als_gain_trim:         default gain trim to account for
>> > + *                          aperture effects.
>> > + *  @als_cal_target:        Known external ALS reading for
>> > + *                          calibration.
>> > + *  @als_thresh_low:        CH0 'low' count to trigger interrupt.
>> > + *  @als_thresh_high:       CH0 'high' count to trigger interrupt.
>> > + *  @persistence:           H/W Filters, Number of 'out of limits'
>> > + *                          ADC readings PRX/ALS.
>> > + *  @interrupts_en:         Enable/Disable - 0x00 = none, 0x10 =
>als,
>> > + *                                           0x20 = prx,  0x30 =
>bth
>> > + *  @prox_thres_low:        Low threshold proximity detection.
>> > + *  @prox_thres_high:       High threshold proximity detection
>> > + *  @prox_max_samples_cal:  Used for prox cal.
>> > + *  @prox_pulse_count:      Number if proximity emitter pulses
>> reorder the docs to match the structure.  Pick which ever order makes
>> most sense
>> (don't worry about wasting a byte or two, clarity is more important
>on
>> structures
>> like this!)
>OK
>
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
>> > + * @platform_power:				Suspend/resume
>> platform callback
>> > + * @power_on:					Power on callback
>> > + * @power_off:					Power off callback
>> > + * @platform_lux_table:			Device specific glass
>> coefficents
>> > + * @platform_default_settings:	Device specific power on defaults
>> > + * Platform PM functions.
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
>> b/drivers/staging/iio/light/tsl2x7x_core.c
>> > new file mode 100644
>> > index 0000000..267faab
>> > --- /dev/null
>> > +++ b/drivers/staging/iio/light/tsl2x7x_core.c
>> > @@ -0,0 +1,1830 @@
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
>MERCHANTABILITY
>> or
>> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
>License
>> for
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
>> hmmm.. fish ;)
>And Chips - uum ;^)
>
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
>> > +#define TSL2X7X_STA_ADC_PRX_VALID      0x03
>> Would prefer above defined as TSL2X7X_STA_ADC_VALID |
>> TSL2X7X_STA_PRX_VALID
>> (makes it obvious at a glance what is going on).
>> > +#define TSL2X7X_STA_ALS_INTR           0x10
>> > +#define TSL2X7X_STA_ADC_INTR           0x10
>> above unused (and seems to be repeated) ? (repeated value was
>suspicious )
>> > +#define TSL2X7X_STA_PRX_INTR           0x20
>> > +
>> > +#define TSL2X7X_STA_ADC_INTR           0x10
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
>> > +/* Per-device data */
>> > +struct tsl2x7x_als_info {
>> > +	u16 als_ch0;
>> > +	u16 als_ch1;
>> > +	u16 lux;
>> > +};
>> > +
>> > +struct prox_stat {
>> > +	u16 min;
>> > +	u16 max;
>> > +	u16 mean;
>> > +	unsigned long stddev;
>> > +};
>> > +
>> > +struct tsl2x7x_chip_info {
>> > +	int chan_table_elements;
>> > +	struct iio_chan_spec		channel[9];
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
>> > +	.als_time = 200,
>> > +	.als_gain = 0,
>> > +	.prx_time = 0xfe, /*5.4 mS */
>> > +	.prox_gain = 1,
>> > +	.wait_time = 245,
>> > +	.prox_config = 0,
>> > +	.als_gain_trim = 1000,
>> > +	.als_cal_target = 150,
>> > +	.als_thresh_low = 200,
>> > +	.als_thresh_high = 256,
>> > +	.persistence = 0xFF,
>> > +	.interrupts_en = 0x00,
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
>> > +/*
>> > + * Read a number of bytes starting at register (reg) location.
>> > + * Return 0, or i2c_smbus_write_byte ERROR code.
>> > + *

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
