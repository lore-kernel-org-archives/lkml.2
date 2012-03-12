Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2CLNAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:00:14 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:50161 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab2CLNAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:00:07 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F5DF34F.4040801@cam.ac.uk>
Date: Mon, 12 Mar 2012 12:59:59 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120308 Thunderbird/11.0
MIME-Version: 1.0
To: Jon Brenner <jbrenner@taosinc.com>
CC: linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] TAOS tsl2x7x
References: <1331308637.15344.9.camel@jonz-ub2>
In-Reply-To: <1331308637.15344.9.camel@jonz-ub2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/2012 3:57 PM, Jon Brenner wrote:
> TAOS device driver (version 2) for the tsl/tmd 2771 and 2772 device families (inc. all variants).
Mostly fine, various nitpicks inline.  A lot of them are requests for 
documentation or trivial cleanups.

For the sysfs docs please push them as high up the tree (to 
sysfs-bus-iio if relevant).  That way we carry
less bulk of documentation with the same level of details.  Better for 
maintenance!
> Signed-off-by: Jon Brenner<jbrenner@taosinc.com>
>
> ---
>   .../light/sysfs-bus-iio-light-tsl2583              |    6 +
>   .../light/sysfs-bus-iio-light-tsl2x7x              |   20 +
>   drivers/staging/iio/Documentation/sysfs-bus-iio    |   53 +
>   .../staging/iio/Documentation/sysfs-bus-iio-light  |   14 +-
>   drivers/staging/iio/light/Kconfig                  |   11 +
>   drivers/staging/iio/light/Makefile                 |    1 +
>   drivers/staging/iio/light/tsl2x7x_core.c           | 1871 ++++++++++++++++++++
>   drivers/staging/iio/light/tsl2x7x_core.h           |  156 ++
>   8 files changed, 2128 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583 b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
> new file mode 100644
> index 0000000..8f2a038
> --- /dev/null
> +++ b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2583
> @@ -0,0 +1,6 @@
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property causes an internal calibration of the als gain trim
> +		value which is later used in calculating illuminance in lux.
> diff --git a/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
> new file mode 100644
> index 0000000..cceadae
> --- /dev/null
> +++ b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
> @@ -0,0 +1,20 @@
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibrate
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		This property causes an internal calibration of the als gain trim
> +		value which is later used in calculating illuminance in lux.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_both_raw
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Simultainious ALS channel data.
err, not present (and good that it isn't!)
> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_calibrate
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Causes an recalculation and adjustment to the
> +		proximity_thresh_rising_value.
> +
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio b/drivers/staging/iio/Documentation/sysfs-bus-iio
> index 46a995d..4b6b002 100644
> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio
> @@ -739,3 +739,56 @@ Description:
>   		system. To minimize the current consumption of the system,
>   		the bridge can be disconnected (when it is not being used
>   		using the bridge_switch_en attribute.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_thresh_falling_value
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Low (falling) trigger point for the internal ALS comparison
> +		function for interrupt generation.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_thresh_rising_value
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		high (rising) trigger point for the internal ALS comparison
> +		function for interrupt generation.
> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_thresh_falling_value
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Low (falling) trigger point for the internal proximity comparison
> +		function for interrupt generation.
> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_thresh_rising_value
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		high (rising) trigger point for the internal proximity comparison
> +		function for interrupt generation.
would much prefer these were added to the bit lists of such parameters 
in sysfs-bus-iio to avoid
and explosion in the amount of documentation being carried.


> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_raw
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		State of proximity detection based on the
> +		proximity_thresh_rising_value.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_calibscale
> +KernelVersion:	2.6.37
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware or software applied calibration scale factor assumed
> +		to account for attenuation due to industrial design (glass
> +		filters or aperture holes).
> +
> +What:		/sys/bus/iio/devices/device[n]/proximity_calibscale
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Hardware or software applied calibration scale factor assumed
> +		to account for attenuation due to industrial design (glass
> +		filters or aperture holes).
> +
> +
> diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> index edbf470..e992f35 100644
> --- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> +++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
> @@ -76,10 +76,16 @@ Contact:	linux-iio@vger.kernel.org
>   Description:
>   		This property gets/sets the sensors ADC analog integration time.
>
> -What:		/sys/bus/iio/devices/device[n]/illuminance0_calibscale
> +What:		/sys/bus/iio/devices/device[n]/lux_table
>   KernelVersion:	2.6.37
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> -		Hardware or software applied calibration scale factor assumed
> -		to account for attenuation due to industrial design (glass
> -		filters or aperture holes).
> +		This property gets/sets the table of coefficients
> +		used in calculating illuminance in lux.
> +
> +What:		/sys/bus/iio/devices/device[n]/illuminance0_both_raw
> +KernelVersion:	3.3-rc1
> +Contact:	linux-iio@vger.kernel.org
> +Description:
> +		Simultainious ALS channel data
typo and not present I think?
> +
> diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
> index e7e9159..29de333 100644
> --- a/drivers/staging/iio/light/Kconfig
> +++ b/drivers/staging/iio/light/Kconfig
> @@ -31,4 +31,15 @@ config TSL2583
>   	 Provides support for the TAOS tsl2580, tsl2581 and tsl2583 devices.
>   	 Access ALS data via iio, sysfs.
>
> +	 This driver can also be built as a module.  If so, the module
> +	 will be called tsl2583.
Drop this change from this patch. Ignore silly checkpatch moaning that 
the description is too short.
> +
> +config TSL2x7x
> +	tristate "TAOS TSL/TMD2x71 and TSL/TMD2x72 Family of light and proximity sensors"
> +	depends on I2C
> +	help
> +	 Support for: tsl2571, tsl2671, tmd2671, tsl2771, tmd2771, tsl2572, tsl2672,
> +	 tmd2672, tsl2772, tmd2772 devices.
> +	 Provides iio_events and direct access via sysfs.
> +
>   endmenu
> diff --git a/drivers/staging/iio/light/Makefile b/drivers/staging/iio/light/Makefile
> index 3011fbf..ff12c4b 100644
> --- a/drivers/staging/iio/light/Makefile
> +++ b/drivers/staging/iio/light/Makefile
> @@ -5,3 +5,4 @@
>   obj-$(CONFIG_SENSORS_TSL2563)	+= tsl2563.o
>   obj-$(CONFIG_SENSORS_ISL29018)	+= isl29018.o
>   obj-$(CONFIG_TSL2583)	+= tsl2583.o
> +obj-$(CONFIG_TSL2x7x)	+= tsl2x7x_core.o
> diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
> new file mode 100644
> index 0000000..16275d9
> --- /dev/null
> +++ b/drivers/staging/iio/light/tsl2x7x_core.c
> @@ -0,0 +1,1871 @@
> +/*
> + * Device driver for monitoring ambient light intensity in (lux)
> + * and proximity detection (prox) within the TAOS TSL2X7X family of devices.
> + *
> + * Copyright (c) 2012, TAOS Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA        02110-1301, USA.
> + */
> +
> +#include<linux/kernel.h>
> +#include<linux/i2c.h>
> +#include<linux/errno.h>
> +#include<linux/delay.h>
> +#include<linux/mutex.h>
> +#include<linux/interrupt.h>
> +#include<linux/slab.h>
> +#include<linux/module.h>
> +#include<linux/version.h>
> +#include "tsl2x7x_core.h"
> +#include "../events.h"
> +#include "../iio.h"
> +#include "../sysfs.h"
> +
> +/* Cal defs*/
> +#define PROX_STAT_CAL        0
> +#define PROX_STAT_SAMP       1
> +#define MAX_SAMPLES_CAL      200
> +
> +/* TSL2X7X Device ID */
> +#define TRITON_ID    0x00
> +#define SWORDFISH_ID 0x30
> +#define HALIBUT_ID   0x20
> +
> +/* Lux calculation constants */
> +#define TSL2X7X_LUX_CALC_OVER_FLOW        65535
> +
> +/* TAOS txx2x7x Device family members */
> +enum {
> +	tsl2571,
> +	tsl2671,
> +	tmd2671,
> +	tsl2771,
> +	tmd2771,
> +	tsl2572,
> +	tsl2672,
> +	tmd2672,
> +	tsl2772,
> +	tmd2772
> +};
> +
> +enum {
> +	TSL2X7X_CHIP_UNKNOWN = 0,
> +	TSL2X7X_CHIP_WORKING = 1,
> +	TSL2X7X_CHIP_SUSPENDED = 2
> +};
> +
> +/* Per-device data */
> +struct tsl2x7x_als_info {
> +	u16 als_ch0;
> +	u16 als_ch1;
> +	u16 lux;
> +};
> +
> +/* proximity data */
> +struct tsl2x7x_prox_info {
> +	u16 prox_data;
> +	int prox_event;
> +};
> +
> +struct prox_stat {
> +	u16 min;
> +	u16 max;
> +	u16 mean;
> +	unsigned long stddev;
> +};
> +
> +struct tsl2x7x_chip_info {
> +	int num_channels;
> +	struct iio_chan_spec		channel[9];
> +	const struct iio_info		*info;
> +};
> +
> +struct tsl2X7X_chip {
> +	kernel_ulong_t id;
> +	struct mutex prox_mutex;
> +	struct mutex als_mutex;
> +	struct i2c_client *client;
> +	struct tsl2x7x_prox_info prox_cur_info;
> +	struct tsl2x7x_als_info als_cur_info;
> +	struct tsl2x7x_settings tsl2x7x_settings;
> +	struct tsl2X7X_platform_data *pdata;
> +	int als_time_scale;
> +	int als_saturation;
> +	int tsl2x7x_chip_status;
> +	u8 tsl2x7x_config[TSL2X7X_REG_MAX];
> +	bool init_done;
> +	const struct tsl2x7x_chip_info	*chip_info;
> +	const struct iio_info *info;
> +	s64 event_timestamp;
> +	/* This structure is intentionally large to accommodate
> +	 * updates via sysfs. */
> +	/* Sized to 9 = max 8 segments + 1 termination segment */
> +	struct tsl2x7x_lux tsl2x7x_device_lux[MAX_TABLE_SIZE];
> +};
> +
> +/* Different devices require different coefficents */
> +static const struct tsl2x7x_lux tsl2x71_lux_table[] = {
> +	{ 14461,   611,   1211 },
> +	{ 18540,   352,    623 },
> +	{     0,     0,      0 },
> +};
> +
> +static const struct tsl2x7x_lux tmd2x71_lux_table[] = {
> +	{ 11635,   115,    256 },
> +	{ 15536,    87,    179 },
> +	{     0,     0,      0 },
> +};
> +
> +static const struct tsl2x7x_lux tsl2x72_lux_table[] = {
> +	{ 14013,   466,   917 },
> +	{ 18222,   310,   552 },
> +	{     0,     0,     0 },
> +};
> +
> +static const struct tsl2x7x_lux tmd2x72_lux_table[] = {
> +	{ 13218,   130,   262 },
> +	{ 17592,   92,    169 },
> +	{     0,     0,     0 },
> +};
> +
> +static const struct tsl2x7x_lux *tsl2x7x_default_lux_table_group[] = {
> +	[tsl2571] = tsl2x71_lux_table,
> +	[tsl2671] =	tsl2x71_lux_table,
> +	[tmd2671] =	tmd2x71_lux_table,
> +	[tsl2771] =	tsl2x71_lux_table,
> +	[tmd2771] =	tmd2x71_lux_table,
> +	[tsl2572] =	tsl2x72_lux_table,
> +	[tsl2672] =	tsl2x72_lux_table,
> +	[tmd2672] = tmd2x72_lux_table,
spacing vs tabs issues.
> +	[tsl2772] =	tsl2x72_lux_table,
> +	[tmd2772] =	tmd2x72_lux_table,
> +};
> +
> +static const struct tsl2x7x_settings tsl2x7x_default_settings = {
> +	.als_time = 200,
> +	/* must be a multiple of 50mS */
> +	.als_gain = 0,
> +	/* this is actually an index into the gain table */
> +	.prx_time = 0xfe, /*5.4 mS */
> +	/* 2.7ms prox integration time - decrease to increase time */
> +	/* decreases in 2.7 ms intervals */
> +	.prox_gain = 1,
> +	/* these are bits 3:2 of reg 0x0f: 0=x1,1=x2,2=x4,3=x8 */
> +	/* assume clear glass as default */
> +	.wait_time = 245,
> +	/* Time between PRX and ALS cycles -decrease to increase time */
> +	/* decreases in 2.7 ms intervals */
> +	.prox_config = 0,
> +	/* Prox configuration filters */
> +	.als_gain_trim = 1000,
> +	/* default gain trim to account for aperture effects */
> +	.als_cal_target = 150,
> +	/* Known external ALS reading used for calibration */
> +	.als_thresh_low = 200,
> +	/* CH0 'low' count to trigger interrupt */
> +	.als_thresh_high = 256,
> +	/* CH0 'high' count to trigger interrupt */
> +	.als_persistence = 0xFF,
> +	/* Number of 'out of limits' ADC readings PRX/ALS*/
> +	.interrupts_en = 0x00,
> +	/* Default interrupt(s) enabled.
> +	 * 0x00 = none, 0x10 = als, 0x20 = prx 0x30 = bth */
> +	.prox_thres_low  = 0,
> +	.prox_thres_high = 512,
> +	/*default threshold (adjust either manually or with cal routine*/
> +	.prox_max_samples_cal = 30,
> +	.prox_pulse_count = 8
> +};
> +
> +static const s16 tsl2X7X_als_gainadj[] = {
> +	1,
> +	8,
> +	16,
> +	120
> +};
> +
> +static const s16 tsl2X7X_prx_gainadj[] = {
> +	1,
> +	2,
> +	4,
> +	8
> +};
> +
> +/* Channel variations */
> +enum {
> +	ALS,
> +	PRX,
> +	ALSPRX,
> +	PRX2,
> +	ALSPRX2,
> +};
> +
> +const u8 device_channel_config[] = {
> +	ALS,
> +	PRX,
> +	PRX,
> +	ALSPRX,
> +	ALSPRX,
> +	ALS,
> +	PRX2,
> +	PRX2,
> +	ALSPRX2,
> +	ALSPRX2
> +};
> +
> +/*
> + * Read a number of bytes starting at register (reg) location.
> + * Return 0, or i2c_smbus_write_byte ERROR code.
> + */
> +static int
> +tsl2x7x_i2c_read(struct i2c_client *client, u8 reg, u8 *val)
> +{
> +	int ret;
> +
> +	/* select register to write */
> +	ret = i2c_smbus_write_byte(client, (TSL2X7X_CMD_REG | reg));
> +	if (ret<  0) {
> +		dev_err(&client->dev, "tsl2x7x_i2c_read failed to write"
> +			" register %x\n", reg);
> +		return ret;
> +	}
> +	/* read the data */
> +	*val = i2c_smbus_read_byte(client);
> +
> +	return 0;
> +}
> +
> +/*
> + * Reads and calculates current lux value.
> + * The raw ch0 and ch1 values of the ambient light sensed in the last
> + * integration cycle are read from the device.
> + * Time scale factor array values are adjusted based on the integration time.
> + * The raw values are multiplied by a scale factor, and device gain is obtained
> + * using gain index. Limit checks are done next, then the ratio of a multiple
> + * of ch1 value, to the ch0 value, is calculated. The array tsl2x7x_device_lux[]
> + * declared above is then scanned to find the first ratio value that is just
> + * above the ratio we just calculated. The ch0 and ch1 multiplier constants in
> + * the array are then used along with the time scale factor array values, to
> + * calculate the lux.
> + */
> +static int tsl2x7x_get_lux(struct iio_dev *indio_dev)
> +{
> +	u16 ch0, ch1; /* separated ch0/ch1 data from device */
> +	u32 lux; /* raw lux calculated from device data */
> +	u64 lux64;
> +	u32 ratio;
> +	u8 buf[4];
> +	struct tsl2x7x_lux *p;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	int i, ret;
> +	u32 ch0lux = 0;
> +	u32 ch1lux = 0;
> +
> +	if (mutex_trylock(&chip->als_mutex) == 0) {
> +		dev_info(&chip->client->dev, "tsl2x7x_get_lux device is busy\n");
> +		return chip->als_cur_info.lux; /* busy, so return LAST VALUE */
> +	}
> +
> +	if (chip->tsl2x7x_chip_status != TSL2X7X_CHIP_WORKING) {
> +		/* device is not enabled */
> +		dev_err(&chip->client->dev, "tsl2x7x_get_lux device is not enabled\n");
> +		ret = -EBUSY ;
> +		goto out_unlock;
> +	}
> +
> +	ret = tsl2x7x_i2c_read(chip->client,
> +		(TSL2X7X_CMD_REG | TSL2X7X_STATUS),&buf[0]);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_get_lux failed to read CMD_REG\n");
> +		goto out_unlock;
> +	}
> +	/* is data new&  valid */
> +	if (!(buf[0]&  TSL2X7X_STA_ADC_VALID)) {
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_get_lux data not valid yet\n");
> +		ret = chip->als_cur_info.lux; /* return LAST VALUE */
> +		goto out_unlock;
> +	}
> +
> +	for (i = 0; i<  4; i++) {
> +		ret = tsl2x7x_i2c_read(chip->client,
> +			(TSL2X7X_CMD_REG | (TSL2X7X_ALS_CHAN0LO + i)),
> +			&buf[i]);
> +		if (ret<  0) {
> +			dev_err(&chip->client->dev,
> +				"tsl2x7x_get_lux failed to read"
> +				" ret: %x\n", ret);
> +			goto out_unlock;
> +		}
> +	}
> +
> +	/* clear status, really interrupt status ( are off),
> +	but we use the bit anyway */
> +	ret = i2c_smbus_write_byte(chip->client,
> +		(TSL2X7X_CMD_REG |
> +				TSL2X7X_CMD_SPL_FN |
> +				TSL2X7X_CMD_ALS_INT_CLR));
> +
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_i2c_write_command failed in tsl2x7x_get_lux, err = %d\n",
> +			ret);
> +		goto out_unlock; /* have no data, so return failure */
> +	}
> +
> +	/* extract ALS/lux data */
> +	ch0 = le16_to_cpup((const __le16 *)&buf[0]);
> +	ch1 = le16_to_cpup((const __le16 *)&buf[2]);
> +
> +	chip->als_cur_info.als_ch0 = ch0;
> +	chip->als_cur_info.als_ch1 = ch1;
> +
> +	if ((ch0>= chip->als_saturation) || (ch1>= chip->als_saturation))
> +		goto return_max;
> +
> +	if (ch0 == 0) {
> +		/* have no data, so return LAST VALUE */
> +		ret = chip->als_cur_info.lux = 0;
> +		goto out_unlock;
> +	}
> +	/* calculate ratio */
> +	ratio = (ch1<<  15) / ch0;
> +	/* convert to unscaled lux using the pointer to the table */
> +	p = (struct tsl2x7x_lux *) chip->tsl2x7x_device_lux;
> +	while (p->ratio != 0&&  p->ratio<  ratio)
> +			p++;
> +
> +	if (p->ratio == 0) {
> +		lux = 0;
> +	} else {
> +		ch0lux = ((ch0 * p->ch0) +
> +		(tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain]>>  1))
> +		/ tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain];
> +
> +		ch1lux = ((ch1 * p->ch1) +
> +		(tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain]>>  1))
> +		/ tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain];
> +
> +		lux = ch0lux - ch1lux;
> +	}
> +
> +	/* note: lux is 31 bit max at this point */
> +	if (ch1lux>  ch0lux) {
> +		dev_dbg(&chip->client->dev, "No Data - Return last value\n");
> +		ret = chip->als_cur_info.lux = 0;
> +		goto out_unlock;
> +	}
> +
> +	/* adjust for active time scale */
> +	if (chip->als_time_scale == 0)
> +		lux = 0;
> +	else
> +		lux = (lux + (chip->als_time_scale>>  1)) /
> +			chip->als_time_scale;
> +
> +	/* adjust for active gain scale
> +	 * The tsl2x7x_device_lux tables have a factor of 256 built-in.
> +	 * User-specified gain provides a multiplier.
> +	 * Apply user-specified gain before shifting right to retain precision.
> +	 * Use 64 bits to avoid overflow on multiplication.
> +	 * Then go back to 32 bits before division to avoid using div_u64().
> +	 */
> +	lux64 = lux;
> +	lux64 = lux64 * chip->tsl2x7x_settings.als_gain_trim;
> +	lux64>>= 8;
> +	lux = lux64;
> +	lux = (lux + 500) / 1000;
> +
> +	if (lux>  TSL2X7X_LUX_CALC_OVER_FLOW) { /* check for overflow */
> +return_max:
uggly. Would prefer no branches into an if statement.
> +		lux = TSL2X7X_LUX_CALC_OVER_FLOW;
> +	}
> +
> +	/* Update the structure with the latest VALID lux. */
> +	chip->als_cur_info.lux = lux;
> +	ret = lux;
> +
> +out_unlock:
> +	mutex_unlock(&chip->als_mutex);
> +
> +	return ret;
> +}
> +
> +/*
> + * Proximity poll function - if valid data is available, read and form the ch0
> + * and prox data values, check for limits on the ch0 value, and check the prox
> + * data against the current thresholds, to set the event status accordingly.
> + */
> +static int tsl2x7x_prox_poll(struct iio_dev *indio_dev)
> +{
> +#define CONSECUTIVE_RETRIES 50
> +
> +	int i;
> +	int ret;
> +	u8 status;
> +	u8 chdata[2];
> +	int err_cnt;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	if (mutex_trylock(&chip->prox_mutex) == 0) {
> +		dev_err(&chip->client->dev, "Can't get prox mutex\n");
> +		return -EBUSY;
> +	}
> +
> +	err_cnt = 0;
> +
> +try_again:
> +	ret = tsl2x7x_i2c_read(chip->client,
> +		(TSL2X7X_CMD_REG | TSL2X7X_STATUS),&status);
> +	if (ret<  0)
> +		goto prox_poll_err;
> +
> +	/*Prox interrupt asserted*/
one big if is cleaner and would mean the brackets were right!
if ((chip->id > tsl2572) && ((chip->tsl2x7x_settings.interrupts_en << 4) 
+ & TSL2X7X_CNTL_PROX_INT_ENBL) && !(status & TSL2X7X_STA_ADC_VALID))
> +	if (chip->id<  tsl2572) {
> +		if (((chip->tsl2x7x_settings.interrupts_en<<  4)
> +				&  TSL2X7X_CNTL_PROX_INT_ENBL)) {
> +			if (!(status&  TSL2X7X_STA_ADC_VALID)) {
> +				err_cnt++;
> +				if (err_cnt>  CONSECUTIVE_RETRIES) {
> +					dev_err(&chip->client->dev,
> +					"Consec. retries exceeded\n");
> +					goto prox_poll_err;
> +				}
> +				goto try_again;
> +			}
> +		}
> +	}
> +
> +	for (i = 0; i<  2; i++) {
> +		ret = tsl2x7x_i2c_read(chip->client,
> +			(TSL2X7X_CMD_REG |
> +					(TSL2X7X_PRX_LO + i)),&chdata[i]);
> +		if (ret<  0)
> +			goto prox_poll_err;
> +	}
> +
> +	chip->prox_cur_info.prox_data = (chdata[1]<<8)|chdata[0];
> +
> +	if (chip->prox_cur_info.prox_data>=
> +			chip->tsl2x7x_settings.prox_thres_high)
> +		chip->prox_cur_info.prox_event = 1;
> +	else
> +		chip->prox_cur_info.prox_event = 0;
> +
> +	mutex_unlock(&chip->prox_mutex);
> +	return chip->prox_cur_info.prox_event;
> +
> +prox_poll_err:
> +	mutex_unlock(&chip->prox_mutex);
> +
> +	return ret;
> +}
> +
> +/*
> + * Provides initial operational parameter defaults.
> + * These defaults may be changed through the device's sysfs files.
> + */
> +static void tsl2x7x_defaults(struct tsl2X7X_chip *chip)
> +{
> +	/* If Operational settings defined elsewhere.. */
> +	if (chip->pdata&&  chip->pdata->platform_default_settings != 0)
> +		memcpy(&(chip->tsl2x7x_settings),
> +			chip->pdata->platform_default_settings,
> +			sizeof(tsl2x7x_default_settings));
> +	else
> +		memcpy(&(chip->tsl2x7x_settings),
> +			&tsl2x7x_default_settings,
> +			sizeof(tsl2x7x_default_settings));
> +
> +	/* Load up the proper lux table. */
> +	if (chip->pdata&&  chip->pdata->platform_lux_table[0].ratio != 0)
> +		memcpy(chip->tsl2x7x_device_lux,
> +			chip->pdata->platform_lux_table,
> +			sizeof(chip->pdata->platform_lux_table));
> +	else
> +		memcpy(chip->tsl2x7x_device_lux,
> +		(struct tsl2x7x_lux *)tsl2x7x_default_lux_table_group[chip->id],
> +				MAX_DEFAULT_TABLE_BYTES);
> +
> +}
> +
> +/*
> + * Obtain single reading and calculate the als_gain_trim
> + * (later used to derive actual lux).
> + * Return updated gain_trim value.
> + */
> +static int tsl2x7x_als_calibrate(struct iio_dev *indio_dev)
> +{
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	u8 reg_val;
> +	int gain_trim_val;
> +	int ret;
> +	int lux_val;
> +
> +	ret = i2c_smbus_write_byte(chip->client,
> +			(TSL2X7X_CMD_REG | TSL2X7X_CNTRL));
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_als_calibrate failed to write CNTRL register, ret=%d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	reg_val = i2c_smbus_read_byte(chip->client);
> +	if ((reg_val&  (TSL2X7X_CNTL_ADC_ENBL | TSL2X7X_CNTL_PWR_ON))
> +			!= (TSL2X7X_CNTL_ADC_ENBL | TSL2X7X_CNTL_PWR_ON)) {
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_als_calibrate failed: ADC not enabled\n");
> +		return -1;
> +	}
> +
> +	ret = i2c_smbus_write_byte(chip->client,
> +			(TSL2X7X_CMD_REG | TSL2X7X_CNTRL));
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_als_calibrate failed to write ctrl reg: ret=%d\n",
> +			ret);
> +		return ret;
> +	}
> +	reg_val = i2c_smbus_read_byte(chip->client);
> +
> +	if ((reg_val&  TSL2X7X_STA_ADC_VALID) != TSL2X7X_STA_ADC_VALID) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_als_calibrate failed: STATUS - ADC not valid.\n");
> +		return -ENODATA;
> +	}
spacing a little random in here and could do with tidying up. (blank lines)
> +	lux_val = tsl2x7x_get_lux(indio_dev);
> +	if (lux_val<  0) {
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_als_calibrate failed to get lux\n");
> +		return lux_val;
> +	}
> +	gain_trim_val =  (((chip->tsl2x7x_settings.als_cal_target)
> +			* chip->tsl2x7x_settings.als_gain_trim) / lux_val);
> +
> +	if ((gain_trim_val<  250) || (gain_trim_val>  4000))
> +		return -ERANGE;
> +
> +	chip->tsl2x7x_settings.als_gain_trim = gain_trim_val;
> +
> +	dev_info(&chip->client->dev,
> +			"%s als_calibrate completed\n", chip->client->name);
> +
> +	return (int) gain_trim_val;
> +}
> +
> +/*
> + * Turn the device on.
> + * Configuration must be set before calling this function.
> + */
> +static int tsl2x7x_chip_on(struct iio_dev *indio_dev)
> +{
> +	int i;
> +	int ret = 0;
> +	u8 *dev_reg;
> +	u8 utmp;
> +	int als_count;
> +	int als_time;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	u8 reg_val = 0;
> +
> +	if (chip->pdata&&  chip->pdata->power_on)
> +		chip->pdata->power_on(indio_dev);
> +
> +	/* Non calculated parameters */
> +	chip->tsl2x7x_config[TSL2X7X_PRX_TIME] =
> +			chip->tsl2x7x_settings.prx_time;
> +	chip->tsl2x7x_config[TSL2X7X_WAIT_TIME] =
> +			chip->tsl2x7x_settings.wait_time;
> +	chip->tsl2x7x_config[TSL2X7X_PRX_CONFIG] =
> +			chip->tsl2x7x_settings.prox_config;
> +
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MINTHRESHLO] =
> +		(chip->tsl2x7x_settings.als_thresh_low)&  0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MINTHRESHHI] =
> +		(chip->tsl2x7x_settings.als_thresh_low>>  8)&  0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MAXTHRESHLO] =
> +		(chip->tsl2x7x_settings.als_thresh_high)&  0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MAXTHRESHHI] =
> +		(chip->tsl2x7x_settings.als_thresh_high>>  8)&  0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_PERSISTENCE] =
> +		chip->tsl2x7x_settings.als_persistence;
> +
> +	chip->tsl2x7x_config[TSL2X7X_PRX_COUNT] =
> +			chip->tsl2x7x_settings.prox_pulse_count;
> +	chip->tsl2x7x_config[TSL2X7X_PRX_MINTHRESHLO] =
> +	chip->tsl2x7x_settings.prox_thres_low;
> +	chip->tsl2x7x_config[TSL2X7X_PRX_MAXTHRESHLO] =
> +			chip->tsl2x7x_settings.prox_thres_high;
> +
> +	/* and make sure we're not already on */
> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING) {
> +		/* if forcing a register update - turn off, then on */
> +		dev_info(&chip->client->dev, "device is already enabled\n");
> +		return -EINVAL;
> +	}
> +
> +	/* determine als integration regster */
> +	als_count = (chip->tsl2x7x_settings.als_time * 100 + 135) / 270;
> +	if (als_count == 0)
> +		als_count = 1; /* ensure at least one cycle */
> +
> +	/* convert back to time (encompasses overrides) */
> +	als_time = (als_count * 27 + 5) / 10;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_TIME] = 256 - als_count;
> +
> +	/* Set the gain based on tsl2x7x_settings struct */
> +	chip->tsl2x7x_config[TSL2X7X_GAIN] =
> +		(chip->tsl2x7x_settings.als_gain |
> +			(TSL2X7X_mA100 | TSL2X7X_DIODE1)
> +			| ((chip->tsl2x7x_settings.prox_gain)<<  2));
> +
> +	/* set chip struct re scaling and saturation */
> +	chip->als_saturation = als_count * 922; /* 90% of full scale */
> +	chip->als_time_scale = (als_time + 25) / 50;
> +
> +	/* TSL2X7X Specific power-on / adc enable sequence
> +	 * Power on the device 1st. */
> +	utmp = TSL2X7X_CNTL_PWR_ON;
> +	ret = i2c_smbus_write_byte_data(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_CNTRL, utmp);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev, "tsl2x7x_chip_on failed on CNTRL reg.\n");
> +		return -1;
> +	}
> +
> +	/* Use the following shadow copy for our delay before enabling ADC.
> +	 * Write all the registers. */
> +	for (i = 0, dev_reg = chip->tsl2x7x_config; i<  TSL2X7X_REG_MAX; i++) {
> +		ret = i2c_smbus_write_byte_data(chip->client,
> +				TSL2X7X_CMD_REG + i, *dev_reg++);
> +		if (ret<  0) {
> +			dev_err(&chip->client->dev,
> +			"tsl2x7x_chip_on failed on write to reg %d.\n", i);
> +			return ret;
> +		}
> +	}
> +
> +	udelay(3000);	/* Power-on settling time */
> +
> +	/* NOW enable the ADC
> +	 * initialize the desired mode of operation */
> +	utmp = TSL2X7X_CNTL_PWR_ON |
> +			TSL2X7X_CNTL_ADC_ENBL |
> +			TSL2X7X_CNTL_PROX_DET_ENBL;
> +	ret = i2c_smbus_write_byte_data(chip->client,
> +			TSL2X7X_CMD_REG | TSL2X7X_CNTRL, utmp);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev, "tsl2x7x_chip_on failed on 2nd CTRL reg.\n");
> +		return ret;
> +		}
> +
> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_WORKING;
> +
> +	if (chip->tsl2x7x_settings.interrupts_en != 0) {
> +		dev_info(&chip->client->dev, "Setting Up Interrupt(s)\n");
> +		/* first time interrupt */
> +		chip->init_done = 0;
> +
> +
> +	reg_val = TSL2X7X_CNTL_PWR_ON;
> +
> +	if (chip->tsl2x7x_settings.interrupts_en == 0x10)
> +		reg_val |= TSL2X7X_CNTL_ADC_ENBL;
> +
> +	if (chip->tsl2x7x_settings.interrupts_en == 0x20)
> +		reg_val |= TSL2X7X_CNTL_PROX_DET_ENBL;
> +
> +	if (chip->tsl2x7x_settings.interrupts_en == 0x30)
> +		reg_val |= (TSL2X7X_CNTL_ADC_ENBL | TSL2X7X_CNTL_PROX_DET_ENBL);
> +
> +	reg_val |= chip->tsl2x7x_settings.interrupts_en;
> +
> +	ret = i2c_smbus_write_byte_data(chip->client,
> +		(TSL2X7X_CMD_REG | TSL2X7X_CNTRL), reg_val);
> +	if (ret<  0)
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_i2c_write to device failed in tsl2x7x_IOCTL_INT_SET.\n");
> +
> +	/* Clear out any initial interrupts  */
> +	ret = i2c_smbus_write_byte(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_CMD_SPL_FN |
> +		TSL2X7X_CMD_PROXALS_INTCLR);
> +	if (ret<  0) {
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_i2c_write_command failed in tsl2x7x_chip_on\n");
> +		return ret;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int tsl2x7x_chip_off(struct iio_dev *indio_dev)
> +{
> +	int ret;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	/* turn device off */
> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_SUSPENDED;
> +
> +	ret = i2c_smbus_write_byte_data(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_CNTRL, 0x00);
> +
> +	if (chip->pdata&&  chip->pdata->power_off)
> +		chip->pdata->power_off(chip->client);
> +
> +	return ret;
> +}
> +
I'm still not all that keen on having this in kernel. It really really 
smacks of
the sort of complexity that belongs in userspace...  Ah well, I'll keep 
moaning
and let it go anyway (for now!)
> +/**
> + * Integer Square Root
> + * We need an integer version since 1st Floating point is not allowed
> + * in driver world, 2nd, cannot count on the devices having a FPU, and
> + * 3rd software FP emulation may be excessive.
> + */
> +static unsigned long tsl2x7x_isqrt(unsigned long x)
> +{
> +	register unsigned long op, res, one;
> +	op = x;
> +	res = 0;
> +
> +	one = 1<<  30;
> +	while (one>  op)
> +		one>>= 2;
> +
> +	while (one != 0) {
> +		if (op>= res + one) {
> +			op -= res + one;
> +			res += one<<  1;
> +		}
> +		res>>= 1;
> +		one>>= 2;
> +	}
> +
> +	return res;
> +}
> +
> +/*
> + * Proximity calibration helper function
> + * runs through a collection of data samples,
> + * sets the min, max, mean, and std dev.
> + */
> +static
> +void tsl2x7x_prox_calculate(u16 *data, int length, struct prox_stat *statP)
> +{
> +	int i;
> +	int min, max, sum, mean;
> +	unsigned long stddev;
> +	int tmp;
> +
> +	if (length == 0)
> +		length = 1;
> +
> +	sum = 0;
> +	min = 0xffff;
> +	max = 0;
> +	for (i = 0; i<  length; i++) {
> +		sum += data[i];
> +		if (data[i]<  min)
> +			min = data[i];
> +		if (data[i]>  max)
> +			max = data[i];
> +	}
> +	mean = sum/length;
> +	statP->min = min;
> +	statP->max = max;
> +	statP->mean = mean;
> +
> +	sum = 0;
> +	for (i = 0; i<  length; i++) {
> +		tmp = data[i]-mean;
> +		sum += tmp * tmp;
> +	}
> +	stddev = tsl2x7x_isqrt((long)sum)/length;
> +	statP->stddev = stddev;
> +
> +}
> +
> +/**
> + * Proximity calibration - collects a number of samples,
> + * calculates a standard deviation based on the samples, and
> + * sets the threshold accordingly.
> + */
> +static void tsl2x7x_prox_cal(struct iio_dev *indio_dev)
> +{
> +	u16 prox_history[MAX_SAMPLES_CAL+1];
> +	int i;
> +	struct prox_stat prox_stat_data[2];
> +	struct prox_stat *calP;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	u8 tmp_irq_settings;
> +	u8 current_state = chip->tsl2x7x_chip_status;
> +
> +	if (chip->tsl2x7x_settings.prox_max_samples_cal>  MAX_SAMPLES_CAL) {
> +		dev_err(&chip->client->dev,
> +			"max prox samples cal is too big: %d\n",
> +			chip->tsl2x7x_settings.prox_max_samples_cal);
> +		chip->tsl2x7x_settings.prox_max_samples_cal = MAX_SAMPLES_CAL;
> +	}
> +
> +	/* have to stop to change settings */
> +	tsl2x7x_chip_off(indio_dev);
> +
> +	/* Enable proximity detection save just in case prox not wanted yet*/
> +	tmp_irq_settings = chip->tsl2x7x_settings.interrupts_en;
> +	chip->tsl2x7x_settings.interrupts_en |= TSL2X7X_CNTL_PROX_INT_ENBL;
> +
> +	/*turn on device if not already on*/
> +	tsl2x7x_chip_on(indio_dev);
> +
> +	/*gather the samples*/
> +	for (i = 0; i<  chip->tsl2x7x_settings.prox_max_samples_cal; i++) {
> +		mdelay(15);
> +		tsl2x7x_prox_poll(indio_dev);
> +		prox_history[i] = chip->prox_cur_info.prox_data;
> +		dev_info(&chip->client->dev, "2 i=%d prox data= %d\n",
> +			i, chip->prox_cur_info.prox_data);
> +
> +	}
> +
> +	tsl2x7x_chip_off(indio_dev);
> +
> +	calP =&prox_stat_data[PROX_STAT_CAL];
> +	tsl2x7x_prox_calculate(prox_history,
> +		chip->tsl2x7x_settings.prox_max_samples_cal, calP);
> +	chip->tsl2x7x_settings.prox_thres_high = (calP->max<<  1) - calP->mean;
> +
> +	dev_info(&chip->client->dev, " cal min=%d mean=%d max=%d\n",
> +		calP->min, calP->mean, calP->max);
> +	dev_info(&chip->client->dev,
> +		"%s proximity threshold set to %d\n",
> +		chip->client->name, chip->tsl2x7x_settings.prox_thres_high);
> +
> +	/* back to the way they were */
> +	chip->tsl2x7x_settings.interrupts_en = tmp_irq_settings;
> +	if (current_state == TSL2X7X_CHIP_WORKING)
> +		tsl2x7x_chip_on(indio_dev);
> +}
> +
> +static ssize_t tsl2x7x_power_state_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n", chip->tsl2x7x_chip_status);
> +}
> +
> +static ssize_t tsl2x7x_power_state_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	bool value;
> +
> +	if (strtobool(buf,&value))
> +		return -EINVAL;
> +
> +	if (!value)
> +		tsl2x7x_chip_off(indio_dev);
> +	else
> +		tsl2x7x_chip_on(indio_dev);
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_gain_available_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	if (chip->id>  tsl2771)
> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 8 16 128");
> +	else
> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 8 16 120");
> +}
> +
> +static ssize_t tsl2x7x_prox_gain_available_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +		return snprintf(buf, PAGE_SIZE, "%s\n", "1 2 4 8");
> +}
> +
> +static ssize_t tsl2x7x_als_time_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.als_time);
> +}
> +
> +static ssize_t tsl2x7x_als_time_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	if ((value<  50) || (value>  650))
> +		return -EINVAL;
> +
> +	if (value % 50)
> +		return -EINVAL;
> +
> +	 chip->tsl2x7x_settings.als_time = value;
> +
> +	return len;
> +}
> +
> +static IIO_CONST_ATTR(illuminance0_integration_time_available,
> +		"50 100 150 200 250 300 350 400 450 500 550 600 650");
> +
> +static ssize_t tsl2x7x_als_cal_target_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.als_cal_target);
> +}
> +
> +static ssize_t tsl2x7x_als_cal_target_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	if (value)
> +		chip->tsl2x7x_settings.als_cal_target = value;
> +
> +	return len;
> +}
> +
> +/* sampling_frequency AKA persistence in data sheet */
> +static ssize_t tsl2x7x_als_persistence_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			chip->tsl2x7x_settings.als_persistence);
> +}
Not really the same as sampling frequency.  Could have sworn we had an 
api for
this at some point....
> +
> +static ssize_t tsl2x7x_als_persistence_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	unsigned long value;
> +
> +	if (kstrtoul(buf, 0,&value))
> +		return -EINVAL;
> +
> +	chip->tsl2x7x_settings.als_persistence = value;
> +
> +	return len;
> +}
> +
> +static IIO_CONST_ATTR(sampling_frequency_available,
> +		"0x00 - 0xFF (0 - 255)");
In hz? (should be but seems a little unlikely).
> +
> +static ssize_t tsl2x7x_do_calibrate(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	bool value;
> +
> +	if (strtobool(buf,&value))
> +		return -EINVAL;
> +
> +	if (value)
> +		tsl2x7x_als_calibrate(indio_dev);
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_luxtable_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	int i;
> +	int offset = 0;
> +
> +	i = 0;
> +	while (i<  (MAX_TABLE_SIZE * 3)) {
> +		offset += snprintf(buf + offset, PAGE_SIZE, "%d,%d,%d,",
> +			chip->tsl2x7x_device_lux[i].ratio,
> +			chip->tsl2x7x_device_lux[i].ch0,
> +			chip->tsl2x7x_device_lux[i].ch1);
> +		if (chip->tsl2x7x_device_lux[i].ratio == 0) {
> +			/* We just printed the first "0" entry.
> +			 * Now get rid of the extra "," and break. */
> +			offset--;
> +			break;
> +		}
> +		i++;
> +	}
> +
> +	offset += snprintf(buf + offset, PAGE_SIZE, "\n");
> +	return offset;
> +}
> +
> +static ssize_t tsl2x7x_luxtable_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	int value[ARRAY_SIZE(chip->tsl2x7x_device_lux)*3 + 1];
> +	int n;
> +
> +	get_options(buf, ARRAY_SIZE(value), value);
> +
> +	/* We now have an array of ints starting at value[1], and
> +	 * enumerated by value[0].
> +	 * We expect each group of three ints is one table entry,
> +	 * and the last table entry is all 0.
> +	 */
> +	n = value[0];
> +	if ((n % 3) || n<  6 ||
> +			n>  ((ARRAY_SIZE(chip->tsl2x7x_device_lux) - 1) * 3)) {
> +		dev_info(dev, "LUX TABLE INPUT ERROR 1 Value[0]=%d\n", n);
> +		return -EINVAL;
> +	}
> +
> +	if ((value[(n - 2)] | value[(n - 1)] | value[n]) != 0) {
> +		dev_info(dev, "LUX TABLE INPUT ERROR 2 Value[0]=%d\n", n);
> +		return -EINVAL;
> +	}
> +
> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING)
> +		tsl2x7x_chip_off(indio_dev);
> +
> +	/* Zero out the table */
> +	memset(chip->tsl2x7x_device_lux, 0, sizeof(chip->tsl2x7x_device_lux));
> +	memcpy(chip->tsl2x7x_device_lux,&value[1], (value[0] * 4));
> +
> +	return len;
> +}
> +
> +static ssize_t tsl2x7x_do_prox_calibrate(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	bool value;
> +
> +	if (strtobool(buf,&value))
> +		return -EINVAL;
> +
> +	if (value)
> +		tsl2x7x_prox_cal(indio_dev);
> +
> +	return len;
> +}
> +
> +static int tsl2x7x_read_interrupt_config(struct iio_dev *indio_dev,
> +					 u64 event_code)
> +{
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	int ret;
> +
> +	if (IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event_code) == IIO_LIGHT)
> +		ret = !!(chip->tsl2x7x_settings.interrupts_en&  0x10);
> +	else
> +		ret = !!(chip->tsl2x7x_settings.interrupts_en&  0x20);
> +
> +	return ret;
> +}
> +
> +static int tsl2x7x_write_interrupt_config(struct iio_dev *indio_dev,
> +					  u64 event_code,
> +					  int val)
> +{
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	if (IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event_code) == IIO_LIGHT) {
> +		if (val)
> +			chip->tsl2x7x_settings.interrupts_en |= 0x10;
> +		else
> +			chip->tsl2x7x_settings.interrupts_en&= 0x20;
> +	} else {
> +		if (val)
> +			chip->tsl2x7x_settings.interrupts_en |= 0x20;
> +		else
> +			chip->tsl2x7x_settings.interrupts_en&= 0x10;
> +	}
> +
> +	return 0;
> +}
> +
> +static int tsl2x7x_write_thresh(struct iio_dev *indio_dev,
> +				  u64 event_code,
> +				  int val)
> +{
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	if (IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event_code) == IIO_LIGHT) {
> +		switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
> +		case IIO_EV_DIR_RISING:
> +			chip->tsl2x7x_settings.als_thresh_high = val;
> +			break;
> +		case IIO_EV_DIR_FALLING:
> +			chip->tsl2x7x_settings.als_thresh_low = val;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	} else {
> +		switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
> +		case IIO_EV_DIR_RISING:
> +			chip->tsl2x7x_settings.prox_thres_high = val;
> +			break;
> +		case IIO_EV_DIR_FALLING:
> +			chip->tsl2x7x_settings.prox_thres_low = val;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +	}
> +
> +	return 0;
> +}
> +
> +static int tsl2x7x_read_thresh(struct iio_dev *indio_dev,
> +			       u64 event_code,
> +			       int *val)
> +{
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	if (IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(event_code) == IIO_LIGHT) {
> +		switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
> +		case IIO_EV_DIR_RISING:
> +			*val = chip->tsl2x7x_settings.als_thresh_high;
> +			break;
> +		case IIO_EV_DIR_FALLING:
> +			*val = chip->tsl2x7x_settings.als_thresh_low;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +	} else {
> +		switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
> +		case IIO_EV_DIR_RISING:
> +			*val = chip->tsl2x7x_settings.prox_thres_high;
> +			break;
> +		case IIO_EV_DIR_FALLING:
> +			*val = chip->tsl2x7x_settings.prox_thres_low;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +	}
> +
> +	return 0;
> +}
> +
> +static int tsl2x7x_read_raw(struct iio_dev *indio_dev,
> +			    struct iio_chan_spec const *chan,
> +			    int *val,
> +			    int *val2,
> +			    long mask)
> +{
> +	int ret = -EINVAL;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	switch (mask) {
> +	case 0:
> +		switch (chan->type) {
> +		case IIO_LIGHT:
> +			tsl2x7x_get_lux(indio_dev);
> +			if (chan->processed_val)
> +				*val = chip->als_cur_info.lux;
> +			else
> +				*val = (((chip->als_cur_info.als_ch0<<  16) |
> +					chip->als_cur_info.als_ch1));
> +			ret = IIO_VAL_INT;
> +			break;
> +		case IIO_PROXIMITY:
> +			tsl2x7x_prox_poll(indio_dev);
> +			if (chan->processed_val)
> +				*val = chip->prox_cur_info.prox_event;
> +			else
> +				*val = chip->prox_cur_info.prox_data;
> +			ret = IIO_VAL_INT;
> +			break;
> +		default:
> +			return -EINVAL;
> +			break;
> +		}
> +		break;
> +	case IIO_CHAN_INFO_CALIBSCALE:
> +		if (chan->type == IIO_LIGHT) {
> +			*val =
> +			tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain];
> +		} else {
> +			*val =
> +			tsl2X7X_prx_gainadj[chip->tsl2x7x_settings.prox_gain];
> +		}
Brackets here aren't wanted for kernel style.
> +		ret = IIO_VAL_INT;
> +		break;
> +	case IIO_CHAN_INFO_CALIBBIAS:
> +		*val = chip->tsl2x7x_settings.als_gain_trim;
> +		ret = IIO_VAL_INT;
> +		break;
> +
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int tsl2x7x_write_raw(struct iio_dev *indio_dev,
> +			       struct iio_chan_spec const *chan,
> +			       int val,
> +			       int val2,
> +			       long mask)
> +{
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
> +	switch (mask) {
> +	case IIO_CHAN_INFO_CALIBSCALE:
> +		if (chan->type == IIO_LIGHT) {
> +			switch (val) {
> +			case 1:
> +				chip->tsl2x7x_settings.als_gain = 0;
> +				break;
> +			case 8:
> +				chip->tsl2x7x_settings.als_gain = 1;
> +				break;
> +			case 16:
> +				chip->tsl2x7x_settings.als_gain = 2;
> +				break;
> +			case 120:
> +				if (chip->id>  tsl2771)
> +					return -EINVAL;
> +				chip->tsl2x7x_settings.als_gain = 3;
> +				break;
> +			case 128:
> +				if (chip->id<  tsl2572)
> +					return -EINVAL;
> +				chip->tsl2x7x_settings.als_gain = 3;
> +				break;
> +			default:
> +				return -EINVAL;
> +			}
> +		} else {
> +			switch (val) {
> +			case 1:
> +				chip->tsl2x7x_settings.prox_gain = 0;
> +				break;
> +			case 2:
> +				chip->tsl2x7x_settings.prox_gain = 1;
> +				break;
> +			case 4:
> +				chip->tsl2x7x_settings.prox_gain = 2;
> +				break;
> +			case 8:
> +				chip->tsl2x7x_settings.prox_gain = 3;
> +				break;
use log2?
> +			default:
> +				return -EINVAL;
> +			}
> +		}
> +		break;
> +	case IIO_CHAN_INFO_CALIBBIAS:
> +		chip->tsl2x7x_settings.als_gain_trim = val;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR,
> +		tsl2x7x_power_state_show, tsl2x7x_power_state_store);
> +
> +static DEVICE_ATTR(proximity_calibscale_available, S_IRUGO,
> +		tsl2x7x_prox_gain_available_show, NULL);
> +
> +static DEVICE_ATTR(illuminance0_calibscale_available, S_IRUGO,
> +		tsl2x7x_gain_available_show, NULL);
> +
> +static DEVICE_ATTR(illuminance0_integration_time, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_time_show, tsl2x7x_als_time_store);
> +
> +static DEVICE_ATTR(illuminance0_target_input, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_cal_target_show, tsl2x7x_als_cal_target_store);
> +
> +static DEVICE_ATTR(illuminance0_calibrate, S_IWUSR, NULL,
> +		tsl2x7x_do_calibrate);
> +
> +static DEVICE_ATTR(proximity_calibrate, S_IWUSR, NULL,
> +		tsl2x7x_do_prox_calibrate);
> +
> +static DEVICE_ATTR(illuminance0_lux_table, S_IRUGO | S_IWUSR,
> +		tsl2x7x_luxtable_show, tsl2x7x_luxtable_store);
> +
> +static DEVICE_ATTR(sampling_frequency, S_IRUGO | S_IWUSR,
> +		tsl2x7x_als_persistence_show, tsl2x7x_als_persistence_store);
> +
> +/* Use the default register values to identify the Taos device */
> +static int tsl2x7x_device_id(unsigned char *id, int target)
> +{
> +	switch (target) {
> +	case tsl2571:
> +	case tsl2671:
> +	case tsl2771:
> +		return ((*id&  0xf0) == TRITON_ID);
> +	break;
> +	case tmd2671:
> +	case tmd2771:
> +		return ((*id&  0xf0) == HALIBUT_ID);
> +	break;
> +	case tsl2572:
> +	case tsl2672:
> +	case tmd2672:
> +	case tsl2772:
> +	case tmd2772:
> +		return ((*id&  0xf0) == SWORDFISH_ID);
> +	break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +/*
> + * Run-time interrupt handler - depending on whether the device is in ambient
> + * light sensing interrupt mode, this handler can queue up
> + * a thread, to handle valid interrupts.
Not immediately seeing a thread being queued?  Out of date comment?
> + */
> +static irqreturn_t tsl2x7x_event_handler(int irq, void *private)
> +{
> +	struct iio_dev *indio_dev = private;
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	s64 timestamp = iio_get_time_ns();
> +	int ret;
> +	int value;
> +
> +	value = i2c_smbus_read_byte_data(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_STATUS);
> +
> +	/* What type of interrupt do we need to process */
> +	if (value&  TSL2X7X_STA_PRX_INTR) {
> +		tsl2x7x_prox_poll(indio_dev);
> +		iio_push_event(indio_dev,
> +			       IIO_UNMOD_EVENT_CODE(IIO_PROXIMITY,
> +						    0,
> +						    IIO_EV_TYPE_THRESH,
> +						    IIO_EV_DIR_EITHER),
> +						    timestamp);
> +	}
> +
> +	if (value&  TSL2X7X_STA_ALS_INTR) {
> +		tsl2x7x_get_lux(indio_dev);
> +		iio_push_event(indio_dev,
> +		       IIO_UNMOD_EVENT_CODE(IIO_LIGHT,
> +					    0,
> +					    IIO_EV_TYPE_THRESH,
> +					    IIO_EV_DIR_EITHER),
> +					    timestamp);
> +	}
> +	/* Clear interrupt now that we have the status */
> +	ret = i2c_smbus_write_byte(chip->client,
> +		TSL2X7X_CMD_REG | TSL2X7X_CMD_SPL_FN |
> +		TSL2X7X_CMD_PROXALS_INTCLR);
> +	if (ret<  0)
> +		dev_err(&chip->client->dev,
> +		"Failed to clear irq from event handler. err = %d\n", ret);
> +
> +	return IRQ_HANDLED;
> +}
> +
Could deploy a few #define s perhaps to shorten the following, mostly 
combinations of
a couple of standard sets afterall...
maybe

#define TSL2X7X_IL_ATTRS \

	&dev_attr_illuminance0_calibscale_available.attr,\
	&dev_attr_illuminance0_integration_time.attr,\
	&iio_const_attr_illuminance0_integration_time_available.dev_attr.attr,\
	&dev_attr_illuminance0_target_input.attr,\
	&dev_attr_illuminance0_calibrate.attr,\
	&dev_attr_illuminance0_lux_table.attr,
etc

> +static struct attribute *tsl2x7x_ALS_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_illuminance0_calibscale_available.attr,
> +	&dev_attr_illuminance0_integration_time.attr,
> +	&iio_const_attr_illuminance0_integration_time_available.dev_attr.attr,
> +	&dev_attr_illuminance0_target_input.attr,
> +	&dev_attr_illuminance0_calibrate.attr,
> +	&dev_attr_illuminance0_lux_table.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
> +	NULL
> +};
> +
> +static struct attribute *tsl2x7x_PRX_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
> +	&dev_attr_proximity_calibrate.attr,
> +	NULL
> +};
> +
> +static struct attribute *tsl2x7x_ALSPRX_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_illuminance0_calibscale_available.attr,
> +	&dev_attr_illuminance0_integration_time.attr,
> +	&iio_const_attr_illuminance0_integration_time_available.dev_attr.attr,
> +	&dev_attr_illuminance0_target_input.attr,
> +	&dev_attr_illuminance0_calibrate.attr,
> +	&dev_attr_illuminance0_lux_table.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
> +	&dev_attr_proximity_calibrate.attr,
> +	NULL
> +};
> +
> +static struct attribute *tsl2x7x_PRX2_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
> +	&dev_attr_proximity_calibrate.attr,
> +	&dev_attr_proximity_calibscale_available.attr,
> +	NULL
> +};
> +
> +static struct attribute *tsl2x7x_ALSPRX2_device_attrs[] = {
> +	&dev_attr_power_state.attr,
> +	&dev_attr_illuminance0_calibscale_available.attr,
> +	&dev_attr_illuminance0_integration_time.attr,
> +	&iio_const_attr_illuminance0_integration_time_available.dev_attr.attr,
> +	&dev_attr_illuminance0_target_input.attr,
> +	&dev_attr_illuminance0_calibrate.attr,
> +	&dev_attr_illuminance0_lux_table.attr,
> +	&dev_attr_sampling_frequency.attr,
> +	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
> +	&dev_attr_proximity_calibrate.attr,
> +	&dev_attr_proximity_calibscale_available.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group tsl2X7X_device_attr_group_tbl[] = {
> +	[ALS] = {
> +		.attrs = tsl2x7x_ALS_device_attrs,
> +	},
> +	[PRX] = {
> +		.attrs = tsl2x7x_PRX_device_attrs,
> +	},
> +	[ALSPRX] = {
> +		.attrs = tsl2x7x_ALSPRX_device_attrs,
> +	},
> +	[PRX2] = {
> +		.attrs = tsl2x7x_PRX2_device_attrs,
> +	},
> +	[ALSPRX2] = {
> +		.attrs = tsl2x7x_ALSPRX2_device_attrs,
> +	},
> +};
> +
> +static const struct iio_info tsl2X7X_device_info[] = {
> +	[ALS] = {
> +		.attrs =&tsl2X7X_device_attr_group_tbl[ALS],
> +		.driver_module = THIS_MODULE,
> +		.read_raw =&tsl2x7x_read_raw,
> +		.write_raw =&tsl2x7x_write_raw,
> +		.read_event_value =&tsl2x7x_read_thresh,
> +		.write_event_value =&tsl2x7x_write_thresh,
> +		.read_event_config =&tsl2x7x_read_interrupt_config,
> +		.write_event_config =&tsl2x7x_write_interrupt_config,
> +	},
> +	[PRX] = {
> +		.attrs =&tsl2X7X_device_attr_group_tbl[PRX],
> +		.driver_module = THIS_MODULE,
> +		.read_raw =&tsl2x7x_read_raw,
> +		.write_raw =&tsl2x7x_write_raw,
> +		.read_event_value =&tsl2x7x_read_thresh,
> +		.write_event_value =&tsl2x7x_write_thresh,
> +		.read_event_config =&tsl2x7x_read_interrupt_config,
> +		.write_event_config =&tsl2x7x_write_interrupt_config,
> +	},
> +	[ALSPRX] = {
> +		.attrs =&tsl2X7X_device_attr_group_tbl[ALSPRX],
> +		.driver_module = THIS_MODULE,
> +		.read_raw =&tsl2x7x_read_raw,
> +		.write_raw =&tsl2x7x_write_raw,
> +		.read_event_value =&tsl2x7x_read_thresh,
> +		.write_event_value =&tsl2x7x_write_thresh,
> +		.read_event_config =&tsl2x7x_read_interrupt_config,
> +		.write_event_config =&tsl2x7x_write_interrupt_config,
> +	},
> +	[PRX2] = {
> +		.attrs =&tsl2X7X_device_attr_group_tbl[PRX2],
> +		.driver_module = THIS_MODULE,
> +		.read_raw =&tsl2x7x_read_raw,
> +		.write_raw =&tsl2x7x_write_raw,
> +		.read_event_value =&tsl2x7x_read_thresh,
> +		.write_event_value =&tsl2x7x_write_thresh,
> +		.read_event_config =&tsl2x7x_read_interrupt_config,
> +		.write_event_config =&tsl2x7x_write_interrupt_config,
> +	},
> +	[ALSPRX2] = {
> +		.attrs =&tsl2X7X_device_attr_group_tbl[ALSPRX2],
> +		.driver_module = THIS_MODULE,
> +		.read_raw =&tsl2x7x_read_raw,
> +		.write_raw =&tsl2x7x_write_raw,
> +		.read_event_value =&tsl2x7x_read_thresh,
> +		.write_event_value =&tsl2x7x_write_thresh,
> +		.read_event_config =&tsl2x7x_read_interrupt_config,
> +		.write_event_config =&tsl2x7x_write_interrupt_config,
> +	},
> +};
> +
> +static const struct tsl2x7x_chip_info tsl2x7x_chip_info_tbl[] = {
> +	[ALS] = {
> +	.channel = {
> +		[0] = {
> +			.type = IIO_LIGHT,
> +			.indexed = 1,
> +			.channel = 0,
> +			.processed_val = 1,
> +		},
> +		[1] = {
> +			.type = IIO_LIGHT,
> +			.indexed = 1,
> +			.channel = 0,
> +			.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT |
> +					IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT,
> +			.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_RISING) |
> +					IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_FALLING)),
> +		},
> +	},
> +	.num_channels = 2,
> +	.info =&tsl2X7X_device_info[ALS],
> +	},
> +	[PRX] = {
> +	.channel = {
> +		[0] = {
> +			.type = IIO_PROXIMITY,
> +			.indexed = 1,
> +			.channel = 0,
> +			.processed_val = 1,
I'd normally expect an _input attribute to give a value in a suitable SI 
unit. I'm guessing these
aren't?
> +		},
> +		[1] = {
> +			.type = IIO_PROXIMITY,
> +			.indexed = 1,
> +			.channel = 0,
> +			.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_RISING) |
> +					IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_FALLING)),
> +		},
> +	},
> +	.num_channels = 2,
> +	.info =&tsl2X7X_device_info[PRX],
> +	},
> +	[ALSPRX] = {
> +	.channel = {
> +		[0] = {
> +			.type = IIO_LIGHT,
> +			.indexed = 1,
> +			.channel = 0,
> +			.processed_val = 1,
> +		},
> +		[1] = {
> +			.type = IIO_LIGHT,
> +			.indexed = 1,
> +			.channel = 0,
> +			.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT |
> +			IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT,
> +			.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_RISING) |
> +					IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_FALLING)),
> +		},
> +		[2] = {
> +			.type = IIO_PROXIMITY,
> +			.indexed = 1,
> +			.channel = 0,
> +			.processed_val = 1,
> +		},
> +		[3] = {
> +			.type = IIO_PROXIMITY,
> +			.indexed = 1,
> +			.channel = 0,
These event_mask settings would benefit from a #define given they are 
all the same!
> +			.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_RISING) |
> +					IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_FALLING)),
> +		},
> +	},
> +	.num_channels = 4,
> +	.info =&tsl2X7X_device_info[ALSPRX],
> +	},
> +	[PRX2] = {
would I think expect .channel to be indented one more tab?
> +	.channel = {
> +		[0] = {
> +			.type = IIO_PROXIMITY,
> +			.indexed = 1,
> +			.channel = 0,
> +			.processed_val = 1,
> +		},
> +		[1] = {
> +			.type = IIO_PROXIMITY,
> +			.indexed = 1,
> +			.channel = 0,
> +			.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
> +			.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_RISING) |
> +					IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_FALLING)),
> +		},
> +	},
> +	.num_channels = 2,
> +	.info =&tsl2X7X_device_info[PRX2],
> +	},
> +	[ALSPRX2] = {
> +	.channel = {
> +			[0] = {
> +			.type = IIO_LIGHT,
> +			.indexed = 1,
> +			.channel = 0,
> +			.processed_val = 1,
> +		},
> +		[1] = {
> +			.type = IIO_LIGHT,
> +			.indexed = 1,
> +			.channel = 0,
> +			.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT |
> +				IIO_CHAN_INFO_CALIBBIAS_SEPARATE_BIT,
> +			.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_RISING) |
> +					IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_FALLING)),
> +		},
> +		[2] = {
> +			.type = IIO_PROXIMITY,
> +			.indexed = 1,
> +			.channel = 0,
> +			.processed_val = 1,
> +		},
> +		[3] = {
> +			.type = IIO_PROXIMITY,
> +			.indexed = 1,
> +			.channel = 0,
> +			.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
> +			.event_mask = (IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_RISING) |
> +					IIO_EV_BIT(IIO_EV_TYPE_THRESH,
> +					IIO_EV_DIR_FALLING)),
> +		},
> +	},
> +	.num_channels = 4,
> +	.info =&tsl2X7X_device_info[ALSPRX2],
> +	},
> +};
> +
> +/*
> + * Client probe function.
> + */
> +static int __devinit tsl2x7x_probe(struct i2c_client *clientp,
> +	const struct i2c_device_id *id)
> +{
> +	int ret;
> +	unsigned char device_id;
> +	struct iio_dev *indio_dev;
> +	struct tsl2X7X_chip	*chip;
space / tab issue above.
> +
> +	indio_dev = iio_allocate_device(sizeof(*chip));
> +	if (!indio_dev)
> +		return -ENOMEM;
> +
> +	chip = iio_priv(indio_dev);
> +	chip->client = clientp;
> +	i2c_set_clientdata(clientp, indio_dev);
> +
> +	/* ALS and PROX functions can be invoked via user space poll
> +	 * or H/W interrupt. If busy return last sample. */
> +	mutex_init(&chip->als_mutex);
> +	mutex_init(&chip->prox_mutex);
> +
> +	chip->tsl2x7x_chip_status = TSL2X7X_CHIP_UNKNOWN;
> +	chip->pdata = clientp->dev.platform_data;
> +
> +	ret = tsl2x7x_i2c_read(chip->client,
> +		TSL2X7X_CHIPID,&device_id);
> +	if (ret<  0)
> +		goto fail1;
> +
> +	if ((!tsl2x7x_device_id(&device_id, id->driver_data)) ||
> +		(tsl2x7x_device_id(&device_id, id->driver_data) == -EINVAL)) {
> +		dev_info(&chip->client->dev, "i2c device found but does not match "
> +			"expected id in tsl2x7x_probe()\n");
ret not set appropriately?
> +		goto fail1;
> +	}
> +
one blank line is plenty.
> +
> +	ret = i2c_smbus_write_byte(clientp, (TSL2X7X_CMD_REG | TSL2X7X_CNTRL));
> +	if (ret<  0) {
> +		dev_err(&clientp->dev, "i2c_smbus_write_byte() to cmd reg "
> +			"failed in tsl2x7x_probe(), err = %d\n", ret);
> +		goto fail1;
> +	}
> +
> +	chip->id = id->driver_data;
> +	chip->chip_info =
> +		&tsl2x7x_chip_info_tbl[device_channel_config[id->driver_data]];
> +
> +	indio_dev->info = chip->chip_info->info;
> +	indio_dev->dev.parent =&clientp->dev;
> +	indio_dev->modes = INDIO_DIRECT_MODE;
> +	indio_dev->name = chip->client->name;
> +	indio_dev->channels = chip->chip_info->channel;
> +	indio_dev->num_channels = chip->chip_info->num_channels;
> +
> +	if (clientp->irq) {
> +		ret = request_threaded_irq(clientp->irq,
> +					   NULL,
> +					&tsl2x7x_event_handler,
> +					   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
> +					   "TSL2X7X_event",
> +					   indio_dev);
> +		if (ret)
> +			dev_err(&clientp->dev, "irq request failed");
Not exit?
> +	}
> +
> +	ret = iio_device_register(indio_dev);
> +	if (ret) {
> +		dev_err(&clientp->dev, "iio registration failed\n");
> +		goto fail2;
> +	}
After the register all the sysfs files etc are available, hence is there 
a plausible race with the
chip turning on below?  Normally we carefully keep iio_device_register 
last in the
probe unless there is a very good reason not to.
> +
> +	/* Load up the defaults */
> +	tsl2x7x_defaults(chip);
> +
> +	/* Make sure the chip is on */
> +	tsl2x7x_chip_on(indio_dev);
> +
> +	dev_info(&clientp->dev, "%s Light sensor found.\n", id->name);
> +
> +	return 0;
> +
interrupt needs unwinding if the register fails.
> +fail1:
> +	iio_free_device(indio_dev);
> +
> +fail2:
> +
> +	return ret;
> +}
> +
> +static int tsl2x7x_suspend(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +
Spurious blank line?  Inconsistent if nothing else ;)
> +	int ret = 0;
> +
> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING) {
> +		ret = tsl2x7x_chip_off(indio_dev);
> +		chip->tsl2x7x_chip_status = TSL2X7X_CHIP_SUSPENDED;
> +	}
> +
> +	if (chip->pdata&&  chip->pdata->platform_power) {
> +		pm_message_t pmm = {PM_EVENT_SUSPEND};
> +		chip->pdata->platform_power(dev, pmm);
> +	}
> +
> +	return ret;
> +}
> +
> +static int tsl2x7x_resume(struct device *dev)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct tsl2X7X_chip *chip = iio_priv(indio_dev);
> +	int ret = 0;
> +
> +	if (chip->pdata&&  chip->pdata->platform_power) {
> +		pm_message_t pmm = {PM_EVENT_RESUME};
> +		chip->pdata->platform_power(dev, pmm);
> +	}
> +
> +	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_SUSPENDED)
> +		ret = tsl2x7x_chip_on(indio_dev);
> +
> +	return ret;
> +}
> +
> +static int __devexit tsl2x7x_remove(struct i2c_client *client)
> +{
> +	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +	struct tsl2X7X_chip *chip = i2c_get_clientdata(client);
> +
> +	tsl2x7x_chip_off(indio_dev);
> +
> +	if (client->irq)
> +		free_irq(client->irq, chip->client->name);
> +
> +	iio_device_unregister(indio_dev);
> +	kfree(chip);
Don't free chip. iio_device_free please. That will clear up chip.  This 
used to
be muddled, but is now a simple allocate->register, unregister->free set.
> +
> +	return 0;
> +}
> +
> +static struct i2c_device_id tsl2x7x_idtable[] = {
> +	{ "tsl2571", tsl2571 },
> +	{ "tsl2671", tsl2671 },
> +	{ "tmd2671", tmd2671 },
> +	{ "tsl2771", tsl2771 },
> +	{ "tmd2771", tmd2771 },
> +	{ "tsl2572", tsl2572 },
> +	{ "tsl2672", tsl2672 },
> +	{ "tmd2672", tmd2672 },
> +	{ "tsl2772", tsl2772 },
> +	{ "tmd2772", tmd2772 },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, tsl2x7x_idtable);
> +
> +static const struct dev_pm_ops tsl2x7x_pm_ops = {
> +	.suspend = tsl2x7x_suspend,
> +	.resume  = tsl2x7x_resume,
> +};
> +
> +/* Driver definition */
> +static struct i2c_driver tsl2x7x_driver = {
> +	.driver = {
> +		.name = "tsl2x7x",
> +		.pm =&tsl2x7x_pm_ops,
> +	},
> +	.id_table = tsl2x7x_idtable,
> +	.probe = tsl2x7x_probe,
> +	.remove = __devexit_p(tsl2x7x_remove),
> +};
> +
> +module_i2c_driver(tsl2x7x_driver);
> +
> +MODULE_AUTHOR("J. August Brenner<jbrenner@taosinc.com>");
> +MODULE_DESCRIPTION("TAOS tsl2x7x ambient and proximity light sensor driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/iio/light/tsl2x7x_core.h b/drivers/staging/iio/light/tsl2x7x_core.h
> new file mode 100644
> index 0000000..8ff8afb
> --- /dev/null
> +++ b/drivers/staging/iio/light/tsl2x7x_core.h
> @@ -0,0 +1,156 @@
> +/*
> + * Device driver for monitoring ambient light intensity (lux)
> + * and proximity (prox) within the TAOS TSL2X7X family of devices.
> + *
> + * Copyright (c) 2012, TAOS Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
> + */
> +
> +#ifndef __TSL2X7X_H
> +#define __TSL2X7X_H
> +#include<linux/pm.h>
> +
> +/* TAOS Register definitions - note:
> + * depending on device, some of these register are not used and the
> + * register address is benign.
> + */
> +/* 2X7X register offsets */
> +#define TSL2X7X_REG_MAX         16
Perhaps a comment about this REG_MAX. Doesn't immediately look obvious
that it corresponds to the number of registers as I'd expect from it's name.
> +
I'm guessing some of the following isn't used anywhere other than in the
driver.  To that end, push them down into the c file rather than having 
them here
in the header.
> +/* Device Registers and Masks */
> +#define TSL2X7X_CNTRL                  0x00
> +#define TSL2X7X_ALS_TIME               0X01
> +#define TSL2X7X_PRX_TIME               0x02
> +#define TSL2X7X_WAIT_TIME              0x03
> +#define TSL2X7X_ALS_MINTHRESHLO        0X04
> +#define TSL2X7X_ALS_MINTHRESHHI        0X05
> +#define TSL2X7X_ALS_MAXTHRESHLO        0X06
> +#define TSL2X7X_ALS_MAXTHRESHHI        0X07
> +#define TSL2X7X_PRX_MINTHRESHLO        0X08
> +#define TSL2X7X_PRX_MINTHRESHHI        0X09
> +#define TSL2X7X_PRX_MAXTHRESHLO        0X0A
> +#define TSL2X7X_PRX_MAXTHRESHHI        0X0B
> +#define TSL2X7X_PERSISTENCE            0x0C
> +#define TSL2X7X_PRX_CONFIG             0x0D
> +#define TSL2X7X_PRX_COUNT              0x0E
> +#define TSL2X7X_GAIN                   0x0F
> +#define TSL2X7X_NOTUSED                0x10
> +#define TSL2X7X_REVID                  0x11
> +#define TSL2X7X_CHIPID                 0x12
> +#define TSL2X7X_STATUS                 0x13
> +#define TSL2X7X_ALS_CHAN0LO            0x14
> +#define TSL2X7X_ALS_CHAN0HI            0x15
> +#define TSL2X7X_ALS_CHAN1LO            0x16
> +#define TSL2X7X_ALS_CHAN1HI            0x17
> +#define TSL2X7X_PRX_LO                 0x18
> +#define TSL2X7X_PRX_HI                 0x19
> +
> +/* tsl2X7X cmd reg masks */
> +#define TSL2X7X_CMD_REG                0x80
> +#define TSL2X7X_CMD_SPL_FN             0x60
> +
> +#define TSL2X7X_CMD_PROX_INT_CLR       0X05
> +#define TSL2X7X_CMD_ALS_INT_CLR        0x06
> +#define TSL2X7X_CMD_PROXALS_INT_CLR    0X07
> +
> +/* tsl2X7X cntrl reg masks */
> +#define TSL2X7X_CNTL_ADC_ENBL          0x02
> +#define TSL2X7X_CNTL_PWR_ON            0x01
> +
> +/* tsl2X7X status reg masks */
> +#define TSL2X7X_STA_ADC_VALID          0x01
> +#define TSL2X7X_STA_PRX_VALID          0x02
> +#define TSL2X7X_STA_ADC_PRX_VALID      0x03
> +#define TSL2X7X_STA_ALS_INTR           0x10
> +#define TSL2X7X_STA_ADC_INTR           0x10
> +#define TSL2X7X_STA_PRX_INTR           0x20
> +
> +#define TSL2X7X_STA_ADC_INTR           0x10
> +
> +/* tsl2X7X cntrl reg masks */
> +#define TSL2X7X_CNTL_REG_CLEAR         0x00
> +#define TSL2X7X_CNTL_PROX_INT_ENBL     0X20
> +#define TSL2X7X_CNTL_ALS_INT_ENBL      0X10
> +#define TSL2X7X_CNTL_WAIT_TMR_ENBL     0X08
> +#define TSL2X7X_CNTL_PROX_DET_ENBL     0X04
> +#define TSL2X7X_CNTL_PWRON             0x01
> +#define TSL2X7X_CNTL_ALSPON_ENBL       0x03
> +#define TSL2X7X_CNTL_INTALSPON_ENBL    0x13
> +#define TSL2X7X_CNTL_PROXPON_ENBL      0x0F
> +#define TSL2X7X_CNTL_INTPROXPON_ENBL   0x2F
> +#define TSL2X7X_CMD_PROXALS_INTCLR     0X07
> +
> +/*Prox diode to use */
> +#define TSL2X7X_DIODE0                 0x10
> +#define TSL2X7X_DIODE1                 0x20
> +#define TSL2X7X_DIODE_BOTH             0x30
> +
> +/* LED Power */
> +#define TSL2X7X_mA100                  0x00
> +#define TSL2X7X_mA50                   0x40
> +#define TSL2X7X_mA25                   0x80
> +#define TSL2X7X_mA13                   0xD0
> +
> +/* Max number of segments allowable in LUX table */
> +#define MAX_TABLE_SIZE		9
> +#define MAX_DEFAULT_TABLE_BYTES (sizeof(int) * MAX_TABLE_SIZE)
> +
> +struct iio_dev;
> +struct iio_chan_spec;
> +
> +struct tsl2x7x_lux {
> +	unsigned int ratio;
> +	unsigned int ch0;
> +	unsigned int ch1;
> +};
> +
whilst these are 'fairly' obvious, I'd prefer this to be documented (for 
stuff
like units of parameters etc).
> +struct tsl2x7x_settings {
> +	int als_time;
> +	int als_gain;
> +	int als_gain_trim;
> +	int wait_time;
> +	int prx_time;
> +	int prox_gain;
> +	int prox_config;
> +	int als_cal_target;
> +	u8  interrupts_en;
> +	u8  als_persistence;
> +	int als_thresh_low;
> +	int als_thresh_high;
> +	int prox_thres_low;
> +	int prox_thres_high;
> +	int prox_pulse_count;
> +	int prox_max_samples_cal;/* for calibration mode*/
bonus blank line.
> +
> +};
> +
> +/* struct tsl2x7x_platform_data -
> + * Platform unique glass and defaults
> + * Platform PM functions. */
> +struct tsl2X7X_platform_data {
> +	/* Suspend/resume platform cb */
> +	int (*platform_power)(struct device *dev, pm_message_t);
> +	/* The following callback gets called when the device is powered on */
> +	int (*power_on)      (struct iio_dev *indio_dev);
> +	/* The following callback gets called when the device is powered off */
> +	int (*power_off)     (struct i2c_client *dev);
> +	/* These are the device specific glass coefficents used to
> +	 * calculate Lux */
> +	struct tsl2x7x_lux platform_lux_table[MAX_TABLE_SIZE];
> +	struct tsl2x7x_settings *platform_default_settings;
> +};
> +
> +#endif /* __TSL2X7X_H */
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

