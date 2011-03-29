Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1C2PIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:08:14 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:24922 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980Ab1C2PIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:08:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V3]TAOS 258x: Device Driver
Date: Tue, 29 Mar 2011 10:08:09 -0500
Message-ID: <B4B07CCC7B7A084E989CF9386538EA1D69ACCD@exchsrvr.taosinc.com>
In-Reply-To: <a3971e1f0d7d9d86b13f09015574b69e@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V3]TAOS 258x: Device Driver
Thread-Index: AcvteRnOrJQewLFuSfik+FRCK4uFigAWbx6QABPtSZA=
References: <1301089260.29448.22.camel@jonz-ubuntu> <4D8E1F9B.9080302@ti.com> <1301338247.1830.6.camel@jonz-ubuntu> <a3971e1f0d7d9d86b13f09015574b69e@mail.gmail.com>
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: "Shubhrajyoti Datta" <shubhrajyoti@ti.com>
Cc: "Jonathan Cameron" <jic23@cam.ac.uk>,
        "linux-iio" <linux-iio@vger.kernel.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Shubhrajyoti Datta [mailto:shubhrajyoti@ti.com] 
Sent: Tuesday, March 29, 2011 12:38 AM
To: Jon Brenner
Cc: Jonathan Cameron; linux-iio; Linux Kernel
Subject: RE: [PATCH V3]TAOS 258x: Device Driver

