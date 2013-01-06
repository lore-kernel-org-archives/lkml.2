Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3AFLvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:51:00 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55992 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3AFLu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:50:58 -0500
Message-ID: <50E9651D.3080300@kernel.org>
Date: Sun, 06 Jan 2013 11:50:53 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4 RESEND] iio: merge hid-sensor-attributes.h into hid-sensor-hub.h
References: <50CC6FE3.6060705@ahsoftware.de> <1355575537-10093-1-git-send-email-holler@ahsoftware.de> <1355575537-10093-2-git-send-email-holler@ahsoftware.de> <alpine.LNX.2.00.1301031041261.27348@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1301031041261.27348@pobox.suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 09:41 AM, Jiri Kosina wrote:
> On Sat, 15 Dec 2012, Alexander Holler wrote:
> 
>> The stuff in hid-sensor-attributes.h is needed by every piece which
>> uses hid-sensor-hub and merging it into hid-sensor-hub.h makes it accessible
>> from outside the iio subdirectory.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> 
> Acked-by: Jiri Kosina <jkosina@suse.cz>
Added to togreg branch of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks,

> 
>> ---
>>  drivers/iio/accel/hid-sensor-accel-3d.c            |    1 -
>>  .../iio/common/hid-sensors/hid-sensor-attributes.c |    1 -
>>  .../iio/common/hid-sensors/hid-sensor-attributes.h |   57 --------------------
>>  .../iio/common/hid-sensors/hid-sensor-trigger.c    |    1 -
>>  drivers/iio/gyro/hid-sensor-gyro-3d.c              |    1 -
>>  drivers/iio/light/hid-sensor-als.c                 |    1 -
>>  drivers/iio/magnetometer/hid-sensor-magn-3d.c      |    1 -
>>  include/linux/hid-sensor-hub.h                     |   38 +++++++++++++
>>  8 files changed, 38 insertions(+), 63 deletions(-)
>>  delete mode 100644 drivers/iio/common/hid-sensors/hid-sensor-attributes.h
>>
>> diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
>> index 314a405..72371aa 100644
>> --- a/drivers/iio/accel/hid-sensor-accel-3d.c
>> +++ b/drivers/iio/accel/hid-sensor-accel-3d.c
>> @@ -28,7 +28,6 @@
>>  #include <linux/iio/buffer.h>
>>  #include <linux/iio/trigger_consumer.h>
>>  #include <linux/iio/triggered_buffer.h>
>> -#include "../common/hid-sensors/hid-sensor-attributes.h"
>>  #include "../common/hid-sensors/hid-sensor-trigger.h"
>>  
>>  /*Format: HID-SENSOR-usage_id_in_hex*/
>> diff --git a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
>> index 7537495..5873f16 100644
>> --- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
>> +++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
>> @@ -25,7 +25,6 @@
>>  #include <linux/hid-sensor-hub.h>
>>  #include <linux/iio/iio.h>
>>  #include <linux/iio/sysfs.h>
>> -#include "hid-sensor-attributes.h"
>>  
>>  static int pow_10(unsigned power)
>>  {
>> diff --git a/drivers/iio/common/hid-sensors/hid-sensor-attributes.h b/drivers/iio/common/hid-sensors/hid-sensor-attributes.h
>> deleted file mode 100644
>> index a4676a0..0000000
>> --- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.h
>> +++ /dev/null
>> @@ -1,57 +0,0 @@
>> -/*
>> - * HID Sensors Driver
>> - * Copyright (c) 2012, Intel Corporation.
>> - *
>> - * This program is free software; you can redistribute it and/or modify it
>> - * under the terms and conditions of the GNU General Public License,
>> - * version 2, as published by the Free Software Foundation.
>> - *
>> - * This program is distributed in the hope it will be useful, but WITHOUT
>> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> - * more details.
>> - *
>> - * You should have received a copy of the GNU General Public License along with
>> - * this program; if not, write to the Free Software Foundation, Inc.,
>> - * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>> - *
>> - */
>> -#ifndef _HID_SENSORS_ATTRIBUTES_H
>> -#define _HID_SENSORS_ATTRIBUTES_H
>> -
>> -/* Common hid sensor iio structure */
>> -struct hid_sensor_iio_common {
>> -	struct hid_sensor_hub_device *hsdev;
>> -	struct platform_device *pdev;
>> -	unsigned usage_id;
>> -	bool data_ready;
>> -	struct hid_sensor_hub_attribute_info poll;
>> -	struct hid_sensor_hub_attribute_info report_state;
>> -	struct hid_sensor_hub_attribute_info power_state;
>> -	struct hid_sensor_hub_attribute_info sensitivity;
>> -};
>> -
>> -/*Convert from hid unit expo to regular exponent*/
>> -static inline int hid_sensor_convert_exponent(int unit_expo)
>> -{
>> -	if (unit_expo < 0x08)
>> -		return unit_expo;
>> -	else if (unit_expo <= 0x0f)
>> -		return -(0x0f-unit_expo+1);
>> -	else
>> -		return 0;
>> -}
>> -
>> -int hid_sensor_parse_common_attributes(struct hid_sensor_hub_device *hsdev,
>> -					u32 usage_id,
>> -					struct hid_sensor_iio_common *st);
>> -int hid_sensor_write_raw_hyst_value(struct hid_sensor_iio_common *st,
>> -					int val1, int val2);
>> -int hid_sensor_read_raw_hyst_value(struct hid_sensor_iio_common *st,
>> -					int *val1, int *val2);
>> -int hid_sensor_write_samp_freq_value(struct hid_sensor_iio_common *st,
>> -					int val1, int val2);
>> -int hid_sensor_read_samp_freq_value(struct hid_sensor_iio_common *st,
>> -					int *val1, int *val2);
>> -
>> -#endif
>> diff --git a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
>> index d4b790d..b097b68 100644
>> --- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
>> +++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
>> @@ -26,7 +26,6 @@
>>  #include <linux/iio/iio.h>
>>  #include <linux/iio/trigger.h>
>>  #include <linux/iio/sysfs.h>
>> -#include "hid-sensor-attributes.h"
>>  #include "hid-sensor-trigger.h"
>>  
>>  static int hid_sensor_data_rdy_trigger_set_state(struct iio_trigger *trig,
>> diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
>> index 4c56ada..b98cd70 100644
>> --- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
>> +++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
>> @@ -28,7 +28,6 @@
>>  #include <linux/iio/buffer.h>
>>  #include <linux/iio/trigger_consumer.h>
>>  #include <linux/iio/triggered_buffer.h>
>> -#include "../common/hid-sensors/hid-sensor-attributes.h"
>>  #include "../common/hid-sensors/hid-sensor-trigger.h"
>>  
>>  /*Format: HID-SENSOR-usage_id_in_hex*/
>> diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
>> index 96e3691..9610989 100644
>> --- a/drivers/iio/light/hid-sensor-als.c
>> +++ b/drivers/iio/light/hid-sensor-als.c
>> @@ -28,7 +28,6 @@
>>  #include <linux/iio/buffer.h>
>>  #include <linux/iio/trigger_consumer.h>
>>  #include <linux/iio/triggered_buffer.h>
>> -#include "../common/hid-sensors/hid-sensor-attributes.h"
>>  #include "../common/hid-sensors/hid-sensor-trigger.h"
>>  
>>  /*Format: HID-SENSOR-usage_id_in_hex*/
>> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> index c4f0d27..4957430 100644
>> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> @@ -28,7 +28,6 @@
>>  #include <linux/iio/buffer.h>
>>  #include <linux/iio/trigger_consumer.h>
>>  #include <linux/iio/triggered_buffer.h>
>> -#include "../common/hid-sensors/hid-sensor-attributes.h"
>>  #include "../common/hid-sensors/hid-sensor-trigger.h"
>>  
>>  /*Format: HID-SENSOR-usage_id_in_hex*/
>> diff --git a/include/linux/hid-sensor-hub.h b/include/linux/hid-sensor-hub.h
>> index 0aa5f4c..e6265f9 100644
>> --- a/include/linux/hid-sensor-hub.h
>> +++ b/include/linux/hid-sensor-hub.h
>> @@ -157,4 +157,42 @@ int sensor_hub_set_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
>>  */
>>  int sensor_hub_get_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
>>  			u32 field_index, s32 *value);
>> +
>> +/* hid-sensor-attributes */
>> +
>> +/* Common hid sensor iio structure */
>> +struct hid_sensor_iio_common {
>> +	struct hid_sensor_hub_device *hsdev;
>> +	struct platform_device *pdev;
>> +	unsigned usage_id;
>> +	bool data_ready;
>> +	struct hid_sensor_hub_attribute_info poll;
>> +	struct hid_sensor_hub_attribute_info report_state;
>> +	struct hid_sensor_hub_attribute_info power_state;
>> +	struct hid_sensor_hub_attribute_info sensitivity;
>> +};
>> +
>> +/*Convert from hid unit expo to regular exponent*/
>> +static inline int hid_sensor_convert_exponent(int unit_expo)
>> +{
>> +	if (unit_expo < 0x08)
>> +		return unit_expo;
>> +	else if (unit_expo <= 0x0f)
>> +		return -(0x0f-unit_expo+1);
>> +	else
>> +		return 0;
>> +}
>> +
>> +int hid_sensor_parse_common_attributes(struct hid_sensor_hub_device *hsdev,
>> +					u32 usage_id,
>> +					struct hid_sensor_iio_common *st);
>> +int hid_sensor_write_raw_hyst_value(struct hid_sensor_iio_common *st,
>> +					int val1, int val2);
>> +int hid_sensor_read_raw_hyst_value(struct hid_sensor_iio_common *st,
>> +					int *val1, int *val2);
>> +int hid_sensor_write_samp_freq_value(struct hid_sensor_iio_common *st,
>> +					int val1, int val2);
>> +int hid_sensor_read_samp_freq_value(struct hid_sensor_iio_common *st,
>> +					int *val1, int *val2);
>> +
>>  #endif
>> -- 
>> 1.7.8.6
>>
> 
