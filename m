Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3AFLuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 06:50:22 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55951 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3AFLuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 06:50:19 -0500
Message-ID: <50E964F6.9090204@kernel.org>
Date: Sun, 06 Jan 2013 11:50:14 +0000
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
Subject: Re: [PATCH 4/4 RESEND] hid: iio: rename struct hid_sensor_iio_common
 to hid_sensor_common
References: <50CC6FE3.6060705@ahsoftware.de> <1355575537-10093-1-git-send-email-holler@ahsoftware.de> <1355575537-10093-4-git-send-email-holler@ahsoftware.de> <alpine.LNX.2.00.1301031041580.27348@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1301031041580.27348@pobox.suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 09:42 AM, Jiri Kosina wrote:
> On Sat, 15 Dec 2012, Alexander Holler wrote:
> 
>> The structure with common attributes for hid-sensors isn't specific
>> to the iio-subsystem, so rename it to hid_sensor_common.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> 
> Acked-by: Jiri Kosina <jkosina@suse.cz>
Added to togreg branch of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks,

> 
>> ---
>>  drivers/iio/accel/hid-sensor-accel-3d.c            |    2 +-
>>  .../iio/common/hid-sensors/hid-sensor-attributes.c |   10 +++++-----
>>  .../iio/common/hid-sensors/hid-sensor-trigger.c    |    4 ++--
>>  .../iio/common/hid-sensors/hid-sensor-trigger.h    |    2 +-
>>  drivers/iio/gyro/hid-sensor-gyro-3d.c              |    2 +-
>>  drivers/iio/light/hid-sensor-als.c                 |    2 +-
>>  drivers/iio/magnetometer/hid-sensor-magn-3d.c      |    2 +-
>>  drivers/rtc/rtc-hid-sensor-time.c                  |    2 +-
>>  include/linux/hid-sensor-hub.h                     |   12 ++++++------
>>  9 files changed, 19 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
>> index 72371aa..2133da8 100644
>> --- a/drivers/iio/accel/hid-sensor-accel-3d.c
>> +++ b/drivers/iio/accel/hid-sensor-accel-3d.c
>> @@ -43,7 +43,7 @@ enum accel_3d_channel {
>>  
>>  struct accel_3d_state {
>>  	struct hid_sensor_hub_callbacks callbacks;
>> -	struct hid_sensor_iio_common common_attributes;
>> +	struct hid_sensor_common common_attributes;
>>  	struct hid_sensor_hub_attribute_info accel[ACCEL_3D_CHANNEL_MAX];
>>  	u32 accel_val[ACCEL_3D_CHANNEL_MAX];
>>  };
>> diff --git a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
>> index 5873f16..75b5473 100644
>> --- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
>> +++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
>> @@ -113,7 +113,7 @@ static u32 convert_to_vtf_format(int size, int exp, int val1, int val2)
>>  	return value;
>>  }
>>  
>> -int hid_sensor_read_samp_freq_value(struct hid_sensor_iio_common *st,
>> +int hid_sensor_read_samp_freq_value(struct hid_sensor_common *st,
>>  				int *val1, int *val2)
>>  {
>>  	s32 value;
>> @@ -140,7 +140,7 @@ int hid_sensor_read_samp_freq_value(struct hid_sensor_iio_common *st,
>>  }
>>  EXPORT_SYMBOL(hid_sensor_read_samp_freq_value);
>>  
>> -int hid_sensor_write_samp_freq_value(struct hid_sensor_iio_common *st,
>> +int hid_sensor_write_samp_freq_value(struct hid_sensor_common *st,
>>  				int val1, int val2)
>>  {
>>  	s32 value;
>> @@ -168,7 +168,7 @@ int hid_sensor_write_samp_freq_value(struct hid_sensor_iio_common *st,
>>  }
>>  EXPORT_SYMBOL(hid_sensor_write_samp_freq_value);
>>  
>> -int hid_sensor_read_raw_hyst_value(struct hid_sensor_iio_common *st,
>> +int hid_sensor_read_raw_hyst_value(struct hid_sensor_common *st,
>>  				int *val1, int *val2)
>>  {
>>  	s32 value;
>> @@ -190,7 +190,7 @@ int hid_sensor_read_raw_hyst_value(struct hid_sensor_iio_common *st,
>>  }
>>  EXPORT_SYMBOL(hid_sensor_read_raw_hyst_value);
>>  
>> -int hid_sensor_write_raw_hyst_value(struct hid_sensor_iio_common *st,
>> +int hid_sensor_write_raw_hyst_value(struct hid_sensor_common *st,
>>  					int val1, int val2)
>>  {
>>  	s32 value;
>> @@ -211,7 +211,7 @@ EXPORT_SYMBOL(hid_sensor_write_raw_hyst_value);
>>  
>>  int hid_sensor_parse_common_attributes(struct hid_sensor_hub_device *hsdev,
>>  					u32 usage_id,
>> -					struct hid_sensor_iio_common *st)
>> +					struct hid_sensor_common *st)
>>  {
>>  
>>  	sensor_hub_input_get_attribute_info(hsdev,
>> diff --git a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
>> index b097b68..58fc108 100644
>> --- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
>> +++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
>> @@ -31,7 +31,7 @@
>>  static int hid_sensor_data_rdy_trigger_set_state(struct iio_trigger *trig,
>>  						bool state)
>>  {
>> -	struct hid_sensor_iio_common *st = trig->private_data;
>> +	struct hid_sensor_common *st = trig->private_data;
>>  	int state_val;
>>  
>>  	state_val = state ? 1 : 0;
>> @@ -65,7 +65,7 @@ static const struct iio_trigger_ops hid_sensor_trigger_ops = {
>>  };
>>  
>>  int hid_sensor_setup_trigger(struct iio_dev *indio_dev, const char *name,
>> -				struct hid_sensor_iio_common *attrb)
>> +				struct hid_sensor_common *attrb)
>>  {
>>  	int ret;
>>  	struct iio_trigger *trig;
>> diff --git a/drivers/iio/common/hid-sensors/hid-sensor-trigger.h b/drivers/iio/common/hid-sensors/hid-sensor-trigger.h
>> index fd98297..9a87314 100644
>> --- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.h
>> +++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.h
>> @@ -20,7 +20,7 @@
>>  #define _HID_SENSOR_TRIGGER_H
>>  
>>  int hid_sensor_setup_trigger(struct iio_dev *indio_dev, const char *name,
>> -				struct hid_sensor_iio_common *attrb);
>> +				struct hid_sensor_common *attrb);
>>  void hid_sensor_remove_trigger(struct iio_dev *indio_dev);
>>  
>>  #endif
>> diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
>> index b98cd70..85330ad 100644
>> --- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
>> +++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
>> @@ -43,7 +43,7 @@ enum gyro_3d_channel {
>>  
>>  struct gyro_3d_state {
>>  	struct hid_sensor_hub_callbacks callbacks;
>> -	struct hid_sensor_iio_common common_attributes;
>> +	struct hid_sensor_common common_attributes;
>>  	struct hid_sensor_hub_attribute_info gyro[GYRO_3D_CHANNEL_MAX];
>>  	u32 gyro_val[GYRO_3D_CHANNEL_MAX];
>>  };
>> diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
>> index 9610989..051b88c 100644
>> --- a/drivers/iio/light/hid-sensor-als.c
>> +++ b/drivers/iio/light/hid-sensor-als.c
>> @@ -38,7 +38,7 @@
>>  
>>  struct als_state {
>>  	struct hid_sensor_hub_callbacks callbacks;
>> -	struct hid_sensor_iio_common common_attributes;
>> +	struct hid_sensor_common common_attributes;
>>  	struct hid_sensor_hub_attribute_info als_illum;
>>  	u32 illum;
>>  };
>> diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> index 4957430..5c59044 100644
>> --- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> +++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
>> @@ -43,7 +43,7 @@ enum magn_3d_channel {
>>  
>>  struct magn_3d_state {
>>  	struct hid_sensor_hub_callbacks callbacks;
>> -	struct hid_sensor_iio_common common_attributes;
>> +	struct hid_sensor_common common_attributes;
>>  	struct hid_sensor_hub_attribute_info magn[MAGN_3D_CHANNEL_MAX];
>>  	u32 magn_val[MAGN_3D_CHANNEL_MAX];
>>  };
>> diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
>> index 25cac6e..0438c9e 100644
>> --- a/drivers/rtc/rtc-hid-sensor-time.c
>> +++ b/drivers/rtc/rtc-hid-sensor-time.c
>> @@ -39,7 +39,7 @@ enum hid_time_channel {
>>  
>>  struct hid_time_state {
>>  	struct hid_sensor_hub_callbacks callbacks;
>> -	struct hid_sensor_iio_common common_attributes;
>> +	struct hid_sensor_common common_attributes;
>>  	struct hid_sensor_hub_attribute_info info[TIME_RTC_CHANNEL_MAX];
>>  	struct rtc_time last_time;
>>  	spinlock_t lock_last_time;
>> diff --git a/include/linux/hid-sensor-hub.h b/include/linux/hid-sensor-hub.h
>> index e6265f9..ecefb73 100644
>> --- a/include/linux/hid-sensor-hub.h
>> +++ b/include/linux/hid-sensor-hub.h
>> @@ -161,7 +161,7 @@ int sensor_hub_get_feature(struct hid_sensor_hub_device *hsdev, u32 report_id,
>>  /* hid-sensor-attributes */
>>  
>>  /* Common hid sensor iio structure */
>> -struct hid_sensor_iio_common {
>> +struct hid_sensor_common {
>>  	struct hid_sensor_hub_device *hsdev;
>>  	struct platform_device *pdev;
>>  	unsigned usage_id;
>> @@ -185,14 +185,14 @@ static inline int hid_sensor_convert_exponent(int unit_expo)
>>  
>>  int hid_sensor_parse_common_attributes(struct hid_sensor_hub_device *hsdev,
>>  					u32 usage_id,
>> -					struct hid_sensor_iio_common *st);
>> -int hid_sensor_write_raw_hyst_value(struct hid_sensor_iio_common *st,
>> +					struct hid_sensor_common *st);
>> +int hid_sensor_write_raw_hyst_value(struct hid_sensor_common *st,
>>  					int val1, int val2);
>> -int hid_sensor_read_raw_hyst_value(struct hid_sensor_iio_common *st,
>> +int hid_sensor_read_raw_hyst_value(struct hid_sensor_common *st,
>>  					int *val1, int *val2);
>> -int hid_sensor_write_samp_freq_value(struct hid_sensor_iio_common *st,
>> +int hid_sensor_write_samp_freq_value(struct hid_sensor_common *st,
>>  					int val1, int val2);
>> -int hid_sensor_read_samp_freq_value(struct hid_sensor_iio_common *st,
>> +int hid_sensor_read_samp_freq_value(struct hid_sensor_common *st,
>>  					int *val1, int *val2);
>>  
>>  #endif
>> -- 
>> 1.7.8.6
>>
> 