> -----Original Message-----
> From: Jon Brenner [mailto:jbrenner@TAOSinc.com]
> Sent: Tuesday, March 29, 2011 12:21 AM
> To: Shubhrajyoti
> Cc: Jonathan Cameron; linux-iio; Linux Kernel
> Subject: Re: [PATCH V3]TAOS 258x: Device Driver
>
> HI Shubhrajyoti:
> Thanks for taking time to review the code.
> Please see my response to your comments throughout.
>
>
> Jon
>
> On Sat, 2011-03-26 at 22:47 +0530, Shubhrajyoti wrote:
> > Hi Jon,
> > Some minor comments.
> >
> > On Saturday 26 March 2011 03:11 AM, Jon Brenner wrote:
> > > [PATCH v3] for TAOS tsl2580/81/83 Device driver
> > >
> > > Added suspend/resume functions.
> > > Changed attribute names to match existing where applicable and 
> > > updated
> or documented new ABI as discussed.
> > > Changed integration time ABI from using index (0 to 3) to use 
> > > actual
> gain values (1x,8x, etc.).
> > > Removed various unused variables, declarations, and functions.
> > > Revised code to accommodate different endianess (le16_to_cpu).
> > > Updated error return codes in various functions.
> > > Changed from mdelay to msleep after determining that longer wait 
> > > would
> be acceptable.
> > >
> > > Signed-off-by:Jon August Brenner<jbrenner@taosinc.com>
> > >
> > > ---
> > >   drivers/staging/iio/Documentation/sysfs-bus-iio    |    6 +
> > >   .../staging/iio/Documentation/sysfs-bus-iio-light  |   13 +
> > >   .../iio/Documentation/sysfs-bus-iio-light-tsl2583  |   20 +
> > >   drivers/staging/iio/light/Kconfig                  |    9 +
> > >   drivers/staging/iio/light/Makefile                 |    1 +
> > >   drivers/staging/iio/light/tsl2583.c                |  962
> ++++++++++++++++++++
> > >   6 files changed, 1011 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio
> b/drivers/staging/iio/Documentation/sysfs-bus-iio
> > > index 2dde97d..6a86ad2 100644
> > > --- a/drivers/staging/iio/Documentation/sysfs-bus-iio
> > > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio
> > > @@ -6,6 +6,12 @@ Description:
> > >   		Corresponds to a grouping of sensor channels. X
is the
> IIO
> > >   		index of the device.
> > >
> > > +What:		/sys/bus/iio/devices/device[n]/power_state
> > > +KernelVersion:	2.6.37
> > > +Contact:	linux-iio@vger.kernel.org
> > > +Description:
> > > +		This property gets/sets the device power state.
> > > +
> > >   What:		/sys/bus/iio/devices/triggerX
> > >   KernelVersion:	2.6.35
> > >   Contact:	linux-iio@vger.kernel.org
> > > diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> > > index 5d84856..21d2774 100644
> > > --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> > > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> > > @@ -62,3 +62,16 @@ Description:
> > >   		sensing mode. This value should be the output
from a
> reading
> > >   		and if expressed in SI units, should include
_input. If
> this
> > >   		value is not in SI units, then it should include
_raw.
> > > +
> > > +What:
/sys/bus/iio/devices/device[n]/illuminance0_target
> > > +KernelVersion:	2.6.37
> > > +Contact:	linux-iio@vger.kernel.org
> > > +Description:
> > > +		This property gets/sets the last known external
> > > +		lux measurement used in/for calibration.
> > > +
> > > +What:
> 	/sys/bus/iio/devices/device[n]/illuminance0_integration_time
> > > +KernelVersion:	2.6.37
> > > +Contact:	linux-iio@vger.kernel.org
> > > +Description:
> > > +		This property gets/sets the sensors ADC analog
integration
> time.
> > > diff --git 
> > > a/drivers/staging/iio/Documentation/sysfs-bus-iio-light-
> tsl2583 
> b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
> > > new file mode 100644
> > > index 0000000..660781d
> > > --- /dev/null
> > > +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl258
> > > +++ 3
> > > @@ -0,0 +1,20 @@
> > > +What:		/sys/bus/iio/devices/device[n]/lux_table
> > > +KernelVersion:	2.6.37
> > > +Contact:	linux-iio@vger.kernel.org
> > > +Description:
> > > +		This property gets/sets the table of coefficients
> > > +		used in calculating illuminance in lux.
> > > +
> > > +What:
/sys/bus/iio/devices/device[n]/illuminance0_calibrate
> > > +KernelVersion:	2.6.37
> > > +Contact:	linux-iio@vger.kernel.org
> > > +Description:
> > > +		This property causes an internal calibration of the als
gain
> trim
> > > +		value which is later used in calculating illuminance in
lux.
> > > +
> > > +What:
/sys/bus/iio/devices/device[n]/illuminance0_input_target
> > > +KernelVersion:	2.6.37
> > > +Contact:	linux-iio@vger.kernel.org
> > > +Description:
> > > +		This property is the known externally illuminance (in
lux).
> > > +		It is used in the process of calibrating the device
accuracy.
> > > diff --git a/drivers/staging/iio/light/Kconfig
> b/drivers/staging/iio/light/Kconfig
> > > index 36d8bbe..55c146c 100644
> > > --- a/drivers/staging/iio/light/Kconfig
> > > +++ b/drivers/staging/iio/light/Kconfig
> > > @@ -13,6 +13,15 @@ config SENSORS_TSL2563
> > >   	 This driver can also be built as a module.  If so, the
module
> > >   	 will be called tsl2563.
> > >
> > > +config TSL2583
> > > +	tristate "TAOS TSL2580, TSL2581, and TSL2583 light-to-digital
> converters"
> > > +	depends on I2C
> > > +	help
> > > +	  Y = in kernel.
> > > +	  M = as module.
> > > +	  Provides support for the TAOS tsl2580, tsl2581, and tsl2583
> devices.
> > > +	  Access ALS data via iio, sysfs.
> > > +
> > >   config SENSORS_ISL29018
> > >           tristate "ISL 29018 light and proximity sensor"
> > >           depends on I2C
> > > diff --git a/drivers/staging/iio/light/Makefile
> b/drivers/staging/iio/light/Makefile
> > > index 9142c0e..8a10815 100644
> > > --- a/drivers/staging/iio/light/Makefile
> > > +++ b/drivers/staging/iio/light/Makefile
> > > @@ -3,4 +3,5 @@
> > >   #
> > >
> > >   obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
> > > +obj-$(CONFIG_TSL2583)	+= tsl2583.o
> > >   obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
> > > diff --git a/drivers/staging/iio/light/tsl2583.c
> b/drivers/staging/iio/light/tsl2583.c
> > > new file mode 100644
> > > index 0000000..013a742
> > > --- /dev/null
> > > +++ b/drivers/staging/iio/light/tsl2583.c
> > > @@ -0,0 +1,962 @@
> > > +/*
> > > + * Device driver for monitoring ambient light intensity (lux)
> > > + * within the TAOS tsl258x family of devices (tsl2580, tsl2581).
> > > + *
> > > + * Copyright (c) 2011, TAOS Corporation.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> modify
> > > + * it under the terms of the GNU General Public License as 
> > > + published
> by
> > > + * the Free Software Foundation; either version 2 of the License,

> > > + or
> > > + * (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it will be 
> > > + useful,
> but WITHOUT
> > > + * ANY WARRANTY; without even the implied warranty of 
> > > + MERCHANTABILITY
> or
> > > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> License for
> > > + * more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public 
> > > + License
> along
> > > + * with this program; if not, write to the Free Software 
> > > + Foundation,
> Inc.,
> > > + * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
> > > + */
> > > +
> > > +#include<linux/kernel.h>
> > > +#include<linux/i2c.h>
> > > +#include<linux/errno.h>
> > > +#include<linux/delay.h>
> > > +#include<linux/string.h>
> > > +#include<linux/mutex.h>
> > > +#include<linux/unistd.h>
> > > +#include "../iio.h"
> > > +
> > > +
> > > +#define TSL258X_MAX_DEVICE_REGS		32
> > > +
> > > +/* Triton register offsets */
> > > +#define	TSL258X_REG_MAX		8
> > > +
> > > +/* Device Registers and Masks */
> > > +#define TSL258X_CNTRL			0x00
> > > +#define TSL258X_ALS_TIME		0X01
> > > +#define TSL258X_INTERRUPT		0x02
> > > +#define TSL258X_GAIN			0x07
> > > +#define TSL258X_REVID			0x11
> > > +#define TSL258X_CHIPID			0x12
> > > +#define TSL258X_ALS_CHAN0LO		0x14
> > > +#define TSL258X_ALS_CHAN0HI		0x15
> > > +#define TSL258X_ALS_CHAN1LO		0x16
> > > +#define TSL258X_ALS_CHAN1HI		0x17
> > > +#define TSL258X_TMR_LO			0x18
> > > +#define TSL258X_TMR_HI			0x19
> > > +
> > > +/* tsl2583 cmd reg masks */
> > > +#define TSL258X_CMD_REG			0x80
> > > +#define TSL258X_CMD_SPL_FN		0x60
> > > +#define TSL258X_CMD_ALS_INT_CLR	0X01
> > > +
> > > +/* tsl2583 cntrl reg masks */
> > > +#define TSL258X_CNTL_ADC_ENBL	0x02
> > > +#define TSL258X_CNTL_PWR_ON		0x01
> > > +
> > > +/* tsl2583 status reg masks */
> > > +#define TSL258X_STA_ADC_VALID	0x01
> > > +#define TSL258X_STA_ADC_INTR	0x10
> > > +
> > > +/* Lux calculation constants */
> > > +#define	TSL258X_LUX_CALC_OVER_FLOW		65535
> > > +
> > > +enum {
> > > +	TSL258X_CHIP_UNKNOWN = 0,
> > > +	TSL258X_CHIP_WORKING = 1,
> > > +	TSL258X_CHIP_SUSPENDED = 2
> > > +} TSL258X_CHIP_WORKING_STATUS;
> > > +
> > > +/* Per-device data */
> > > +struct taos_als_info {
> > > +	u16 als_ch0;
> > > +	u16 als_ch1;
> > > +	u16 lux;
> > > +};
> > > +
> > > +struct taos_settings {
> > > +	int als_time;
> > > +	int als_gain;
> > > +	int als_gain_trim;
> > > +	int als_cal_target;
> > > +};
> > > +
> > > +struct tsl2583_chip {
> > > +	struct mutex als_mutex;
> > > +	struct i2c_client *client;
> > > +	struct iio_dev *iio_dev;
> > > +	struct taos_als_info als_cur_info;
> > > +	struct taos_settings taos_settings;
> > > +	int als_time_scale;
> > > +	int als_saturation;
> > > +	int taos_chip_status;
> > > +	u8 taos_config[8];
> > > +};
> > > +
> > > +/*
> > > + * Initial values for device - this values can/will be changed by
> driver.
> > > + * and applications as needed.
> > > + * These values are dynamic.
> > > + */
> > > +static const u8 taos_config[8] = {
> > > +		0x00, 0xee, 0x00, 0x03, 0x00, 0xFF, 0xFF, 0x00
> > > +}; /*	cntrl atime intC  Athl0 Athl1 Athh0 Athh1 gain */
> > > +
> > > +struct taos_lux {
> > > +	unsigned int ratio;
> > > +	unsigned int ch0;
> > > +	unsigned int ch1;
> > > +};
> > > +
> > > +/* This structure is intentionally large to accommodate updates 
> > > +via
> sysfs. */
> > > +/* Sized to 11 = max 10 segments + 1 termination segment */
> > > +/* Assumption is is one and only one type of glass used  */ 
> > > +struct taos_lux taos_device_lux[11] = {
> > > +	{  9830,  8520, 15729 },
> > > +	{ 12452, 10807, 23344 },
> > > +	{ 14746,  6383, 11705 },
> > > +	{ 17695,  4063,  6554 },
> > > +};
> > > +
> > > +struct gainadj {
> > > +	s16 ch0;
> > > +	s16 ch1;
> > > +};
> > > +
> > > +/* Index = (0 - 3) Used to validate the gain selection index */ 
> > > +static const struct gainadj gainadj[] = {
> > > +	{ 1, 1 },
> > > +	{ 8, 8 },
> > > +	{ 16, 16 },
> > > +	{ 107, 115 }
> > > +};
> > > +
> > > +/*
> > > + * Provides initial operational parameter defaults.
> > > + * These defaults may be changed through the device's sysfs
files.
> > > + */
> > > +static void taos_defaults(struct tsl2583_chip *chip) {
> > > +	/* Operational parameters */
> > > +	chip->taos_settings.als_time = 450;
> > > +	/* must be a multiple of 50mS */
> > > +	chip->taos_settings.als_gain = 2;
> > > +	/* this is actually an index into the gain table */
> > > +	/* assume clear glass as default */
> > > +	chip->taos_settings.als_gain_trim = 1000;
> > > +	/* default gain trim to account for aperture effects */
> > > +	chip->taos_settings.als_cal_target = 130;
> > > +	/* Known external ALS reading used for calibration */ }
> > > +
> > > +/*
> > > + * Read a number of bytes starting at register (reg) location.
> > > + * Return 0, or i2c_smbus_write_byte ERROR code.
> > > + */
> > Could we use i2c_smbus_read_block_data ?
> NO -Many controllers no longer seem to support block mode read/write.
> To use block mode reads could exclude some.
By controller you mean the i2c controller?
(ie. - msg from older driver)
taos 0-0039: taos_probe() - i2c smbus block data functions unsupported

>
> > > +static int
> > > +taos_i2c_read(struct i2c_client *client, u8 reg, u8 *val, 
> > > +unsigned
> int len)
> > > +{
> > > +	int ret;
